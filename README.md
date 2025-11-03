# Azure Policy GitHub Actions Deployment Guide

This repository contains GitHub Actions workflows for deploying Azure Policy Definitions, Definition Sets, and Assignments using Bicep templates. The workflows provide user-friendly, flexible deployment options for managing Azure Policies at scale.

## 🚀 Quick Start

### Prerequisites

1. **Azure Subscription** with appropriate permissions
2. **Management Group** access where policies will be deployed
3. **GitHub Repository** with this code
4. **Service Principal** with Management Group Contributor role

### Initial Setup

#### 1. Create Azure Service Principal

Run the following Azure CLI command to create a service principal:

```powershell
# Replace YOUR_ROOT_MG_ID with your actual management group ID
az ad sp create-for-rbac --name "github-actions-azure-policy" --role "Management Group Contributor" --scopes "/providers/Microsoft.Management/managementGroups/YOUR_ROOT_MG_ID" --sdk-auth
```

Save the JSON output for the next step.

#### 2. Configure GitHub Repository

1. **Add Secrets:**
   - Go to your repository → Settings → Secrets and variables → Actions
   - Add a new repository secret named `AZURE_CREDENTIALS`
   - Paste the JSON output from the service principal creation

2. **Create Environments:**
   - Go to Settings → Environments
   - Create environments: `dev`, `test`, `prod`
   - For each environment, add variable `DEFAULT_MANAGEMENT_GROUP_ID` with your management group ID

#### 3. Repository Structure

Ensure your repository has the following structure:
```
AzurePolicyV2/
├── .github/
│   └── workflows/
│       ├── deploy-policy-definitions.yml
│       ├── deploy-policy-definition-sets.yml
│       └── deploy-policy-assignments.yml
├── policyDefinition.bicep
├── policyDefinitionSet.bicep
├── policyAssignment.bicep
└── Params/
    ├── Definition/
    │   ├── DFC01.json
    │   ├── DFC02.json
    │   └── ... (other policy definition files)
    ├── DefinitionSet/
    │   ├── CDS001.json
    │   ├── CDS002.json
    │   └── ... (other policy set definition files)
    └── Assignment/
        ├── CDS001.json
        ├── BD001.json
        └── ... (other assignment files)
```

## 📋 Available Workflows

### 1. Deploy Policy Definitions

**File:** `.github/workflows/deploy-policy-definitions.yml`

**Purpose:** Deploys custom Azure Policy definitions to a management group.

**Trigger Options:**
- Manual trigger with parameters
- Automatic trigger on push to main branch (when policy definition files change)

**Parameters:**
- `environment`: Deployment environment (dev/test/prod)
- `management_group_id`: Target management group ID
- `policy_definitions_to_deploy`: Specific policies to deploy (comma-separated) or "all"

**Usage Example:**
1. Go to Actions tab in your GitHub repository
2. Select "Deploy Azure Policy Definitions"
3. Click "Run workflow"
4. Fill in the parameters:
   - Environment: `dev`
   - Management Group ID: `mg-corp`
   - Policies to Deploy: `DFC01,DFC02` or `all`

### 2. Deploy Policy Definition Sets

**File:** `.github/workflows/deploy-policy-definition-sets.yml`

**Purpose:** Deploys policy definition sets (collections of policies) to a management group.

**Prerequisites:** Custom policy definitions should be deployed first if referenced.

**Parameters:**
- `environment`: Deployment environment (dev/test/prod)
- `management_group_id`: Target management group ID
- `policy_definition_prefix`: Custom policy prefix (default: "DFC")
- `definition_sets_to_deploy`: Specific definition sets to deploy or "all"

**Usage Example:**
1. Go to Actions tab in your GitHub repository
2. Select "Deploy Azure Policy Definition Sets"
3. Click "Run workflow"
4. Fill in the parameters:
   - Environment: `dev`
   - Management Group ID: `mg-corp`
   - Policy Definition Prefix: `DFC`
   - Definition Sets to Deploy: `CDS001,CDS011` or `all`

### 3. Deploy Policy Assignments

**File:** `.github/workflows/deploy-policy-assignments.yml`

**Purpose:** Assigns policies and policy sets to management groups, subscriptions, or resource groups.

**Prerequisites:** Policy definitions and definition sets should be deployed first.

**Parameters:**
- `environment`: Deployment environment (dev/test/prod)
- `target_management_group_id`: Where to assign policies
- `source_management_group_id`: Where policies are defined (optional, defaults to target)
- `assignment_type`: custom/builtin/both
- `assignments_to_deploy`: Specific assignments to deploy or "all"

**Usage Example:**
1. Go to Actions tab in your GitHub repository
2. Select "Deploy Azure Policy Assignments"
3. Click "Run workflow"
4. Fill in the parameters:
   - Environment: `dev`
   - Target Management Group ID: `mg-workloads`
   - Source Management Group ID: `mg-corp`
   - Assignment Type: `custom`
   - Assignments to Deploy: `CDS001,CDS011` or `all`

## 🔄 Deployment Workflow

### Recommended Deployment Order

1. **Policy Definitions** → Deploy custom policy definitions first
2. **Policy Definition Sets** → Deploy policy sets that reference the definitions
3. **Policy Assignments** → Assign policies to target scopes

### Example Complete Deployment

```yaml
# Step 1: Deploy Custom Policies
Environment: dev
Management Group ID: mg-corp
Policies: all

# Step 2: Deploy Policy Sets
Environment: dev
Management Group ID: mg-corp
Policy Prefix: DFC
Definition Sets: all

# Step 3: Assign Policies
Environment: dev
Target Management Group: mg-workloads
Source Management Group: mg-corp
Assignment Type: custom
Assignments: all
```

## 🏗️ Architecture

### Workflow Features

- **User-Friendly:** Manual triggers with input parameters
- **Flexible:** Deploy all or specific policies/assignments
- **Safe:** Validation steps and environment-specific deployments
- **Modular:** Separate workflows for each component
- **Dependency Aware:** Validates prerequisites before deployment
- **Scalable:** Easy to extend with additional environments

### Dynamic Parameter Generation

The workflows automatically generate Bicep parameter files based on user input, allowing for:
- Selective deployment of specific policies
- Dynamic management group references
- Environment-specific configurations

## 🔧 Advanced Configuration

### Environment-Specific Variables

Each environment can have different configuration:

```yaml
# dev environment
DEFAULT_MANAGEMENT_GROUP_ID: mg-corp-dev

# test environment  
DEFAULT_MANAGEMENT_GROUP_ID: mg-corp-test

# prod environment
DEFAULT_MANAGEMENT_GROUP_ID: mg-corp-prod
```

### Custom Policy Naming Convention

The workflows expect custom policies to follow naming patterns:
- **Policy Definitions:** `DFC*.json` (e.g., DFC01.json, DFC02.json)
- **Policy Definition Sets:** `CDS*.json` (e.g., CDS001.json, CDS002.json)
- **Custom Assignments:** `CDS*.json` for custom policy assignments
- **Built-in Assignments:** `BD*.json` for built-in policy assignments

### Multi-Management Group Scenarios

For complex scenarios with multiple management groups:

1. **Policy Storage MG:** Where custom policies are stored
2. **Target MG:** Where policies are assigned

Use different management group IDs in the assignment workflow:
- `source_management_group_id`: Where policies are defined
- `target_management_group_id`: Where policies are assigned

## 🛠️ Troubleshooting

### Common Issues

1. **Permission Errors**
   - Ensure service principal has Management Group Contributor role
   - Verify management group ID is correct

2. **Policy Not Found**
   - Deploy policy definitions before definition sets
   - Deploy definition sets before assignments
   - Check policy naming conventions

3. **Parameter File Errors**
   - Verify JSON files are valid
   - Check file naming matches expected patterns

### Debugging Steps

1. **Check Workflow Logs:**
   - Go to Actions tab → Select failed workflow → View logs

2. **Validate Bicep Files:**
   ```bash
   az bicep build --file AzurePolicyV2/policyDefinition.bicep
   ```

3. **List Existing Policies:**
   ```bash
   az policy definition list --management-group YOUR_MG_ID --query "[?policyType=='Custom'].name"
   ```

## 📚 Additional Resources

- [Azure Policy Documentation](https://docs.microsoft.com/en-us/azure/governance/policy/)
- [Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the workflows
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.