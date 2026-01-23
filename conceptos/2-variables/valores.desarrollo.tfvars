
variables_de_entorno = {
    VAR1 = "valor1"
    VAR2 = "valor2"
}

puertos = [
    {
        puerto_interno = 80
        puerto_externo = 8080
        protocolo      = "TCP"
    },
    {
        puerto_interno = 443
        puerto_externo = 8443
        ip            = "0.0.0.0"
    }
]

nombre_del_contenedor = "ivan-desa"