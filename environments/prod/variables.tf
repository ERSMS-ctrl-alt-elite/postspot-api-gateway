variable "project_id" {
  type = string
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

variable "commit_sha" {
  type = string
}

variable "domain" {
  type = string
  default = "postspot.gro4t.dev"
}