
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
        # De qué depende la versión que quiero usar?
        # - Compatibilidad con mi versión de Terraform
        # - Las funcionalidades que necesito para mi script.
        #   Cada versión de un provider aporta una serie de funcionalidades.
        #   Si una versión ya trae las funcionalidades que necesito. ME VALE !! No la toques. 
        #   No necesito una versión superior
        # - Subir de versión implica SERIOS RIESGOS! Pueden venir nuevos BUGS
        #   Tengo además que prestar especial atención a no subir de major a lo loco (sin pruebas muy extensivas)
        #   El Major se incrementa cuando hay cambios incompatibles con versiones anteriores = BREAKING CHANGES
        #   Al subir un major, se me puede caer el chiringuito! Me puede dejar de funcionar lo que tenemos hecho.
        # Una opción muy conservadora es poner una versión fija, como tenemos aquí: 3.6.2
        # Una opción muy aceptable es poner un rango con el operador ~> , que nos permite actualizaciones de parches y menores
        #      version = "~> 3.6.2" Esto nos instalaría el último patch de la versión 3.6.x. Si sale una 3.7 esa no se instalaría.
        # Otras opciones que podemos usar son >, <, >=, <=. Incluso concatenarlas:
        #      version = ">= 3.6.2, < 4.0.0" Esto nos permitiría actualizaciones de parches y menores, pero no de major.
        #       En este caso, estamos fijando el major a la versión 3.
        # Podría ser aceptable en alguos casos (es menos conservador) que fijar solamente el patch.
        # Ni de coña deberíamos usar operadores como > o >= sin más restricciones, ya que nos exponemos a actualizaciones de major
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