locals {
  res_suffix                 = "${var.env}-${var.seqnum}"
  resource_group_name        = "${var.rg_name}-${local.res_suffix}"
  sqlsvrname                 = "${var.sqlsvrname}-${local.res_suffix}"
  sqldbname                  = "${var.sqldbname}-${local.res_suffix}"
  stgaccname                 = "${var.stgaccname}${var.env}${var.seqnum}"
  service_plan_name_windows1 = "${var.service_plan_name_windows1}-${var.env}-${var.seqnum}"
  service_plan_name_windows2 = "${var.service_plan_name_windows2}-${var.env}-${var.seqnum}"
  webappfename               = "${var.webappfename}-${local.res_suffix}"
  webappbename               = "${var.webappbename}-${local.res_suffix}"
  webjobbename               = "${var.webjobbename}-${local.res_suffix}"

  tags = merge(
    var.tags,
    { "ModifiedAt" = formatdate("DD-MMM-YYYY hh:mm AA", timestamp()) },
    { "Environment" = "${var.env}" }
  )
  dtags = merge(var.data_tags, local.tags)
}