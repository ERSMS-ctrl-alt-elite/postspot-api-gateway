variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-central2"
}

variable "api_gateway_region" {
  type    = string
  default = "europe-west2"
}

variable "environment" {
  type = string
}

variable "user_service_url" {
  type = string
}

variable "post_service_url" {
  type = string
}

variable "notification_service_url" {
  type = string
}