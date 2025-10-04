variable "project_id" {
  type    = string
  default = null
}

packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "googlecompute" "basic-example" {
  project_id              = "${var.project_id}"
  image_name              = "master-node-{{timestamp}}"
  source_image            = "debian-12-bookworm-v20250910"
  source_image_family     = "debian-12"
  ssh_username            = "packer"
  zone                    = "europe-north2-a"
  instance_name           = "packer-build-master"
  disk_size               = 20
  image_description       = "Base master node image"
  image_storage_locations = ["eu"]
  image_labels = {
    name = "master-node"
  }
  # Machine type for for the image, should specified upon provisioning
  # machine_type = e2-standard-2
  # The path to a startup script to run on the launched instance from which the image will be made
  # startup_script_file =
  # Set to true for future backward compatibility
  wrap_startup_script = "true"
}

build {
  sources = ["sources.googlecompute.basic-example"]

  provisioner "shell" {
    scripts = [
        "setup.sh"
    ]
  }
}
