# Managed Cassandra deployment repro

## Versions

* `casmi_v1.bicep` uses `Microsoft.DocumentDB/cassandraClusters@2024-05-15` which is the latest version documented in the public [ARM Reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.documentdb/cassandraclusters?pivots=deployment-language-arm-template)

## How to deploy?

```azcli
az login

az group create -n <rgname> -l <location>

az deployment group create --resource-group <rgname> --template-file .\bicep\casmi_v1.bicep --parameters .\bicep\casmi_v1.parameters.json --name localtest01-with-whatif2024
```