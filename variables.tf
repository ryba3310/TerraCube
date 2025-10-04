variable "control-nodes-number" {
  description = "Number of instanes to provison in private subnet"
  type        = number
  default     = 2
}

variable "project_id" {
  description = "Id of GCP project"
  type        = string
  default     = "august-apogee-473914-c5"
}

variable "region" {
  description = "Region of GCP"
  type        = string
  default     = "europe-north2"
}

variable "zone" {
  description = "Id of GCP project"
  type        = string
  default     = "europe-north2-a"
}
variable "ssh_pubkey" {
  description = "SSH key to access instance"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOENQFO4tM8ml1Y/zX/TV8yDWk1/Q40mudL/8sJcSkLX admin@pop-os"
}
