variable "region" {
  description = "The AWS region of the project"
  default     = "us-east-1"
}

variable "git_clone_http_url" {
  description = "The name of the GitHub Repo HTTP URL"
  type        = string
  default     = "https://github.com/cloudacode/python-docker.git"
}

variable "git_branch" {
  description = "The name of the Git branch to be triggered"
  type        = string
  default     = "master"
}

variable "dockerhub_repo" {
  description = "The name of the Docker Registry Repo"
  type        = string
  default     = "cloudacode/python-docker"
}

variable "dockerhub_creds" {
  description = "The credentials of the DockerHub"
  type = object({
    username = string
    password = string
  })
  # default = {
  #   username = "<username>"
  #   password = "<password>"
  # }
  # instead of defining secrets as a file, you can also use env to import secrets
  # export TF_VAR_dockerhub_creds='{username="<username>",password="<password>"}'
}
