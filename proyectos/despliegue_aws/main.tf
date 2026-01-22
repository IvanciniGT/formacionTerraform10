
# generaremos la clave ssh pública en el módulo ssh
module "mis_claves_ssh" {
    source = "../modulo_ssh" # Aqui se admiten varias cosas:
                            # - Rutas relativas (como esta)
                            # - Rutas absolutas
                            # - URLs a repositorios git
                            # - Nombres de módulos publicados en el registro de terraform
}

# generamos la máquina virtual 
resource "maquina_virtual" "mi_maquina"{
   # Configuración del recurso
   # Por algún sitio aquí tendremos que poner la clave ssh publica que hemos generado
   # module.mis_claves_ssh.clave_publica.openssh
}