variable "region" {
  default = "ap-south-1"
}

variable "project" {
  default = "node-cicd-poc"
}

variable "k8s_version" {
  default = "1.29"
}

variable "ecr_repo_name" {
  default = "node-cicd-poc"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "node-cicd-poc"
    Env     = "dev"
  }
}
