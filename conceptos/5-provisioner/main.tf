
resource "docker_container" "mi_contenedor" {
    name       = "mi-nginx"
    image      = docker_image.mi_imagen.image_id 

    # Este provisionador se ejecutará LOCALMENTE cuando se cree o modifique el contenedor
    # Estoy levantando un contenedor con nginx.
    # Me puede interesar saber si hago ping y llego sin problemas al contenedor.
    provisioner "local-exec" {
        # command = "ping -c 4 ${docker_container.mi_contenedor.network_data[0].ip_address}"
        command = "ping -c 4 ${self.network_data[0].ip_address}"
        # Cuando desde un recurso me refiero a él mismo, puedo usar la palabra reservada self,
        # en lugar de poner el nombre completo del recurso.
        # Esto funciona no solamente dentro de los provisioners, sino en cualquier parte del recurso.
        
        # Si el comando devuelve 0 (éxito) todo bien.
        # Si devuelve otro valor (error) el provisioner falla 
        # y se considera que el script no se ha ejecutado correctamente.
        # Acaba la ejecución de terraform con error.
        # Es más... la ejecución se detiene en este punto.
        # Este comportamiento, es el por defecto de los provisioners... puedo cambiarlo:
        on_failure = "continue"  # Si pongo esto, aunque falle el provisioner, la ejecución de terraform continúa.
    } # Este es un caso de uso de provisioner LOCAL: Hacer pruebas desde la máquina donde se ejecuta terraform
      # hacia el recurso que acabamos de crear (el contenedor docker en este caso)... aunque habrá otras opciones para esto más usadas: Checks, post-conditions, etc

    # HAy otro comportamiento que podemos modificar. 
    # El provisionador se ejecuta cuando se crea o modifica el recurso... pero esto puedo cambiarlo:
    # when = "destroy"  # Con esto, el provisioner se ejecuta SOLO cuando se DESTRUYE el recurso.

    # Más cosas... qué es lo que estamos poniendo en el command? Comandos que ejecuto en un entorno (cli, interprete...)
    # Es posible establer el interprete con el que quiero ejecutar el comando:
    # interpreter = ["PowerShell", "-Command"]  # Esto haría que el comando
    # interpreter = ["/bin/bash", "-c"]  # Esto haría que el comando se ejecutase en bash (Linux/Mac)
    # interpreter = ["/bin/sh", "-c"]  # Esto haría que el comando se ejecutase en bash (Linux/Mac)
    # interpreter = ["python", "-c"]  # Esto haría que el comando se ejecutase en bash (Linux/Mac)

    provisioner "local-exec" {
        interpreter = [ "/bin/bash" , "-c" ]
        # Terraform ofrece una sintaxis muy especial para poder poner textos multilínea
        # Eso aplica a todos los valores de tipo texto (string)
        ## < < - EOT
        command = <<-EOT
                         echo "El contenedor se ha creado correctamente"
                         echo "La IP del contenedor es: $IP"
                    EOT
          
        on_failure  = "continue"
        # Es posible también crear variables de entorno para ese intérprete
        environment = {
            IP = "${docker_container.mi_contenedor.network_data[0].ip_address}"
        }
    }

}

resource "docker_image" "mi_imagen" {
    name  = "nginx:latest"
}

# En ocasiones necesitamos poder ejecutar algunas tipo de acción cuando un recurso es creado,
# modificado o destruido.
# Para ello, podemos usar los PROVISIONERS.

# No lo mezclemos con el concepto de PROVIDERS
# Provider = plugin que me permite gestionar recursos de un tipo concreto (docker, aws, azure, google, etc)
# Provisioner = mecanismo para ejecutar acciones concretas al crear/modificar/destruir un recurso.

# Hay varios tipos de provisioners:
# - Locales: Se ejecutan en el recurso donde se está ejecutando Terraform
# - Remotos: Se ejecutan en el recurso que estamos creando/modificando/destruyendo


# Creo una máquina con Terraform en un proveedor Cloud (AWS, Azure, GCP, etc)
# El objetivo de terraform es el generar esa máquina virtual.
# Esa máquina posteriormentee la configuraré (paquetería, usuarios, servicios, etc) 
# Eso lo haría con terraform? NO
# Lo podría hacer con Ansible, puppet, saltstack, etc

# Pregunta... Si opto por ansible... qué necesita ansible para poder configurar esa máquina?
# Necesita:
# - Poder conectarse a esa máquina (normalmente por SSH)... va a estar habilitado?
#   Depende de la imagen de SO que este usando. Y si no? Puede ansible conectarse?
#   Incluso aunque esté habilitado, me puede interesar copiar una clave SSH concreta para conectarme
# - Tener un usuario con permisos para hacer las configuraciones necesarias <<<< root
# - IP <<<<<< OUTPUT de terraform

# Este tipo de escenarios (acciones muy puntuales al crear/modificar/destruir un recurso)
# es donde tienen sentido los provisioners.

# Mucho mucho cuidado con los provisioners.
# Son un mecanismo que puede romper la idempotencia de terraform.
# Tengo que vigilar de cerca la lógica que pongo en los provisioners para no romper la idempotencia.
# Y usarlos solo para casos muy muy concretos.