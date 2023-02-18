terraform {
  required_providers {
    tfe = {
      version = "~> 0.42.0"
    }
  }
}

provider "tfe" {
  token    = var.terraform_bearer
}


data "tfe_organization" "organisation" {
  name = var.terraform_organisation
}

resource "tfe_variable_set" "set" {
  name         = "${var.cluster}-kubeconfig"
  description  = "Kubeconfig Target"
  global       = false
  organization = data.tfe_organization.organisation.name
}

data "tfe_workspace" "workspace" {
  name         = "prod_services_cluster"
  organization = data.tfe_organization.organisation.name
}

resource "tfe_workspace_variable_set" "workspace" {
  workspace_id    = data.tfe_workspace.workspace.id
  variable_set_id = tfe_variable_set.set.id
}

data "tfe_variable_set" "return" {
   depends_on = [
    tfe_variable_set.set, hcloud_server.node
  ]
  name         = "${var.cluster}-kubeconfig"
  organization = data.tfe_organization.organisation.name
}


data "tfe_variables" "results" {
  variable_set_id = data.tfe_variable_set.return.id
}

/* output "valueset" {
  value = tfe_variable_set.set.id  
} */

output "kubeconfig" {
  value = data.tfe_variables.results.variables
  sensitive = true
}


variable "terraform_bearer" {
}

variable "terraform_organisation" {
  
}