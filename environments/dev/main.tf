module "postspot_api_gateway" {
  source = "./modules/api_gateway"

  project_id               = var.project_id
  api_gateway_region       = var.api_gateway_region
  environment              = var.environment
  user_service_url         = var.user_service_url
  post_service_url         = var.post_service_url
  notification_service_url = var.notification_service_url
  commit_sha               = var.commit_sha
}
