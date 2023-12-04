resource "azurerm_gallery_application_version" "gallery_application_version" {
  for_each = lookup(var.settings, "application_versions", {})

  name                   = each.value.name
  gallery_application_id = azurerm_gallery_application.gallery_application.id
  location               = local.location
  enable_health_check    = try(each.value.enable_health_check, false)
  end_of_life_date       = try(each.value.end_of_life_date, null)
  exclude_from_latest    = try(each.value.exclude_from_latest, false)
  tags                   = local.tags
  manage_action {
    install = each.value.install_cmd
    remove  = each.value.remove_cmd
    update  = try(each.value.update_cmd, null)
  }

  source {
    media_link                 = each.value.media_link
    default_configuration_link = try(each.value.default_configuration_link, null)
  }

  target_region {
    name                   = local.location
    regional_replica_count = try(each.value.defult_regional_replica_count, 1)
    storage_account_type   = try(each.value.defult_storage_account_type, "Standard_LRS")
  }
  dynamic "target_region" {
    for_each = try(each.value.target_regions, {})
    content {
      name                   = try(target_region.value.name, null)
      regional_replica_count = coalesce(try(target_region.value.regional_replica_count, null), try(each.value.defult_storage_account_type, 1))
      storage_account_type   = coalesce(try(target_region.value.storage_account_type, null), try(each.value.defult_storage_account_type, "Standard_LRS"))
    }
  }
}