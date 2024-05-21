param location string = resourceGroup().location

var paramsVB = loadJsonContent('./parameters/account/vb.json')
var paramsIM = loadJsonContent('./parameters/account/im.json')
var paramsPB = loadJsonContent('./parameters/account/pb.json')
var paramsGEN = loadJsonContent('./parameters/account/gen.json')

param account string = 'pb' //replaced by pipeline, see https://stackoverflow.com/questions/77181479/how-to-pass-parameters-from-an-azure-devops-pipeline-into-a-bicep-template

var accountParams = (account == 'vb') ? paramsVB : (account == 'im' ? paramsIM : (account == 'pb' ? paramsPB : (account == 'gen' ? paramsGEN : null)))



resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'mybicepdjstorage'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

resource strorageblobservices 'Microsoft.Storage/storageAccounts/blobServices@2023-04-01' = {
  name: 'default'
  parent: storageaccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-04-01' = [for name in accountParams.containers: {
  name: name
  parent: strorageblobservices
}]
