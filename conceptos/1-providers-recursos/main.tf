# En este archivo declaramos solo recursos 
# (y datas... pero por ahora no hablamos de eso)

# resource "TIPO_DE_RECURSO" "NOMBRE_DEL_RECURSO" { 
#   Configuración del recurso... con los parámetros concretos que nos indique 
#   el proveedor.
# }

# Por ejemplo, si quisiéramos crear un contenedor Docker, con nginx

resource "docker_container" "mi_contenedor" {
    name  = "mi-nginx"
    image = docker_image.mi_imagen.image_id # De ahí estoy sacando el ID de la imagen
}


# Esto descarga la imagen a nivel local (si no la tenemos ya)
resource "docker_image" "mi_imagen" {
    name  = "nginx:latest"
}

