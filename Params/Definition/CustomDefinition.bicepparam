/*# ==================================================
# Bicep Parameters files for custom policy definition
# ====================================================
*/

using '../../policyDefinition.bicep'

@description('Array value for policy definition.Contains name and path of the policy definition json file')
param CustomPolicyDefinitionsArray = [
  {
    libDefinition: loadJsonContent('DFC01.json')
  }
  {
    libDefinition: loadJsonContent('DFC02.json')
  }
  {
    libDefinition: loadJsonContent('DFC03.json')
  }
  {
    libDefinition: loadJsonContent('DFC04.json')
  }
  {
    libDefinition: loadJsonContent('DFC05.json')
  }
  {
    libDefinition: loadJsonContent('DFC06.json')
  }
 {
  libDefinition: loadJsonContent('DFC08.json')
 }
  {
    libDefinition: loadJsonContent('DFC09.json')
  }
  {
    libDefinition: loadJsonContent('DFC10.json')
  }
  {
    libDefinition: loadJsonContent('DFC11.json')
  }
  {
    libDefinition: loadJsonContent('DFC12.json')
  }
  {
    libDefinition: loadJsonContent('DFC14.json')
  }
  {
    libDefinition: loadJsonContent('DFC15.json')
  }
  {
    libDefinition: loadJsonContent('DFC16.json')
  }
  {
    libDefinition: loadJsonContent('DFC17.json')
  }
  {
    libDefinition: loadJsonContent('DFC18.json')
  }
  {
    libDefinition: loadJsonContent('DFC19.json')
  }
  {
    libDefinition: loadJsonContent('DFC20.json')
  }
  {
    libDefinition: loadJsonContent('DFC21.json')
  }
  {
    libDefinition: loadJsonContent('DFC23.json')
  }
  {
    libDefinition: loadJsonContent('DFC27.json')
  }
  {
    libDefinition: loadJsonContent('DFC28.json')
  }
  {
    libDefinition: loadJsonContent('DFC29.json')
  }
  {
    libDefinition: loadJsonContent('DFC31.json')
  }
  {
    libDefinition: loadJsonContent('DFC32.json')
  }
  {
    libDefinition: loadJsonContent('DFC33.json')
  }
  {
    libDefinition: loadJsonContent('DFC35.json')
  }
  {
    libDefinition: loadJsonContent('DFC36.json')
  }
  {
    libDefinition: loadJsonContent('DFC37.json')
  }
  {
    libDefinition: loadJsonContent('DFC38.json')
  }
  {
    libDefinition: loadJsonContent('DFC39.json')
  }
  {
    libDefinition: loadJsonContent('DFC40.json')
  }
  {
    libDefinition: loadJsonContent('DFC41.json')
  }
  {
    libDefinition: loadJsonContent('DFC42.json')
  }
  {
    libDefinition: loadJsonContent('DFC43.json')
  }
  {
    libDefinition: loadJsonContent('DFC44.json')
  }
  {
    libDefinition: loadJsonContent('DFC45.json')
  }
  {
    libDefinition: loadJsonContent('DFC46.json')
  }
  {
    libDefinition: loadJsonContent('DFC47.json')
  }
  {
    libDefinition: loadJsonContent('DFC48.json')
  }
  {
    libDefinition: loadJsonContent('DFC50.json')
  }
  {
    libDefinition: loadJsonContent('DFC51.json')
  }
  {
    libDefinition: loadJsonContent('DFC52.json')
  }
  {
    libDefinition: loadJsonContent('DFC53.json')
  }
  {
    libDefinition: loadJsonContent('DFC54.json')
  }
  {
    libDefinition: loadJsonContent('DFC55.json')
  }
  {
    libDefinition: loadJsonContent('DFC56.json')
  }
  {
    libDefinition: loadJsonContent('DFC57.json')
  }
  {
    libDefinition: loadJsonContent('DFC58.json')
  }
  {
    libDefinition: loadJsonContent('DFC59.json')
  }
  {
    libDefinition: loadJsonContent('DFC60.json')
  }
  {
    libDefinition: loadJsonContent('DFC61.json')
  }
  {
    libDefinition: loadJsonContent('DFC62.json')
  }
  {
    libDefinition: loadJsonContent('DFC63.json')
  }
  {
    libDefinition: loadJsonContent('DFC64.json')
  }
  {
    libDefinition: loadJsonContent('DFC65.json')
  }
  {
    libDefinition: loadJsonContent('DFC66.json')
  }
  {
    libDefinition: loadJsonContent('DFC68.json')
  }
  {
    libDefinition: loadJsonContent('DFC69.json')
  }
  {
    libDefinition: loadJsonContent('DFC70.json')
  }
  {
    libDefinition: loadJsonContent('DFC71.json')
  }
  {
    libDefinition: loadJsonContent('DFC72.json')
  }
  {
    libDefinition: loadJsonContent('DFC73.json')
  }
  {
    libDefinition: loadJsonContent('DFC74.json')
  }
  {
    libDefinition: loadJsonContent('DFC75.json')
  }
  {
    libDefinition: loadJsonContent('DFC76.json')
  }
  {
    libDefinition: loadJsonContent('DFC77.json')
  }
  {
    libDefinition: loadJsonContent('DFC78.json')
  }
  {
    libDefinition: loadJsonContent('DFC81.json')
  }
  {
    libDefinition: loadJsonContent('DFC83.json')
  }
  {
    libDefinition: loadJsonContent('DFC84.json')
  }
  {
    libDefinition: loadJsonContent('DFC85.json')
  }
]
