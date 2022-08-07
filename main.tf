terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name   = var.k8s_name
  region = var.k8s_region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s_iniciativa.id
  name       = "premium"
  size       = "s-2vcpu-2gb"
  node_count = 1
}


variable "do_token" {}

variable "k8s_name" {}

variable "k8s_region" {}


output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
}

resource "local_file" "kube_config" {
    filename = "kube_config.yaml"
    content = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
}