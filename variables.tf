variable "control-nodes-number" {
  description = "Number of instanes to provison in private subnet"
  type        = number
  default     = 2
}

variable "project_id" {
  description = "Id of GCP project"
  type        = string
  default     = "Your GCP project id"
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

