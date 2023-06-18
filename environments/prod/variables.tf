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
  type    = string
  default = "https://user-service-prod-w6bxxp65eq-lm.a.run.app"
}

variable "post_service_url" {
  type    = string
  default = "https://post-service-prod-w6bxxp65eq-lm.a.run.app"
}