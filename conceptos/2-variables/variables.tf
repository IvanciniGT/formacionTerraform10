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
    validation {
        error_message = "El nombre del contenedor solo puede contener letras, números, guiones y guiones bajos"
        condition     =  length(regexall("^[A-Za-z0-9_-]+$", var.nombre_del_contenedor)) == 1
        # En este caso, estamos usando en la expresion un operador comparativo: ==
        # Eso da como resultado true o false
        # Si devuelve true la variable es válida.. La validación se considera satisfecha
        # Si devuelve false la variable no es válida.. La validación falla
    }
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

    validation {
        #condition     = var.cpus > 0
        # Me temo que no es suficiente
        # Si la variable vale -1, cuando devuelve esa expresión: false. Es adecuado? SI
        # Si la variable vale 4, cuando devuelve esa expresión: true.   Es adecuado? SI
        # Pero... qué pasa si la variable vale null?
        # Y null > 0 que devuelve? ERROR!!!! El operador > no se se puede aplicar sobre null
        #condition     = var.cpus == null ? true : (var.cpus > 0 && var.cpus <= 6)
        condition     = var.cpus == null ? true : var.cpus > 0
        # Hay que tener cuidad con el && y el || en estas expresiones
        # En muchos lenguajes de programación el && es el operador AND en cortocircuito
        # Eso significa que si la primera condición no se cumple, la segunda NO SE PROCESA
        # Si el operador no es en cortocircuito, ambas condiciones se procesan SIEMPRE
        # condition    = var.cpus == null || var.cpus > 0
        # Eso si var.cpus es null, la primera condición da true, pero como en terraform
        # el operador || no es en cortocircuito, se evalúa la segunda condición
        # Y devolvería ERROR !!!!!
        # Si la variable es null, cuanto devuelve esa expresión? true... Me vale.. admito el valor nulo
        # Si no es nulo? Es cuando comprueba si es mayor que 0 o no. Está bien!
        error_message = "El número de CPUs debe ser superior a 0"
    }
    validation {
        condition     = var.cpus == null ? true : var.cpus <= 6
        error_message = "El número de CPUs debe ser inferior o igual a 6"
    }
    # Las validaciones se aplican en orden... y todas deben dar true para que la variable sea válida
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
    # Aquí pondríamos una validación con REGEX similar a la del nombre del contenedor
}

variable "tag_imagen_contenedor" {
    description = "Tag de la imagen del contenedor Docker"
    type        = string
    nullable    = false
    # Aquí pondríamos una validación con REGEX similar a la del nombre del contenedor
}

variable "variables_de_entorno" {
    description = "Variables de entorno para el contenedor Docker"
    #type        = set(string)
    nullable    = true
    # Esto es un desmadre == GUARRADA !
    # No estamos dejando claro cómo hay que rellenar esta variable.
    # En este caso el proveedor solo admite que los string tengan clave, valor separados por =
    # Pero eso no lo estamos explicitando por ningún sitio.
    # 2 opciones para resolver este entuerto:
    # Opción 1: Validar los strings con REGEX para que cumplan el formato clave=valor
    #           Y si alguien escribe algo de forma diferente, EXPLOTAR y sacar mensaje
    #           Esto es una opción VALIDA, pero CUTRE! Es reactivo
    #           Primero date la ostia... y luego ya te lo cuento!
    # Opción 2: Cambiar el tipo de dato a algo que no genere ambigüedad
    # Opción 2.1: Usar un map(string). un map es un conjunto de pares clave:valor
    # Es lo que en otros lenguajes de programación llamamos un diccionario o un hashmap, un array asociativo, etc
    type        = map(string) # este string se refiere al VALOR!
                              # Los map en terraform, su clave siempre es un string
    #Al definir la variable de esta forma, el valor debe sumistrarse:
    # variables_de_entorno = {
    #     VAR1 = "valor1"
    #     VAR2 = "valor2"
    # }
    # Opción 2.2: Usar un object.
    # Esto es lo más completo en tipos de datos que ofrece terraform
    # type = set(object({
    #     nombre: string,
    #     valor: string
    # }))
    # Si lo definimos así, el valor debe suministrarse:
    # variables_de_entorno = [
    #     {
    #       nombre = "VAR1",
    #       valor  = "valor1"
    #      },
    #     {
    #       nombre = "VAR2",
    #       valor  = "valor2"
    #     }
    # ]
    # En un proyecto real, yo dejaría set(object) para evitar ambigüedades
    # En el curso, vamos a usar map(string)
    # Para tener variedad de ejemplos, ya que la siguiente variable (ports) si la dejamos como set(object)
}

variable "puertos" {
    description = "Puertos a mapear en el contenedor Docker"
    type        = list(object({
        puerto_interno = number
        puerto_externo = number
        ip             = optional(string, "0.0.0.0")
        protocolo      = optional(string, "tcp")
    }))
    nullable    = false

    # Validaciones
    # Puerto_interno.. debe estar entre 1 y 65535
    validation {
        condition     = (
                            length(var.puertos) == 0 || 
                            alltrue([ for puerto in var.puertos : puerto.puerto_interno > 0 ])
                        )
        error_message = "El puerto interno debe ser mayor que 0"
    }
    # Puerto_interno.. debe ser menor o igual que 65535
    validation {
        condition     = (
                            length(var.puertos) == 0 || 
                            alltrue([ for puerto in var.puertos : puerto.puerto_interno <= 65535 ])
                        )
        error_message = "El puerto interno debe ser menor o igual que 65535"
    }
    # Puerto externo.. debe estar entre 1 y 65535
    validation {
        condition     = (
                            length(var.puertos) == 0 || 
                            alltrue([ for puerto in var.puertos : puerto.puerto_externo > 0 ])
                        )
        error_message = "El puerto externo debe ser mayor que 0"
    }
    # Puerto externo.. debe ser menor o igual que 65535
    validation {
        condition     = (
                            length(var.puertos) == 0 || 
                            alltrue([ for puerto in var.puertos : puerto.puerto_externo <= 65535 ])
                        )
        error_message = "El puerto externo debe ser menor o igual que 65535"    
    }
    # Protocolo... solo admitimos tcp y udp
    validation {
        condition     = (
                            length(var.puertos) == 0 || 
                            alltrue([ for puerto in var.puertos : 
                                contains(["tcp", "udp"], lower(puerto.protocolo))
                            ])
                        )
        error_message = "El protocolo debe ser tcp o udp"   
    }
}