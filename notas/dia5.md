# Flujo de trabajo habitual con terraform 

terraform init
    terraform validate
    terraform plan
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
terraform init            Si tengo versiones nuevas de providers o nuevos providers
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform apply --auto-approve
    terraform destroy
    
---

# Null resource:

Chapuza oficializada... Para casos donde terraform no da más de si.


Tengo un recurso multiple (count) - > Servidores virtuales que estamos creando.

Quiero un fichero con las IPs de los servidores

Puedo meter en el resource de los servidores un ?
    provisioner "local-exec" {
        command = "echo self.propiedad_con_la_ip >> ips.txt"
    }
    provisioner ="local-exec" {
        command = "CURRARME UN SCRIPT MEGACHUNGO que eliminase la ip del que estoy borrando del archivo"
        when = "on_destroy"
    }
    
Si funcionaría... pero... solo la primera vez que lo ejecute!

Hay otra opcion.

locals {
    IPS = join("\n", servidores.ips)
}

resource "null_resource" "exportador_de_ips" {
    
    triggers = {
        IPS = local.IPS
    }
    
    provisioner "local-exec" {
        command = "echo ${local.IPS} > ips.txt"
    }
    
}


# Terraform y cloud providers

Depende un poco el cloud.. en general todos los gordos van igual

    admite configuración de usuario/contraseña
                  v
    TERRAFORM > PROVIDER > CLI DEL CLOUD > CLOUD
     ^                          ^
    SCRIPT                  usuario/contraseña
    
    
# Y ahora qué!

Tengo ya un cacho de script de flipar... que me despliega una infra guay!
- Superparametrizada
- Supervalidada
- Extrayendo un monton de datos


Ahora... a produccion!
A producción, mi script! mi programa.. para que usuarios empiecen a crear sus infras!

Mi programa, que irá a un repo de git!

Se va generando al ejecutar mi programa para crear una infra un fichero tfstate con el estado de esa infra...
Y si trabajo con 5 entornos?
Necesito 5-50-500-3 tfstate

Terraform tiene una utilidad para eso: WORKSPACES

Un workspace básicamente es un archivo tfstate independiente.
Por defecto, cuando creamos un proyecto se genera un workspace llamado default,
cuyo archivo es el que vemos en la carpeta raiz del script!

$ terraform workspace list 

Puedo crearme tantos workspaces como quiera:

$ terraform workspace new NOMBRE_WORKSPACE
$ terraform workspace select NOMBRE_WORKSPACE
$ terraform workspace delete NOMBRE_WORKSPACE

Dicho esto!

En la realidad... lo usamos mucho? NO... o al menos.. no solamente!


Mi script hemos dicho que sube a git.
Subiré a git los archivos .tfstate -> NO... el problema es que llevan información sensible!
Y podría hacerlo.. pero no está considerado una buena práctica.
Es más... querría separar el programa de las ejecuciones del programa.

Debo tener un repo de git para el script!

Y en ese repo tener ramas!
    
    main/master
        release
    desarrollo
        [features]

Esto, no está pensado para que lo ejecuten humanos. NO ES LA IDEA.
La idea es que haya un orquestador que se encargue de las ejecuciones.
Voy a tener eso el día 1... posiblemente NO.

Muchas veces, empezamos creando scripts que ejecutamos a mano.
Lo natural es que con el tiempo, esa actividad (la ejecución a mano) sea reeemplazada por un orquestador.

Los estados los solemos guardar en un repositorio de objetos: MINIO, Buckets S3, VAULT HS

Una orquestación desde Jenkins o equivalente, lo que hace es:
- 1. Descargar el tfstate del repositorio correspondiente
- 2. Descarga el script del repo de git
- 3. Ya ejecuta
- 4. Deja la nueva versión del tfstate en el repo de artefactos

Y en estas herramientas además puedo configurar que no se admitan ejecuciones paralelas de los trabajos... 
para evitar que por error 2 personas puedan a la vez estar lanzando aquello.

Haciéndolo así, no tiene tanto sentido el uso de los workspaces

Las variables... ficheros .tfvars. Esos tampoco los guardamos en el repo git del script.

Esos ficheros tenemos 2 opciones:
- Opción 1: Guardarlos en su propio repo de git
- Opción 2: Guardarlos en un repo de artefactos

En cualquiera de los casos, siempre independientes del script de terraform.

    SCRIPT + tfvars + .tfstate en la realidad los guardamos en 3 sitios diferentes...
    Y suelen estar gestionados por 3 equipos diferentes
    
        SCRIPT:     Desarrollo (Devops, ingeniero de cloud...)
        tfvars...   operario.
        .tfstate    JENKINS o SIMILAR
