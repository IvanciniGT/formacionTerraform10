Mañana vamos a hacer un despliegue en un cloud... en concreto en AWS.
Entre los recursos que vamos a crear, crearemos servidores.
Y para dar de alta un servidor en AWS, necesitaremos una clave SSH.
Esto es algo que exige AWS.

Cómo funciona eso del ssh, con claves?
Se trabaja con un par de claves, donde una la consideramos pública y la otra privada.
Cuál pondremos en el servidor: pública.
Básicamente se da de alta un texto dentro de un fichero llamado authorized_keys.
Y la clave privada, la tendremos nosotros en nuestro equipo.

El conectarme con claves pub/priv, qué ventajas tiene frente al uso de usuario y contraseña?
2 cosas importantes:
- La contraseña en algún momento ha tenido que viajar al servidor (aunque sea cifrada)... o desde el servidor hacia mi... Y se considera un punto donde pueda verse expuesta. Con claves pub/priv, la clave privada nunca viaja. No hay punto potencial de exposición.
- Ataques de tipo phising: suplantación de identidad.



---

Necesitamos unas claves que hay que generar.
Consideramos esas claves parte de la infra? SI.
La vamos a generar desde terraform.
Y en terraform hay un provider oficial de hashicorp para gestionar claves ssh: 

hashicorp/tls

Queremos hacer unn programa que:
- Genere un par de claves ssh (pública y privada)
- Las guarde en unos archivos en disco en la máquina donde se ejecute terraform
- Esos archivos deben guardarse dentro de una carpeta que se suministre enm tiempo de ejecución
- Debe admitir parametrización de algoritmo/otros parámetros en la generación de las claves (RSA, ECDSA, ED25519..... 4096 bits, 2048 bits....)
- Si ya tengo claves en disco, en esa carpeta, no quiero que se vuelvan a generar (idempotencia)
- A no ser que explicitamente le diga que sí quiero regenerarlas (un parámetro booleano)
- Los ficheros de las claves se llamarán:
  - public_key.pem
  - private_key.pem
  - public_key.openssh
  - private_key.openssh