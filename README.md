# LibreChatAzureDeployment
A Terraform setup to deploy [LibreChat](https://github.com/danny-avila/LibreChat) to Azure and setup all the necessary services.

# Azure Deployment Instructions

## Prerequisites

You must have an existing Azure subscription for this to work.

## Steps

1. **Clone the repository.**
   
2. **Open in VS-Code Devcontainer.**

3. **[Optional] Configure Deployment:**
    * Edit `terraform.tfvars` to customize your deployment. 
    * You can for example set the `MONGO_URI` which is the connection string to your MongoDB. A fast and simple solution for that is a free cloud instance, like setting up an [Atlas Instance](https://github.com/danny-avila/LibreChat/blob/main/docs/install/mongodb.md). By default a CosmosDB instance is set up automatically.

4. **Azure Login:** Open the Terminal inside of VS-Code, and run the command `az login`.

5. **Terraform Initialization:** In the Terminal inside of VS-Code, run the command `terraform init`.

6. **Apply Terraform Configuration:** In the Terminal inside of VS-Code, run the command `terraform apply`.

7. **Open LibreChat:** After finishing, terraform shows the outputs in the terminal. Open the Url of "libre_chat_url" (it might take some minutes until everything has booted)

## Enable MCP (Model Context Protocol)

- Provide a custom `librechat.yaml` that includes an `mcpServers` section (see: https://www.librechat.ai/docs/features/mcp). Host it at an accessible URL or a path available to the container.
- In `terraform.tfvars`, set:
  - `config_path` to that path or URL (supports file path or URL).
  - Optionally tune MCP via:
    - `mcp_oauth_on_auth_error = "true"`
    - `mcp_oauth_detection_timeout = "5000"`
    - `mcp_connection_check_ttl = "60000"`

Note: When using a URL for `config_path`, LibreChat will fetch the YAML at startup. Ensure it contains your MCP server definitions and any required user variables.
## Teardown

To tear down your Azure resources, run the command `terraform destroy` in the Terminal inside of VS-Code.



Playful note: 
Using mongo atlas instance, not cosmo, which was having a lot of compat problems
