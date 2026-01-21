
resource "docker_container" "mi_contenedor" {
    #name       = "mi-nginx"
    name       = var.nombre_del_contenedor
    image      = docker_image.mi_imagen.image_id 
    #cpu_shares = var.cpus
    # Aquí va a pasar algo curioso
    # Si una propiedad de un recurso toma valor null
    # Es como si no le estuviese pasando ningún valor
    #cpu_shares = null # Esto sería lo mismo que no haber escrito cpu_shares en el fichero
    #cpu_shares = var.cpus == 0 ? null : var.cpus
                 # Aquí estamos metiendo un IF
                 # Las propiedades de los recursos, hasta ahora
                 # las hemos rellenado con valores literales o referencias a otros recursos/variables
                 # Pero realmente podemos poner EXPRESIONES complejas (MUY COMPLEJAS)
                 # En este caso estamos metiendo un IF:
                 # CONDICION ? VALOR_SI_SE_CUMNPLE_LA_CONDICION : VALOR_SI_NO_SE_CUMPLE_LA_CONDICION
    cpu_shares = var.cpus == null ? null : var.cpus * 1024
    # En este caso, convertimos nosotros el valor de cpus (en base 1) a cpu_shares (en base 1024)
    # En los valores de las propiedades podemos usar operadores:
    # +, -, *, /, % (resto de la division entera), etc
    start      = var.arranque_automatico
    #env        = ["VAR1=valor1" , "VAR2=valor2"]

    env        = [ for clave, valor in var.variables_de_entorno : "${clave}=${valor}" ]

    ports {
        internal = 80
        external = 8080
        ip       = "0.0.0.0"
    }

    ports {
        internal = 443
        external = 8443
    }
}

resource "docker_image" "mi_imagen" {
    #name  = "nginx:latest"
    # Interpolación de cadenas de texto
    name  = "${var.repo_imagen_contenedor}:${var.tag_imagen_contenedor}"
    # Y esto es chulo... Realmente dentro de los ${} podemos poner expresiones complejas
}
