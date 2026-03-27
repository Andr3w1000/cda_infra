# -------------------------------------------------------
# Dev environment — lowest cost settings
# -------------------------------------------------------

environment = "dev"
location    = "West Europe"
project     = "cda"

# subscription_id and databricks_account_id are set via TF_VAR_* env vars or passed with -var

tags = {
  environment = "dev"
  project     = "cda"
  managed_by  = "terraform"
}

# Function App — B1 is the minimum for always_on (continuous execution)
function_app_sku        = "B1"
function_app_python_version = "3.11"

# Event Hub — Basic is the cheapest tier
eventhub_namespace_sku          = "Basic"
eventhub_namespace_capacity     = 1
eventhub_partition_count        = 2
eventhub_message_retention_days = 1

azure_tenant_id       = "60061333-74ad-454c-87de-9e487218dc5b"
databricks_account_id = "e9cbaae9-1059-4979-8eef-235061afc85c"
owner_object_id       = "1739b579-dc72-48f7-b7a5-1f931a1adca7"

# Run account/ apply first, then copy the metastore_id output here.
# metastore_id = ""