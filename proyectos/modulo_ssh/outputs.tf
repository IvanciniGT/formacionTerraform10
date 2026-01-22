# De entrada, vamos a generar unos ficheros con las claves (publicas y privadas, y en formato PEM y Openssh)
# Eso son outputs?  Desde mi puento de vista son outputs del programa
#                   Desde el punto de vista de terraform no son "outputs"
# A priori no. (Luego los generaremos...pero cuando hagamos algo de magia!)

# Esto ahora es un módulo.
# Se usará en un script.
# Dentro de ese script, puede interesar acceder a alguno de los datos de las claves generadas.
# SI... a cuales? Publicas o Privadas? A las públicas

# Las exponemos con un output