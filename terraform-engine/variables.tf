variable "target_tier" {
  type        = string
  description = "The targeted deployment workspace environment tier"
  default     = "Dev"
}

variable "compliance_matrix" {
  type = map(object({
    security_level = string
    logs_retention = number
    auto_rotate    = bool
  }))
  description = "Enterprise Compliance Matrix mapping across lifecycle environments"
  default = {
    "Dev" = {
      security_level = "Standard"
      logs_retention = 7
      auto_rotate    = false
    }
    "Staging" = {
      security_level = "Enhanced"
      logs_retention = 30
      auto_rotate    = true
    }
    "Prod" = {
      security_level = "Strict-ISO27001"
      logs_retention = 365
      auto_rotate    = true
    }
  }
}
