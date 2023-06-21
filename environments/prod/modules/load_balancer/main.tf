resource "google_compute_global_network_endpoint_group" "postspot_neg" {
  name                  = "postspot-neg"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_global_network_endpoint" "postspot_default_endpoint" {
  global_network_endpoint_group = google_compute_global_network_endpoint_group.postspot_neg.name
  fqdn                          = google_api_gateway_gateway.postspot_api_gateway.default_hostname
  port                          = 443

  depends_on = [google_compute_global_network_endpoint_group.postspot_neg]
}

resource "google_compute_backend_service" "postspot_backend_service" {
  name                   = "api-gateway-backend-service"
  protocol               = "HTTPS"
  custom_request_headers = ["host: ${google_compute_global_network_endpoint.postspot_default_endpoint.fqdn}"]

  backend {
    group = google_compute_global_network_endpoint_group.postspot_neg.id
  }

  depends_on = [google_compute_global_network_endpoint.postspot_default_endpoint]
}

resource "google_compute_url_map" "postspot_url_map" {
  name            = "api-gateway-url-map"
  default_service = google_compute_backend_service.postspot_backend_service.id

  depends_on = [google_compute_backend_service.postspot_backend_service]
}

resource "google_compute_managed_ssl_certificate" "postspot_ssl_cert" {
  name = "postspot-cert"

  managed {
    domains = [var.domain]
  }
}

resource "google_compute_target_https_proxy" "postspot_target_https_proxy" {
  name             = "api-gateway-https-proxy"
  url_map          = google_compute_url_map.postspot_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.postspot_ssl_cert.id]

  depends_on = [google_compute_url_map.postspot_url_map]
}

resource "google_compute_global_forwarding_rule" "postspot_forwarding_rules" {
  name       = "my-fw"
  target     = google_compute_target_https_proxy.postspot_target_https_proxy.id
  port_range = 443

  depends_on = [google_compute_target_https_proxy.postspot_target_https_proxy]
}