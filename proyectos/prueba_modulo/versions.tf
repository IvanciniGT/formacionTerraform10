terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}

provider "tls" {           # La configuración de los proveedores se pone en los scripts 
                            # No la ponemos en los módulos
  # Configuration options
}

provider "null" {
  # Configuration options
}