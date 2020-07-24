
resource "azurecaf_naming_convention" "rg" {
  for_each      = var.resource_groups

  name          = each.value.name
  resource_type = "azurerm_resource_group"
  convention    = lookup(each.value, "convention", var.global_settings.convention)
  prefix        = lookup(each.value, "useprefix", false) == true ? var.prefix : ""
  max_length    = lookup(each.value, "max_length", null)
}

resource "azurerm_resource_group" "rg" {
  for_each      = var.resource_groups

  name          = azurecaf_naming_convention.rg[each.key].result
  location      = lookup(each.value, "location", var.global_settings.default_location)
  tags          = merge(lookup(each.value, "tags", {}), var.tags) 
}
