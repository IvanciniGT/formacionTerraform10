# De entrada, vamos a generar unos ficheros con las claves (publicas y privadas, y en formato PEM y Openssh)
# Eso son outputs?  Desde mi puento de vista son outputs del programa
#                   Desde el punto de vista de terraform no son "outputs"
# A priori no. (Luego los generaremos...pero cuando hagamos algo de magia!)

# Esto ahora es un módulo.
# Se usará en un script.
# Dentro de ese script, puede interesar acceder a alguno de los datos de las claves generadas.
# SI... a cuales? Públicas o Privadas? A las públicas

# Las exponemos con un output

output "clave_publica" {
    value       = local.es_necesario_generar_claves ? (
                        # Si hemos generado las claves, las tomamos del recurso
                        {
                            pem      = ephemeral.tls_private_key.mi_clave_ssh[0].public_key_pem
                            openssh  = ephemeral.tls_private_key.mi_clave_ssh[0].public_key_openssh
                        }
                    ) : (
                        # Si no hemos generado las claves, las leemos de los ficheros
                        {
                            pem      = file( local.ruta_fichero_publico_pem )
                            openssh  = file( local.ruta_fichero_publico_openssh )
                        }
                    )
                    # Pero en cualquiera de los 2 casos, cuando me pregunten por ellas, las devuelvo

    description = "Clave pública en formato PEM y OpenSSH"
    sensitive   = true # Esto evita que este valor se muestre en consola al hacer terraform apply o terraform output
    ephemeral   = true
}
