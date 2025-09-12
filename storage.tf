#==================================================#
#         Azure Storage for LibreChat Config       #
#==================================================#

# Storage account for LibreChat configuration files
resource "azurerm_storage_account" "librechat_config" {
  count = var.enable_mcp ? 1 : 0

  name                     = "librechatcfg${random_string.random_postfix.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable public blob access for CONFIG_PATH URL
  allow_nested_items_to_be_public = true
  
  # Enable CORS for LibreChat to access the config
  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "OPTIONS"]
      allowed_origins    = ["*"]  # In production, restrict to your app URL
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }

  tags = {
    Purpose = "LibreChat Configuration Storage"
    MCP     = "Enabled"
  }
}

# Container for configuration files
resource "azurerm_storage_container" "config" {
  count = var.enable_mcp ? 1 : 0

  name                  = "config"
  storage_account_name  = azurerm_storage_account.librechat_config[0].name
  container_access_type = "blob" # Allow public read access to blobs
}

# Generate librechat.yaml content
locals {
  librechat_yaml_content = var.enable_mcp ? templatefile("${path.module}/templates/librechat.yaml.tpl", {
    enable_mcp        = var.enable_mcp
    mcp_servers       = var.mcp_servers
    app_title         = var.app_title
    azure_api_key     = "$${AZURE_API_KEY}" # Escaped to be literal in output
    azure_instance    = "$${AZURE_OPENAI_API_INSTANCE_NAME}"
    azure_deployment  = "$${AZURE_OPENAI_API_DEPLOYMENT_NAME}"
    azure_version     = "$${AZURE_OPENAI_API_VERSION}"
  }) : ""
}

# Upload librechat.yaml to blob storage
resource "azurerm_storage_blob" "librechat_config" {
  count = var.enable_mcp ? 1 : 0

  name                   = "librechat.yaml"
  storage_account_name   = azurerm_storage_account.librechat_config[0].name
  storage_container_name = azurerm_storage_container.config[0].name
  type                   = "Block"
  content_type           = "text/yaml"
  
  # Use source_content for inline content
  source_content = local.librechat_yaml_content
}

# Output the public URL for CONFIG_PATH
output "librechat_config_url" {
  value = var.enable_mcp ? azurerm_storage_blob.librechat_config[0].url : ""
  description = "Public URL for librechat.yaml configuration file"
}