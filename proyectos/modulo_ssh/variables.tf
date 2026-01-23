# Directorio
variable "directorio_claves" {
  description = "Directorio donde se almacenarán las claves SSH"
  type        = string
  nullable    = false

  validation {
    condition     = length( 
                        regexall("^([.]{0,2})([\\/\\\\][.]?[a-zA-Z0-9_-]+)+([\\/\\\\]?)$", var.directorio_claves) 
                        # TODO Mejorar la expresión regular para caso windows (letras de unidad C:\ etc)
                    ) == 1
    error_message = "El directorio de claves no es válido"
  }

  default    = "./claves"

}

# Regeneración
variable "forzar_regeneracion_de_claves" {
  description = "Indica si se deben regenerar las claves SSH aunque ya existan"
  type        = bool
  nullable    = false
  default     = false
}

# Algoritmo
variable "algoritmo_claves" {
    description = "Algoritmo y configuración para la generación de claves SSH"
    type        = object({
                        nombre        = string
                        configuracion = optional(string) # Cuando ponemos un dato como opcional
                        # Hay 2 opciones. Opción 1: Dar un valor por defecto en la variable
                        #                 Opción 2: No poner valor por defecto, y en automático se pone null
                    })
    nullable    = false
    default     = {
                    nombre        = "RSA"
                    configuracion = 2048
                  }

    validation  {
        error_message = "El algoritmo de clave no es válido. Valores permitidos: RSA, ECDSA, ED25519"
        condition     = contains( ["RSA", "ECDSA", "ED25519"], upper(var.algoritmo_claves.nombre) )
    }

    validation { # Esta regla aplica solo si el algoritmo es ED25519
        error_message = "El algoritmo ED25519 no admite configuración"
        condition     =  (                                   # ! =
                            upper(var.algoritmo_claves.nombre) != "ED25519" || # Si el algoritmo no es ED25519, 
                                                                               # la condición debe ser true (pasa la validación),
                                                                               # ya que no le aplica esta validación
                            var.algoritmo_claves.configuracion == null         # Si el algoritmo es ED25519
                                                                               # Entonces la configuración debe ser null (no definida)
                         )
    }

    validation { # Esta regla aplica solo si el algoritmo es ECDSA
        error_message = "El algoritmo ECDSA admite las configuraciones: P224, P256, P384, P521"
        condition     =  (                                   # ! =
                            upper(var.algoritmo_claves.nombre) != "ECDSA" || # Si el algoritmo no es ECDSA, 
                                                                             # la condición debe ser true (pasa la validación),
                                                                             # ya que no le aplica esta validación
                            var.algoritmo_claves.configuracion == null ? true : # Si el algoritmo es ECDSA
                                                                                # y la configuración no está definida (null) se
                                                                                # tomará luego el valor por defecto. Lo damos por bueno
                            contains( ["P224", "P256", "P384", "P521"], upper(var.algoritmo_claves.configuracion) ) # Si si me dan configuración
                                                                                                                    # Debe ser una de las permitidas
                         )
    }

    # Número, entero y en un rango concreto .. Si queremos complicarlo más.. que sea múltiplo de numero % 8 == 0
    # Funciones útiles: can()  tonumber()


    validation { # Esta regla aplica solo si el algoritmo es RSA
        error_message = "El algoritmo RSA admite configuraciones numéricas entre 1024 y 16384, que sean múltiplos de 8"
        condition     =  (                                   # ! =
                            upper(var.algoritmo_claves.nombre) != "RSA"   || # Si el algoritmo no es RSA, 
                                                                             # la condición debe ser true (pasa la validación),
                                                                             # ya que no le aplica esta validación
                            var.algoritmo_claves.configuracion == null ? true : # Si el algoritmo es RSA
                                                                                # y la configuración no está definida (null) se
                                                                                # tomará luego el valor por defecto. Lo damos por bueno
                            (
                                !can( tonumber( var.algoritmo_claves.configuracion ) ) ? false :  # Que sea numérico
                                # can devuelve true si la operacion que hay dentro se ejecuta sin errores.
                                (
                                    # Que sea mayor o igual a 1024
                                    tonumber(var.algoritmo_claves.configuracion) >= 1024 &&
                                    # Que sea menor o igual a 16384
                                    tonumber(var.algoritmo_claves.configuracion) <= 16384 &&
                                    # Que sea múltiplo de 8
                                    tonumber(var.algoritmo_claves.configuracion) % 8 == 0
                                )
                            )
                         )
    }
}
