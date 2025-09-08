#export ARM_SUBSCRIPTION_ID="a61db838-dad4-48fa-a83f-b118fce0f24d"

rg_name = "rg-newgen"
#env     = "uat"
seqnum = "01"

tags = {
  SEALZ-BusinessUnit = "Schneider Digital"
  SEALZ-CostCenter   = "IN288105"
}

#networking details
vnet_name  = "vnet-spoke-digaccesstoenergydit001-prod-fc-001"
wl_sn_name = "snet-newgen-pvtep-workload"
ob_sn_name = "snet-newgen-delegation-wapoutbound"


#SQL Details
sqlsvrname          = "sql-svr-newgen"
administrator_login = "newgenadmin"
ad_login_username   = "SG_ltimindtree_azure_admin_group"
ad_object_id        = "b029eeb0-5b6a-47d2-82ae-a3171551457e"
ad_tenant_id        = "6e51e1ad-c54b-4b39-b598-0ffe9ae68fef"
sqldbname           = "sql-db-newgen"
stgacctype          = "Local"
sku_name            = "S1"

#storage account Details
stgaccname = "stognewgen"

#webapp details
service_plan_name_windows1 = "aspwin-newgen1"
service_plan_name_windows2 = "aspwin-newgen2"
asp_sku_windows1           = "S2"
asp_sku_windows2           = "S1"
webappfename               = "wap-newgen-fe"
webappbename               = "apiapp-newgen-be-api"
webjobbename               = "apiwebjobapp-newgen-be-api"