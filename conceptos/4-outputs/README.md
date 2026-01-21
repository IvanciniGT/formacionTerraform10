# Outputs en Terraform

Este directorio contiene ejemplos prácticos y documentación sobre los **outputs** en Terraform.

## ¿Qué son los Outputs?

Los outputs son una forma de extraer y exponer información de los recursos que Terraform ha creado. Funcionan como las "salidas" o "valores de retorno" de tu configuración de Terraform.

## ¿Para qué sirven?

1. **Mostrar información al usuario**: Después de ejecutar `terraform apply`, se muestran automáticamente
2. **Comunicación entre módulos**: Permiten que un módulo comparta información con otros
3. **Integración con otras herramientas**: Los outputs se pueden consumir desde scripts, CI/CD, etc.
4. **Consulta posterior**: Se guardan en el estado y se pueden consultar con `terraform output`

## Archivos en este directorio

- **versions.tf**: Configuración de providers
- **variables.tf**: Variables de entrada para los ejemplos
- **main.tf**: Recursos de ejemplo y explicación conceptual
- **outputs.tf**: Ejemplos completos de diferentes tipos de outputs

## Ejemplos incluidos

### 1. Outputs simples
Extraer valores directos de recursos (IDs, nombres, etc.)

### 2. Outputs de recursos únicos
Información de un contenedor específico y sus propiedades

### 3. Outputs sensibles
Cómo marcar información como sensible para que no se muestre en logs

### 4. Outputs con COUNT
Trabajar con listas de recursos creados con `count`

### 5. Outputs con formatos personalizados
Crear estructuras de datos complejas (mapas, objetos anidados)

### 6. Outputs calculados
Usar expresiones, condicionales y funciones en los outputs

### 7. Outputs combinados
Agregar información de múltiples recursos en una sola salida

## Comandos útiles

```bash
# Inicializar Terraform (primera vez)
terraform init

# Ver el plan de ejecución
terraform plan

# Aplicar la configuración
terraform apply

# Ver todos los outputs
terraform output

# Ver un output específico
terraform output contenedores_nombres

# Ver outputs en formato JSON
terraform output -json

# Ver un output sensible
terraform output -raw contenedor_principal_id_sensible

# Destruir los recursos creados
terraform destroy
```

## Sintaxis básica

```hcl
output "nombre_del_output" {
  description = "Descripción clara de qué representa este output"
  value       = expresion_que_calcula_el_valor
  sensitive   = false  # true para información sensible
}
```

## Buenas prácticas

1. **Siempre incluir description**: Ayuda a entender qué representa cada output
2. **Usar outputs.tf**: Mantener todos los outputs en un archivo separado
3. **Nombres descriptivos**: Usar nombres claros y consistentes
4. **Marcar como sensitive**: Cualquier dato sensible (passwords, tokens, keys)
5. **Estructurar bien los datos**: Usar objetos y mapas para información relacionada
6. **Documentar**: Añadir comentarios para casos complejos

## Referencias

Dentro del código encontrarás:
- Comentarios detallados explicando cada tipo de output
- Ejemplos progresivos desde simples a complejos
- Casos de uso reales y prácticos
- Notas sobre el comportamiento de Terraform con outputs
