// picked up from locally ignored ´terraform.tfvars´
variable "email" {} 
variable "api_key" {}

// to be prompted upon applying, must have
variable "name" {}
variable "branch" {}
variable "github_key" {}
variable "github_secret" {}
variable "twitter_key" {}
variable "twitter_secret" {}
variable "google_key" {}
variable "google_secret" {}
variable "linkedin_key" {}
variable "linkedin_secret" {}

// fallback value, not prompted upon applying
variable "region" { default = "us" }
variable "lang" { default = "en_US.UTF-8" }
variable "tz" { default = "America/Argentina/Buenos_Aires" }
variable "submission_due_date" { default = "July 8 2020 23:59 UTC-3" }
variable "acceptance_due_date" { default = "August 17 2020 23:59 UTC-3" }
variable "web_concurrency" { default = "2" }
