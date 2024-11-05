# Parametros en bash
```bash
echo "Primer parámetro: $1"
echo "Segundo parámetro: $2"

```
Al ejecutar lo siguiente:
./script.sh a b 

Recogerá a como $1 y b como $2

### Si necesitamos más de 10 parametros:
Introduciendo $10 nos lee el 1 y el 0 por separado.
Tendríamos que ponerlo así ${10}
 ```bash
echo "Primer parámetro: $1"
echo "Segundo parámetro: $2"
echo "tercer parámetro: ${10}"
```
 
### La variable $0 almacena el nombre del script
 ```bash
echo "Nombre del script: $0"
```
 Esto ejecuta: Nombre del script: ./script.sh


Podemos usar el comando **basename** para obtener el nombre del script, de la siguiente manera:
 ```bash
echo "Nombre del script: $( basename $0 )"
```

- Si el usuario no nos pasa suficientes variables, la cadena se quedará como vacía.

Comprobar si los parámetros que ha introducido el usuario existen:
 ```bash
if [ -n ${10} ]
then
    echo "Falta un parámetro"
else
    echo "Decimo parámetro : ${10}"
fi
```
 
 ### $# nos dice la cantidad de parámetros que se han introducido:

```bash
echo "Se han indicado $# parámetros"
```

### $@ $* - Contienen el listado de los parámetros introducidos

El $@ guarda los parámetros en formato lista para poder hacer un **for** para interar sobre esa lista.
```bash
echo "\$@: $@"
echo "\$*: $*"
for par in $@
do
    echo $par
done
```
 

 ```bash

```
 