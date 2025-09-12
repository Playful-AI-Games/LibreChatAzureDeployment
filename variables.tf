variable "location" {
  description = "The location where all resources will be deployed"
  default     = "australiaeast"
}

variable "app_title" {
  description = "The title that librechat will display"
  default     = "librechat"
}

variable "openai_key" {
  description = "OpenAI API Key"
  default     = ""
  sensitive   = true
}

variable "chatgpt_token" {
  description = "ChatGPT Token"
  default     = "user_provided"
  sensitive   = true
}

variable "anthropic_api_key" {
  description = "Anthropic API Key"
  default     = "user_provided"
  sensitive   = true
}

variable "bingai_token" {
  description = "BingAI Token"
  default     = "user_provided"
  sensitive   = true
}

variable "palm_key" {
  description = "PaLM Key"
  default     = "user_provided"
  sensitive   = true
}

variable "app_service_sku_name" {
  description = "size of the VM that runs the librechat app. F1 is free but limited to 1h per day."
  default     = "B1"
}

variable "mongo_uri" {
  description = "Connection string for the mongodb"
  default     = ""
  sensitive   = true
}

variable "use_cosmosdb_free_tier" {
  description = "Flag to enable/disable free tier of cosmosdb. This needs to be false if another instance already uses free tier."
  default     = true
}

variable "deployments" {
  description = "(Optional) Specifies the deployments of the Azure OpenAI Service"
  type = map(object({
    name            = string
    rai_policy_name = string
    model_format    = string
    model_name      = string
    model_version   = string
    scale_type      = string
  }))
  default = {
    "gpt-4.1" = {
      name            = "gpt-4.1"
      rai_policy_name = "Microsoft.Default"
      model_name      = "gpt-4"
      model_format    = "OpenAI"
      model_version   = "2025-04-14"
      scale_type      = "Standard"
    },
    "text-embedding-ada-002" = {
      name            = "text-embedding-ada-002"
      rai_policy_name = "Microsoft.Default"
      model_name      = "text-embedding-ada-002"
      model_format    = "OpenAI"
      model_version   = "2"
      scale_type      = "Standard"
    },
  }
}

variable "azure_openai_api_deployment_name" {
  description = "(Optional) The deployment name of your Azure OpenAI API; if deployments.chat_model.name is defined, the default value is that value."
  default     = ""
}

variable "azure_openai_api_completions_deployment_name" {
  description = "(Optional) The deployment name for completion; if deployments.chat_model.name is defined, the default value is that value."
  default     = ""
}

variable "azure_openai_api_version" {
  description = "The version of your Azure OpenAI API"
  default     = "2024-02-01"
}

variable "azure_openai_api_embeddings_deployment_name" {
  description = "(Optional) The deployment name for embedding; if deployments.embedding_model.name is defined, the default value is that value."
  default     = ""
}

variable "public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed for the Azure OpenAI Service"
  type        = bool
  default     = false
}

#======================#
# MCP / Config Options #
#======================#

variable "enable_mcp" {
  description = "Enable MCP (Model Context Protocol) support with agents and MCP servers"
  type        = bool
  default     = false
}

variable "mcp_servers" {
  description = "List of MCP servers to enable. Options: filesystem, fetch, puppeteer, github, sqlite, memory"
  type        = list(string)
  default     = ["filesystem", "fetch"]
  
  validation {
    condition = alltrue([
      for server in var.mcp_servers : contains(
        ["filesystem", "fetch", "puppeteer", "github", "sqlite", "memory"],
        server
      )
    ])
    error_message = "Invalid MCP server. Valid options are: filesystem, fetch, puppeteer, github, sqlite, memory"
  }
}

variable "config_path" {
  description = "Optional path or URL to a custom librechat.yaml. Only used when enable_mcp is false. Setting both enable_mcp=true and config_path will result in an error."
  type        = string
  default     = ""
}

variable "mcp_oauth_on_auth_error" {
  description = "Treat 401/403 responses as OAuth requirement when no oauth metadata found (set to 'true' or 'false')."
  type        = string
  default     = ""
}

variable "mcp_oauth_detection_timeout" {
  description = "Timeout in ms for OAuth detection requests (string value, e.g. '5000')."
  type        = string
  default     = ""
}

variable "mcp_connection_check_ttl" {
  description = "Cache connection status checks for this many ms to avoid expensive verification (string value, e.g. '60000')."
  type        = string
  default     = ""
}


variable "amplitude_api_instantgarden" {
  description = "amplitude api key for amplitude-analytics-instantgarden MCP server"
  type        = string
  default     = ""
}

variable "amplitude_secret_instantgarden" {
  description = "amplitude secret key for amplitude-analytics-instantgarden MCP server"
  type        = string
  default     = ""
}