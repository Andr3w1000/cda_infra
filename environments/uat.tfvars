# -------------------------------------------------------
# UAT environment — closer to prod, still budget-conscious
# -------------------------------------------------------

environment = "uat"
location    = "West Europe"
project     = "cda"

# subscription_id and databricks_account_id are set via TF_VAR_* env vars or passed with -var
# Run account/ apply first, then copy the metastore_id output here.
# metastore_id = ""

tags = {
  environment = "uat"
  project     = "cda"
  managed_by  = "terraform"
}

# Function App — same as prod for realistic testing
function_app_sku            = "B1"
function_app_python_version = "3.11"

# Event Hub — Standard to match prod behaviour (consumer groups, retention)
eventhub_namespace_sku          = "Standard"
eventhub_namespace_capacity     = 1
eventhub_partition_count        = 2
eventhub_message_retention_days = 3
