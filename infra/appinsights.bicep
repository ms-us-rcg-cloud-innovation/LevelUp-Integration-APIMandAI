@description('Application Insights resource name')
param applicationInsightsName string

@description('Log Analytics resource name')
param logAnalyticsWorkspaceName string 

param location string = resourceGroup().location

param keyVaultName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    Flow_Type: 'Bluefield'
  }
}

var appInsightsInstrumentationKey = applicationInsights.properties.InstrumentationKey
var appInsightsConnectionString = applicationInsights.properties.ConnectionString
var logAnalyticsWorkspaceId = logAnalyticsWorkspace.id

resource SecretsKeyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
  resource kvAppInsightsKey 'secrets@2021-10-01' = {name: 'appInsightsKey', properties:{value: appInsightsInstrumentationKey}}
  resource kvAppInsightsConnString 'secrets@2021-10-01' = {name: 'appInsightsConnString', properties:{value: appInsightsConnectionString}}
  resource kvLogAnalyticsWorkspaceId 'secrets@2021-10-01' = {name: 'logAnalyticsWorkspaceId', properties:{value: logAnalyticsWorkspaceId}}
}

output appInsightsInstrumentationKey string = appInsightsInstrumentationKey
output appInsightsConnectionString string = appInsightsConnectionString
output logAnalyticsWorkspaceId string = logAnalyticsWorkspaceId
