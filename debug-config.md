# LibreChat MCP Configuration Debugging Guide

## Current Configuration Status

Your CONFIG_PATH URL: `https://librechatcfg3lr3q5cc.blob.core.windows.net/config/librechat.yaml`

## Changes Made to Fix Configuration

### 1. Path References Fixed
- Changed `/workspace` to `/app` in librechat.yaml.tpl
- This matches the LibreChat container's actual directory structure

### 2. Environment Variables Added
- `ALLOW_CONFIG_OVERRIDE = "true"` - Allows external config to override defaults
- `CONFIG_CACHE_MODE = "file"` - Ensures config is cached as file
- `CONFIG_VALIDATE = "true"` - Validates config on load
- `DEBUG_CONFIG = "true"` - Enables debug logging for config loading
- `DEBUG_VERBOSE = true` - Enables verbose logging

### 3. Storage Configuration Updated
- Added CORS rules to allow LibreChat to fetch the config
- Ensures public blob access is enabled

### 4. Diagnostic Outputs Added
- New `config_path_debug` output shows all config-related settings
- Helps verify configuration is correct

## How to Apply Changes

```bash
# 1. Apply Terraform changes
terraform plan
terraform apply

# 2. Check the debug output
terraform output config_path_debug

# 3. Restart the Azure App Service (forces config reload)
az webapp restart --name librechatapp<postfix> --resource-group <your-rg-name>
```

## Verification Steps

### 1. Check App Service Logs
Navigate to Azure Portal > Your App Service > Log stream

Look for messages like:
- "Loading configuration from CONFIG_PATH"
- "CONFIG_PATH: https://..."
- "Agents endpoint enabled"
- "MCP servers configured"

### 2. Check LibreChat UI
After deployment:
1. Navigate to your LibreChat URL
2. Look for "Agents" or "Tools" in the endpoint selector
3. Check if MCP servers appear in the tools/agents section

### 3. Test CONFIG_PATH Loading
You can test if the config is accessible:
```bash
curl https://librechatcfg3lr3q5cc.blob.core.windows.net/config/librechat.yaml
```

### 4. Check Environment Variables
In Azure Portal > App Service > Configuration > Application settings:
- Verify CONFIG_PATH is set to the blob URL
- Verify AGENTS_ENDPOINT is true
- Verify ENDPOINTS includes "agents"

## Common Issues and Solutions

### Issue 1: CONFIG_PATH not loading
**Symptoms:** No agents/MCP options in UI
**Solution:** 
- Ensure `enable_mcp = true` in terraform.tfvars
- Check CONFIG_PATH environment variable is set
- Verify the YAML file is accessible publicly

### Issue 2: YAML parsing errors
**Symptoms:** Errors in logs about invalid YAML
**Solution:**
- Check YAML syntax is valid
- Ensure no tabs (only spaces) in YAML
- Verify template interpolation worked correctly

### Issue 3: MCP servers not appearing
**Symptoms:** Agents enabled but no MCP tools
**Solution:**
- Check mcpServers section in YAML
- Verify npx commands are available in container
- Check server initialization timeout settings

### Issue 4: Environment variable placeholders
**Symptoms:** Seeing ${AZURE_API_KEY} instead of actual values
**Solution:**
- LibreChat should replace these from environment
- Verify the environment variables are set in App Service
- Check if AZURE_API_KEY, AZURE_OPENAI_API_INSTANCE_NAME, etc. are defined

## Additional Debugging Commands

```bash
# View current app settings
az webapp config appsettings list \
  --name librechatapp<postfix> \
  --resource-group <your-rg-name> \
  --output table | grep -E "CONFIG|AGENT|MCP|ENDPOINT"

# Stream app logs
az webapp log tail \
  --name librechatapp<postfix> \
  --resource-group <your-rg-name>

# Check if config file is being fetched
az webapp log download \
  --name librechatapp<postfix> \
  --resource-group <your-rg-name> \
  --log-file config-debug.zip
```

## Next Steps

1. Run `terraform apply` to apply all changes
2. Monitor the App Service logs during restart
3. Check if agents/MCP options appear in LibreChat UI
4. If issues persist, check the debug output and logs

## Support

If MCP still doesn't appear after these changes:
1. Check the official LibreChat docs: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/agents
2. Verify the Docker image version supports CONFIG_PATH
3. Consider opening an issue with the logs from the debug steps