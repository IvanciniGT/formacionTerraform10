# Directorio donde se guardaran las claves generadas
# Nota: Se generarán 4 archivos en ese directorio:
#       private_key.pem
#       public_key.pem
#       private_key.openssh
#       public_key.openssh
# Admite rutas absolutas y relativas
directorio_claves                   = "./claves"
# Indica si se deben regenerar las claves SSH aunque ya existan. Admite true o false
forzar_regeneracion_de_claves       = false
# Algoritmo y configuración para la generación de claves SSH
algoritmo_claves                    = {
                                            nombre        = "RSA"    # Valores permitidos: RSA, ECDSA, ED25519
                                            configuracion = "2048"   # Dependiendo del algoritmo:
                                                                        # RSA: Valores permitidos: 1024, 2048, 3072, 4096... por defecto: 2048
                                                                        # ECDSA: Valores permitidos: P224, P256, P384, P521... por defecto: P256
                                                                        # ED25519: No admite configuración (debe ser nulo)
                                       }