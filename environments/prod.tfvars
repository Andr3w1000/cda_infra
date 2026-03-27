# -------------------------------------------------------
# Prod environment — slightly higher capacity & retention
# -------------------------------------------------------

environment = "prod"
location    = "West Europe"
project     = "cda"

# subscription_id and databricks_account_id are set via TF_VAR_* env vars or passed with -var
# Run account/ apply first, then copy the metastore_id output here.
# metastore_id = ""

tags = {
  environment = "prod"
  project     = "cda"
  managed_by  = "terraform"
}

# Function App — B2 gives more CPU/memory if prod load increases
# Switch back to B1 if budget is the priority
function_app_sku            = "B2"
function_app_python_version = "3.11"

# Event Hub — Standard unlocks more consumer groups and higher retention
eventhub_namespace_sku          = "Standard"
eventhub_namespace_capacity     = 1
eventhub_partition_count        = 4
eventhub_message_retention_days = 7
