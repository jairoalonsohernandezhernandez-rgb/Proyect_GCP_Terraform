resource "google_compute_security_policy" "policy" {
  name        = var.policy_name
  project     = var.project_id
  description = "Política de seguridad WAF para proteger el backend  en GKE"

  rule {
    action   = "deny(403)"
    priority = "1000"

    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-v33-stable')"
      }
    }
    description = "Bloquear intentos de ataques de XSS"
  }

  rule {
    action   = "deny(403)"
    priority = "1001"

    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }

    description = "Bloquear intentos de ataques de SQL Injection"
  }

  rule {
    action   = "allow"
    priority = "2147483647"

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Permitir en general el tráfico de entrada"
  }
}