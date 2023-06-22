resource "google_api_gateway_api" "postspot_api" {
  project      = var.project_id
  provider     = google-beta
  api_id       = "postspot-api-${var.environment}"
  display_name = "PostSpot API"

}

resource "google_api_gateway_api_config" "postspot_api_config" {
  project       = var.project_id
  provider      = google-beta
  api           = google_api_gateway_api.postspot_api.api_id
  api_config_id = "postspot-api-config-${var.environment}-${var.commit_sha}"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = base64encode(
        templatefile(
          "../../openapi.yaml",
          {
            user_service_url         = var.user_service_url,
            post_service_url         = var.post_service_url,
            recommendation_service_url = var.recommendation_service_url,
          }
        )
      )
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "postspot_api_gateway" {
  project    = var.project_id
  region     = var.api_gateway_region
  provider   = google-beta
  api_config = google_api_gateway_api_config.postspot_api_config.id
  gateway_id = "postspot-api-gateway-eu-${var.environment}"

  depends_on = [google_api_gateway_api_config.postspot_api_config]
}