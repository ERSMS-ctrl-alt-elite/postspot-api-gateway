terraform {
  backend "gcs" {
    bucket = "postspot-tf-state"
    prefix = "api-gateway/env/prod"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.67.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}