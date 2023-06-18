locals {
  version = "v1.0.0"
}

resource "google_api_gateway_api" "postspot_api" {
  project = var.project_id
  provider = google-beta
  api_id = "postspot-api-${var.environment}-${local.version}"
  display_name = "PostSpot API"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_api_config" "postspot_api_config" {
  project = var.project_id
  provider = google-beta
  api = google_api_gateway_api.postspot_api.api_id
  api_config_id = "postspot-api-config-${var.environment}-${local.version}"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = filebase64("../../openapi.yaml")
    }
  }
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_api_gateway_api.postspot_api]
}

resource "google_api_gateway_gateway" "postspot_api_gateway" {
  project = var.project_id
  region = var.api_gateway_region
  provider = google-beta
  api_config = google_api_gateway_api_config.postspot_api_config.id
  gateway_id = "postspot-api-gateway-eu-${var.environment}-${local.version}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_api_gateway_api_config.postspot_api_config]
}
