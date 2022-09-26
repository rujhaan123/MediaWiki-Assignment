variable "region" {
  type    = string
  default = "us-central1"
}
variable "project" {
  type = string
}

variable "user" {
  type = string
}

variable "email" {
  type = string
}
variable "privatekeypath" {
  type    = string
  default = "/home/rujhaanb807/id_rsa"
}

variable "publickeypath" {
  type    = string
  default = "/home/rujhaanb807/id_rsa.pub"
}