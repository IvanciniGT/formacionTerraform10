# Dependencias entre recursos

Estamos creando un servidor dentro de un cloud: Azure
Y en AZURE existe un concepto que no existe por ejemplo en AWS que es el de GRUPO DE RECURSOS.

Como parte del despliegue tendría quizás que crear el GRUPO DE RECURSOS y luego dentro de ese grupo de recursos crear el servidor.

Quizás el nombre del grupo de recursos lo quiero parametrizar y sacarlo de lo que en terraform llamamos una VARIABLE.

```tf
variable "nombre_grupo" {
  description = "Nombre del grupo de recursos"
  type        = string
  default     = "mi-grupo-recursos"
}

resource "azurerm_resource_group" "mi_grupo" {
  name     = var.nombre_grupo
  location = var.ubicacion
}

resource "azurerm_virtual_machine" "mi_servidor" {
  name                  = "mi-servidor"
  location              = azurerm_resource_group.mi_grupo.location
  #resource_group_name   = var.nombre_grupo   # Si lo hago así no hay dependencia explícita entre el grupo de recursos y la máquina virtual. Y terraform las creearía en paralelo. Tanto servidor como grupo dependen de: la variable 
  # Y una vez creada la variable, ambos recursos se crearían en paralelo.
  # Y como se intente crear la máquina virtual ANTES de crear el grupo de recursos, fallaría.
  # Podría resolver esto con un depends_on, pero no es la mejor práctica.
  # La mejor práctica es referenciar el recurso directamente.
  resource_group_name   = azurerm_resource_group.mi_grupo.name  # Con esto si creo la dependencia explícita entre ambos recursos.
  network_interface_ids = [azurerm_network_interface.mi_nic.id]
  vm_size               = "Standard_DS1_v2"
  
  # Resto de la configuración de la máquina virtual
}
```

# Expresiones en Terraform

Al rellenar valores de propiedades de recursos, a veces necesitamos hacer cálculos o manipulaciones de datos.
Esto también nos va a pasar al hacer validaciones de las variables o al definir salidas (outputs).

Una expresión es un trozo de código que produce un valor.
Ese valor podrá ser de un tipo u otro dependiendo de la expresión.

## Ejemplos de expresiones sencillas:

var.nombre_variable  # Referencia a una variable
resource.tipo_recurso.nombre_recurso.propiedad  # Referencia a una propiedad de un recurso

### Expresiones un poco más complejas:

#### Cálculos matemáticos

var.cpus * 1024  # Multiplicación . Otros operadores: + - / %

#### Interpolación de cadenas de textoç

"${var.prefijo_nombre}-${var.sufijo_nombre}"

#### Funciones.

Terraform incluye una enorme librería de funciones que nos permiten hacer todo tipo de manipulaciones de datos.
En el curso vamos a ver bastantes de ellas... Pero hay más de 100.
Queda de vuestra parte el echarle un ojo al listado completo en la documentación oficial. En la certificación os pueden preguntar por funciones que no hemos visto en el curso.

abs(var.numero_negativo)  # Devuelve el valor absoluto de un número 

ceil(var.numero_decimal)  # Redondea hacia arriba un número decimal

split(",", var.cadena_coma)  # Divide una cadena de texto en una lista, usando el separador que le pasamos como primer parámetro.

### Otroas cosas que podemos meter en esas expresiones:

#### Condicionales (if else)

condicion ? valor_si_verdadero : valor_si_falso

#### Bucles (for)

Los bucles en expresiones :

[for elemento in var.lista : elemento * 2 if elemento > 10]

[for mi_variable_de_iteracion in lista : valor_a_devolver if condicion_para_procesar_ese_elemento]

Los bucles siempre me devuelven una lista.

#### Operadores booleans

condicion1 && condicion2  # Y lógico
condicion1 || condicion2  # O lógico
!condicion               # Negación lógica
---

# Patrones de expresiones regulares.

Los usamos muchísimo, especialmente en terraform... Pero en muchos otros sitios.

Básicamente me permiten hacer operaciones avanzadas sobre textos.
Esto sale en un lenguaje de programación llamado PERL.
En ese lenguaje definieron un sublenguaje para definir patrones de búsqueda dentro de textos.

Ese sublenguaje se ha ido extendiendo a muchos otros lenguajes de programación y herramientas.

En que consiste:

Lo que vamos a definir es un patrón!
Posteriormente usamos ese patrón para realizar operaciones avanzadas dentro de textos:
- Buscar si un texto cumple con ese patrón
- Reemplaza cada ocurrencia que cumple con ese patrón por otro texto
- Extraer las partes del texto que cumplen con ese patrón

Por ejemplo:
TEXTO: En un lugar de la Mancha de cuyo nombre no quiero acordarme...
PATRÓN: Secuencia de caractares que empieza por una letra mayúscula y después acaba por un espacio.

OPERACION: 
- Cumple el texto con ese patrón? Si.. dentro del texto encontramos trozos que cumplen con ese patrón:
    - En 
    - Mancha
- Reemplaza cada ocurrencia que cumple con ese patrón por el texto XXXXX
    - TEXTO RESULTADO: XXXXX un lugar de la XXXXX de cuyo nombre no quiero acordarme...

# Cuál es la sintasis que define perl para esos patrones:

Un patrón es un conjunto de subpatrones.
Un subpatrón es una secuencia de caracteres seguido de un modificador de cantidad.

- Secuencia de caracteres:
    HOLA                    -> Buscar literalmente la secuencia de caracteres HOLA dentro del texto
    [HOLA]                  -> Buscar cualquiera de los caracteres H, O, L, A
    [A-Z]                   -> Buscar cualquier letra entre la A y la Z mayúscula en ASCII
    [a-z]                   -> Buscar cualquier letra entre la a y la z minúscula
    [0-9]                   -> Buscar cualquier dígito entre el 0 y el 9
    [A-Za-z0-9]             -> Buscar cualquier letra mayúscula, minúscula o dígito
    [A-ZÁÉÍÓÚÑ]             -> Buscar cualquier letra mayúscula incluyendo vocales con tilde y la Ñ
    .                       -> Cualquier carácter (excepto salto de línea)
- Modificadores de cantidad:
    No poner nada:           La secuencia a la que aplica ese modificador debe aparecer exactamente 1 vez.
    ?                        La secuencia a la que aplica ese modificador puede aparecer o no... De aparecer podría aparecer 1 vez.
    *                        La secuencia a la que aplica ese modificador puede aparecer 0 o más veces.
    +                        La secuencia a la que aplica ese modificador puede aparecer 1 o más veces.
    {n}                      La secuencia a la que aplica ese modificador debe aparecer exactamente n veces.
    {n,}                     La secuencia a la que aplica ese modificador debe aparecer al menos n veces.
    {n,m}                    La secuencia a la que aplica ese modificador debe aparecer al menos n veces y como máximo m veces.

- Otros caracteres especiales:
   ^                 -> Indica el inicio del texto
   $                 -> Indica el final del texto
   |                 -> Operador lógico O entre dos subpatrones. 
   ()                -> Agrupa varios subpatrones en uno solo.


Hola, Mi fecha de nacimiento es 25/12/1980 y mi teléfono es 600123456 y mi email es federico@menchu.com.

> Quiero un patrón para extraer el email.
 [a-z]+@[a-z]+[.][a-z]+ ---> federico@menchu.com

> Quiero sacar el teléfono:
 [0-9]{9}  ---> 600123456
 
> Quiero sacar la fecha de nacimiento:
 [0-9]{2}/[0-9]{2}/[0-9]{4}  ---> 25/12/1980

> quiero el nombre de un contenedor... Donde solo tengamos letras mayúsculas, minúsculas, dígitos, guiones y guiones bajos.

[a-zA-Z0-9_-]+

Nombre_de_contenedor-01
Y este nombre: Nombre*de*contenedor#01  no es válido porque tiene caracteres que no están permitidos.
  Pues me temo que si se cumple! UPS!!!!
   De hecho hay 4 ocurrencias del patrón en ese texto:
    - Nombre
    - de
    - contenedor
    - 01
Y para resolver este problema: ^$
^[a-zA-Z0-9_-]+$

Este patrón significa:
- Debe empezar el texto (^) y a continuación debe haber una secuencia de uno o más caracteres permitidos ([a-zA-Z0-9_-]+) y a continuación debe terminar el texto ($).