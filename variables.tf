variable "groundcover" {
  description = "Customize groundcover chart, see `groundcover.tf` for supported values"
  type        = any
  default     = {}
}

variable "labels_prefix" {
  description = "Custom label prefix used for network policy namespace matching"
  type        = string
  default     = "mzc-hk-demo.com"
}
