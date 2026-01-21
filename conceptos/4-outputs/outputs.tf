# ARCHIVO DE OUTPUTS
# ==================

# Es una buena práctica mantener todos los outputs en un archivo separado llamado outputs.tf
# Aunque podrían estar en cualquier archivo .tf

# OUTPUT SIMPLE
# =============
# Ejemplo 1: Sacar el ID de la imagen Docker creada
output "imagen_id" {
    description = "ID de la imagen Docker creada"
    value       = docker_image.nginx.image_id
}

# Ejemplo 2: Sacar el nombre de la imagen
output "imagen_nombre" {
    description = "Nombre completo de la imagen Docker"
    value       = docker_image.nginx.name
}

# OUTPUT DE UN RECURSO ÚNICO
# ==========================
# Ejemplo 3: Información del contenedor único
output "contenedor_principal_id" {
    description = "ID del contenedor principal"
    value       = docker_container.web_unico.id
}

output "contenedor_principal_nombre" {
    description = "Nombre del contenedor principal"
    value       = docker_container.web_unico.name
}

# Ejemplo 4: Información de los puertos del contenedor único
output "contenedor_principal_puertos" {
    description = "Puertos expuestos del contenedor principal"
    # Aquí usamos una expresión for para extraer información de un bloque
    value = [for puerto in docker_container.web_unico.ports : {
        interno  = puerto.internal
        externo  = puerto.external
        ip       = puerto.ip
        protocolo = puerto.protocol
    }]
}

# OUTPUT SENSIBLE
# ===============
# Ejemplo 5: Información sensible que no debe mostrarse en logs
# Si tuviéramos passwords o tokens, los marcaríamos como sensitive
output "contenedor_principal_id_sensible" {
    description = "ID del contenedor (marcado como sensible para demostración)"
    value       = docker_container.web_unico.id
    sensitive   = true  # No se mostrará en la consola al hacer terraform apply
}

# OUTPUTS CUANDO USAMOS COUNT
# ============================
# Cuando un recurso usa count, terraform crea una LISTA de recursos
# Por lo tanto, para acceder a ellos necesitamos referenciarlos como lista

# Ejemplo 6: IDs de todos los contenedores creados con count
output "contenedores_ids" {
    description = "Lista con los IDs de todos los contenedores web"
    value       = docker_container.web[*].id
    # La sintaxis [*] es el "splat operator"
    # Es equivalente a: [for c in docker_container.web : c.id]
}

# Ejemplo 7: Nombres de todos los contenedores
output "contenedores_nombres" {
    description = "Lista con los nombres de todos los contenedores"
    value       = docker_container.web[*].name
}

# Ejemplo 8: Puertos externos de todos los contenedores
output "contenedores_puertos_externos" {
    description = "Lista de puertos externos asignados a cada contenedor"
    # Aquí es más complejo porque ports es un bloque list
    # Necesitamos extraer el primer puerto de cada contenedor
    value = [for contenedor in docker_container.web : contenedor.ports[0].external]
}

# OUTPUT CON FORMATO PERSONALIZADO
# =================================
# Ejemplo 9: Crear una estructura de datos personalizada
output "info_completa_contenedores" {
    description = "Información completa de todos los contenedores en formato estructurado"
    value = {
        total_contenedores = length(docker_container.web)
        contenedores = [for idx, contenedor in docker_container.web : {
            indice          = idx
            nombre          = contenedor.name
            id              = contenedor.id
            puerto_externo  = contenedor.ports[0].external
            puerto_interno  = contenedor.ports[0].internal
        }]
    }
}

# OUTPUT CON MAP
# ==============
# Ejemplo 10: Crear un mapa (diccionario) con información
output "contenedores_map" {
    description = "Mapa de contenedores donde la clave es el nombre y el valor es el puerto"
    value = {
        for contenedor in docker_container.web :
        contenedor.name => contenedor.ports[0].external
    }
}

# OUTPUT CALCULADO
# ================
# Ejemplo 11: Outputs con expresiones y cálculos
output "url_acceso_contenedores" {
    description = "URLs para acceder a cada contenedor"
    value = [
        for contenedor in docker_container.web :
        "http://localhost:${contenedor.ports[0].external}"
    ]
}

# Ejemplo 12: Output condicional
output "estado_despliegue" {
    description = "Estado del despliegue basado en el número de contenedores"
    value = length(docker_container.web) > 0 ? "Despliegue exitoso con ${length(docker_container.web)} contenedores" : "Sin contenedores desplegados"
}

# OUTPUT DE DATOS COMBINADOS
# ===========================
# Ejemplo 13: Combinar información de múltiples recursos
output "resumen_infraestructura" {
    description = "Resumen completo de la infraestructura desplegada"
    value = {
        imagen = {
            id     = docker_image.nginx.image_id
            nombre = docker_image.nginx.name
        }
        contenedor_principal = {
            nombre = docker_container.web_unico.name
            id     = docker_container.web_unico.id
            puertos = [for p in docker_container.web_unico.ports : "${p.internal}:${p.external}"]
        }
        contenedores_replicas = {
            cantidad = length(docker_container.web)
            nombres  = docker_container.web[*].name
            puertos  = docker_container.web[*].ports[0].external
        }
    }
}

# OUTPUTS CON DEPENDS_ON
# =======================
# Ejemplo 14: Output con dependencia explícita (raro, pero posible)
# Útil cuando necesitamos asegurar que ciertos recursos se creen antes de calcular el output
output "mensaje_final" {
    description = "Mensaje que se muestra al final del despliegue"
    value       = "Infraestructura desplegada correctamente. Total de contenedores: ${length(docker_container.web) + 1}"
    depends_on  = [
        docker_container.web,
        docker_container.web_unico
    ]
}

# NOTAS IMPORTANTES
# =================
#
# 1. Los outputs se evalúan DESPUÉS de crear todos los recursos
# 2. Se pueden ver con: terraform output
# 3. Se pueden ver en formato JSON con: terraform output -json
# 4. Un output específico: terraform output nombre_del_output
# 5. Los outputs se guardan en el terraform.tfstate
# 6. Si un output es sensitive, necesitas usar -raw para verlo: terraform output -raw nombre_output
# 7. Los outputs son la forma de comunicación entre módulos de Terraform
# 8. Podemos usar cualquier expresión válida de HCL en el value de un output
# 9. Los outputs con sensitive=true seguirán guardándose en el estado (no es encriptación)
# 10. Los outputs son útiles para pasarlos a otras herramientas (CI/CD, scripts, etc)
