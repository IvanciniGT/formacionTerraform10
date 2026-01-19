
# Aquí vamos a escribir código HCL
# En HCL podemos poner COMENTARIOS.

# El lenguajes es una mezcla entre JSON y YAML.

#terraform {
    # Aquí declararemos los proveedores que usaremos
#    required_providers {
#        nombre = {
#            source = "ubicacion/del/proveedor/en/el/registry/de/terraform"
#            version = ">= 1.0.0"
#        }
#}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

# Para cada proveedor, posteriormente, debemos declarar un bloque
# con su configuración específica.
# Hay proveedores que no requieren configuración, otros que requieren de poca
# configuración y otros que requieren de mucha configuración.
provider "docker" {
  # Configuration options
}