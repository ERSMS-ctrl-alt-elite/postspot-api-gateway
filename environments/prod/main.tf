locals {
  version = "1.0.7"
  suffix  = "${var.environment}-v${replace(local.version, ".", "-")}"
}

/* -------------------------------------------------------------------------- */
/*                                 API Gateway                                */
/* -------------------------------------------------------------------------- */

resource "google_api_gateway_api" "postspot_api" {
  project      = var.project_id
  provider     = google-beta
  api_id       = "postspot-api-${local.suffix}"
  display_name = "PostSpot API"

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_api_config" "postspot_api_config" {
  project       = var.project_id
  provider      = google-beta
  api           = google_api_gateway_api.postspot_api.api_id
  api_config_id = "postspot-api-config-${local.suffix}"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = base64encode(
        templatefile(
          "../../openapi.yaml",
          {
            version                  = local.version,
            user_service_url         = var.user_service_url,
            post_service_url         = var.post_service_url,
            notification_service_url = var.notification_service_url,
          }
        )
      )
    }
  }
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_api_gateway_api.postspot_api]
}

resource "google_api_gateway_gateway" "postspot_api_gateway" {
  project    = var.project_id
  region     = var.api_gateway_region
  provider   = google-beta
  api_config = google_api_gateway_api_config.postspot_api_config.id
  gateway_id = "postspot-api-gateway-eu-${local.suffix}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_api_gateway_api_config.postspot_api_config]
}
