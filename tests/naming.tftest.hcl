run "dev_names_match_existing_resources" {
  command = plan

  variables {
    environment = "dev"
    location    = "westus"
  }

  assert {
    condition     = output.names.primary_management_resource_group_name == "rg-management-dev-westus"
    error_message = "The DEV management resource group name changed."
  }

  assert {
    condition     = output.names.primary_log_analytics_workspace_name == "law-management-dev-westus"
    error_message = "The DEV Log Analytics workspace name changed."
  }

  assert {
    condition     = output.names.primary_ama_user_assigned_managed_identity_name == "uami-management-ama-dev-westus"
    error_message = "The DEV AMA identity name changed."
  }
}

run "qa_names_match_existing_resources" {
  command = plan

  variables {
    environment = "qa"
    location    = "westus3"
  }

  assert {
    condition     = output.names.primary_management_resource_group_name == "rg-management-westus3"
    error_message = "The QA management resource group name changed."
  }

  assert {
    condition     = output.names.primary_log_analytics_workspace_name == "law-management-westus3"
    error_message = "The QA Log Analytics workspace name changed."
  }

  assert {
    condition     = output.names.primary_ama_user_assigned_managed_identity_name == "uami-management-ama-westus3"
    error_message = "The QA AMA identity name changed."
  }

  assert {
    condition     = output.names.dcr_change_tracking_name == "dcr-change-tracking"
    error_message = "The change-tracking DCR name changed."
  }
}

run "non_prod_workspace_name_uses_production_style_names" {
  command = plan

  variables {
    environment = "non-prod"
    location    = "westus3"
  }

  assert {
    condition     = output.names.primary_management_resource_group_name == "rg-management-westus3"
    error_message = "The non-prod workspace name should not add an environment infix."
  }
}

run "other_environments_get_an_automatic_infix" {
  command = plan

  variables {
    environment = "sandbox"
    location    = "westus2"
  }

  assert {
    condition     = output.names.primary_management_resource_group_name == "rg-management-sandbox-westus2"
    error_message = "An unlisted environment should automatically become the naming infix."
  }
}

run "environment_infix_can_be_overridden" {
  command = plan

  variables {
    environment = "qa"
    location    = "westus3"
    environment_infixes = {
      qa = "-asuqa"
    }
  }

  assert {
    condition     = output.names.primary_management_resource_group_name == "rg-management-asuqa-westus3"
    error_message = "An explicit environment infix should override the omission default."
  }
}

run "resource_identifiers_use_generated_names" {
  command = plan

  variables {
    environment = "qa"
    location    = "westus3"
    subscription_ids = {
      management = "00000000-0000-0000-0000-000000000001"
    }
  }

  assert {
    condition     = output.resource_identifiers.primary_log_analytics_workspace_id == "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/rg-management-westus3/providers/Microsoft.OperationalInsights/workspaces/law-management-westus3"
    error_message = "The Log Analytics workspace ID does not use the generated names."
  }
}