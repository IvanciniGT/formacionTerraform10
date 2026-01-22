
resource  "tls_private_key" "mi_clave_ssh" {
    count = local.es_necesario_generar_claves ? 1 : 0

    algorithm = local.nombre_algoritmo
    
    rsa_bits  = (
                    local.nombre_algoritmo == "RSA" ?             # Si el algoritmo es RSA
                    tonumber(var.algoritmo_claves.configuracion)  # Ponemos la configuración como número 
                                                                  # Si la han dejado en null, tonumber() devolverá null
                                                                  # Y en ese caso, se aplica el valor por defecto del recurso (2048)
                    : null                                        # Si no han puesto RSA, No se aplica, ponemos null
                )
    ecdsa_curve  = (
                    local.nombre_algoritmo == "ECDSA" 
                    && var.algoritmo_claves.configuracion != null ?  # Si el algoritmo es ECDSA y no me han dejado la configuración en nulo
                    upper(var.algoritmo_claves.configuracion)        # ponemos la configuración en mayúsculas. 
                    : null                                           # Si no han puesto ECDSA o la configuración es nula, No se aplica, ponemos null
                )
    
    provisioner "local-exec" {
        command = <<EOT
            mkdir -p ${local.directorio_claves}

            echo -n "${self.private_key_pem}"      > ${local.ruta_fichero_privado_pem}
            echo -n "${self.private_key_openssh}"  > ${local.ruta_fichero_privado_openssh}

            echo -n "${self.public_key_pem}"       > ${local.ruta_fichero_publico_pem}
            echo -n "${self.public_key_openssh}"   > ${local.ruta_fichero_publico_openssh}
        EOT
    }
}

locals {
    nombre_algoritmo = upper( var.algoritmo_claves.nombre )

    directorio_claves = (
                            endswith( var.directorio_claves, "/" ) ? var.directorio_claves : "${var.directorio_claves}/"
                        )

    ruta_fichero_privado_pem                = "${local.directorio_claves}private_key.pem"
    ruta_fichero_publico_pem                = "${local.directorio_claves}public_key.pem"
    ruta_fichero_privado_openssh            = "${local.directorio_claves}private_key.openssh"
    ruta_fichero_publico_openssh            = "${local.directorio_claves}public_key.openssh"

    no_existe_el_fichero_privado_pem        = ! fileexists( local.ruta_fichero_privado_pem )
    no_existe_el_fichero_publico_pem        = ! fileexists( local.ruta_fichero_publico_pem )
    no_existe_el_fichero_privado_openssh    = ! fileexists( local.ruta_fichero_privado_openssh )
    no_existe_el_fichero_publico_openssh    = ! fileexists( local.ruta_fichero_publico_openssh )

    no_existan_claves = (
                            local.no_existe_el_fichero_privado_pem     ||
                            local.no_existe_el_fichero_publico_pem     ||
                            local.no_existe_el_fichero_privado_openssh ||
                            local.no_existe_el_fichero_publico_openssh
                        )

    es_necesario_generar_claves = var.forzar_regeneracion_de_claves || local.no_existan_claves
}

# Aqui meteremos otros 50 recursos. Servidores...
# Hemos escrito aquñi mucho código. Código valioso que me puede interesar en otros proyectos.
# Lo guay sería poder reutilizar este código en otros proyectos sin tener que copiar y pegar.
# Y aquñi sale otro concepto enorme de Terraform: LOS MÓDULOS.
# Un módulo es como una función en un lenguaje de programación o una librería.

# En el caso de terraform, un modulo es un conjunto de ficheros (recursos, variables, outputs, etc)
# Que puedo reutilizar en otros proyectos directamente.

# Un script de Terraform lo creo para un proyecto concreto.
# Un módulo lo creo para reutilizarlo en varios proyectos.

# La cosa es... cómo convierto esto en un módulo? Bastante poco.
# Lo único que vamos a hacer es eliminar del archivo versions.tf la configuración del provider.
# Esa que la ponga cada persona en su proyecto.
# Mi modulo necesita un provider (tls en este caso) para funcionar.
# Pero la configuración del provider la tiene que poner cada proyecto que use el módulo.

# La otra cosa que necesitamos es quitar los ficheros .auto.tfvars
# Ya que esos ficheros son específicos de cada proyecto.
# EN LOS MODULOS, los valores por defecto de las variables los pondremos en el bloque de definición de la variable.
# Bajo el nombre default = "valor_por_defecto"