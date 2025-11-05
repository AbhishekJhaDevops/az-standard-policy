/*# ========================================
# Bicep Parameters files for custom policy definitionset
# ==========================================
*/

using '../../policyDefinitionSet.bicep'

@description('Management group name where custom policies has been created')
param managementGroupName = '/providers/Microsoft.Management/managementGroups/alzpoc'
@description('Prefix for custom policy definition name.')
param policyDefinitionPrefix = 'DFC'
@description('Array value for policy definitionSet.Contains name and path of the policy definitionSet json file')
param PolicySetDefinitionsArray = [
  {
    libSetDefinition: loadJsonContent('CDS001.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS002.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS003.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS004.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS005.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS006.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS005.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS006.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS007.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS008.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS009.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS010.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS011.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS012.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS013.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS014.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS015.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS016.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS017.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS018.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS019.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS020.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS021.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS022.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS023.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS024.json')
  }
  {
    libSetDefinition: loadJsonContent('CDS025.json')
  }
]
