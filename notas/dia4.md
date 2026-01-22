# Por qué es tan importante en terraform poner validaciones a las variables?

Caso que una variable tenga un valor inválido, puede ser que al crear un recurso ese recurso no se pueda crear, provocando un error en la creación del recurso, y por ende en la ejecución del script terraform.

Pero ... eso cuando se produce? Al crearlo...
Y si antes según el grafo de dependencias se han creado otros 5? Se quedan creados.

Quiero yo dejar en pro una infra a medias? NO
Quiero que si puedo evitar un fallo en una infra en pro, lo evite? SI

Las validaciones se aplican al principio... antes de ninguna tarea.

## Terraform y valores null

Muchas (casi todas) las funciones y operadores de terraform, cuando los aplico a un valor null, generan un error, que corta la ejecución del script terraform. Eso hay que prevenirlo.

upper(variable que potencialmente puede ser null) -> ERROR al evaluarse... en tiempo de ejecución.

En nuestro caso, queremos que ese upper solo se aplique si la variable no es null.

    var.nombre == null || upper(var.nombre) == "SIN_NOMBRE"
    # Admito quee la variable sea nula
     true              || ERROR                             -> Esto genere error y corta la ejecución del script
                                                               Esa forma de escribirlo no nos vale!
                                                    
    var.nombre == null ? true : upper(var.nombre) == "SIN_NOMBRE"

    Esto es otra forma de escribirlo.
    Si la variable es null  devolver true ... Pero la ghracia de esta forma de escribirlo es que en este caso no se evalúa el upper.
    No se evalua el código que hay detrás del ":" si la condición previa es true.
