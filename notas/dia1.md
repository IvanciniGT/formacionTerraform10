
# Qué es Terraform?

Herramienta de software que produce una empresa llamada HashiCorp. Nos ofrece 2 cosas:
- Lenguaje DECLARATIVO (HCL - HashiCorp Configuration Language) con el que podemos definir scripts.
- Un interprete que lee esos scripts y los ejecuta de acuerdo a la instrucción que le solicitemos.

Uso:
- Gestionar infraestructura en clouds de forma automatizada.
- Se puede usar para otros cientos de miles de cosas.... En general es una herramienta para hacer SCRIPTS = AUTOMATIZACIONES DE TAREAS.

Cuando hablamos de terraform en seguida nos aparece el concepto de IaC (Infrastructure as Code).

---

## Lenguaje declarativo

Lo que vamos a estar es escribiendo código! Vamos a estar creando scripts. Un script no es sino un tipo de programa que se ejecuta para automatizar tareas.

Dicho de otra forma: Vamos a estar programando!

Al escribir código (un programa... en nuestro caso scripts) podemos usar diferentes paradigmas de programación.

### Paradigma de programación

Unb paradigma de programación es un nombre "un tanto hortera" que los desarrolladores damos a las distintas formas de usar un lenguaje para expresar los conceptos que queramos. No es algo propio de los lenguajes de programación, los humanos, en los lenguajes naturales que usamos, también usamos diferentes paradigmas para expresar ideas.

> Felipe, pon una silla debajo de la ventana! IMPERATIVO = ORDEN (tiempo verbal imperativo)

Estamos muy acostumbrados al paradigma imperativo. En este paradigma le decimos a la máquina paso a paso lo que tiene que hacer. Cuando escribimos un script con bash, python, ps1, etc estamos usando el paradigma imperativo.

Es una mierda el paradigma imperativo, y cada día nos gusta menos... aunque insisto, estamos muy acostumbrados a él.

> Felipe, SI (IF) hay algo que no sea una silla debajo de la ventana (CONDICIONAL):
     THEN: Quitalo!        IMPERATIVO
> Felipe, IF (SI) no hay una silla debajo de la ventana (CONDICIONAL):
    > IF not silla (silla == FALSE): GOTO IKEA y compra silla ! 
    > Felipe, pon una silla debajo de la ventana!  IMPERATIVO

## Paradigma declarativo

> Felipe, debajo de la ventana tiene que haber una silla. Es tu responsabilidad.   AFIRMATIVA

Esto es paradigma declarativo.
No le digo a Felipe lo que debe hacer, le digo lo que quiero conseguir. Le digo el ESTADO FINAL que deseo para mi sistema.
La responsabilidad de conseguir ese estado final es de Felipe. Acabo de delegar en Felipe la responsabilidad de conseguir ese estado final.

Hoy ene día ADORAMOS el paradigma declarativo. Y de hecho todas las herramientas que triunfan a día de hoy en el mundo IT lo hacen precisamiente porque usan el paradigma declarativo:
- Terraform
- Ansible (más o menos)
- Kubernetes
- Angular
- Spring
- ....

### Idempotencia

Propiedad por la cual al aplicar un proceso varias veces, el resultado es el mismo que si se aplicara una sola vez.

Si con independencia del estado inicial en el que se encuentre el sistema, al aplicar el proceso conseguimos el mismo estado final, entonces ese proceso es idempotente.

El paradigma declarativo, por definición, nos permite definir procesos idempotentes.

> Ansible es idempotente (ofrece idempotencia?)

Ansible NO OFRECE idempotencia. Ansible ofrece un lenguaje NO DECLARATIVO. Los módulos de Ansible (algunos, la mayor parte) son idempotentes y me ofrecen lenguajes declarativos, PERO los scripts que creo con Ansible NO SON idempotentes por definición... de hecho los escribimnos en lenguaje imperativo.

# IaC (Infrastructure as Code)

IaC no es solo definir la infraestructura mediante código.... en el caso de teerraform con código declarativo.
Va un poco más allá. Es tratar la infra como si fuera código de software.

Un programa no es solo escribirlo en un lenguaje de programación. Un programa lleva asociado un ciclo de vida... y de ese programa lo primero que hago es controlar sus versiones.

Vamos a tener versiones de la infraestructura... que en muchos casos van en paralelo con las versiones del software que corre sobre esa infraestructura.

Sistema informático software v1.0.0 -> Infra v1.0.0
Sistema informático software v2.0.0 -> Infra v2.0.0

## Versionado de software

Habitualmente, al nombrar una versión de software utilizamos un esquema llamado SEMVER (Semantic Versioning).

    vA.B.C

                    Cuando cambian?
    A = Major       Cuando se produce un breaking change =
                        Cambios incompatibles con versiones anteriores
    B = Minor       Cuando añadimos funcionalidad
                    O cuando marcamos una funcionalidad como obsoleta (deprecated)
                        Adicionalmente pueden venir bugs arreglados
    C = Patch       Aumenta cuando se arreglan bugs

Este esquema, que es el que tradicionalmente se usa en software, también se puede usar para versionar infraestructuras.

No es obligatorio, pero se hace mucho.

Sistema informático software v1.0.0 -> Infra v1.0.0
Sistema informático software v1.0.1 -> Infra v1.0.0
Sistema informático software v1.1.0 -> Infra v1.0.0
Sistema informático software v1.2.0 -> Infra v2.0.0
Sistema informático software v1.2.0 -> Infra v2.0.1

La infra ahora pasa a ser un código.. y lo trato como tal. Con versiones, con control de versiones (git).

### Script IaC

En un script de IaC, al usar un lenguaje declarativo, lo que hacemos es definir el ESTADO FINAL que queremos para nuestra infraestructura = Declaro la infraestructura que quiero.

La pinta que tiene un script IaC es:

    - Sease un servidor con estas características (CPU, RAM, Disco, IP, etc)
    - Sease una red con estas características (subredes, rangos IP, etc)
    - Sease una base de datos con estas características (motor, versión, tamaño, etc)
    - Sease un balanceador de carga con estas características (tipo, IP, reglas, etc)

Estamos diciendo ahi algo al respecto de lo que hay que hacer con esa infra?
NO decimos nada en este sentido. Solo declaramos una infra... y es curioso... porque a lo mejor lo que quiero es DESTRUIR esa infra.

Una cosa es la infra, el cómo es... y otra cosa es lo que quiero hacer con ella = CREARLA, ACTUALIZARLA, DESTRUIRLA.

Por cierto...:
- Crea
- Actualiza
- Destruye

Qué tipo de lenguajes es ese? IMPERATIVO

Los scripts de terraform son declarativos, pero sobre ellos hacemos (ejecutamos) operaciones imperativas.

Hemos dicho que terraform ofrece 2 cosas:
- Lenguaje declarativo (HCL)
- Intérprete:
  Ejecuta operaciones imperativas sobre los scripts declarativos.
   $ terraform VERBOS_IMPERATIVOS + script_declarativo

   VERBOS_IMPERATIVOS:
    - init
    - plan
    - apply
    - destroy
    - test
    - validate
    - fmt
    - import
    - taint

### Hablando de scripts... en terraform

En terraform un script NO ES UN FICHERO. Un script de terraform es una carpeta que contiene uno o varios ficheros con extensión .tf. Lo habitual es que esa carpeta acabe siendo un repositorio git... sometida a control de versiones.

El nombre de esos archivos es a vuestra elección. Hay cierta convención... pero lo dicho es convención no obligación.
Aunque todo el mundo lo hace y es bueno hacerlo:
- main.tf
- variables.tf
- outputs.tf
- providers.tf
- versions.tf

Cuando terraform ejecuta cualquier comando sobre un script, lo que hace es leer TODOS los ficheros .tf que encuentre en esa carpeta, los consolida en un archivo (en memoria) y trabaja sobre ese archivo consolidado.

### Continuación sobre scripts de terraform

Dentro de los scripts lo principal que vamos a definir son RECURSOS (resources).
Qué puede ser un resource?
- Máquina virtual
- Red
- Clave ssh
- Base de datos
- Usuario
- Entrada en un DNS
- ...

En los scripts lo que declaramos son esos recursos... con sus características (atributos).

Quién gestiona (crea, borra, actualiza) esos recursos? Providers.
Cada provider me ofrece una serie de recursos con los que puedo trabajar.

Qué datos describen cada recursos?
- Por ejemplo... una máquina virtual? CPU, RAM, DISCO
                                      Hay clouds que tienen las máquinas agrupadar por tipos... 
                                      - Y al elegir un tipo t3.xlarge = CPU = 4, RAM=16GB

Y aquí nos encontramos con un problema GORDO !
Cuando montamos un script, los recursos que podemos incluir en ese script dependen de los providers que usemos.
Y son esos providers los que definen QUÉ ATRIBUTOS TIENE CADA RECURSO.

La forma de definir una máquina virtual en AWS es diferente a la forma de definir una máquina virtual en GCP o en AZURE. Es decir -> Un script que monte para definir una infra en AWS NO SIRVE para montar esa misma infra en GCP o AZURE. Si el día de mañana quiero cambiar de cloud, tendré que reescribir TODOS los scripts de terraform que tengo.

El objetivo del curso NO ES APRENDER A USAR TERRAFORM PARA MONTAR INFRA EN UN CLOUD DETERMINADO (AWS, GCP, AZURE, etc). Es más... El provider de AWS me permite crear más de 500 recursos diferentes... totalmente diferentes a los que puedo crear en GCP o AZURE.... que son otros cuantos cientos de ellos. Ni dedicando un mes a cada cloud me daría tiempo a aprender a usar terraform para montar infra en todos ellos.

El objetivo no es aprender ningun provider concreto... sino aprender a usar terraform para que seáis capaces de aprender a usar cualquier provider. Eso si... esto luego implicará trabajo de vuestra parte... porque tendréis que aprender a usar el provider concreto que os interese.

Dentro de un fichero .tf vamos a definir:
- Terraform <- Declarar los providers que vamos a usar          LUNES
- Providers  <- Configurar los providers que vamos a usar       LUNES
- Resources  <- Definir los recursos que queremos crear/gestionar                MARTES
- Variables  <- No permite definir variables. Nos permite definir ARGUMENTOS.    MARTES
                                                                                 MIERCOLES 
- Locals     <- Nos permite definir VARIABLES al script.                         MIERCOLES
- Outputs    <- Definir salidas del script.                                      JUEVES

- Data       <- Hablar con el provider para obtener información sobre recursos ya existentes en el provider (cloud)
                VIERNES 
- Modules    <- Ya os lo contaré                                                 JUEVES

Pensar que estamos creando un programa... y como tal a ese programa, cuando quiera ejecuatrlo le podré pasar ARGUMENTOS (variables) y el programa me podrá devolver RESULTADOS (outputs).

Habitualmente en el mundo de la programación reservamos la palabra variable para definir nombres con los que poder referirme a datos que voy creando u obteniendo a lo largo de la ejecución del programa.
Eso se puede hacer en terraform mediante LOCALS.

Hemos dicho que un script de terraform es una carpeta con ficheros .tf.
Y esos archivos se deben llamar como queramos... aunque hay cierta convención.
También hemos dicho que al ejecutar un script qué hace terraform? Juntar todos esos ficheros en uno solo (en memoria) y trabajar sobre ese archivo consolidado.
En qué orden junta los contenidos de esos ficheros? NO IMPORTA! (es alfabético... pero no importa)
Lo cuál nos lleva a un tema importante... y un problema potencial.

Quiero crear una máquina virtual pinchada en una subred... que también debo crear.
Cuál debe crearse primero? La subred. Si no hay red, puedo crear una máquina pinchada en esa red? NO

Y cómo determina terraform el orden de creación de los recursos?
Es complejo. Terraform NO LO SABE... Ni los providers lo saben tampoco! 
Debo explicitarlo YO! Terraform no se va a equivocar NUNCA en el orden... ya que el orden lo impongo YO... Si alguien se equivoca soy YO, no terraform. 
El problema de todo esto es que NO ASIGNO o establezco el orden de creación de los recursos mediante un mecanismo explícito (diciendo: este es el primero, este es el segundo...)... sino implícito, mediante relaciones entre recursos, que debo explicitar!

    recurso red MI_RED {
        name = "Nombre_de_mi_red_en_mi_cloud"
        cidr = "198.168.0.0/16"
        ...
    }

    recurso maquina_virtual MI_MAQUINA {
        name = "Nombre_de_mi_maquina_en_mi_cloud"
        cpu  = 4
        ram  = 16
        red  = "Nombre_de_mi_red_en_mi_cloud"
        ...
    }

Pregunta... es ese escenario. Qué recurso crearía primero terraform? Se crean en paralelo.
Terraform crea en tiempo de ejecución un grafo de dependencias entre recursos.
Para ello, mira qué recursos hacen referencia a otros recursos.... mediante el nombre del recurso... EL NOMBRE EN EL SCRIPT DE TERRAFORM, NO EL NOMBRE EN EL CLOUD... en nuestro caso: MI_RED y MI_MAQUINA.

Como en ese ejemplo, los recursos no usan información de otros recursos (no usan referencias), terraform considera que son independientes y los crea en paralelo.

Diferente sería:


    recurso red MI_RED {
        name = "nombre_de_mi_red_en_mi_cloud"
        cidr = "198.168.0.0/16"
        ...
    }

    recurso maquina_virtual MI_MAQUINA {
        name = "Nombre_de_mi_maquina_en_mi_cloud"
        cpu  = 4
        ram  = 16
        red  = MI_RED.name  # Aquí estoy usando una referencia a otro recurso
        ...
    }

En este caso, Terraform si es capaz de entender que MI_MAQUINA depende de MI_RED... y por tanto crea primero MI_RED y después MI_MAQUINA... eso en el caso que lo que esté sea creando los 2 recursos....
Y si los estoy borrando? Primero se borraría MI_MAQUINA y después MI_RED.... ya que no puedo borrar la red si hay una máquina pinchada en esa red.

Esa es la forma de establecer el orden de creación/borrado de recursos en terraform: Mediante referencias entre recursos.

Ese grafo de dependencias podremosa verlo gráficamente mediante el comando:

    terraform graph | dot -Tpng > graph.png

    Los grafos que vamos a generar no son de secuencia de ejecución... sino de dependencias entre recursos.

    Grafo de secuencia: MI_RED -> MI_MAQUINA
    Grafo de dependencias: MI_MAQUINA -> MI_RED

    El grafo de dependencias que genera terraform no es una imagen. Está ESCRITO en lenguaje DOT... que es un lenguaje para definir grafos. Necesitaremos de un programa que generer una imagen desde ese lenguaje DOT: GRAPHVIZ (dot).

En ocasiones es importante crear un recurso antes que otro, aunque no haya una dependencia directa entre ellos.
Para esos casos terraform nos ofrece el atributo "depends_on", que nos permite establecer dependencias explícitas entre recursos.

Terraform NO INVENTA NADA.. en cuanto al orden de creación de recursos.
Analiza las dependencias entre recursos (referencias y depends_on) y crea un grafo de dependencias.
Y soy yo el responsable de que ese grafo sea correcto ( de haber establecido correctamente las dependencias entre recursos)

---

# NOTA IMPORTANTISISISISMA

Lo más importante al crear cualquier programa (del tipo que sea) ... y es algo que saben bien los desarrolladores NO ES que el programa funcione. ESO SE DA POR DESCONTADO!
Lo más importante es que el programa sea MANTENIBLE.


> Voy a comprar un coche.
  Por definición, un coche es un producto sujeto a mantenimientos.
  Al año voy al taller a la primera revisión (cambio de aceite)
  Me dan cita para el jueves a las 10:00. Voy y pregunto: PRECIO?  A que hora vuelvo?
  Y me dice el del taller... uy!!! eso es muy complicado. Tengo que desmontar el motoro entero para cambiar el aceite. Lleva mucho tiempo... es que no hay otra forma de acceder al deposito de aceite.
  Y luego montarlo de nuevo... Y probar el coche entero para asegurarme que funciona bien.
  Venga dentro de un mes... y le sale por 5.000€.
  Cómo os sentiríais? Estafado!

Un producto de forware por definición es un producto sujeto a cambios y mantenimientos.
Sabiendo esto, tengo que crear el programa de forma que sea fácilmente mantenible y evolucionable en el futuro.
Si no lo hago... cuando en el futuro me pida un cliente (equipo de desarrollo) que hay que subir la ram de una máquina virtual de 8 a 16GB... y le digo que tardo un mes... y que son 5.000€ ... Cómo se sentirá el cliente? Estafado!

---

## A la hora de usar el cli de terraform

Tenemos varias fases que habitualmente seguimos:
- Init -> Plan -> Apply -> Plan -> Apply -> ... -> Destroy

## El cliente de terraform

El cliente de terraform es un programa bastante simple... no sabe hacer mucho.
Todas las operaciones que se ejecutan cuando lanzamos/solicitamos un comando sobre nuestro script son realizadas por los proveedores (providers).

## Provider

Un provider es una librería (plugin) que podemos descargar e instalar en el entorno desde donde queramos ejecutar un script de terraform, que se encarga de realizar operaciones.

    terraform (cli) <---> provider (aws, gcp, az) ---> cliente de un cloud ---> cloud (aws, gcp, az)
        Se alimenta de un script (carpeta con ficheros .tf)
        Y un comando (init, plan, apply, destroy, etc)

Esos plugins se descargan e instalan en nuestro equipo cuando ejecutamos el comando "terraform init".
Al ejecutar ese comando, terraform lee eel script (la carpeta y todos los archivos .tf que contiene) y detecta los providers que necesita descargar e instalar.... y los descarga e instala.
Esos proveedores se descagan desde el registry de terraform: https://registry.terraform.io/

Terraform es una de las muchas herramientas que usamos a lo largo del ciclo de vida de un software.
Es un eslabón más en la cadena de herramientas que usamos en el mundo IT.
Cuando montamos un pipeline de CI/CD (Integración Continua / Despliegue Continuo) podemos usar terraform para gestionar la infraestructura que necesitamos para desplegar nuestro software.... en serie o en paralelo con otras herramientas (Ansible, Docker, Kubernetes, etc)

    En muchos casos, creo infra con terraform (por ejemplo máquinas virtuales en AWS)
    Después configuro esas máquinas con Ansible (instalo software, copio ficheros, etc)
    Y luego lanzo pruebas sobre ellas con JMeter, Selenium, etc... que he instalado mediante contenedores Docker.

Hay otra cosa a tener en cuenta. Estamos creando programas. Y en el mundo de la administración de sistemas NO SOMOS EXPERTOS PROGRAMADORES.
Hoy en día mi trabajo como administrador de sistemas es crear programas (scripts) que administren sistemas.
Igual que el trabajo de hoy en día de un tester es crear programas (scripts) que prueben sistemas, no probar sistemas a mano.

Y como no sabemos mucho de programación, debemos echar mano de conceptos de los que si saben de programación: DESARROLLADORES. Y han aprendido a ostias después de muchos años pegándose con el mundo de la programación.
Y hay cosas que debemos aplicar al crear nuestros programas:
- Montar componentes independientes y reutilizables... no acoplados.

    Script de terraform -> Playbook de Ansible = RUINA!

    Si me pongo a trabajar así, dentro de 5 años tendré 2000 scripts de terraform y 5000 playbooks de Ansible... y si decido cambiar Ansible por otra herramienta (Puppet, Chef, SaltStack, etc) tendré que cambiar los 2000 scripts de terraform, que acababan llamando a los playbooks de Ansible.

       Pipeline de Jenkins               <<<< Orquestación de todas las tareas
        v  ^              v  ^
    Script de terraform   Playbook de Ansible
---

## DEVOPS = AUTOMATIZACIÓN 

Es una cultura, es una filosofía, un movimiento en pro de la automatización de tareas y la mejora de los procesos de desarrollo y despliegue de software.

## Automatizar

Crear una máquina (o cambiar el comportamiento de una mediante programas) que hagan lo que antes hacía un humano.

Puedo automatizar el lavado de la ropa -> Lavadora

Lavadora = Máquina que automatiza el lavado de la ropa (incluso me permite cambiar su comportamiento mediante programas = programa de frio, de prendas delicadas, etc)

En nuestro caso (mundo IT) las máquinas ya las tenemos, no las creamos = COMPUTADORES. Lo que hacemos es crear programas (scripts) que automaticen tareas que antes hacía un humano.

## Más sobre DEVOPS

### Ciclo de vida de DEVOPS

                Automatizable?                  Herramientas?
PLAN                Poco
CODE                Poco (cada día más!)
BUILD               Totalmente
   Empaquetado, Compilación, Lincado..              Java: Maven, Gradle
                                                    C#:   MSBuild, dotnet, Nuget
                                                    C/C++: Make, CMake
                                                    JS:    NPM, Yarn
                                                    Ant
TEST                
    Definición de la prueba   Poco (cada día más)

    Ejecución de la prueba    Totalmente
                                                    Framework : JUnit, NUnit, PyTest, Mocha      
                                                    Web: Selenium, Cypress, Karma
                                                    Performance: JMeter, Gatling
                                                    Calidad de código: SonarQube, Lint, ESLint
                                                    Servicios web: Postman, SoapUI, ReadyAPI
   Dónde se ejecutan esas pruebas?
            En la máquina del desarrollador? NO... no me fío.. ese entorno está maleao!
            En la máquina del tester?        NO... no me fío.. ese entorno está maleao!
            En un entorno de integración/pre-producción/pruebas/Q&A?
                                             NO... antiguamente si. Cuando arrancaba un proyecto hace años (décadas!) me creaban el entorno de desarrollo, el de pruebas y el de producción. 
                                             Ahora bien... Antiguamente, usábamos metodologías tradicionales (cascada/waterfall) y el entorno de pruebas se usaba al final del proyecto.
                                             Hoy en día, con las metodologías ágiles, me paso el día instalando a mi cliente (cada mes... 5 semanas... 2 meses a lo sumo) en producción... lo cual implica que previamente tengo que instalarlo en un entorno de pre-producción/pruebas/Q&A.
                                             Cuántas instalaciones haré a lo largo del proyecto en ese entorno de pruebas? Montonón!
                                             Y después de montonón de instalaciones, cómo vba a estar el entorno de pruebas? Maleao!
                Hoy en día la tendencia es crear entornos de usar y tirar (ephemeral environments)
                Creándolos siempre desde cero. Y así me aseguro que el entorno está limpio.
                Más me vale automatizar la creación de esos entornos... porque si no me paso el día creando entornos.
                Es automatizable? TOTALMENTE
                                                    Herramientas: Terraform, Ansible, Vagrant, Packer, Docker, Kubernetes, Helm, etc
---> SI AUTOMATIZO HASTA AQUI: Integración Continua (CI - Continuous Integration):
    Tener CONTINUAmente la última versión desarrollada del software en un entorno de INTEGRACION limpio sometida a pruebas automatizadas.
    Esto lo hacemos con un script de automatización (Jenkins, Gitops, Gitlab CI, GitHub Actions, Microsoft DevOps, ArgoCD, etc). Esos scripts los llamamos PIPELINES.
    Cuá es el producto de un pipeline de CI? Un informe de pruebas en tiempo real, que indique cómo está el sistema actualmente.

    > Extraído del manifiesto ágil: 
        El software funcionando es la MEDIDA principal de progreso. < Define un indicador para un cuadro de mando

           Núcleo
           ------
        La MEDIDA principal de progreso es el "software funcionando".
        ------------------------------- ----------------------------
        Sujeto                          Predicado

    Cómo mido qué  tal va a el desarrollo de mi producto? Y la respuesta es mediante el concepto "Software funcionando".

    "software funcionando": Software que cumple con sus requisitos, que hace lo que debe hacer.
    Y eso quién lo dice?
     - ~~El cliente~~ Ayuda a definir los requisitos.
     - Las pruebas: Las pruebas son las qaue aseguran que el software funciona como debe funcionar.

RELEASE         TOTALMENTE AUTOMATIZABLE
    Poner en manos de mi cliente la nueva versión funcional de mi software.
    Si hago una app movil, subirla a la tienda de apps (App Store, Google Play, etc)
    Si hago un microservicio para mi empresa? Subirlo a un repositorio de artefactos (Nexus, Artifactory, etc)
-----> Continuous delivery: Entrega continua
DEPLOY          TOTALMENTE AUTOMATIZABLE
    Instalar la nueva versión funcional de mi software en el entorno de producción.
    Lo que a su vez implica montar/mantener ese entorno de producción (INFRAESTRUCTURA)
                                                Terraform, Ansible, Docker, Kubernetes, Helm, etc
---> Continuous deployment: Despliegue continuo
OPERATE         TOTALMENTE AUTOMATIZABLE
MONITOR.        TOTALMENTE AUTOMATIZABLE


CD = Continuous Delivery/Deployment

---

- Lenguaje declarativo para definir infra
- Automatización
- Despliegue de infra reproducible
- Gestión de la infra
- Control y auditoría
- IaC - Infrastructure as Code

---

# Cloud

Es el conjunto de servicios que una empresa IT ofrece a sus clientee a traves de internet.
Servicios que pueden ser de muchos tipos:
- Infraestructura (IaaS - Infrastructure as a Service)
  - Máquinas virtuales/físicas
  - Redes
  - Almacenamiento
- Plataforma (PaaS - Platform as a Service)
  - Bases de datos (DBaaS - Database as a Service)
  - Kubernetes (KaaS - Kubernetes as a Service)
- Software (SaaS - Software as a Service)
  - Cloud9 -> IDE en la nube
  - Gmail -> Correo en la nube

Además características de los clouds son:
- Modelo pago por uso (PAYG - Pay As You Go)
- Automatización... desde su punto de vista. De su lado no hay nadie (programas) ofreciendo esos servicios.

---

# Entornos de producción

- Alta disponibilidad
  Tratar de garantizar un determinado tiempo de servicio (pactado previamente de forma contractual).

    - Quiero que me trates de garantiuzar que el sistema estará funcionando el 99% del timepo que debería estar funcionando.
    - Habitualmente lo medimos en 9s:
      
      90%     36,5 días/año con el sistema offline      €
      99%     3,65 días/año con el sistema offline      €€
      99,9%   8,76 horas/año con el sistema offline     €€€€€
      99,99%  52,56 minutos/año con el sistema offline  €€€€€€€€€€€€€

    La forma de tratar de garantizar alta disponibilidad es mediante la redundancia:
    - Redundancia de componentes (computadores, discos, fuentes de alimentación, etc)
    - Redundancia geográfica (diferentes datacenters)
    - Redundancia de proveedores (electricidad, conectividad, etc)

    Aquí sale el concepto de cluster:
        - HW : Varias máquinas físicas trabajando juntas
        - SW : Un programa instalado en varias máquinas trabajando juntas

    Asegurar (o al menos tratar de asegurar) que no es posible perder información.

- Escalabilidad
    Capacidad de ajustar la infra para adaptarse a las necesidades del momento.

    App1: App departamental
        día 1:          100 usuarios      
        día 100:        102 usuarios     NO HACE FALTA ESCALABILIDAD
        día 1000:       98 usuarios

    App2: 
        día 1:          100 usuarios
        día 100:        1.000 usuarios    Tiramos de escalabilidad vertical: MAS MAQUINA!
        día 1000:       10.000 usuarios

    App3:  INTERNET
        día n:         100 usuarios
        día n+1:       1.000.000 usuarios
        día n+2:       10.000 usuarios
        día n+3:       5.000.000 usuarios
        día n+4:       0 usuarios

    Esto lo habitual es que pase por minutos

        Sistema de petición de pizzas TELEPI:
            00:00 ->  0 estoy cerrado
            10:00 ->  4 despistaos
            14:00 ->  5000 peticiones              Escalado horizontal = MÁS MAQUINAS! o MENOS!
            17:00 ->  20 peticiones
            18:00 ->  700 peticiones
            20:30 -> (Madrid vs Barça) 100.000.000 peticiones

            A qué dimensiono la infra?
            Y esto es lo que tenemos con INTERNET

        Feermin (el comercial de Dell) ya no cubre esta forma de trabajo... Qué necesito aquí? CLOUD

...

Los clouds automatizan el trabajo... en su lado!
Y yo en el mio? Es decir, cuando necesite más máquinas? Entro en la web del cloud y aprieto botones y relleno formularios? Me voy a pasar el día allí dentro.

El hecho es que me va a interesar autoamrizar desde mi lado la gestión de la infra que tengo en el cloud <- TERRAFORM

Es uno de los casos de uso más habituales de terraform = Gestionar infra en clouds públicos (AWS, GCP, AZURE, etc)