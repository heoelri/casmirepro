# Experiments

## 1) casmi_v1 to uksouth

`casmi_v1.bicep` with the following parameters set:

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

## 2) casmi_v1 to eastus2

`casmi_v1.bicep` with the following parameters set:

* `location` set to `eastus2`
* `zoneRedundancy` set to `false`
* `cassandraSku` set to `Standard_E16s_v5`
* `cassandraDiskSku` set to `P30`
* `cassandraDiskCapacity` set to `4`
* `cassandraNodeCount` set to `3`

**Result:**

```console
{"code":"BadRequest","message":"Managed Instance for Apache Cassandra is not available in region East US 2. For a list of available regions, see https://aka.ms/CassandraMISupportedRegions.\r\nActivityId: 21db178a-1eec-4894-8e57-7fc65b3d69c9, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0"}
```


* **Correlation ID:** `3e7abfc6-0872-47ed-8b38-f10da8bb96c2`
* **Start time:** `9.10.2024, 09:35:53`


## 3) casmi_v2 to uksouth

`casmi_v2.bicep` with the following parameters set:

* `location` set to `uksouth`
* `zoneRedundancy` set to `false`
* `cassandraSku` set to `Standard_E16s_v5`
* `cassandraDiskSku` set to `P30`
* `cassandraDiskCapacity` set to `4`
* `cassandraNodeCount` set to `3`

**Result:**

```console
{"code":"BadRequest","message":"Managed Instance for Apache Cassandra is not available in region UK South. For a list of available regions, see https://aka.ms/CassandraMISupportedRegions.\r\nActivityId: fba47c46-868d-41eb-a955-84c93ec09a60, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0, Microsoft.Azure.Documents.Common/2.14.0"}
```

* **Correlation ID:** `1b4ca9d3-f1b6-4050-a085-bc02456c7824`
* **Start time:** `9.10.2024, 09:13:27`
