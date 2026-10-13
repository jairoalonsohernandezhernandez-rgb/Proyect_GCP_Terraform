# Arquitectura Cloud-Native en Google Cloud con Terraform y Kubernetes

Infraestructura modular en **Google Cloud Platform** definida como código con **Terraform**, junto con los manifiestos de **Kubernetes** y una aplicación web de demostración en **Node.js**. Combina un clúster **GKE** expuesto mediante un balanceador HTTP global protegido con **Cloud Armor**, **Cloud DNS**, **API Gateway**, **Firestore** y **Workload Identity** hacia una cuenta de servicio de **Vertex AI**.

## Estado del proyecto

| Verificación | Estado |
|---|---|
| Sintaxis y referencias de Terraform (`terraform validate`) | Aprobado |
| Aplicación contenerizada en Kubernetes local (Minikube) | Pods en `Running` |
| Despliegue en GCP (`terraform apply`) | **No realizado**: no hay una cuenta de facturación activa |

Los manifiestos usan una imagen local (`imagePullPolicy: Never`), pensada para Minikube. El `BackendConfig` y el Ingress de clase `gce` son propios de GKE, por lo que no se pueden probar localmente.

La aplicación todavía **no llama a Firestore ni a Vertex AI**: ambos servicios están provisionados y la identidad está configurada, pero la integración en el código de la app es un paso pendiente. Ver [Próximos pasos](#próximos-pasos).

## Arquitectura

```
                     Usuario
                        │
                   Cloud DNS  (zona pública, registro A + CNAME www)
                        │
              IP global estática (reservada con Terraform)
                        │
        Balanceador HTTP global (creado por el Ingress de GKE)
                        │
             Cloud Armor (WAF: bloquea XSS y SQL injection,
                          asociado desde el BackendConfig)
                        │
        ┌───────────────┴───────────────┐
        │   VPC personalizada           │
        │   └─ Subred con rangos        │
        │      secundarios (pods/svc)   │
        │        └─ GKE: app web        │
        │           (Workload Identity, │
        │            autoscaling)       │
        └───────┬───────────────┬───────┘
                │               │
           Firestore       Vertex AI
        (provisionado)   (API + cuenta de servicio)

   API Gateway (OpenAPI 2.0, endpoint /health) — componente independiente
```

## Infraestructura (Terraform)

| Servicio | Qué define el código |
|---|---|
| **VPC** | Red en modo personalizado (sin subredes automáticas), con una subred y dos rangos secundarios (pods y servicios) para GKE nativo de VPC. Regla de firewall que permite tráfico interno (ICMP, TCP y UDP) solo desde la subred y el rango de pods. |
| **GKE** | Clúster regional con el node pool por defecto eliminado y un node pool propio con autoscaling de 1 a 3 nodos (`e2-medium`). Workload Identity habilitado en el clúster y en los nodos (`GKE_METADATA`), canal de actualizaciones `REGULAR` y add-on de HTTP load balancing. |
| **Cloud Armor** | Política de seguridad que bloquea (403) ataques XSS y SQL injection mediante reglas preconfiguradas, y una regla final que permite el resto del tráfico. Se asocia al backend desde el `BackendConfig` de Kubernetes. |
| **IP del balanceador** | IP global estática reservada con Terraform. El balanceador lo crea el Ingress de GKE usando esa IP, y Cloud DNS apunta a ella. |
| **Cloud DNS** | Zona pública administrada con registro `A` hacia la IP estática y `CNAME` para `www`. El dominio es un parámetro. |
| **API Gateway** | API, configuración (OpenAPI 2.0 en un archivo `openapi.yaml`) y gateway con un endpoint `/health`. |
| **Firestore** | Base de datos en modo Native, con control de concurrencia optimista y política de borrado `ABANDON`. |
| **Vertex AI** | Habilita la API, crea una cuenta de servicio dedicada con el rol Vertex AI User (`roles/aiplatform.user`) y le otorga `roles/iam.workloadIdentityUser` al ServiceAccount de Kubernetes de la app. |

## Kubernetes (`k8s/`)

| Manifiesto | Qué define |
|---|---|
| **Namespace** | `portfolio-app`, para aislar los recursos de la aplicación. |
| **Deployment** | 2 réplicas, con requests y limits de CPU y memoria, y probes de liveness y readiness sobre `/health`. |
| **Service** | Tipo `NodePort` en el puerto 8080, con anotación de NEG para el Ingress y un `BackendConfig` asociado. |
| **BackendConfig** | Asocia la política de Cloud Armor y define el health check del backend (HTTP, `/health`, puerto 8080). |
| **Ingress** | Clase `gce`, con la IP estática reservada en Terraform. |
| **ServiceAccount** | Anotado para usar Workload Identity con la cuenta de servicio de Vertex AI. |

## Aplicación y contenedor

- **`src/app.js`:** servidor HTTP en Node.js sin dependencias externas. Expone `/health` (respuesta JSON con estado, servicio, entorno y marca de tiempo) y `/` (página HTML de demostración).
- **`Dockerfile`:** imagen basada en `node:20-alpine` que copia la app y la ejecuta en el puerto 8080.

## Decisiones de diseño

- **Modularización:** cada servicio de Terraform vive en su propio módulo y el ambiente `dev` los conecta pasando salidas como entradas (la red y los rangos de la VPC hacia GKE, y la IP estática hacia Cloud DNS).
- **Un solo dueño del balanceador:** el Ingress de GKE crea y gestiona el balanceador, y Terraform solo reserva la IP. Así se evita mantener dos balanceadores en paralelo.
- **Seguridad en el borde:** el WAF de Cloud Armor se aplica en el balanceador, antes de que el tráfico llegue al clúster.
- **Identidad sin llaves:** Workload Identity en el clúster, en los nodos y en la cuenta de servicio de Vertex AI evita distribuir archivos de credenciales.
- **Alta disponibilidad básica:** dos réplicas, autoscaling del node pool y health checks en el Deployment.
- **Red aislada:** VPC personalizada con rangos IP definidos de forma explícita en lugar de redes automáticas.

## Estructura del repositorio

```
.
├── .github/workflows/   # Workflow de GitHub Actions
├── k8s/                 # Manifiestos de Kubernetes
├── src/app.js           # Aplicación web de demostración (Node.js)
├── terraform/           # Infraestructura como código (ambiente dev y módulos)
├── Dockerfile
└── .gitignore
```

## Próximos pasos

- Desplegar la infraestructura con una cuenta de facturación activa y validar el flujo completo, incluyendo el Ingress y Cloud Armor.
- Publicar la imagen en Artifact Registry y ajustar el Deployment para usarla en lugar de la imagen local.
- Hacer que la app llame a Vertex AI y a Firestore.
- Apuntar el API Gateway a un backend real en lugar del endpoint de prueba actual.
- Habilitar HTTPS con certificado administrado.
- Agregar validación en CI (`terraform fmt`, `validate` y escaneo de seguridad) sin necesidad de credenciales.

## Tecnologías

Terraform · Google Cloud (VPC, GKE, Cloud Armor, Cloud Load Balancing, API Gateway, Cloud DNS, Firestore, Vertex AI, IAM) · Kubernetes · Docker · Node.js · GitHub Actions

---

*Proyecto personal de práctica, orientado a arquitectura de soluciones en la nube y buenas prácticas de seguridad y modularidad en infraestructura como código.*
