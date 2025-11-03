/*# =================================================
# Bicep Parameters files for custom policy assignment 
# ===================================================
*/
using '../../policyAssignment.bicep'

@description('Management group name to assign the policy')
param managementGroupName = '/providers/Microsoft.Management/managementGroups/B2B'

@description('Array value for policy assignment.Contains name and path of the policy assignment json file')
param PolicyAssignmentArray = [
  {
    libDefinition: loadJsonContent('CDS001.json')
  }
  {
    libDefinition: loadJsonContent('CDS002.json')
  }
  {
    libDefinition: loadJsonContent('CDS003.json')
  }
  {
    libDefinition: loadJsonContent('CDS004.json')
  }
  {
    libDefinition: loadJsonContent('CDS005.json')
  }
]
