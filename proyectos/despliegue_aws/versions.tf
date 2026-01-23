terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}


provider "tls" {           # La configuración de los proveedores se pone en los scripts 
                            # No la ponemos en los módulos
  # Configuration options
}

provider "null" {
  # Configuration options
}