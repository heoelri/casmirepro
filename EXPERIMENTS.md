# Experiments

## casmi_v1 to uksouth

`casmi_v1` with the following parameters set:

* `location` set to `uksouth`
* `zoneRedundancy` set to `false`
* `cassandraSku` set to `Standard_E16s_v5`
* `cassandraDiskSku` set to `P30`
* `cassandraDiskCapacity` set to `4`
* `cassandraNodeCount` set to `3`

**Result:**

```console
Managed Instance for Apache Cassandra is not available in region UK South. For a list of available regions, see https://aka.ms/CassandraMISupportedRegions.
ActivityId: 123de185-9da0-4404-a880-71f6f58a6634, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0
```

* **Correlation ID:** `a2e66f4e-7a29-4a4a-9db8-61e9f1499694`
* **Start time:** `9.10.2024, 08:52:54`

## casmi_v1 to eastus2

`casmi_v1` with the following parameters set:

* `location` set to `eastus2`
* `zoneRedundancy` set to `false`
* `cassandraSku` set to `Standard_E16s_v5`
* `cassandraDiskSku` set to `P30`
* `cassandraDiskCapacity` set to `4`
* `cassandraNodeCount` set to `3`