# The Client ID of the Azure Active Directory Service Principal.
variable "ARM_CLIENT_ID" {}

# The Client Secret of the Azure Active Directory Service Principal (used for authentication).
variable "ARM_CLIENT_SECRET" {}

# The Tenant ID of the Azure Active Directory where the Service Principal is located.
variable "ARM_TENANT_ID" {}

# The Subscription ID under which the Azure resources will be provisioned.
variable "ARM_SUBSCRIPTION_ID" {}
