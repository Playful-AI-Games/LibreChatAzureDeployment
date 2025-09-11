# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform configuration for deploying LibreChat to Azure with all necessary services including:
- Azure App Service (Linux web app)
- Azure OpenAI Service with model deployments
- CosmosDB (MongoDB API) or custom MongoDB URI
- Virtual Network and networking components
- Cognitive Services for AI capabilities

## Key Commands

### Initial Setup
```bash
# Login to Azure
az login

# Initialize Terraform
terraform init

# Plan deployment (review changes)
terraform plan

# Apply configuration (deploy resources)
terraform apply

# Destroy all resources
terraform destroy
```

### Development Workflow
```bash
# Format Terraform files
terraform fmt

# Validate configuration
terraform validate

# Show current state
terraform state list
terraform state show <resource>
```

## Architecture & Structure

### Core Infrastructure Components
- **resource_group.tf**: Defines the Azure resource group containing all resources
- **network.tf**: Virtual network and subnet configuration for secure networking
- **db.tf**: CosmosDB with MongoDB API (free tier option available)
- **openai.tf**: Azure OpenAI service with configurable model deployments
- **webapps.tf**: Main LibreChat application deployment on Azure App Service with extensive environment variable configuration

### Configuration Files
- **variables.tf**: All input variables with defaults and descriptions
- **terraform.tfvars**: User-specific configuration (gitignored)
- **terraform.tfvars.sample**: Template for configuration values
- **outputs.tf**: Exposes important values like app URL and resource IDs

### Key Variables to Configure
- `location`: Azure region for deployment
- `app_title`: LibreChat instance title
- `mongo_uri`: Optional external MongoDB connection string (CosmosDB created if empty)
- `deployments`: Map of Azure OpenAI model deployments to create
- `app_service_sku_name`: App Service pricing tier (default: B1)
- Various API keys for AI services (OpenAI, Anthropic, Bing, etc.)

## Development Environment

The project includes a VS Code devcontainer configuration with:
- Azure CLI
- Terraform CLI
- Azure and Terraform VS Code extensions

## Important Notes

- The web app is configured with HTTPS-only and minimum TLS 1.2
- Public network access can be controlled via `public_network_access_enabled`
- CosmosDB free tier is available (limited to one per subscription)
- Random postfix is added to resource names to ensure uniqueness
- App settings in webapps.tf configure LibreChat environment variables including AI service connections, authentication, and feature flags