## Introduction
   The Repository Directory 'AzurePolicy' provides an approach for deploying and managing the azure policies components in to the SPC environment. Below are the azure policy coponents getting deployed by the bicep under this directory
   * Definition: Creates cutom definatition for SPC environment
   * DefinitionSet: Creates builtin and custom definition for SPC     environment
   * Assignment: Assign custom and builtin definition/definitionSet at SPC management group level

## Directory Structure

>[!Caution]
>To avoid conflicts, I moved the directory that handles the Parameters values ​​to the Root Level. Once done at the Root Level, you should move it into the Azure Policy directory.

>[!note]
>The basic structure, excluding directory for Parameters, is the same as defined in the Readme.md file. (Parameters are structured within a separate Params directory.)

```bash
└───AzurePolicy
    ├───policyDefinition.bicep
    ├───policyDefinitionSet.bicep
    ├───policyAssignment.bicep
    └───Params
        ├───Assignment
        │   ├───SPC-COMMON
        │   │   ├───{policyName 1}.json
        │   │   ├───{policyName 2}.json
        │   │   ├───...
        │   │   ├───BuiltinAssignment.bicepparam
        │   │   ├───CustomAssignment.bicepparam
        │   ├───SPC-INDUSTRY-COMMON
        │   │   ├───{policyName 1}.json
        │   │   ├───{policyName 2}.json
        │   │   ├───...
        │   │   ├───BuiltinAssignment.bicepparam
        │   │   ├───CustomAssignment.bicepparam
        │   └───...
        ├───policyDefinationParams
        │   ├───SPC-COMMON
        │   │   ├───{policyName 1}.json
        │   │   ├───{policyName 2}.json
        │   │   ├───...
        │   │   ├───CustomAssignment.bicepparam
        │   ├───SPC-INDUSTRY-COMMON
        │   │   ├───{policyName 1}.json
        │   │   ├───{policyName 2}.json
        │   │   ├───...
        │   │   ├───CustomAssignment.bicepparam
        │   └───...
        └───policyDefinationSetParams
            ├───default
            │   ├───{policyName 1}.json
            │   ├───{policyName 2}.json
            │   ├───...
            │   ├───BuiltinAssignment.bicepparam
            │   ├───CustomAssignment.bicepparam
            └───industryCommon
                ├───{policyName 1}.json
                ├───{policyName 2}.json
                └───...
                ├───BuiltinAssignment.bicepparam
                ├───CustomAssignment.bicepparam
            
```

# Definition

## Parameters
### Custom Definition
Parameter name | Required | Description
-------------- | -------- | -----------
CustomPolicyDefinitionsArray | Yes       | Array value for policy definition.Contains name and path of the policy definition json file.

## Parameter file (Snippets)
### CustomDefinition.bicepparam

```bicepparam
using '../../../policyDefinition.bicep'

@description('Array value for policy definition.Contains name and path of the policy definition json file')
param CustomPolicyDefinitionsArray = [
  {
    name: 'DFC01'
    libDefinition: loadJsonContent('DFC01.json')
  }
  {
    name: 'DFC02'
    libDefinition: loadJsonContent('DFC02.json')
  }
]
```


## Deployment

### PolicyDefination Command
  * Syntax 
     ``` 
     az deployment mg create --name <name_of_bicep_deployment> --location <region> --management-group-id <managementGroupId> --template-file /path/to/<bicepResourcefile.bicep> --parameters /path/to/<parameterfile.bicepparam> 
     ```
    ### Example : Command execution from root(AzurePolicy) directory
    * Default policies: 
      ```
       az deployment mg create --name demoMGDeployment --location koreacentral --management-group-id Lab365 --template-file policyDefination.bicep --parameters Params/policyDefinationParams/default/default.bicepparam 
       ```

    * IndustryCommon policies:  
      ``` 
      az deployment mg create --name demoMGDeployment --location koreacentral --management-group-id Lab365 --template-file policyDefination.bicep --parameters Params/policyDefinationParams/industryCommon/industryCommon.bicepparam 
      
      ```
# DefinitionSet

## Parameters
### Builtin DefinitionSet

Parameter name | Required | Description
-------------- | -------- | -----------
PolicySetDefinitionsArray | Yes       | Array value for policy definitionSet.Contains name and path of the policy definitionSet json file.

### Custom DefinitionSet

Parameter name | Required | Description
-------------- | -------- | -----------
managementGroupName | Yes       | Management group name to create the definitionset.
PolicySetDefinitionsArray | Yes       | Array value for policy definitionSet.Contains name and path of the policy definitionSet json file.
## Parameter file (Snippets)

### BuiltinDefinitionSet.bicepparam

```bicepparam
using '../../../policyDefinitionSet.bicep'

@description('Array value for policy definitionSet.Contains name and path of the policy definitionSet json file')
param PolicySetDefinitionsArray = [
  {
    name: 'DFIC01'
    libSetDefinition: loadJsonContent('DFIC01.json')
  }
  {
    name: 'DFIC02'
    libSetDefinition: loadJsonContent('DFIC02.json')
  }
  {
    name: 'DFIC04'
    libSetDefinition: loadJsonContent('DFIC04.json')
  }
]
```

### CustomDefinitionSet.bicepparam

```bicepparam
using '../../../policyDefinitionSet.bicep'

@description('Management group name to create the definitionset')
param managementGroupName = '/providers/Microsoft.Management/managementGroups/B2B'

@description('Array value for policy definitionSet.Contains name and path of the policy definitionSet json file')
param PolicySetDefinitionsArray = [
 
]
```
## Deployment
### PolicyDefinationSet Command
  * Syntax
      ``` 
       az deployment mg create --name <name_of_bicep_deployment> --location <region> --management-group-id <managementGroupId> --template-file /path/to/<bicepResourcefile.bicep> --parameters /path/to/<parameterfile.bicepparam> 
      ```
    ### Example : Command execution from root(AzurePolicy) directory
    * Default policySet:
        ```
        az deployment mg create --name demoMGDeployment --location koreacentral --management-group-id Lab365 --template-file policyDefinationSet.bicep --parameters Params/policyDefinationSetParams/default/default.bicepparam
        ```
    * industryCommon policySet:
        ```
        az deployment mg create --name demoMGDeployment --location koreacentral --management-group-id Lab365 --template-file policyDefinationSet.bicep --parameters Params/policyDefinationSetParams/industryCommon/industryCommon.bicepparam
        ```

# Assignment
  ## Parameters
  ### Builtin Policy Assignment
  Parameter name | Required | Description
  -------------- | -------- | -----------
  PolicyAssignmentArray | Yes       | Array value for policy assignment.Contains name and path of the policy assignment json file.

  ### Custom Policy Assignment
  Parameter name | Required | Description
  -------------- | -------- | -----------
  managementGroupName | Yes       | Managemenr group name to assign the policy.
  PolicyAssignmentArray | Yes       | Array value for policy assignment.Contains name and path of the policy assignment json file.
 
 ## Parameter file (Snippets)

  ### BuiltinAssignment.bicepparam

  ```bicepparam
  using '../../../policyAssignment.bicep'

  @description('Array value for policy assignment.Contains name and path of the policy assignment json file')
  param PolicyAssignmentArray = [
    {
      name: 'DFB01'
      libDefinition: loadJsonContent('DFB01.json')
    }
    {
    name: 'DFB02'
    libDefinition: loadJsonContent('DFB02.json')
    }
  ]
  ```
 ## Deployment
  ### CustomAssignment.bicepparam

  ```bicepparam
  using '../../../policyAssignment.bicep'

  @description('Managemenr group name to assign the policy')
  param managementGroupName = '/providers/Microsoft.Management/managementGroups/B2B'

  @description('Array value for policy assignment.Contains name and path of the policy assignment json file')
  param PolicyAssignmentArray = [
  ]
  ```
  ### PolicyAssignment Command
  * Syntax
      ``` 
      az deployment mg create --name <name_of_bicep_deployment> --location <region> --management-group-id <managementGroupId> --template-file /path/to/<bicepResourcefile.bicep> --parameters /path/to/<parameterfile.bicepparam> 
      ```
    ### Example : Command execution from root(AzurePolicy) directory
    * Default policyAssignment:
        ```
        az deployment mg create --name demoMGDeployment --location koreacentral --management-group-id Lab365 --template-file policyAssignment.bicep --parameters Params/policyAssignmentParams/default/default.bicepparam
        ```
    * industryCommon policyAssignment:
        ```
        az deployment mg create --name demoMGDeployment --location koreacentral --management-group-id Lab365 --template-file policyAssignment.bicep --parameters Params/policyAssignmentParams/industryCommon/industryCommon.bicepparam
        ```