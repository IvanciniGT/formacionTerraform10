VARIABLES.tf

- Ahi definimos la variable. (solo digo el tipo de datos que admite)

MAIN.tf

- Ahí creamos recursos... y para rellenar algunas propiedades podemos usar datos de las variables definidas en VARIABLES.tf
- CUIDADO.. En este punto, AUN NO HAY DATOS.

Cuando el script se ejecute!
    terraform plan
    terraform apply

    En ese momento se deben suministrar valores a las variables.
    Si no se hace TERRAFORM NO ARRANCA! Me da un error!
    Eh! NO ME HAS PUESTO DATOS A LA VARIABLE X!

    Cómo dan esos datos?
    - Pasandolos con argumento -var al comando terraform
        terraform apply -var="nombre_variable=valor_variable"
    - Con un fichero de variables
        terraform apply -var-file="variables.tfvars"
    - Con variables de entorno 
        TF_VAR_nombre_variable=valor_variable terraform apply
    - Con valores por defecto en VARIABLES.auto.tfvars


# En nuestro ejemplo: 
    map(string)
                                {
                                    VAR1 = "valor1"
                                    VAR2 = "valor2"
                                }

 vvvvvvvvvvvvvvv lo convertimos a:
    set(string)
                                [ "VAR1=valor1" , "VAR2=valor2" ]

lista = []
for clave, valor in mapa:
    item = "clave=valor"
    lista += item

return lista


    [ for clave,valor in var.variables_de_entorno : "${clave}=${valor}" ]
    [ "VAR1=valor1", "VAR2=valor2" ]

---

Hay 3 conceptos independientes:

- Una cosa son los datos! El dato es el dato!
- Otra cosa es una estructura de datos, la forma en que representamos esos datos.
- Otra cosa es el tipo de datos... que sale de la estructura de datos.

Además, tenemos una variable!, que es la que guardará el dato!

DATO: Iván Osuna                                                        Mi nombre y mi primer apellido.
Cómo lo represento? Tengo muchas opciones.. y yo elijo una.
Estructura de datos: Cadena de texto (string): "Iván Osuna"
Lo puedo representar como una texto... pero mucho más complejo: "<nombre>Iván</nombre><apellido>Osuna</apellido>"
Lo puedo representar como un mapa: { nombre = "Iván", apellido = "Osuna" }
Lo puedo representar como un lista: [ "Iván", "Osuna" ]

Una cosa ES EL DATO! y otra cosa es CÓMO LO REPRESENTO!

"Felipe Juan Froilán de todos los Santos y Todos los Santos de Marichalar y Borbón"

Cual es el nombre? y el apellido?


[ "Menchu", "Federico" ]

 { nombre = "Federico", apellido = "Menchu" }

---

DATOS!

80          (1)
8080        (1)
"0.0.0.0"   (1)

4443        (2)
8443        (2)


Cómo represento esos datos?

[80, 8080, "0.0.0.0", 4443, 8443, null]             ESTAN AQUI LOS DATOS REPRESENTADOS ? SI    TIPO DE DATOS: LISTA
[[80, 8080, "0.0.0.0"], [4443, 8443, null]]         ESTAN AQUI LOS DATOS REPRESENTADOS ? SI    TIPO DE DATOS: LISTA DE LISTAS
[
    { 
        puerto_interno  = 80
        puerto_externo  = 8080
        ip              = "0.0.0.0"
    },
    { 
        puerto_interno = 4443
        puerto_externo = 8443
    }
]

    list(object({
        puerto_interno = number
        puerto_externo = number
        ip             = optional(string, "0.0.0.0")
        protocolo      = optional(string, "tcp")
    }))

[]

Uso 3 variables:
puertos_internos    = [80, 4443]               list(number)
puertos_externos    = [8080, 8443]             list(number)
ips                 = ["0.0.0.0", null]        list(string)

ESTAN AQUI LOS DATOS REPRESENTADOS ? SI    TIPO DE DATOS: LISTA DE MAPA/OBJECT


Diferencias entre mapa y object:
- Diferencia 1
    En los mapas, todos los valores son del mismo tipo.
    En los object, cada valor puede ser de un tipo diferente.
- Diferencia 2
    En los mapas, las claves pueden ser lo que a quien lo rellene le dé la gana.
    En los object, las claves están predefinidas, el que lo rellena no elige las claves.... le vienen impuestas.


Los datos quee necesito, REPITO: LOS DATOS vienen impuestos por la funcionalidad que quiero conseguir.
La forma en que los REPRESENTO es cosa mía... Opto por la que sea más cómoda para quién rellena esos datos (EMPATIA POR FAVOR !!!!).
Mi trabajo: PARTIRME EL CULO PARA MONTAR LUEGO LAS EXPRESIONES PERTINENTES QUE CONVIERTAN ESOS DATOS EN LO QUE NECESITA LA PROPIEDAD DEL RECURSO.


---

255.255.255.255
0

^(ALGO[.]){3}ALGO$

ALGO?

0 7 9        (([0-9])|
10-99        ([1-9][0-9])|
100-199      (1[0-9]{2})|
200-249      (2[0-4][0-9])|
250-255      (25[0-5]))


^(((([0-9])|([1-9][0-9])|(1[0-9]{2})|(2[0-4][0-9])|(25[0-5]))[.]){3})(((([0-9])|([1-9][0-9])|(1[0-9]{2})|(2[0-4][0-9])|(25[0-5]))))$

---

# CONTROL DE FLUJO:

Hasta ahora ya hemos aprendido como escribir algunos CONDICIONALES y BUCLES en terraform.

## CONDICIONALES:

- La expresión ternaria:      CONDICION ? VALOR_SI_CIERTO : VALOR_SI_FALSO
    que podemos usarla para:
    - Rellenar propiedades de recursos
    - En las validaciones de las variables

## BUCLES:

- La expresión:          [ for elemento in coleccion : dato_a_devlver if condicion ]
    que podemos usarla para:
    - Rellenar propiedades de recursos
    - En las validaciones de las variables

- La expresión:          { for elemento in coleccion : clave => valor_a_devlver if condicion }
    que podemos usarla para:
    - Rellenar propiedades de recursos
    - En las validaciones de las variables

- Bloques dinamicos. Dentro de un recurso, cuando queremos crear Blocks repetidos dentro de un resource en función de una colección.
    dynamic "nombre_bloque" {
        for_each = listra o un set
        iterator = nombre
        content {
            propiedad1 = nombre.value.atributo1
            propiedad2 = nombre.value.atributo2
        }
    }

- Si queremos crear recursos repetidos (en bucle), hay 2 opciones:
    - count..... Es muy sencillo... solo tengo que pasarle un numero
                 Al usar count, terraform me regala la variable count.index  
    - for_each.. Es un poquito más complejo... pero me da más flexibilidad.
                 Hay casos donde me compensa usar for_each en lugar de count.
                 Al for_each le puedo pasar un mapa o un set/lista de STRINGS (no de otro tipo).
                 Habitualmente lo usamos para mapas...
                 Al usar for_each, terraform me regala la variable each.key y each.value
                 Si le he pasado un mapa, each.key es la clave del mapa y each.value es el valor del mapa.
                 Si le he pasado un set/lista de strings, each.key es el string y each.value es el mismo string.

Esto.... y puede ser que en ocasiones me interese crear objetos conficionalmente? Y ME TEMO QUE SI!

Tengo un despliegue con unos tomcats sirviendo una app web.
En producción, cuantos servidores quiero? Siempre más de uno para tener alta disponibilidad.
Y en desarrollo? Solo quiero uno.
Pero eso tiene otra implicación...
En producción, que necesito delante de los servidores? Un balanceador de carga.
En desarrollo? No necesito balanceador de carga.

Osea, que dependiendo del número de servidores que quiera desplegar, necesitaré o no un balanceador de carga delante. RECURSO CONDICIONAL!
ESTO SE RESUELVE CON EL COUNT!... mezclado con una expresión condicional (TERNARIA).


Me piden 5 máquinas virtuales... Cuantos balanceadores quiero? 1 
                                                nginx
                                                ha-proxy


Estamos montando un script que nos permita hacer el despliegue de una infra.
Para esta infra necesito una serie de servidores (contenedores)
Y quizás un balanceador de carga... 
El balanceador lo pongo solo si hay más de un servidor.
Si solo hay un servidor, no pongo balanceador.

Definimos una variable llamada: num_contenedores (num_servidores), esta variable contendrá un número.
Cuál será el número que contendrá? Yo que se... depende del entorno donde se despliegue.
E incluso dependerá del momento del tiempo...
Quizás el día 1 en producción arrancan con 2 servidores
Y cuando pase 1 año, necesitan 17.

Quiero montar un programa que me haga el despliegue de esa infra.
Y el programa debe de funcionar tanto si piden 1, como si piden 5 como si piden 17 servidores.