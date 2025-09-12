# output "mongo_connection_string" {
#   description = "Connection string for the MongoDB"
#   value       = azurerm_cosmosdb_account.librechat.connection_strings[0]
#   sensitive = true
# }

output "ressource_group_name" {
  description = "name of the created ressource group"
  value       = azurerm_resource_group.this.name
}

output "libre_chat_url" {
  value = "${azurerm_linux_web_app.librechat.name}.azurewebsites.net"
}

output "meilisearch_url" {
  value = "${azurerm_linux_web_app.meilisearch.name}.azurewebsites.net"
}

output "azure_openai_api_key" {
  value     = module.openai.openai_primary_key
  sensitive = true
}

output "azure_openai_endpoint" {
  value     = module.openai.openai_endpoint
  sensitive = true
}


# output "meilisearch_master_key" {
#   description = "MeiliSearch Master Key"
#   value       = random_string.meilisearch_master_key
# }

#==================================================#
#                 MCP Configuration                #
#==================================================#

output "mcp_enabled" {
  description = "Whether MCP (Model Context Protocol) is enabled"
  value       = var.enable_mcp
}

output "mcp_config_url" {
  description = "URL of the librechat.yaml configuration file (when MCP is enabled)"
  value       = var.enable_mcp ? azurerm_storage_blob.librechat_config[0].url : ""
}

output "mcp_servers_enabled" {
  description = "List of MCP servers that are enabled"
  value       = var.enable_mcp ? var.mcp_servers : []
}

output "config_path_debug" {
  description = "Debug information for CONFIG_PATH configuration"
  value = var.enable_mcp ? {
    message = "MCP is enabled with auto-generated config"
    config_url = azurerm_storage_blob.librechat_config[0].url
    storage_account = azurerm_storage_account.librechat_config[0].name
    container_name = azurerm_storage_container.config[0].name
    blob_name = "librechat.yaml"
    public_access = "blob"
    enable_mcp = var.enable_mcp
    mcp_servers = join(", ", var.mcp_servers)
    custom_config_path = "Not used (auto-generated)"
  } : {
    message = "MCP is disabled. Set enable_mcp = true to enable."
    config_url = var.config_path != "" ? var.config_path : "Not set"
    storage_account = "N/A"
    container_name = "N/A"
    blob_name = "N/A"
    public_access = "N/A"
    enable_mcp = var.enable_mcp
    mcp_servers = "None"
    custom_config_path = var.config_path != "" ? var.config_path : "Not set"
  }
}
