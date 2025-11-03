targetScope = 'managementGroup'

@description('Array value for policy definitionSet.')
param PolicySetDefinitionsArray array
param managementGroupName string = ''
@description('Prefix for custom policy definition name.')
param policyDefinitionPrefix string = 'DFC'

resource resPolicySetDefinitions 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = [for policySet in PolicySetDefinitionsArray: {

  name: policySet.libSetDefinition.name
  properties: {
    description: policySet.libSetDefinition.properties.description
    displayName: policySet.libSetDefinition.properties.displayName
    metadata: policySet.libSetDefinition.properties.metadata
    parameters: policySet.libSetDefinition.properties.parameters
    policyType: policySet.libSetDefinition.properties.policyType
    policyDefinitions: [for policySetDef in policySet.libSetDefinition.properties.policyDefinitions: {
      policyDefinitionReferenceId: policySetDef.policyDefinitionReferenceId
      policyDefinitionId: contains(policySetDef.policyDefinitionId, policyDefinitionPrefix) ? '${managementGroupName}${policySetDef.policyDefinitionId}' : policySetDef.policyDefinitionId
      parameters: policySetDef.parameters
      groupNames: policySetDef.groupNames
    }]
    policyDefinitionGroups: policySet.libSetDefinition.properties.policyDefinitionGroups
  }
}]
