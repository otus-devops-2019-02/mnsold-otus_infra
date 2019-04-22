terraform {
  backend "gcs" {
    bucket = "otus-mnsold-terraform-remote-state"
    prefix = "stage"
  }
}
