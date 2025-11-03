targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - managementGroup Policy Assignments'
metadata description = 'Module used to assign policy definitions to managementGroup'
param managementGroupName string = ''

@description('Array value for policy assignment.')
param PolicyAssignmentArray array

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = [for policyAssignment in PolicyAssignmentArray: {
  name: policyAssignment.libDefinition.name
  properties: {
    displayName: policyAssignment.libDefinition.properties.displayName
    description: policyAssignment.libDefinition.properties.description
    policyDefinitionId: '${managementGroupName}${policyAssignment.libDefinition.properties.policyDefinitionId}'
    parameters: policyAssignment.libDefinition.properties.parameters
    nonComplianceMessages: []
    notScopes: policyAssignment.libDefinition.properties.notScopes
    enforcementMode: policyAssignment.libDefinition.properties.enforcementMode
  }
  identity: policyAssignment.libDefinition.identity.type != null ? {
    type: policyAssignment.libDefinition.identity.type
  } : null
  #disable-next-line no-loc-expr-outside-params 
  location: deployment().location
}]
