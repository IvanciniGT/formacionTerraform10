# Variables para el ejemplo de outputs

variable "nombre_contenedor" {
    description = "Nombre del contenedor Docker"
    type        = string
    default     = "mi-nginx"
}

variable "puerto_externo" {
    description = "Puerto externo del contenedor"
    type        = number
    default     = 8080
}

variable "imagen" {
    description = "Imagen Docker a usar"
    type        = string
    default     = "nginx:latest"
}

variable "num_replicas" {
    description = "Número de réplicas del contenedor"
    type        = number
    default     = 3
}
