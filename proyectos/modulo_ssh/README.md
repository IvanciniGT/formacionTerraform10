# 🔐 Módulo SSH - Generador de Claves SSH para Terraform

Módulo reutilizable de Terraform para la generación automatizada e idempotente de pares de claves SSH utilizando el provider oficial `hashicorp/tls`.

## 📋 Índice

- [Descripción](#-descripción)
- [Motivación](#-motivación)
- [Características](#-características)
- [Requisitos](#-requisitos)
- [Uso del Módulo](#-uso-del-módulo)
- [Variables de Entrada](#-variables-de-entrada)
- [Outputs del Módulo](#-outputs-del-módulo)
- [Ejemplos de Uso](#-ejemplos-de-uso)
- [Archivos Generados](#-archivos-generados)
- [Arquitectura del Módulo](#-arquitectura-del-módulo)

---

## 🎯 Descripción

**Módulo Terraform** diseñado para ser importado y reutilizado en tus proyectos de infraestructura. Genera pares de claves SSH (pública y privada) y las almacena en disco en múltiples formatos, permitiendo su uso inmediato en clouds como AWS, Azure, GCP, etc.

### ¿Qué es un módulo de Terraform?

Un módulo es una **unidad reutilizable** de código Terraform que encapsula un conjunto de recursos relacionados. En lugar de copiar y pegar código entre proyectos, puedes importar este módulo y configurarlo según tus necesidades.

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

- ✅ **Módulo reutilizable**: Importa en cualquier proyecto de Terraform
- ✅ **Generación automatizada** de pares de claves SSH
- ✅ **Múltiples formatos**: PEM y OpenSSH
- ✅ **Soporte de algoritmos**: RSA, ECDSA, ED25519
- ✅ **Configuración flexible** de parámetros por algoritmo
- ✅ **Idempotencia**: No regenera claves existentes por defecto
- ✅ **Regeneración forzada**: Opción para recrear claves cuando sea necesario
- ✅ **Validaciones robustas**: Verificación de parámetros en tiempo de ejecución
- ✅ **Gestión de directorios**: Creación automática de carpetas si no existen
- ✅ **Outputs disponibles**: Acceso a claves públicas para uso en otros recursos
- ✅ **Valores por defecto**: Configuración sensata out-of-the-box

---

## 📦 Requisitos

- **Terraform**: >= 1.0
- **Provider TLS**: hashicorp/tls >= 4.0

> **Nota**: El provider TLS se configura automáticamente dentro del módulo. No necesitas añadirlo en tu proyecto principal.

---

## 🚀 Uso del Módulo

### Sintaxis básica

Para usar este módulo en tu proyecto de Terraform, referéncialo con un bloque `module`:

```hcl
module "claves_ssh" {
  source = "./ruta/al/modulo_ssh"
  
  # Variables del módulo
  directorio_claves               = "./claves"
  forzar_regeneracion_de_claves   = false
  algoritmo_claves = {
    nombre        = "RSA"
    configuracion = "4096"
  }
}
```

### Acceder a los outputs del módulo

Después de declarar el módulo, puedes acceder a sus outputs:

```hcl
# Usar la clave pública en un recurso de AWS
resource "aws_key_pair" "mi_clave" {
  key_name   = "mi-clave-ssh"
  public_key = module.claves_ssh.clave_publica.openssh
}

# O mostrar la clave pública como output de tu proyecto
output "clave_ssh_publica" {
  value     = module.claves_ssh.clave_publica.openssh
  sensitive = true
}
```

---

## 📝 Variables de Entrada

Todas las variables del módulo tienen **valores por defecto**, por lo que el módulo se puede usar sin pasar ningún parámetro:

```hcl
module "claves_ssh" {
  source = "./modulo_ssh"
  # Usará todos los valores por defecto
}
```

### `directorio_claves`

- **Tipo**: `string`
- **Descripción**: Directorio donde se almacenarán las claves SSH generadas
- **Valor por defecto**: `"./claves"`
- **Obligatorio**: No (tiene default)
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
- **Valor por defecto**: `false`
- **Obligatorio**: No (tiene default)
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
- **Valor por defecto**: `{ nombre = "RSA", configuracion = "2048" }`
- **Obligatorio**: No (tiene default)
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

---

## 📤 Outputs del Módulo

El módulo expone un único output que contiene las **claves públicas** en ambos formatos:

### `clave_publica`

- **Tipo**: `object`
- **Descripción**: Claves públicas en formato PEM y OpenSSH
- **Sensible**: Sí (no se muestra en logs)
- **Estructura**:
  ```hcl
  {
    pem      = string  # Clave pública en formato PEM
    openssh  = string  # Clave pública en formato OpenSSH
  }
  ```

### Cómo usar el output:

```hcl
# En un recurso de AWS EC2
resource "aws_key_pair" "deployer" {
  key_name   = "clave-despliegue"
  public_key = module.claves_ssh.clave_publica.openssh
}

# En un recurso de Azure
resource "azurerm_linux_virtual_machine" "example" {
  # ... otras configuraciones
  admin_ssh_key {
    username   = "adminuser"
    public_key = module.claves_ssh.clave_publica.openssh
  }
}

# Ver el output en tu proyecto
output "mi_clave_publica" {
  value     = module.claves_ssh.clave_publica.openssh
  sensitive = true
}
```

> 🔒 **Nota de seguridad**: El output está marcado como `sensitive`. Para verlo usa:
> ```bash
> terraform output -raw mi_clave_publica
> ```

---

## 📚 Ejemplos de Uso

### Ejemplo 1: Uso mínimo (valores por defecto)

```hcl
# main.tf de tu proyecto
module "ssh_keys" {
  source = "./modulo_ssh"
}

# Genera claves RSA 2048 en ./claves/
```

### Ejemplo 2: Configuración para desarrollo

```hcl
module "ssh_dev" {
  source = "./modulo_ssh"
  
  directorio_claves               = "./claves_desarrollo"
  forzar_regeneracion_de_claves   = false
  algoritmo_claves = {
    nombre        = "RSA"
    configuracion = "2048"
  }
}

# Usar la clave en AWS
resource "aws_key_pair" "dev" {
  key_name   = "dev-key"
  public_key = module.ssh_dev.clave_publica.openssh
}
```

### Ejemplo 3: Configuración para producción con ED25519

```hcl
module "ssh_prod" {
  source = "./modulo_ssh"
  
  directorio_claves               = "/secure/keys/production"
  forzar_regeneracion_de_claves   = false
  algoritmo_claves = {
    nombre        = "ED25519"
    configuracion = null  # ED25519 no admite configuración
  }
}

resource "aws_key_pair" "prod" {
  key_name   = "production-key"
  public_key = module.ssh_prod.clave_publica.openssh
}
```

### Ejemplo 4: Alta seguridad con RSA 8192

```hcl
module "ssh_secure" {
  source = "./modulo_ssh"
  
  directorio_claves = "./keys_secure"
  algoritmo_claves = {
    nombre        = "RSA"
    configuracion = "8192"
  }
}
```

### Ejemplo 5: Múltiples entornos

```hcl
# Claves para desarrollo
module "ssh_dev" {
  source            = "./modulo_ssh"
  directorio_claves = "./keys/dev"
  algoritmo_claves = {
    nombre        = "RSA"
    configuracion = "2048"
  }
}

# Claves para staging
module "ssh_staging" {
  source            = "./modulo_ssh"
  directorio_claves = "./keys/staging"
  algoritmo_claves = {
    nombre        = "ECDSA"
    configuracion = "P384"
  }
}

# Claves para producción
module "ssh_prod" {
  source            = "./modulo_ssh"
  directorio_claves = "./keys/production"
  algoritmo_claves = {
    nombre        = "ED25519"
  }
}

# Usar en recursos
resource "aws_key_pair" "dev" {
  key_name   = "dev-key"
  public_key = module.ssh_dev.clave_publica.openssh
}

resource "aws_key_pair" "staging" {
  key_name   = "staging-key"
  public_key = module.ssh_staging.clave_publica.openssh
}

resource "aws_key_pair" "prod" {
  key_name   = "prod-key"
  public_key = module.ssh_prod.clave_publica.openssh
}
```

### Ejemplo 6: Usando el módulo con variables locales

```hcl
locals {
  entorno = "produccion"
  configuracion_claves = {
    desarrollo = {
      directorio = "./keys/dev"
      algoritmo  = { nombre = "RSA", configuracion = "2048" }
    }
    produccion = {
      directorio = "./keys/prod"
      algoritmo  = { nombre = "ED25519", configuracion = null }
    }
  }
}

module "ssh_dinamico" {
  source = "./modulo_ssh"
  
  directorio_claves = local.configuracion_claves[local.entorno].directorio
  algoritmo_claves  = local.configuracion_claves[local.entorno].algoritmo
}
```

### Ejemplo 7: Regeneración forzada (ciclo de rotación de claves)

```hcl
module "ssh_rotacion" {
  source = "./modulo_ssh"
  
  directorio_claves               = "./keys/rotacion"
  forzar_regeneracion_de_claves   = true  # Regenera aunque existan
  algoritmo_claves = {
    nombre        = "ED25519"
  }
}
```

---

## 🧪 Probar el Módulo (antes de eliminarlo valores.auto.tfvars)

Si estás desarrollando o probando el módulo, puedes ejecutarlo directamente:

```bash
# El módulo usa los valores de: valores_por_defecto.auto.tfvars
terraform init
terraform plan
terraform apply

# Ver los outputs (aunque son sensitive)
terraform output clave_publica
terraform output -raw clave_publica

# Limpiar
terraform destroy
```

**Configuración actual en `valores_por_defecto.auto.tfvars`**:
```hcl
directorio_claves                   = "./claves"
forzar_regeneracion_de_claves       = false
algoritmo_claves = {
  nombre        = "RSA"
  configuracion = "2048"
}
```

> ⚠️ **Nota**: Este archivo `valores_por_defecto.auto.tfvars` es solo para testing del módulo y **se eliminará** en la versión final. Cuando uses el módulo en tu proyecto, los valores por defecto vienen definidos directamente en `variables.tf`.

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

## 🏗️ Arquitectura del Módulo

### Estructura del módulo

```
modulo_ssh/
├── versions.tf                      # Configuración de providers requeridos
├── variables.tf                     # Definición de variables con defaults y validaciones
├── main.tf                          # Lógica principal y recursos
├── outputs.tf                       # Outputs expuestos por el módulo
├── valores_por_defecto.auto.tfvars  # ⚠️ Solo para testing (se eliminará)
└── README.md                        # Documentación del módulo
```

### Flujo de ejecución del módulo

```
┌─────────────────────────────────────┐
│  Proyecto Principal                 │
│  (llama al módulo)                  │
└──────────────┬──────────────────────┘
               │
               │ module "ssh" { source = "./modulo_ssh" ... }
               │
               ▼
┌─────────────────────────────────────┐
│  MÓDULO SSH                         │
│  ┌───────────────────────────────┐  │
│  │ 1. Recibe variables           │  │
│  │    (o usa defaults)           │  │
│  └───────────────────────────────┘  │
│               │                     │
│               ▼                     │
│  ┌───────────────────────────────┐  │
│  │ 2. Validaciones               │  │
│  │    - Directorio válido        │  │
│  │    - Algoritmo permitido      │  │
│  │    - Configuración correcta   │  │
│  └───────────────────────────────┘  │
│               │                     │
│               ▼                     │
│  ┌───────────────────────────────┐  │
│  │ 3. Verifica claves existentes │  │
│  │    fileexists() para cada     │  │
│  │    archivo de clave           │  │
│  └───────────────────────────────┘  │
│               │                     │
│               ▼                     │
│  ┌───────────────────────────────┐  │
│  │ 4. Decide si genera claves    │  │
│  │    count = 0 o 1              │  │
│  └───────────────────────────────┘  │
│               │                     │
│      ┌────────┴────────┐            │
│      │                 │            │
│  count=0           count=1          │
│   (Skip)           (Genera)         │
│      │                 │            │
│      │                 ▼            │
│      │    ┌─────────────────────┐  │
│      │    │ 5. tls_private_key  │  │
│      │    │    Genera par       │  │
│      │    └─────────────────────┘  │
│      │                 │            │
│      │                 ▼            │
│      │    ┌─────────────────────┐  │
│      │    │ 6. local-exec       │  │
│      │    │    Guarda en disco  │  │
│      │    └─────────────────────┘  │
│      │                 │            │
│      └────────┬────────┘            │
│               │                     │
│               ▼                     │
│  ┌───────────────────────────────┐  │
│  │ 7. Output clave_publica       │  │
│  │    - Desde recurso (si new)   │  │
│  │    - Desde archivo (si exist) │  │
│  └───────────────────────────────┘  │
└──────────────┬──────────────────────┘
               │
               │ module.ssh.clave_publica
               │
               ▼
┌─────────────────────────────────────┐
│  Proyecto Principal                 │
│  (usa output del módulo)            │
│  ej: aws_key_pair, etc.             │
└─────────────────────────────────────┘
```

### Componentes clave

#### 1. **Variables con defaults** (variables.tf)
```hcl
variable "algoritmo_claves" {
  default = {
    nombre        = "RSA"
    configuracion = "2048"
  }
  # ... validaciones
}
```

#### 2. **Locals para lógica interna** (main.tf)
```hcl
locals {
  es_necesario_generar_claves = var.forzar_regeneracion_de_claves || local.no_existan_claves
}
```

#### 3. **Recurso condicional con count** (main.tf)
```hcl
resource "tls_private_key" "mi_clave_ssh" {
  count = local.es_necesario_generar_claves ? 1 : 0
  # ...
}
```

#### 4. **Output inteligente** (outputs.tf)
```hcl
output "clave_publica" {
  value = local.es_necesario_generar_claves ? 
    tls_private_key.mi_clave_ssh.public_key_openssh :
    file(local.ruta_fichero_publico_openssh)
}
```

---

## 🔍 Lógica de Idempotencia

El módulo implementa idempotencia verificando la existencia de archivos:

```
┌─────────────────────────────────────────────┐
│ ¿forzar_regeneracion_de_claves = true?     │
└────────────┬────────────────────────────────┘
             │
        ┌────┴────┐
        │         │
       SÍ        NO
        │         │
        │         ▼
        │    ┌────────────────────────────────┐
        │    │ ¿Existen TODOS los archivos?   │
        │    │ - private_key.pem              │
        │    │ - public_key.pem               │
        │    │ - private_key.openssh          │
        │    │ - public_key.openssh           │
        │    └────────┬───────────────────────┘
        │             │
        │        ┌────┴────┐
        │        │         │
        │       SÍ        NO
        │        │         │
        └────────┼─────────┘
                 │
            ┌────┴────┐
            │         │
        GENERAR    NO GENERAR
         count=1    count=0
            │         │
            ▼         ▼
     ┌──────────┐  ┌─────────────┐
     │ Crea     │  │ Lee de      │
     │ claves   │  │ archivos    │
     │ nuevas   │  │ existentes  │
     └──────────┘  └─────────────┘
```

---

## 🛡️ Validaciones Implementadas

El módulo incluye validaciones exhaustivas para garantizar configuraciones correctas:

### Validación de directorio
- Verifica que la ruta sea válida mediante regex
- Acepta rutas relativas (`./`, `../`) y absolutas

### Validación de algoritmo
- Solo permite: `RSA`, `ECDSA`, `ED25519`
- Case-insensitive

### Validaciones específicas por algoritmo

**RSA**:
- Tamaño entre 1024 y 16384 bits
- Debe ser múltiplo de 8
- Validación numérica estricta con `can()` y `tonumber()`

**ECDSA**:
- Curvas permitidas: P224, P256, P384, P521
- Configuración opcional (usa P256 por defecto si es null)

**ED25519**:
- No acepta configuración adicional
- La configuración debe ser `null`

---

## 🔍 Comandos Útiles

### Como módulo (en tu proyecto principal)

```bash
# Inicializar (descarga el provider TLS)
terraform init

# Ver el plan
terraform plan

# Aplicar
terraform apply

# Ver outputs del módulo
terraform output

# Destruir
terraform destroy
```

### Para testing del módulo directamente

```bash
# Inicializar el módulo
cd modulo_ssh
terraform init

# Probar con valores por defecto
terraform plan
terraform apply

# Ver las claves generadas
ls -la ./claves/

# Ver outputs (son sensitive)
terraform output -raw clave_publica

# Limpiar
terraform destroy
rm -rf ./claves/
```

---

## 📘 Conceptos Clave de Terraform Utilizados

Este módulo es un excelente ejemplo educativo que demuestra:

### 1. **Creación de módulos reutilizables**
```hcl
# En tu proyecto principal
module "ssh" {
  source = "./modulo_ssh"
  # ...variables
}
```

### 2. **Variables con defaults**
```hcl
variable "directorio_claves" {
  default = "./claves"
}
```
Permite usar el módulo sin pasar todas las variables.

### 3. **Outputs de módulos**
```hcl
# Dentro del módulo
output "clave_publica" { ... }

# En el proyecto que usa el módulo
module.ssh.clave_publica.openssh
```

### 4. **Validaciones avanzadas** con expresiones booleanas
```hcl
validation {
  condition     = contains(["RSA", "ECDSA", "ED25519"], upper(var.algoritmo_claves.nombre))
  error_message = "Algoritmo no válido"
}
```

### 5. **Locals para lógica interna**
```hcl
locals {
  es_necesario_generar_claves = var.forzar_regeneracion_de_claves || local.no_existan_claves
}
```

### 6. **Condicionales con count**
```hcl
resource "tls_private_key" "mi_clave_ssh" {
  count = local.es_necesario_generar_claves ? 1 : 0
}
```
Crea o no crea el recurso según la condición.

### 7. **Funciones de Terraform**
- `fileexists()`: Verifica existencia de archivos
- `endswith()`: Comprueba sufijos
- `tonumber()`: Convierte strings a números
- `can()`: Evalúa si una expresión es válida
- `upper()`/`lower()`: Conversión de mayúsculas/minúsculas
- `file()`: Lee contenido de archivos
- `contains()`: Verifica pertenencia en listas

### 8. **Provisioners (local-exec)**
```hcl
provisioner "local-exec" {
  command = <<EOT
    mkdir -p ${local.directorio_claves}
    echo -n "${self.private_key_pem}" > archivo
  EOT
}
```
Ejecuta comandos locales tras crear el recurso.

### 9. **Implementación de idempotencia**
Verificación de estado antes de actuar.

### 10. **Interpolación de cadenas**
```hcl
"${local.directorio_claves}private_key.pem"
```

### 11. **Uso de `self` en provisioners**
```hcl
echo -n "${self.private_key_pem}" > archivo
```
Referencia al recurso actual dentro de su propio provisioner.

### 12. **Types complejos: `object` y `optional`**
```hcl
type = object({
  nombre        = string
  configuracion = optional(string)
})
```

---

## 🎓 Ventajas de Usar Módulos

### ✅ **Reutilización de código**
- Escribe una vez, usa en múltiples proyectos
- DRY (Don't Repeat Yourself)

### ✅ **Mantenimiento centralizado**
- Arregla bugs en un solo lugar
- Mejoras se propagan a todos los proyectos

### ✅ **Abstracción de complejidad**
- Oculta implementación compleja
- Interfaz simple y clara

### ✅ **Estándares y mejores prácticas**
- Validaciones consistentes
- Convenciones unificadas

### ✅ **Testing independiente**
- Prueba el módulo por separado
- Mayor confianza en el código

### ✅ **Versionado**
- Publica versiones del módulo
- Control de cambios breaking

---

## 🚧 Notas de Desarrollo

### Estado actual
- ✅ Módulo funcional y probado
- ✅ Variables con defaults completos
- ✅ Validaciones exhaustivas
- ✅ Output de clave pública disponible
- ⚠️ Archivo `valores_por_defecto.auto.tfvars` presente (para testing)

### Antes de usar en producción
1. **Eliminar** `valores_por_defecto.auto.tfvars` (no necesario en módulos)
2. Verificar que el directorio de claves tiene permisos adecuados
3. Considerar el backup de claves existentes

### Mejoras futuras posibles
- [ ] Añadir soporte para Windows en la validación de rutas
- [ ] Output adicional con metadatos de las claves
- [ ] Opción para encriptar claves privadas con passphrase
- [ ] Soporte para almacenar claves en sistemas externos (Vault, etc.)
- [ ] Tests automatizados del módulo

---

## ❓ FAQ (Preguntas Frecuentes)

### ¿Puedo usar este módulo sin pasar ninguna variable?
**Sí**. Todas las variables tienen valores por defecto sensatos:
```hcl
module "ssh" {
  source = "./modulo_ssh"
}
```

### ¿Qué pasa si borro los archivos pero no el estado de Terraform?
El módulo detectará que faltan archivos y los volverá a generar con las mismas claves almacenadas en el estado.

### ¿Cómo roto las claves periódicamente?
Usa `forzar_regeneracion_de_claves = true` cuando quieras crear nuevas claves.

### ¿Las claves privadas se exponen en el estado de Terraform?
Sí, Terraform almacena los recursos en el estado. **Asegúrate de**:
- Usar remote state con encriptación (S3 + encryption, Terraform Cloud, etc.)
- Restringir acceso al archivo de estado
- Considerar usar Terraform Vault provider para mayor seguridad

### ¿Puedo usar múltiples instancias del módulo?
**Sí**, puedes invocar el módulo múltiples veces con diferentes nombres:
```hcl
module "ssh_dev" {
  source = "./modulo_ssh"
  directorio_claves = "./keys/dev"
}

module "ssh_prod" {
  source = "./modulo_ssh"
  directorio_claves = "./keys/prod"
}
```

### ¿Qué algoritmo recomiendas?
- **ED25519**: Moderno, rápido, seguro. Recomendado para nuevos proyectos.
- **RSA 4096**: Si necesitas compatibilidad con sistemas legacy.
- **ECDSA**: Buen balance, pero ED25519 suele ser mejor opción.

---

## 🤝 Contribución

Este es un proyecto educativo. Ideas de mejora:
- Mejorar validaciones (rutas Windows)
- Añadir más outputs
- Implementar tests automatizados
- Mejorar documentación con más ejemplos
- Añadir soporte para backends remotos de almacenamiento

---

## 📄 Licencia

Proyecto educativo - Curso de Terraform

---

## ✍️ Autor

Desarrollado como parte del curso de Terraform para demostrar:
- Creación de módulos reutilizables
- Validaciones avanzadas
- Outputs de módulos
- Implementación de idempotencia
- Gestión de claves SSH como IaC