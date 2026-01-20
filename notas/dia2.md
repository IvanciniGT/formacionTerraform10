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