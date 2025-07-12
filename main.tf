resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.target_node

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  vm_id = var.vm_id != null ? var.vm_id : null

  # VM Lifecycle Hooks
  hook_script_file_id = proxmox_virtual_environment_file.dokku_wait_hook.id

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  machine = "q35"
  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  operating_system {
    type = "l26"
  }

  serial_device {
    device = "socket"
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = var.mac_address
  }

  scsi_hardware = "virtio-scsi-single"

  agent {
    enabled = true
  }

  disk {
    datastore_id = var.vm_storage
    file_id      = proxmox_virtual_environment_download_file.image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size
  }
}

resource "proxmox_virtual_environment_download_file" "image" {
  content_type       = "iso"
  datastore_id       = var.iso_storage
  node_name          = var.target_node
  file_name          = var.image.file_name
  url                = var.image.url
  checksum_algorithm = var.image.checksum_algorithm
  checksum           = var.image.checksum
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.iso_storage
  node_name    = var.target_node

  source_raw {
    data = templatefile("${path.module}/templates/user-data.tftpl.yaml", {
      hostname       = var.name
      ssh_public_key = var.ssh_public_key
      dokku_version  = var.dokku_version
    })
    file_name = "user-data.${var.name}.yaml"
  }
}

resource "proxmox_virtual_environment_file" "dokku_wait_hook" {
  content_type = "snippets"
  datastore_id = var.iso_storage
  node_name    = var.target_node

  file_mode = "755"
  source_raw {
    file_name = "dokku-wait-hook.sh"

    data = <<-EOT
#!/bin/bash

VMID="$1"
EVENT="$2"

if [ -z "$VMID" ]; then
  echo "Usage: $0 <VMID> <EVENT>"
  exit 1
fi

if [ "$EVENT" = "post-start" ]; then
  ATTEMPTS=5
  SLEEP=1
  for i in $(seq 1 $ATTEMPTS); do
    OUTPUT=$(qm guest exec "$VMID" -- /bin/bash -c "command -v dokku")
    if echo "$OUTPUT" | jq -e '.exitcode == 0 and .exited == 1 and (.["out-data"] | length > 0)' >/dev/null; then
      echo "Dokku is present and command succeeded."
      exit 0
    fi
    sleep $SLEEP
  done
  echo "Dokku not found after $((ATTEMPTS * SLEEP / 60)) minutes, failing hook."
  exit 2
fi

if [ "$EVENT" = "post-stop" ]; then
  LOCK_FILE="/var/lock/qemu-server/lock-$VMID.conf"
  ATTEMPTS=5
  SLEEP=1
  for i in $(seq 1 $ATTEMPTS); do
    if [ ! -f "$LOCK_FILE" ]; then
      echo "Lock file $LOCK_FILE no longer present."
      exit 0
    fi
    echo "Lock file $LOCK_FILE still present, waiting..."
    sleep $SLEEP
  done
  echo "Lock file $LOCK_FILE still present after $((ATTEMPTS * SLEEP / 60)) minutes, failing hook."
  exit 3
fi

EOT
  }
}
