# GitHub Actions Deployment Examples

This document provides practical examples of using the GitHub Actions workflows for Azure Policy deployments.

## Basic Deployment Scenarios

### Scenario 1: Deploy All Policies to Development

**Use Case:** Initial deployment of all custom policies to development environment.

**Workflow:** Deploy Policy Definitions
```yaml
Environment: dev
Management Group ID: mg-corp-dev
Policy Definitions to Deploy: all
```

**Expected Result:** All DFC*.json policy definitions deployed to development management group.

### Scenario 2: Deploy Specific Policy Set to Test

**Use Case:** Deploy logging and diagnostic policy set to test environment.

**Workflow:** Deploy Policy Definition Sets
```yaml
Environment: test
Management Group ID: mg-corp-test
Policy Definition Prefix: DFC
Definition Sets to Deploy: CDS011
```

**Expected Result:** CDS011-Logging-Diagnostic policy set deployed to test management group.

### Scenario 3: Assign Policies to Production Workloads

**Use Case:** Assign security policies to production workload management group.

**Workflow:** Deploy Policy Assignments
```yaml
Environment: prod
Target Management Group ID: mg-workloads-prod
Source Management Group ID: mg-corp-prod
Assignment Type: custom
Assignments to Deploy: CDS001,CDS002,CDS011
```

**Expected Result:** Selected custom policy assignments applied to production workloads.

## Advanced Deployment Scenarios

### Scenario 4: Cross-Management Group Assignment

**Use Case:** Assign policies defined in central governance MG to different business unit MGs.

**Step 1:** Deploy Policy Definitions
```yaml
Environment: prod
Management Group ID: mg-governance
Policy Definitions to Deploy: all
```

**Step 2:** Deploy Policy Definition Sets
```yaml
Environment: prod
Management Group ID: mg-governance
Policy Definition Prefix: DFC
Definition Sets to Deploy: all
```

**Step 3:** Assign to Business Unit 1
```yaml
Environment: prod
Target Management Group ID: mg-business-unit-1
Source Management Group ID: mg-governance
Assignment Type: custom
Assignments to Deploy: CDS001,CDS011
```

**Step 4:** Assign to Business Unit 2
```yaml
Environment: prod
Target Management Group ID: mg-business-unit-2
Source Management Group ID: mg-governance
Assignment Type: custom
Assignments to Deploy: CDS002,CDS011
```

### Scenario 5: Mixed Built-in and Custom Policy Deployment

**Use Case:** Deploy both custom and built-in policy assignments.

**Step 1:** Deploy Custom Assignments
```yaml
Environment: prod
Target Management Group ID: mg-workloads
Source Management Group ID: mg-governance
Assignment Type: custom
Assignments to Deploy: all
```

**Step 2:** Deploy Built-in Assignments
```yaml
Environment: prod
Target Management Group ID: mg-workloads
Source Management Group ID: (not needed for built-in)
Assignment Type: builtin
Assignments to Deploy: BD001,BD002
```

### Scenario 6: Gradual Rollout Strategy

**Use Case:** Gradual deployment of new policies across environments.

**Phase 1: Development**
```yaml
# Deploy new policy definition
Environment: dev
Management Group ID: mg-corp-dev
Policy Definitions to Deploy: DFC85

# Test the policy set
Environment: dev
Management Group ID: mg-corp-dev
Definition Sets to Deploy: CDS025

# Assign for testing
Environment: dev
Target Management Group ID: mg-corp-dev
Assignment Type: custom
Assignments to Deploy: CDS025
```

**Phase 2: Test Environment**
```yaml
# Promote to test
Environment: test
Management Group ID: mg-corp-test
Policy Definitions to Deploy: DFC85

Environment: test
Management Group ID: mg-corp-test
Definition Sets to Deploy: CDS025

Environment: test
Target Management Group ID: mg-corp-test
Assignment Type: custom
Assignments to Deploy: CDS025
```

**Phase 3: Production**
```yaml
# Deploy to production
Environment: prod
Management Group ID: mg-corp-prod
Policy Definitions to Deploy: DFC85

Environment: prod
Management Group ID: mg-corp-prod
Definition Sets to Deploy: CDS025

Environment: prod
Target Management Group ID: mg-workloads-prod
Source Management Group ID: mg-corp-prod
Assignment Type: custom
Assignments to Deploy: CDS025
```

## Workflow Automation Examples

### Example 1: Automated CI/CD Pipeline

**Trigger:** Push to main branch

```yaml
# Automatically triggered when files change
# .github/workflows/deploy-policy-definitions.yml triggers on:
push:
  branches:
    - main
  paths:
    - 'AzurePolicyV2/policyDefinition.bicep'
    - 'AzurePolicyV2/Params/Definition/**'
```

**Use Case:** Automatic deployment of policy changes to development environment.

### Example 2: Manual Production Deployment

**Trigger:** Manual workflow dispatch

```yaml
# Manual deployment to production with approval
workflow_dispatch:
  inputs:
    environment: prod
    management_group_id: mg-corp-prod
    policy_definitions_to_deploy: all
```

**Use Case:** Controlled production deployments with human approval.

## Real-World Management Group Examples

### Example 1: Enterprise with Business Units

```
Root Tenant
├── mg-enterprise
│   ├── mg-governance (Policy definitions stored here)
│   ├── mg-security (Security-specific assignments)
│   ├── mg-business-unit-finance
│   ├── mg-business-unit-hr
│   └── mg-business-unit-it
```

**Deployment Strategy:**
1. Deploy all policies to `mg-governance`
2. Assign security policies to `mg-security`
3. Assign business-specific policies to respective business unit MGs

### Example 2: Multi-Environment Setup

```
Root Tenant
├── mg-corp
│   ├── mg-corp-nonprod
│   │   ├── mg-corp-dev
│   │   └── mg-corp-test
│   └── mg-corp-prod
│       ├── mg-workloads-prod
│       └── mg-platform-prod
```

**Deployment Strategy:**
1. Develop and test in `mg-corp-dev`
2. Validate in `mg-corp-test`
3. Deploy to production management groups

## Common Parameter Combinations

### For Policy Definitions

```yaml
# Deploy all custom policies
policy_definitions_to_deploy: "all"

# Deploy specific policies
policy_definitions_to_deploy: "DFC01,DFC02,DFC11"

# Deploy single policy
policy_definitions_to_deploy: "DFC85"
```

### For Policy Definition Sets

```yaml
# Deploy all definition sets
definition_sets_to_deploy: "all"

# Deploy security-related sets
definition_sets_to_deploy: "CDS001,CDS002,CDS003"

# Deploy single definition set
definition_sets_to_deploy: "CDS011"
```

### For Policy Assignments

```yaml
# Deploy all custom assignments
assignment_type: "custom"
assignments_to_deploy: "all"

# Deploy specific custom assignments
assignment_type: "custom"
assignments_to_deploy: "CDS001,CDS011"

# Deploy built-in assignments
assignment_type: "builtin"
assignments_to_deploy: "BD001,BD002"

# Deploy both types
assignment_type: "both"
assignments_to_deploy: "all"
```

## Validation and Testing

### Pre-Deployment Validation

```bash
# Validate policies exist before assignment
az policy definition list --management-group mg-governance --query "[?policyType=='Custom'].name"

# Check policy set definitions
az policy set-definition list --management-group mg-governance --query "[?policyType=='Custom'].name"
```

### Post-Deployment Verification

```bash
# List all assignments in target scope
az policy assignment list --scope "/providers/Microsoft.Management/managementGroups/mg-workloads" --query "[].{Name:name,Policy:policyDefinitionId}"

# Check compliance state
az policy state list --management-group mg-workloads --query "[].{Resource:resourceId,State:complianceState}"
```

## Troubleshooting Examples

### Issue: Policy Not Found During Assignment

**Error:** Policy definition 'DFC01' not found

**Solution:**
1. Check if policy was deployed to correct management group
2. Verify source management group ID in assignment workflow
3. Ensure policy definition prefix matches

### Issue: Permission Denied

**Error:** Insufficient permissions to deploy to management group

**Solution:**
1. Verify service principal has Management Group Contributor role
2. Check if management group ID is correct
3. Validate Azure credentials in GitHub secrets

### Issue: Parameter File Generation Error

**Error:** JSON file not found

**Solution:**
1. Verify file naming convention (DFC*.json, CDS*.json, BD*.json)
2. Check file exists in correct directory
3. Validate JSON syntax in parameter files