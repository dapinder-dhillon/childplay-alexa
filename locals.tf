locals {
  common_tags = {
    Product       = var.global_product
    SubProduct    = var.global_subproduct
    CostCode      = var.global_costcode
    Orchestration = var.global_orchestration
    Environment   = var.global_environment
    Contact       = var.global_contact
    Details       = "Q1 Global Hackathon - Dapinder Singh"
  }
}
