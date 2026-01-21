# OUTPUTS EN TERRAFORM
# =====================

# Los outputs son una forma de extraer información de los recursos que hemos creado con Terraform.
# Son valores que queremos "sacar" de nuestro script para poder:
# 1. Mostrarlos al usuario cuando termine la ejecución de terraform apply
# 2. Usarlos en otros módulos de Terraform (cuando trabajamos con módulos)
# 3. Almacenarlos en el estado para consultarlos después con terraform output
# 4. Compartir información entre diferentes configuraciones de Terraform

# Sintaxis básica de un output:
# output "NOMBRE_DEL_OUTPUT" {
#   value       = EXPRESION_QUE_CALCULA_EL_VALOR
#   description = "Descripción de lo que representa este output"
#   sensitive   = true|false  # Por defecto false. Si es true, no se muestra por pantalla
#   depends_on  = [lista_de_recursos]  # Raramente necesario
# }

# Para referenciar un output desde otro módulo:
# module.NOMBRE_MODULO.NOMBRE_OUTPUT

# EJEMPLO PRÁCTICO
# ================

# Primero creamos algunos recursos de ejemplo

resource "docker_image" "nginx" {
    name = var.imagen
}

resource "docker_container" "web" {
    count = var.num_replicas
    name  = "${var.nombre_contenedor}-${count.index + 1}"
    image = docker_image.nginx.image_id
    
    ports {
        internal = 80
        external = var.puerto_externo + count.index
    }
}

# También creamos un contenedor único para ejemplos más simples
resource "docker_container" "web_unico" {
    name  = "nginx-principal"
    image = docker_image.nginx.image_id
    
    ports {
        internal = 80
        external = 9090
    }
    
    ports {
        internal = 443
        external = 9443
    }
}
