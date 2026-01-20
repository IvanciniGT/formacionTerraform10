# En este archivo declaramos solo recursos 
# (y datas... pero por ahora no hablamos de eso)

# resource "TIPO_DE_RECURSO" "NOMBRE_DEL_RECURSO" { 
#   Configuración del recurso... con los parámetros concretos que nos indique 
#   el proveedor.
# }

# El NOMBRE_DEL_RECURSO es un identificador que nosotros ponemos 
# para poder referenciar este recurso dentro de nuestro código.
# A la hora de referenciarlo, usamos: TIPO_DE_RECURSO.NOMBRE_DEL_RECURSO
  
# Por ejemplo, si quisiéramos crear un contenedor Docker, con nginx

resource "docker_container" "mi_contenedor" {
    # Las propiedades que aquí vamos definiciendo vienen determinadas por el provider (docker en este caso)
    # En la documentación del provider me informan de todas las propiedades que puedo usar y de sus tipos 
    # de datos.
    # La sintaxis que usaremos a la hora de definir una propiedad depende del tipo de dato de esa propiedad.
                 # Los textos (String) van entre comillas
    name       = "mi-nginx"
    image      = docker_image.mi_imagen.image_id # De ahí estoy sacando el ID de la imagen
                 # Esto también es un texto que estamos rellenando desde un dato de otro recurso
                 # En la referencia no usmos comilla. Si le pongo comillas se entendería que es un texto literal.
    cpu_shares = 512          # Un número (NUMBER). En este caso, medio core. 
                              # Los números sin comillas
    start      = true         # Un booleano (BOOLEAN). true o false, sin comillas
    env        = ["VAR1=valor1" , "VAR2=valor2"] # Esto serían los Set y los List

    # Cuando encuentro un Block List o un Block Set la sintaxis cambia
    # Detras del nombre de la propiedad ponemos llaves
    # Dentro de las llaves las propiedades que me defina la documentación
    # Si quiero definir varios bloques, los ponemos uno detrás de otro, con la misma sintaxis
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


# Esto descarga la imagen a nivel local (si no la tenemos ya)
resource "docker_image" "mi_imagen" {
    name  = "nginx:latest"
}

