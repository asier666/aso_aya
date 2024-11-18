# Documentación Proyecto 1 Eva - Asier Yusto Abad
# Programa de Escaneo de Redes
## Descripción General
Este programa en Bash permite realizar un escaneo de redes para detectar equipos conectados y puertos abiertos en una red específica. El usuario puede introducir una dirección de red en formato CIDR (Classless Inter-Domain Routing) y el programa realizará un escaneo de los dispositivos conectados, así como un escaneo de puertos en cada dispositivo encontrado. Los resultados se pueden guardar en un archivo en formato CSV o JSON.

## Requisitos
Sistema operativo compatible con Bash (Linux, macOS, etc.)
Herramienta nc (netcat) instalada para el escaneo de puertos.
Acceso a la red que se desea escanear.
Permisos de ejecución para el script.
## Instrucciones de Uso
Ejecutar el Script:
Introducir la Dirección de Red: Cuando se te solicite, introduce la dirección de red en formato CIDR (por ejemplo, 192.168.1.0/24).

Especificar el Nombre del Archivo: Se te pedirá que introduzcas un nombre para el archivo donde se guardarán los resultados. Si dejas este campo vacío, se utilizará el nombre defaultresults.

Elegir la Extensión del Archivo: Selecciona la extensión del archivo para los resultados: csv o json. Si dejas este campo vacío, se guardará en un formato legible sin extensión.

Escaneo de la Red: El programa escaneará la red y mostrará los dispositivos encontrados y el estado de los puertos.

Resultados: Al finalizar, se mostrará el tiempo total de ejecución y se guardarán los resultados en el archivo especificado.

## Funciones
dibujo

Descripción: Muestra un arte ASCII en la terminal.
Uso: Se llama al inicio del script para dar la bienvenida al usuario.
verificarip

Descripción: Verifica si la dirección IP introducida es válida.
Parámetros: Ninguno.
Salida: Establece la variable ok en 0 si la IP es válida, o 1 si no lo es.
escaneopuertos

Descripción: Escanea los puertos de los dispositivos encontrados en la red.
Parámetros: Ninguno.
Salida: Muestra el estado de cada puerto (abierto o cerrado) y el servicio asociado si se encuentra en el archivo tcp.csv.
rastreoips24

Descripción: Escanea la red en un rango de direcciones IP para una subred /24.
Parámetros: Ninguno.
Salida: Muestra los dispositivos encontrados y su información (TTL y sistema operativo).

rastreoips16
Descripción: Escanea la red en un rango de direcciones IP para una subred /16.
Parámetros: Ninguno.
Salida: Muestra los dispositivos encontrados y su información (TTL y sistema operativo).

rastreoips8
Descripción: Escanea la red en un rango de direcciones IP para una subred /8.
Parámetros: Ninguno.
Salida: Muestra los dispositivos encontrados y su información (TTL y sistema operativo).

## Ejemplo de Uso

Introduce una dirección de red: 192.168.1.0/24
Introduce un nombre de archivo para guardar los resultados: resultados
Elige la extensión del archivo de resultados: csv
Salida
Al finalizar el escaneo, el programa mostrará un resumen de los equipos encontrados, el estado de los puertos y el tiempo total de ejecución. Los resultados se guardarán en el archivo especificado.

## Notas
Asegúrate de tener los permisos necesarios para escanear la red.
El escaneo de puertos puede ser detectado por sistemas de seguridad, así que úsalo con responsabilidad.