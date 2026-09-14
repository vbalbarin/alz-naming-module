output "names" {
  description = "Generated ALZ resource names, including any overrides."
  value       = local.names
}

output "resource_group_identifiers" {
  description = "Generated resource group IDs. Values are null when the required subscription ID is omitted."
  value       = local.resource_group_identifiers
}

output "resource_identifiers" {
  description = "Generated resource IDs. Values are null when the required subscription ID is omitted."
  value       = local.resource_identifiers
}

output "custom_replacements" {
  description = "Combined output compatible with the original ALZ custom replacement keys."
  value = merge(
    local.names,
    local.resource_group_identifiers,
    local.resource_identifiers
  )
}