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