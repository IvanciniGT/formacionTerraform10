# 🔐 Generador de Claves SSH con Terraform

Proyecto de Terraform para la generación automatizada e idempotente de pares de claves SSH utilizando el provider oficial `hashicorp/tls`.

## 📋 Índice

- [Descripción](#-descripción)
- [Motivación](#-motivación)
- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Uso](#-uso)
- [Variables de Entrada](#-variables-de-entrada)
- [Ejemplos](#-ejemplos)
- [Archivos Generados](#-archivos-generados)
- [Arquitectura](#-arquitectura)

---

## 🎯 Descripción

Este módulo de Terraform genera pares de claves SSH (pública y privada) y las almacena en disco en múltiples formatos. Está diseñado para ser utilizado como parte de una infraestructura más grande, especialmente útil para despliegues en clouds como AWS, donde las claves SSH son requisito obligatorio para la autenticación en servidores.

## 💡 Motivación

### ¿Por qué autenticación con claves SSH?

La autenticación mediante claves públicas/privadas ofrece ventajas significativas sobre el uso tradicional de usuario y contraseña:

1. **Seguridad mejorada**: La clave privada nunca viaja por la red, eliminando puntos potenciales de exposición
2. **Protección contra phishing**: Inmunidad ante ataques de suplantación de identidad
3. **Automatización segura**: Permite conexiones programáticas sin almacenar contraseñas en texto plano

### ¿Por qué gestionar las claves con Terraform?

Las claves SSH son parte fundamental de la infraestructura (IaC - Infrastructure as Code):
- Versionado y trazabilidad
- Despliegue reproducible
- Gestión centralizada
- Integración con el ciclo de vida de la infraestructura

---

## ✨ Características

- ✅ **Generación automatizada** de pares de claves SSH
- ✅ **Múltiples formatos**: PEM y OpenSSH
- ✅ **Soporte de algoritmos**: RSA, ECDSA, ED25519
- ✅ **Configuración flexible** de parámetros por algoritmo
- ✅ **Idempotencia**: No regenera claves existentes por defecto
- ✅ **Regeneración forzada**: Opción para recrear claves cuando sea necesario
- ✅ **Validaciones robustas**: Verificación de parámetros en tiempo de ejecución
- ✅ **Gestión de directorios**: Creación automática de carpetas si no existen

---

## 📦 Requisitos

- **Terraform**: >= 1.0
- **Provider TLS**: hashicorp/tls >= 4.0

---

## 🚀 Instalación

1. Clona o descarga este proyecto
2. Inicializa Terraform:

```bash
terraform init
```

---

## 🔧 Uso

### Uso básico

```bash
# Con valores por defecto (definidos en valores_por_defecto.auto.tfvars)
terraform apply

# Con archivo de configuración específico
terraform apply -var-file="valores.tfvars"

# Con variables en línea de comandos
terraform apply \
  -var="directorio_claves=./claves" \
  -var="forzar_regeneracion_de_claves=false" \
  -var='algoritmo_claves={nombre="RSA",configuracion="4096"}'
```

### Destruir recursos

```bash
terraform destroy
```

> ⚠️ **Nota**: Los archivos de claves generados en disco NO se eliminan automáticamente al ejecutar `terraform destroy`. Debes eliminarlos manualmente si lo deseas.

---

## 📝 Variables de Entrada

### `directorio_claves`

- **Tipo**: `string`
- **Descripción**: Directorio donde se almacenarán las claves SSH generadas
- **Obligatorio**: Sí
- **Validación**: Debe ser una ruta válida (absoluta o relativa)
- **Ejemplos**:
  ```hcl
  directorio_claves = "./claves"
  directorio_claves = "../ssh_keys"
  directorio_claves = "/home/usuario/claves_ssh"
  ```

### `forzar_regeneracion_de_claves`

- **Tipo**: `bool`
- **Descripción**: Indica si se deben regenerar las claves SSH aunque ya existan en el directorio
- **Obligatorio**: Sí
- **Valores**: `true` o `false`
- **Comportamiento**:
  - `false` (recomendado): Mantiene idempotencia, no regenera claves existentes
  - `true`: Fuerza la regeneración de todas las claves
- **Ejemplo**:
  ```hcl
  forzar_regeneracion_de_claves = false
  ```

### `algoritmo_claves`

- **Tipo**: `object`
- **Descripción**: Algoritmo y configuración para la generación de claves SSH
- **Obligatorio**: Sí
- **Estructura**:
  ```hcl
  {
    nombre        = string           # Algoritmo: "RSA", "ECDSA", o "ED25519"
    configuracion = optional(string) # Parámetros específicos del algoritmo
  }
  ```

#### Opciones por algoritmo:

| Algoritmo | Configuración Válida | Por Defecto | Descripción |
|-----------|---------------------|-------------|-------------|
| **RSA** | `"1024"` - `"16384"` (múltiplos de 8) | `"2048"` | Tamaño de la clave en bits |
| **ECDSA** | `"P224"`, `"P256"`, `"P384"`, `"P521"` | `"P256"` | Curva elíptica |
| **ED25519** | `null` (no acepta configuración) | N/A | Algoritmo de curva elíptica moderna |

#### Ejemplos:

```hcl
# RSA con 4096 bits (alta seguridad)
algoritmo_claves = {
  nombre        = "RSA"
  configuracion = "4096"
}

# ECDSA con curva P384
algoritmo_claves = {
  nombre        = "ECDSA"
  configuracion = "P384"
}

# ED25519 (recomendado para nuevos proyectos)
algoritmo_claves = {
  nombre        = "ED25519"
  configuracion = null
}

# RSA con configuración por defecto (2048 bits)
algoritmo_claves = {
  nombre = "RSA"
}
```

---

## 📚 Ejemplos

### Ejemplo 1: Configuración para desarrollo local

```hcl
# valores.desarrollo.tfvars
directorio_claves               = "./claves_dev"
forzar_regeneracion_de_claves   = false
algoritmo_claves = {
  nombre        = "RSA"
  configuracion = "2048"
}
```

```bash
terraform apply -var-file="valores.desarrollo.tfvars"
```

### Ejemplo 2: Configuración para producción

```hcl
# valores.produccion.tfvars
directorio_claves               = "/secure/keys/production"
forzar_regeneracion_de_claves   = false
algoritmo_claves = {
  nombre        = "ED25519"
  configuracion = null
}
```

```bash
terraform apply -var-file="valores.produccion.tfvars"
```

### Ejemplo 3: Regenerar claves existentes

```bash
# Forzar regeneración sin modificar archivo tfvars
terraform apply \
  -var-file="valores.tfvars" \
  -var="forzar_regeneracion_de_claves=true"
```

### Ejemplo 4: Configuración de alta seguridad

```hcl
# valores.alta_seguridad.tfvars
directorio_claves               = "./claves_seguras"
forzar_regeneracion_de_claves   = false
algoritmo_claves = {
  nombre        = "RSA"
  configuracion = "8192"  # Máxima seguridad con RSA
}
```

---

## 📄 Archivos Generados

Al ejecutar este proyecto, se crearán 4 archivos en el directorio especificado:

```
<directorio_claves>/
├── private_key.pem       # Clave privada en formato PEM
├── public_key.pem        # Clave pública en formato PEM
├── private_key.openssh   # Clave privada en formato OpenSSH
└── public_key.openssh    # Clave pública en formato OpenSSH
```

### Uso de los archivos generados:

- **`private_key.openssh`**: Para autenticación SSH desde cliente
  ```bash
  ssh -i <directorio_claves>/private_key.openssh usuario@servidor
  ```

- **`public_key.openssh`**: Para agregar a `~/.ssh/authorized_keys` en servidores

- **`private_key.pem` / `public_key.pem`**: Para servicios que requieren formato PEM (AWS, etc.)

> 🔒 **Seguridad**: Asegúrate de establecer permisos adecuados:
> ```bash
> chmod 600 <directorio_claves>/private_key.*
> chmod 644 <directorio_claves>/public_key.*
> ```

---

## 🏗️ Arquitectura

### Componentes del proyecto

```
proyecto_ssh/
├── versions.tf                      # Configuración de providers
├── variables.tf                     # Definición de variables con validaciones
├── main.tf                          # Lógica principal y recursos
├── outputs.tf                       # Outputs (actualmente vacío)
├── valores_por_defecto.auto.tfvars  # Valores por defecto
├── valores.tfvars                   # Configuración personalizable
└── README.md                        # Este archivo
```

### Flujo de ejecución

1. **Validación de variables**: Terraform valida todos los parámetros de entrada
2. **Verificación de claves existentes**: Comprueba si ya existen archivos de claves
3. **Decisión de generación**: Determina si es necesario generar nuevas claves
4. **Generación de claves**: Utiliza el provider TLS para crear el par de claves
5. **Persistencia**: Guarda las claves en disco mediante `local-exec` provisioner

### Lógica de idempotencia

```
¿Forzar regeneración? ────── SÍ ──────┐
         │                            │
         NO                            │
         │                             │
         ▼                             │
¿Existen todas las claves?             │
         │                             │
    ┌────┴────┐                        │
    │         │                        │
   SÍ        NO                        │
    │         │                        │
    │         └────────────────────────┤
    │                                  │
    ▼                                  ▼
No generar                         Generar claves
```

---

## 🛡️ Validaciones Implementadas

El proyecto incluye validaciones exhaustivas para garantizar configuraciones correctas:

### Validación de directorio
- Verifica que la ruta sea válida
- Acepta rutas relativas (`./`, `../`) y absolutas

### Validación de algoritmo
- Solo permite: `RSA`, `ECDSA`, `ED25519`
- Case-insensitive

### Validaciones específicas por algoritmo

**RSA**:
- Tamaño entre 1024 y 16384 bits
- Debe ser múltiplo de 8
- Validación numérica estricta

**ECDSA**:
- Curvas permitidas: P224, P256, P384, P521
- Configuración opcional (usa P256 por defecto)

**ED25519**:
- No acepta configuración adicional
- Es el más moderno y recomendado

---

## 🔍 Comandos Útiles

```bash
# Ver plan de ejecución sin aplicar
terraform plan

# Aplicar con confirmación automática
terraform apply -auto-approve

# Ver estado actual
terraform show

# Listar recursos gestionados
terraform state list

# Formatear código HCL
terraform fmt

# Validar configuración
terraform validate

# Ver outputs (cuando estén definidos)
terraform output
```

---

## 📘 Conceptos Clave de Terraform Utilizados

Este proyecto es un excelente ejemplo educativo que demuestra:

- ✓ Uso de **providers** externos (hashicorp/tls)
- ✓ Definición de **variables** con tipos complejos (objects)
- ✓ **Validaciones** avanzadas con expresiones booleanas
- ✓ **Locals** para cálculos y lógica interna
- ✓ **Condicionales** para control de flujo
- ✓ **Funciones de Terraform** (fileexists, endswith, tonumber, etc.)
- ✓ **Provisioners** (local-exec) para tareas locales
- ✓ **Count** para generación condicional de recursos
- ✓ Implementación de **idempotencia**
- ✓ Interpolación de cadenas y expresiones complejas

---

## 🎓 Notas Educativas

### ¿Por qué usar `count` con valor 0 o 1?

```hcl
resource "tls_private_key" "mi_clave_ssh" {
    count = local.es_necesario_generar_claves ? 1 : 0
    # ...
}
```

Esta técnica permite crear o no crear un recurso basándose en condiciones. Es una forma elegante de implementar lógica condicional para recursos completos.

### ¿Por qué `optional` en configuracion?

```hcl
configuracion = optional(string)
```

Permite que el campo sea omitido o establecido explícitamente a `null`, lo que nos da flexibilidad para usar valores por defecto del provider cuando sea apropiado.

### Uso de `self` en provisioners

```hcl
provisioner "local-exec" {
    command = <<EOT
        echo -n "${self.private_key_pem}" > archivo
    EOT
}
```

`self` referencia el recurso actual, permitiendo acceder a sus atributos dentro del provisioner.

---

## 🤝 Contribución

Este es un proyecto educativo. Siéntete libre de:
- Mejorar las validaciones
- Añadir más algoritmos
- Implementar outputs adicionales
- Mejorar la documentación

---

## 📄 Licencia

Proyecto educativo - Curso de Terraform

---

## ✍️ Autor

Desarrollado como parte del curso de Terraform para demostrar conceptos avanzados de IaC.