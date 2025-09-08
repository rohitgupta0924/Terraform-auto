tags = {
  SEALZ-BusinessUnit = "Schneider Digital"
  SEALZ-CostCenter   = "IN288105",
  Project            = "AccessToEnergy",
  Usage              = "Github-Runners"
}

data_tags = {
  "SEALZ-DataClassification" = "SE-Restricted"
}

vnet_name = "vnet-spoke-digaccesstoenergydit001-prod-fc-001"

old_wl_sn_name = "snet-pvtep-a2e-villaya-01"

subnets = {
  workload = {
    name              = "snet-newgen-pvtep-workload"
    addr_prefix       = ["10.144.46.128/26"]
    enable_delegation = false
  }
  wa-outbound = {
    name              = "snet-newgen-delegation-wapoutbound"
    addr_prefix       = ["10.144.46.192/27"]
    enable_delegation = true
  }
  appgw = {
    name              = "snet-newgen-appgw"
    addr_prefix       = ["10.144.46.224/28"]
    enable_delegation = false
  }
}

vm_name = "a2e-ghrunners"

vm_id_name = "muid-a2e-ghrunners"

gh_runner_rg_name = "rg-a2e-ghrunners"
org               = "A2E-NewGen"

runner_group_name = "a2e-lin-runner-grp"
runner_wd         = "a2e_work"
runner_label      = "a2e-linuxrunner"

stg_name = "stga2erunner"


kvname = "kv-a2e-ghrunners"