resource "azurerm_postgresql_flexible_server_active_directory_administrator" "postgresql" {
  for_each = try(var.settings.azuread_administrator, {})

  resource_group_name = local.resource_group_name
  server_name         = azurerm_postgresql_flexible_server.postgresql.name
  tenant_id           = can(var.settings.authentication.tenant_id) ? var.settings.authentication.tenant_id : var.client_config.tenant_id
  object_id           = try(each.value.object_id, var.azuread_groups[var.client_config.landingzone_key][each.value.azuread_group_key].id, var.azuread_groups[each.value.lz_key][each.value.azuread_group_key].id)
  principal_name      = try(each.value.display_name, var.azuread_groups[var.client_config.landingzone_key][each.value.azuread_group_key].display_name, var.azuread_groups[each.value.lz_key][each.value.azuread_group_key].display_name)
  principal_type      = "Group"
}