variable "environment" {
  type        = string
  description = "Semantic deployment environment supplied by the selected tfvars file."

  validation {
    condition     = can(regex("^[a-z0-9]+(?:-[a-z0-9]+)*$", lower(trimspace(var.environment))))
    error_message = "environment must contain only letters, numbers, and single hyphens."
  }
}

variable "location" {
  type        = string
  description = "Primary Azure location included in regional resource names."

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "environment_infixes" {
  type        = map(string)
  description = "Optional environment-specific infix overrides, including the leading separator."
  default     = {}
}

variable "environments_without_infix" {
  type        = set(string)
  description = "Environment names that omit the environment infix."
  default     = ["non-prod", "prod", "production", "qa"]
}

variable "subscription_ids" {
  type        = map(string)
  description = "Optional platform subscription IDs used to construct resource identifiers."
  default     = {}

  validation {
    condition = alltrue([
      for subscription_id in values(var.subscription_ids) :
      can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", subscription_id))
    ])
    error_message = "Every subscription ID must be a valid GUID."
  }
}

variable "name_overrides" {
  type        = map(string)
  description = "Optional final values that replace generated names by output key."
  default     = {}
}