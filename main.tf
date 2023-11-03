terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "rabbitmq_unacknowledged_messages_incident" {
  source    = "./modules/rabbitmq_unacknowledged_messages_incident"

  providers = {
    shoreline = shoreline
  }
}