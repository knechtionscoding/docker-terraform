terraform {
  version = "0.11.11"
}

providers {
  aws = ["~> 1.51"]
  null = ["~> 1.0"]
  datadog = ["~> 1.6"]
  docker = ["~> 1.1"]
  http = ["~> 1.0"]
  postgresql = ["~> 0.1"]
  template = ["~> 1.0"]
  vault = ["~> 1.3"]
  local = ["~> 1.1"]
}
