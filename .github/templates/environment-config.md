# Environment Configuration Template

This document provides templates for configuring GitHub environments and variables for Azure Policy deployments.

## GitHub Repository Settings

### Required Secrets

Add these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

#### `AZURE_CREDENTIALS`
```json
{
  "clientId": "00000000-0000-0000-0000-000000000000",
  "clientSecret": "your-client-secret",
  "subscriptionId": "your-subscription-id",
  "tenantId": "your-tenant-id"
}
```

#### `AZURE_SERVICE_CONNECTION` (Optional)
```
your-service-connection-name
```

### Environment Configuration

Create the following environments with their respective variables:

#### Development Environment (`dev`)
- **Environment Name:** `dev`
- **Variables:**
  - `DEFAULT_MANAGEMENT_GROUP_ID`: `mg-corp-dev`

#### Test Environment (`test`)
- **Environment Name:** `test`
- **Variables:**
  - `DEFAULT_MANAGEMENT_GROUP_ID`: `mg-corp-test`

#### Production Environment (`prod`)
- **Environment Name:** `prod`
- **Variables:**
  - `DEFAULT_MANAGEMENT_GROUP_ID`: `mg-corp-prod`

## Azure Service Principal Configuration

### Required Permissions

The service principal needs the following permissions:

1. **Management Group Contributor** role at the root management group level
2. **Policy Contributor** role (if deploying to subscriptions directly)

### PowerShell Script to Create Service Principal

```powershell
# Replace with your values
$managementGroupId = "mg-corp"
$servicePrincipalName = "github-actions-azure-policy"

# Create service principal
$sp = az ad sp create-for-rbac `
    --name $servicePrincipalName `
    --role "Management Group Contributor" `
    --scopes "/providers/Microsoft.Management/managementGroups/$managementGroupId" `
    --sdk-auth

# Display credentials (save this for GitHub secret)
$sp | ConvertTo-Json -Depth 10
```

### Azure CLI Script to Create Service Principal

```bash
# Replace with your values
MANAGEMENT_GROUP_ID="mg-corp"
SERVICE_PRINCIPAL_NAME="github-actions-azure-policy"

# Create service principal
az ad sp create-for-rbac \
    --name $SERVICE_PRINCIPAL_NAME \
    --role "Management Group Contributor" \
    --scopes "/providers/Microsoft.Management/managementGroups/$MANAGEMENT_GROUP_ID" \
    --sdk-auth
```

## Management Group Structure Example

```
Root Tenant
├── mg-corp (Root Management Group)
│   ├── mg-corp-dev (Development)
│   ├── mg-corp-test (Test)
│   └── mg-corp-prod (Production)
│       ├── subscription-prod-1
│       └── subscription-prod-2
```

## Environment Variables Reference

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `DEFAULT_MANAGEMENT_GROUP_ID` | Default management group for deployments | `mg-corp-dev` |
| `AZURE_CREDENTIALS` | Service principal credentials (JSON) | See JSON template above |
| `AZURE_SERVICE_CONNECTION` | Optional service connection name | `azure-policy-connection` |

## GitHub Environments Setup Steps

### Using GitHub Web Interface

1. Go to your repository
2. Click **Settings**
3. Click **Environments** (left sidebar)
4. Click **New environment**
5. Enter environment name (e.g., `dev`)
6. Click **Configure environment**
7. Under **Environment variables**, click **Add variable**
8. Add `DEFAULT_MANAGEMENT_GROUP_ID` with appropriate value
9. Repeat for other environments

### Using GitHub CLI

```bash
# Set repository
REPO="your-org/your-repo"

# Create environments and set variables
gh api --method PUT "/repos/$REPO/environments/dev"
gh api --method POST "/repos/$REPO/environments/dev/variables" \
    --field name="DEFAULT_MANAGEMENT_GROUP_ID" \
    --field value="mg-corp-dev"

gh api --method PUT "/repos/$REPO/environments/test"
gh api --method POST "/repos/$REPO/environments/test/variables" \
    --field name="DEFAULT_MANAGEMENT_GROUP_ID" \
    --field value="mg-corp-test"

gh api --method PUT "/repos/$REPO/environments/prod"
gh api --method POST "/repos/$REPO/environments/prod/variables" \
    --field name="DEFAULT_MANAGEMENT_GROUP_ID" \
    --field value="mg-corp-prod"
```

## Validation Script

Use this PowerShell script to validate your configuration:

```powershell
# Validate GitHub repository configuration
param(
    [string]$Repository = "your-org/your-repo"
)

Write-Host "Validating GitHub repository configuration..." -ForegroundColor Green

# Check secrets
try {
    gh secret list --repo $Repository
    Write-Host "✅ Secrets configured" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to retrieve secrets" -ForegroundColor Red
}

# Check environments
$environments = @("dev", "test", "prod")
foreach ($env in $environments) {
    try {
        $envInfo = gh api "/repos/$Repository/environments/$env" | ConvertFrom-Json
        Write-Host "✅ Environment '$env' exists" -ForegroundColor Green
    } catch {
        Write-Host "❌ Environment '$env' not found" -ForegroundColor Red
    }
}
```

## Troubleshooting

### Common Issues

1. **Service Principal Permissions**
   - Ensure the service principal has Management Group Contributor role
   - Verify the scope includes the correct management group path

2. **Environment Variables**
   - Check environment names are lowercase and match workflow references
   - Verify variable names match exactly (case-sensitive)

3. **Secret Format**
   - Ensure AZURE_CREDENTIALS is valid JSON
   - Verify all required fields are present (clientId, clientSecret, subscriptionId, tenantId)

### Testing Configuration

```bash
# Test Azure login with service principal
az login --service-principal \
    --username "your-client-id" \
    --password "your-client-secret" \
    --tenant "your-tenant-id"

# Test management group access
az account management-group show --name "your-management-group-id"
```