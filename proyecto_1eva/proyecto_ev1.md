# Proyecto de la 1ª Evaluación

## Análisis de redes

### Descripción del proyecto

Este proyecto consistirá en crear un script en Bash que permita analizar una red local para detectar equipos conectados, identificar puertos abiertos y tratar de obtener el sistema operativo de cada equipo. El script guardará la información recopilada en un archivo de texto.


### Funcionalidades del proyecto

El script comenzará solicitando un dirección IP de red en formato CIDR (p.e. `192.168.1.0/24`) y, a continuación, realizará los siguientes pasos:
- **Escaneo de red**: enviará una señal de `ping` a cada una de las direcciones IP de la red para saber si hay algún equipo con esa IP o no. Por simplicidad, asumiremos que no habrá subredes, y, por tanto, las máscaras solo podrán ser `/8`, `/16` y `/24`.
```bash
Ponerle red sólo anfitrión

Ping 1.1, 1.2, 1.3, 1.4 (que mande ping) --> Si contesta el equipo, lo marco. Si no, paso al siguiente.

/16 cambaia 255.255.0.0

/8 255.0.0.0
```

- **Detección de puertos abiertos**: una vez identificado cada equipo, realiza un escaneo de puertos para identificar aquellos que están abiertos, guardando el número de puerto y el servicio asociado. Para saber si hay un puerto abierto o no puedes utilizar el comando `nc`, que se explica un poco más adelatne. Para conocer el servicio asociado a cada puerto tienes que recurrir al fichero [tcp.csv](./tcp.csv) que contiene una relación de puertos y el servicio correspondiente.
```bash
En los que tengan IP, buscamos los puertos que tengan abiertos. Si acepta la conexión, lo apuntamos, si lo rechaza, pasamos al siguiente.
```  

- **Detección del sistema operativo**: nuestro script también va a intentar identificar el sistema operativo de cada uno de los equipos. Para ello, utilizarás el valor TTL (Time to Live) de la respuesta a los mensajes `ping`, ya que, por norma general, los sistemas Linux tienen un TTL de 64 y los Windows de 128
```bash
Buscar el valor del TTL en el mensaje de ping
```

- **Almacenamiento de la información**: toda la información obtenida (IP de equipos detectados, puertos abiertos y sistema operativo) se irá mostrando por pantalla y, además, se almacenará en un archivo de texto cuyo nombre indique el usuario. Se valorará la claridad en la presentación de la información.
```bash

```


#### El comando `nc` (netcat)

El comando `nc` es una herramienta muy versátil que permite realizar diveras operaciones de red como escanear puertoss, transferir archivos y configurar conexiones TCP y UDP. En nuestro caso concreto, la utilizaremos para comprobar si un puerto específico está abierto en una máquina. Para ello, necesitaremos los modificadores `-z` para indicar que realice el escaneo sin enviar datos y `-v` para habilitar la salida en modo detallado (*verboso*), que mostrará más información sobre el estado del escaneo.

```bash
victor@SERVER:~$ nc -zv 192.168.1.1 80
Connection to 192.168.1.1 80 port [tcp/http] succeeded!
```

### Funcionalidades opcionales

Este es un proyecto bastante abierto en el que se valorará la inclusión de funcionalidades opcionales. Algunas sugerencias son:

- **Datos en parámetros**: en lugar de preguntar al usuario por la IP de la red, el rango de puertos y el nombre del fichero de salida, se pueden recoger como parámetros en el script.
- **Informe en JSON o CSV**: generar la salida en formato CSV o JSON para facilitar la lectura y análisis de los datos.
- **Registro de la marca de tiempo**: para mostrar al final del escaneo el tiempo que ha llevado realizarlo.
- **Direcciones MAC**: junto con la dirección IP de cada equipo detectado se puede almacenar la dirección MAC del mismo.


### Recursos

- [Extrayendo subcadenas en Bash](https://www.baeldung.com/linux/bash-substring)
- [Aplicar colores en Bash](https://soloconlinux.org.es/colores-en-bash/)
- [Comando `netcat`](https://www.ochobitshacenunbyte.com/2021/11/04/uso-del-comando-ncat-nc-en-linux-con-ejemplos/)

### Calificación del proyecto

Para la calificación del proyecto se tendrán en cuenta los siguientes aspectos:

| Concepto                             | Valoración  |
|--------------------------------------|-------------|
| Documentación                        | 3 puntos    |
| Funcionamiento del script            | 3 puntos    |
| Funcionalidades adicionales          | 2 puntos    |
| Presentación de los datos            | 2 puntos    |