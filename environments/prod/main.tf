module "postspot_api_gateway" {
  source = "./modules/api_gateway"
}

module "postspot_load_balancer" {
  source = "./modules/load_balancer"

  depends_on = [postspot_api_gateway]
}