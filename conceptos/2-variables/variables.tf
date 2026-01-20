# Aquí vamos a definir los PARAMETROS de nuestro script

# variable "NOMBRE_DE_LA_VARIABLE" {
#    type    = TIPO_DE_DATO   # string, number, bool, list, set, map, object
#    description = "Descripción de la variable"
#         Es importante poner descripciones a las variables
#         Esas descripciones salen por pantalla cuando hay un error al ejecutar terraform
#    nullable = true|false   # Por defecto es false
# Toda variable tiene siempre un valor. Ese valor puede ser nulo (null) solamente si nullable es true
# Una propiedad de tipo string, a priori solo admite textos
# Igual que una propiedad de tipo number solo admite números
# Si quiero poder dejar en "blanco" una variable de tipo string o de tipo number
# es imprescindible poner nullable = true
# Al hacerlo se admitirá que la variable tome el valor null
#    default = VALOR_POR_DEFECTO  # NO LO USAMOS NUNCA JAMAS EN LA VIDA en nuestros scripts. 
#    No es el objetivo de default.
#    El objetivo de default NO ES ESTABLEC_ER VALORES POR DEFECTO A LAS VARIABLES en los scripts.
#    Sirve para otra cosa... que ya os contaré!
#    Si lo que quiero es establecer valores por defecto a las variables
#    de mi script, creare un fichero independiente llamado COMO_QUIERA.auto.tfvars
#    donde definiré los valores por defecto de las variables que use en mi script.
#    sensitive = true|false  # Por defecto es false
#    En función de este valor, yterraform mostrará el valor de la variable por pantalla o no (en logs).

#    Hay otro tema CRITICO! (Si alguien quiere certificarse, que lo tenga muy en cuenta)
#    Validaciones!
#    Una variable no tiene por qué admitir cualquier valor del tipo de dato que le hayamos definido.
#    Por ejemplo: Nombre del contenedor: "$%&·#99" NO ES VALIDO... aunque es un string
#       Cuando un usuario establezca un valor, tendré que asegurarme que ese valor es válido.
#    Para eso existen las VALIDACIONES de las variables.
#    validation {
#      condition = EXPRESION_BOLEANA  
#                Aquí va una expresión booleana
#                Si al evaluarse esa expresión booleana el resultado es true
#                el valor es válido
#                Si el resultado es false, el valor NO ES VÁLIDO
#      error_message = "Mensaje de error que se mostrará si la condición da false"
#      En automático, si una variable no pasa la validación, terraform no continuará
#      con la ejecución del script.
#      La validación de los valores de las variables es lo primero que hace terraform
#      al ejecutar un script.
#    }
# }

# Para referenciar este PARAMETRO en el código del script, usaremos:
# var.NOMBRE_DE_LA_VARIABLE
variable "nombre_del_contenedor" {
    description = "Nombre del contenedor Docker a crear"
    type        = string
    nullable    = false    # Es una ampliación al tipo de dato string
                           # Permite que la variable tome el valor null o no
    # MUCHO CUIDADO con el nullable. 
    # Nullable no significa OPCIONAL.
    # Significa que la variable, ademas de datos de su tipo, admite el valor null.
    # Pero ese valor hay que establecerlo explícitamente.
    # Terraform NO ARRANCA si una variable NO TIENE VALOR.
}
# Al ejecutar el script:
# terraform plan | apply
# Podremos pasar valor a las variables de distintas formas:
# - Usando la opción -var al ejecutar el comando terraform:
#       $ terraform apply -var="nombre_del_contenedor=mi-nginx"
# - Usando un fichero de variables con extensión .tfvars:
#       # federico.tfvars
#       nombre_del_contenedor = "mi-nginx"
#       $ terraform apply -var-file="federico.tfvars"
# - Usando un fichero de variables con extensión .auto.tfvars:
#       Esos fichero no tengo que pasarlos al ejecutar el comando terraform.
#       Terraform los busca automáticamente y los carga.
#       # menchu.auto.tfvars
#       nombre_del_contenedor = "mi-nginx"
#       $ terraform apply
# - Mediante la propiedad default dentro del bloque de la variable
#      AUNQUE NO LO USAMOS NUNCA JAMAS EN LA VIDA EN NUESTROS SCRIPTS
#       ESTO SIRVE PARA OTRA COSA!
# - Mediante variables de entorno
#       TF_VAR_nombre_del_contenedor="mi-nginx"
#       $ terraform apply
#

# Hay orden de precedencia entre las distintas formas de pasar valores a las variables:
# 1. Opción -var al ejecutar terraform (más prioridad)
# 2. Fichero .tfvars pasado con -var-file al ejecutar terraform
# 3. Variables de entorno
# 4. Fichero .auto.tfvars (se cargan automáticamente)
# 5. default dentro del bloque de la variable (menos prioridad)

# Si paso más de una variable con -var o más de un fichero con -var-file
# La última variable o el último fichero tienen más prioridad
# En el caso que tenga varios ficheros .auto.tfvars
# Se cargan todos, pero si hay variables repetidas
# Se toma por orden alfabético, siendo la última la que más prioridad tiene

variable "cpus" {
    description = "Quota (en base 1) de CPU para el contenedor Docker"
    type        = number
    nullable    = true
}
# Si en docker no limito la CPU, el contenedor puede usar toda la CPU del host
# Imaginemos que si queremos permitir este comportamiento
#  $ terraform apply -var="cpus=2" 
# Hay más formas de conseguir este comportamiento
# OJO. SEPAREMOS EL CONCEPTO DE VARIABLE del concepto de PROPIEDAD DE RECURSO

#variable "cpus" {
#    description = "Quota (en base 1024) de CPU para el contenedor Docker"
#    type        = number
#    nullable    = false
#}

variable "arranque_automatico" {
    description = "Indica si el contenedor Docker debe arrancar automáticamente"
    type        = bool
    nullable    = false
}

# $ terraform apply -var="arranque_automatico=false"

variable "repo_imagen_contenedor" {
    description = "Repositorio de la imagen del contenedor Docker"
    type        = string
    nullable    = false
}

variable "tag_imagen_contenedor" {
    description = "Tag de la imagen del contenedor Docker"
    type        = string
    nullable    = false
}