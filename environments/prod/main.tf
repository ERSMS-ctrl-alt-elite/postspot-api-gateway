resource "google_api_gateway_api" "api_gw" {
  project = var.project_id
  provider = google-beta
  api_id = "postspot-api-${var.environment}"
  display_name = "PostSpot API"
}

resource "google_api_gateway_api_config" "api_gw" {
  project = var.project_id
  provider = google-beta
  api = google_api_gateway_api.api_gw.api_id
  api_config_id = "postspot-api-config-${var.environment}"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = filebase64("../../openapi.yaml")
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "api_gw" {
  project = var.project_id
  region = var.api_gateway_region
  provider = google-beta
  api_config = google_api_gateway_api_config.api_gw.id
  gateway_id = "postspot-api-gateway-eu-${var.environment}"

  depends_on = [google_api_gateway_api_config.api_gw]
}