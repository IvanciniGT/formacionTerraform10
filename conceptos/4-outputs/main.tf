
resource "docker_container" "mi_contenedor" {
    name       = "mi-nginx"
    image      = docker_image.mi_imagen.image_id 
}

resource "docker_image" "mi_imagen" {
    name  = "nginx:latest"
}

# Para qué estoy montando este script?
# - Para crear un contenedor.. para qué?
#   El objetivo es desplegar una infraestructura
# - Para qué quiero desplegar una infraestructura?
#   Para ejecutar aplicaciones encima

# Nuestra parte es SOLO UNA PEQUEÑA PARTE del proceso completo!
# Yo monto la infra...
# Y otro la configurará
# Otro desplegará las aplicaciones
# Otro hará el monitorización

# YO QUE SE !!!! Pero va a haber muchas cositas.. y mucha gente!

# Qué debo yo dar a los demás? Cuando acabe mi parte?
# Tengo que crear 4 servidores, 1 BBDD y 1 configurar 1 balanceador de carga.
# HECHO ! He acabado... Tengo el script.. y ese script se ha ejecutado...
# Y por ende, todos esos recursos están creados.

# Repito pregunta: Qué tengo que dar a los demás? como producto de la ejecución de mi script?
# - Le doy al que viene detrás la IP del balanceador de carga? y de los servidores? MAS VALE!
# - Si he desplegado una BBDD, tenmdré que dar IP, Puerto, Usuario, Password... MAS VALE!

# Este es el concepto de OUTPUTS en Terraform
# Nos permiten sacar datos de los recursos que hemos creado y ponerlos a disposición
# de otros usuarios (u otros scripts de Terraform que vengan detrás)

# Siempre necesitaré sacar datos de los recursos que he creado.
# Y siempre necesitaré dárselos a los que vengan detrás.

# Mi cliente me pide:

#             Recurso
#             vvvvvvvv
# Necesito un servidor Windows con 4 cores y 32 Gbs de Ram.. Y 200Gbs de HDD rapidito y redundante!
#                                   ^^^^^ Como llamamos a eso en Terraform? Variables ^^^^^^^^^^^^

# Cuando acabo, le diré ahí la tienes: En la IP: xx.xx.xx.xx
# Y a esto le llamamos:             Outputs ^^^^^^^^^^^^^^^^

# Tenemos la marca "output" que nos permite precisameente eso: Definir datos de salida
# que queremos sacar de los recursos que hemos creado.

output "ip_contenedor_nginx" {
    value = docker_container.mi_contenedor.network_data[0].ip_address
    description = "La IP del contenedor nginx"
}

# Las quiero en texto, una detras de otra con un ; entre ellas.
output "todas_las_ips" {
    value = join( ";", 
        [ for interfaz_de_red in docker_container.mi_contenedor.network_data: interfaz_de_red.ip_address ] 
    )
}

# Se parece un poquito en la definicióna las variables.

# Una vez se ejecutase el programa de Terraform, podríamos ver el output
# de varias formas:
# - En la consola, al final de la ejecución de "terraform apply"
#   En el log, los datos que he definido como outputs salen al final
#      $ terraform apply:
#           ....
#           Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
#           Outputs:
#           ip_contenedor_nginx = "172.17.0.16"
# 
# - Usando el comando "terraform output". Esto muestra el último valor de los outputs
#      $ terraform output
#      ip_contenedor_nginx = "172.17.0.16"
#      Y el resto de outputs que hubiera
#
# - Si solo me interesa un dato: 
#      $ terraform output ip_contenedor_nginx
# Y además lo puedo pedir en formato JSON
#      $ terraform output -json ip_contenedor_nginx

# Con eso ya, hago lo que quiera.

# Habitualmente, habrá una herramienta tipo Jenkins que ejecute los scripts de Terraform
# Lanzará un :
#   terraform init
#   terraform apply -auto-approve       # El -auto-approve es para que no pida confirmación
# Y luego, recogerá los outputs con:
#   terraform output -json > fichero_de_datos.json
# Y luego, los usará la siguiente fase del pipeline (llamar a ansible, o lo que sea) para hacer lo que tenga que hacer.
# Y a ese programa le pasara los datos que necesite (IP, usuario, password, puerto, etc etc etc)
# En caso que sea necesario, el Jenkins procesará esos datos para darles otro formato, el que necesite el siguiente paso del pipeline.

# Una de las gracias de los outputs es que me permiten aislar mi programa de otros componentes de ese pipeline mayor.

# Puede que cambie algo en mi provider.. o en mi script...
# Pero aun así, yo puedo optar por seguir generando los mismos outputs.
# Mientras siga generando los mismos outputs, el resto del pipeline no se verá afectado por mis cambios internos.

# De hecho, habria otra forma de sacar ese dato sin necesidad de definir un output.
# Mediante otro comando de terraform:
#   terraform state show docker_container.mi_contenedor
# Eso me mostraría todos los datos del recurso "mi_contenedor"
# Y entre esos datos, estaría la IP del contenedor.
# O si quiero sacar solo la IP:
#   terraform state show docker_container.mi_contenedor | grep ip_address