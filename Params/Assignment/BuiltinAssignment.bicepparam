/*# ===================================================
# Bicep Parameters files for builtin policy assignment 
# =====================================================
*/
using '../../policyAssignment.bicep'

@description('Array value for policy assignment.Contains name and path of the policy assignment json file')
param PolicyAssignmentArray = [
  {
    libDefinition: loadJsonContent('BD001.json')
  }
  {
    libDefinition: loadJsonContent('BD002.json')
  }
]
