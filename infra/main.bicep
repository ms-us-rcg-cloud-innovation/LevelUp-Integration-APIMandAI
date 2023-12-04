targetScope = 'subscription'

@allowed(['dev', 'test', 'prod'])
param environment string = 'dev'

param location string = deployment().location

var resourceGroupPrefix = 'levelup-int3'
var uniqueSuffix = substring(uniqueString(concat(subscription().id),environment, resourceGroupPrefix),0,6)
var resourceSuffix = '${uniqueSuffix}-${environment}'
var ResourceGroupName = '${resourceGroupPrefix}-${resourceSuffix}'

var appInsightsName = 'appinsights-${resourceSuffix}'
var logAnalyticsName = 'loganalytics-${resourceSuffix}'
var keyVaultName = 'keyvault-${resourceSuffix}'
var openAIName = 'openai-${resourceSuffix}'
var apimName = 'apim-${resourceSuffix}'

resource RG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: ResourceGroupName
  location: location
}

module KeyVaultDeploy 'keyvault.bicep' = {
  name: 'keyvault'
  scope: RG
  params: {
    resourceName: keyVaultName
    location: location
  }
}

module appInsightsDeploy 'appinsights.bicep' ={
    name: 'appInsights'
    scope: RG
    params: {
      location: location
      keyVaultName: keyVaultName
      applicationInsightsName: appInsightsName
      logAnalyticsWorkspaceName: logAnalyticsName
    }
    dependsOn: [
      KeyVaultDeploy
    ]
}

module openAIDeploy 'openai.bicep' = {
  name: 'openai'
  scope: RG
  params: {
    resourceName: openAIName
    location: location
    keyVaultName: keyVaultName
  }
  dependsOn: [
    KeyVaultDeploy
  ]
}

module apimDeploy 'apim.bicep' = {
  name: 'apim'
  scope: RG
  params: {
    resourceName: apimName
    location: location
  }
}

