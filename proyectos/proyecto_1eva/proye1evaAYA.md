# Documentación Proyecto 1º Eva - Asier Yusto Abad

[Volver al índice](../index.md)

# Programa de Escaneo de Redes - DOGISH-ME NET-SCAN 

[Enlace al código](./proye1evaAYA.sh)

## Descripción General :pig_nose:
Este programa en Bash permite realizar un escaneo de redes para detectar equipos conectados y puertos abiertos en una red específica indicada por el usuario. La dirección de red introducida ha de estar en formato CIDR y acepta redes `/8`, `/16` y `/24`. El programa realizará un escaneo de los dispositivos conectados, así como un escaneo de puertos en cada dispositivo encontrado. Los resultados se pueden guardar en un archivo en formato CSV, JSON o archivo de texto con un diseño más legible.

## Requisitos :shell: 
- Sistema operativo compatible con Bash (Linux, macOS, etc.) 
- Herramienta nc (netcat) instalada para el escaneo de puertos.
- Acceso a la red que se desea escanear.
- Archivo `tcp.csv` conteniendo la relación ``Número de puerto - Servicio`` Este archivo debe estar en la misma carpeta que el script.
- Permisos de ejecución para el script.

## Instrucciones de Uso :dog2:

1. **Ejecutar el script**: añadiendo permisos de ejecución al usuario si fuera necesario.
2. **Introducir la Dirección de Red**: Cuando se solicite, introduce la dirección de red en ``formato CIDR`` (por ejemplo, 192.168.1.0/24). **Se comprobará si el formato y la dirección IP es válida**.

3. **Especificar el Nombre del Archivo**: Se te pedirá que introduzcas un nombre para el archivo donde se guardarán los resultados. Si este campo se deja vacío, se utilizará el nombre ``defaultresults``. Este archivo se guardará en ``./logs/``

4. **Elegir la Extensión del Archivo**: Selecciona la extensión del archivo para los resultados: ``csv`` o ``json``. Si dejas este campo vacío, se guardará en un formato legible sin extensión.
    - Formato archivo `csv`: `192.168.110.11,127,Windows`
    - Formato archivo `json`: `{Direccion:{IP:192.168.110.11,TTL:127,SO:Windows}}`
    - Sin formato (legible):
```
 === 192.168.110.11 === 
TTL = 127
Sistema Operativo: Windows
```

5. **Escaneo de la Red**: El programa entonces escaneará la red introducida y mostrará los dispositivos encontrados. Las direcciones encontradas se almacenan en el archivo `redes_encontradas.txt`, que luego el programa usa para escanear los puertos.

6. **Escaneo de puertos**: El programa hace un escaneo de los puertos de las direcciones encontradas a partir del archivo `redes_encontradas.txt`. Nos muestra los puertos que están abiertos y los que no. Para los abiertos, buscamos el nombre del servicio asignado al puerto a partir del archivo `tcp.csv`

7. **Resultados**: Al finalizar, se mostrará el tiempo total de ejecución y se guardarán los resultados en el archivo especificado.

## Funciones :page_with_curl:

### dibujo
**Descripción**: Muestra un arte ASCII en la terminal con el nombre del programa.

### verificarip
**Descripción**: Verifica si la dirección IP introducida es válida.

**Uso**: Comprueba que el formato de la IP sean de 1 a 3 dígitos seguidos de `.` 3 veces, y 3 números al final: (XXX.XXX.XXX.XXX). Cuando esto se cumple, comprueba que cada octeto esté en el rango de **0 a 255**. Si no se cumple, establece ``ok=1`` que nos permite mostrar el error de IP inválida.

### escaneopuertos
**Descripción**: Escanea los puertos de los dispositivos encontrados en la red.

**Uso**: Empleo un `while` que lee las líneas del fichero `redes_encontradas.txt` (donde se almacenan las redes que responden al ping). Después, en el `for` indico el rango de puertos que se va a escanear (he puesto sólo 100 por motivos de testeo, para que no tarde una eternidad). Los puertos que estén abiertos se buscarán en el archivo `tcp.csv`, informándonos si no se encuentra este archivo. 

### rastreoips24
**Descripción**: Escanea la red en un rango de direcciones IP para una subred /24, mediante un `for` que indica el rango a iterar para el **último octeto**.

**Uso**: La dirección que contesta al ping correctamente se almacena en `redes_encontradas.txt`. Después se clasifica el ping según su valor de `TTL`, separándolo entre Windows, Linux y desconocido. Esta información se guarda en el archivo indicado por el usuario, en el formato que este haya elegido.

### rastreoips16
**Descripción**: Escanea la red en un rango de direcciones IP para una subred /16, mediante un `for` que indica el rango a iterar para el **penúltimo octeto**, y un **until** que itera sobre el último octeto.

**Uso**: igual que `rastreoips24`.

### rastreoips8
**Descripción**: Escanea la red en un rango de direcciones IP para una subred /8, mediante un `for` que indica el rango a iterar para el **segundo octeto**, un **until** que itera sobre el penúltimo octeto y otro **until** más que lo hace sobre el último, para cubrir todo el rango de la red.

**Uso**: igual que `rastreoips24`.

- A continuación de las funciones tenemos las líneas que piden los datos al usuario, con distintas comprobaciones.

### Comprueba que usrfile no esté vacío
**Descripción**: si el usuario no pasa un nombre de archivo, se establece su nombre a defaultresults

### Archivo redes_encontradas.txt
**Descripción**: si este archivo no existe, se crea. Es necesario para que funcione el escaneo de puertos.

### Tiempo de ejecución
**Descripción**: finalmente se muestra el tiempo que ha tardado en ejecutarse el programa. Esto lo consigo almacenando el tiempo al iniciar el programa y restándoselo al tiempo almacenado cuando este termina.

## Contacto :feelsgood:
### Asier Yusto Abad - github.com/asier666 - 2024