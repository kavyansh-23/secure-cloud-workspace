terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

locals {
  active_policy = var.compliance_matrix[var.target_tier]
}

resource "local_file" "environment_manifest" {
  filename = "${path.module}/builds/workspace-${var.target_tier}-manifest.json"
  content  = <<EOT
{
  "workspace_tier": "${var.target_tier}",
  "security_framework": "${local.active_policy.security_level}",
  "compliance_metrics": {
    "audit_log_retention_days": ${local.active_policy.logs_retention},
    "credential_auto_rotation": ${local.active_policy.auto_rotate}
  },
  "generated_by": "Terraform Infrastructure Engine Automation"
}
EOT

  # 👇 AUTOMATION PIPELINE HOOK (TRIGGER COMPLETION AUDIT SHIFT)
  provisioner "local-exec" {
    command = "bash ../automation-utilities/compliance_check.sh"
  }
}
