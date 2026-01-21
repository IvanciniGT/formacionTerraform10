
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
  # Configuration options
}

resource "docker_container" "mis_contenedores" {
    count      = var.num_contenedores # Esto ya hace que me cree varios recursos de este tipo.
                 # Hay que poner un NUMERO
    # name       = "mi-nginx" # Con esto funcionaría.. Solo puedo tener un contenedor con este nombre
                              # en mi host
                              # Necesitamos generar ese nombre dinámicamente
                              # Terraform lo pone fácil. Cuando uso la palabra count dentro de un recurso,
                              # me crea en AUTOMATIUCO una variable llamada "count.index", que me indica por cual voy
                              # Esa variable empieza en 0
    name       = "mi-nginx-${count.index+1}" # Aquí usamos interpolación de cadenas                          
                 # Si tuviera en num_contenedores el valor 30, me crearía:
                      # mi-nginx-1
                      # mi-nginx-2
                      # mi-nginx-3
                      # mi-nginx-4
                      # mi-nginx-5
                      # ...
    image      = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = 8080 + count.index  # Aquí también usamos la variable count.index
                                       # Si tengo 3 contenedores, me crearía los puertos:
                                       # 8080
                                       # 8081
                                       # 8082
    }
}
# $ terraform apply -var="num_contenedores=30"
# En desarrollo , cuando lo ejecuten usan:    -var="num_contenedores=1"
# En preproducción, cuando lo ejecuten usan:  -var="num_contenedores=2"
# En producción, cuando lo ejecuten usan:     -var="num_contenedores=10"

# NOTAS
#------------------------------
# NOTA 1:    La variable tipo_recurso.nombre_recurso me permite referenciar un recurso concreto
#            Pero eso cambia si usamos la palabra count!
#            En el caso de usar count, la variable tipo_recurso.nombre_recurso ya no apunta a un recurso concreto
#            Sino que apunta a UNA LISTA de recursos.
#            Por ejemplo, para saber cuantos hay en la lista, usaríamos:
#               length(docker_container.mi_contenedor)
#            Para acceder a un dato concreto de un recurso dentro de esa lista, usamos:
#               docker_container.mi_contenedor[ÍNDICE].DATO_QUE_QUIERO
#
# NOTA 2:    Count es cojonudo... pero.... es muy simple... y para algunos casos no es suficiente.
#            Ejemplo... Esos 3 contenedores no quiero que se llamen mi-nginx-1, mi-nginx-2, mi-nginx-3
#            Quiero que se llamen: menchu, federico y fermin
#            Y quiero que expongan los puertos: 8080, 8081 y 9090
#            UPS !
#            Me vale la variable count.index para eso? NO DE FORMA SENCILLA



resource "docker_container" "mis_contenedores_personalizados" {
    for_each = var.contenedores_mapa
    # Al poner for_each, tenemos acceso a las variables: each.key y each.value
    name       = each.key
    image      = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = each.value.puerto
    }
}

resource "docker_container" "mis_contenedores_personalizados2" {
    for_each = { for item in var.contenedores: item.nombre => item }
    # Al poner for_each, tenemos acceso a las variables: each.key y each.value
    name       = each.key
    image      = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = each.value.puerto
    }
}


resource "docker_container" "balanceador_de_carga" {
    # Lo creo en base al: num_contenedores
    count = (
              local.necesito_balanceador_de_carga  ? # CONDICION
                  1 :                     # Valor si se cumple la condición
                  0                       # Valor si NO se cumple la condición
            )
    # ESTO LO USAMOS UN HUEVO!
    # En base a la condición, se crea 1 o 0 recursos
    name       = "balanceador-nginx"
    image      = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = 9000
    }
}



resource "docker_image" "mi_imagen" {
    name  = "nginx:latest"
}


# Ahora resulta que no quiero un contenedor... Sino 3 contenedores iguales.

variable "num_contenedores" {
    description = "Número de contenedores nginx a crear"
    type    = number
}

#            Quiero que se llamen: menchu, federico y fermin
#            Y quiero que expongan los puertos: 8080, 8081 y 9090
variable "contenedores" {
    description = "Lista de contenedores con nombre y puerto"
    type = list(object({
        nombre = string
        puerto = number
    }))
}

variable "contenedores_mapa" {
    description = "Lista de contenedores con nombre y puerto"
    type = map(object({
        puerto = number
    }))
}
# Me permitiría dar valores del tipo:
# contenedores = [
#     { 
#       nombre = "menchu"
#       puerto = 8080 
#     },
#     { nombre = "federico", puerto = 8081 },
#     { nombre = "fermin", puerto = 9090 }
# ]


# contenedores = {
#     menchu = { 
#       nombre = "menchu"
#       puerto = 8080 
#     },
#     federico = { nombre = "federico", puerto = 8081 },
#     fermin = { nombre = "fermin", puerto = 9090 }
# }



# contenedores_mapa = {
#     menchu   = { puerto = 8080 },
#     federico = { puerto = 8081 },
#     fermin   = { puerto = 9090 }
# }

# También podríamos hacer con un map(number):
# contenedores_como_map = {
#     menchu   = 8080,
#     federico = 8081,
#     fermin   = 9090
# }

# Consejo... Object!!!!
# Imaginar que pongo map. Y el día de ma´ñana quiero poner además del puerto, el protocolo (http/https)

locals {
  # El bloque locals me permite definir variables internas al script

  necesito_balanceador_de_carga = var.num_contenedores > 1
  # Una vez definida la variable, puedo usarla fácilmente en cualquier parte del script:
  # Me puedo referenciar a ella como: local.necesito_balanceador_de_carga

}