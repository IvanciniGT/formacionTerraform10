
# generaremos la clave ssh pública en el módulo ssh
module "mis_claves_ssh" {
    source = "../modulo_ssh" # Aqui se admiten varias cosas:
                            # - Rutas relativas (como esta)
                            # - Rutas absolutas
                            # - URLs a repositorios git
                            # - Nombres de módulos publicados en el registro de terraform
}
# Un data es una busqueda que hago dentro de un proveedor
# Me permite buscar recursos ya existentes en la plataforma del proveedor
# y traer sus datos para usarlos en mi configuración.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "mi_servidor" {
  ami           = data.aws_ami.ubuntu.id # Amazon Machine Image (AMI)
                                         # Un identificador de una imagen de SO 
                                         # dada de alta en Amazon
  instance_type = "t3.micro" # Esto condiciona:
                                    # - La CPU (vCPU)
                                    # - La memoria RAM
                                    # - El rendimiento de red
                                    # - La arquitectura (x86 o ARM)
                                    # Amazon tiene distintos tipos de instancias
                                    # Si sé de amazon sabré qué características tiene cada tipo
                                    # O me tocará ir a la docu de AWS a mirar las características de cada tipo
                                    # Terraform no me va a contar nada de eso.
  key_name = aws_key_pair.mi_clave.key_name
  tags = {
    Name = "${var.nombre}-server"
  }
}

resource "aws_key_pair" "mi_clave" {
  key_name   = "${var.nombre}-key"
  public_key = file( "./claves/public_key.openssh" )
  
  depends_on = [
    module.mis_claves_ssh
  ]
}

variable "nombre" {
  type = string
  description = "Nombre del despliegue"
  nullable = false
}