locals {
  tags = merge(
    var.tags,
    { "ModifiedAt" = formatdate("DD-MMM-YYYY hh:mm AA", timestamp()) }
  )
  dtags = merge(var.data_tags, local.tags)
}

resource "azurerm_network_interface" "gh_runner_nic" {
  count               = var.num_runners
  location            = var.location
  name                = "${var.vm_name}-nic-${count.index}"
  resource_group_name = var.gh_runner_rg_name
  tags                = local.tags

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.wl_sn.id
  }

  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}

resource "azurerm_user_assigned_identity" "muid" {
  location            = var.location
  name                = var.vm_id_name
  resource_group_name = var.gh_runner_rg_name
  tags                = var.tags
}

data "azurerm_subscription" "current" {}

resource "azurerm_linux_virtual_machine" "gh_runner" {
  count                 = var.num_runners
  name                  = "${var.vm_name}-${count.index}"
  admin_username        = var.vm_user
  location              = var.location
  network_interface_ids = [azurerm_network_interface.gh_runner_nic[count.index].id]
  resource_group_name   = var.gh_runner_rg_name
  size                  = var.vm_size
  identity {
    type         = "UserAssigned"
    identity_ids = ["${azurerm_user_assigned_identity.muid.id}"]
  }

  admin_ssh_key {
    public_key = file("runnerkey.pub")
    username   = var.vm_user
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "canonical"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  #Uncomment if attempting bootstrapping the runner
  #   custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
  #     server_url        = "${var.server_url}"
  #     org               = "${var.org}"
  #     sysuser           = "${var.vm_user}"
  #     gh_token          = "${var.gh_token}"
  #     runner_group_name = "${var.runner_group_name}"
  #     runner_wd         = "${var.runner_wd}"
  #     runner_label      = "${var.runner_label}"
  #   }))

  patch_mode          = "AutomaticByPlatform"
  reboot_setting      = "IfRequired"
  secure_boot_enabled = true
  tags                = var.tags
  vtpm_enabled        = true
  lifecycle {
    ignore_changes = [identity, tags["ModifiedAt"]]
  }
}
