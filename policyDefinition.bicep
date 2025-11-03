//Custom policy defination resource
targetScope = 'managementGroup'

// Passing individual Custom Policy Defintions in below array
@description('Array value for policy definition.')
param CustomPolicyDefinitionsArray array

resource resPolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [for policy in CustomPolicyDefinitionsArray: {
  name: policy.libDefinition.name
  properties: {
    description: policy.libDefinition.properties.description
    displayName: policy.libDefinition.properties.displayName
    metadata: policy.libDefinition.properties.metadata
    mode: policy.libDefinition.properties.mode
    parameters: policy.libDefinition.properties.parameters
    policyType: policy.libDefinition.properties.policyType
    policyRule: policy.libDefinition.properties.policyRule
  }
}]
