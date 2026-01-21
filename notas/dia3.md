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