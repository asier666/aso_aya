# BUCLES 

Contar del 1 al 10
```bash
n=0
while [ $n -lt 10 ]
do
    echo $n
    n=$((n+1))
done
```

Esto va leyendo el line linea a línea. Cada iteración va guardando cada linea en $line.
Para que el read coja los datos de un archivo se usa el <
Coge el fichero file.txt y lo manda al comando while con read.
```bash
while read line
do
    echo $line
done < ./file.txt
```

Con el IFS indicamos que el separador de campo (por defecto **salto de línea**) queremos que sea la `coma`. Nombramos las 3 variables: nombre, apellido, ciclo.
```bash
while IFS=,
read nombre apellido ciclo
do
    echo "El alumno $nombre $apellido está cursando el ciclo $ciclo"
done < ./fichero
```
FORMATO Fichero fichero:
victor,gonzalez,asir
pepe,fernandez,dam
luis,alvarez,asir


Leer líneas y campos específicos del ficheroi `/etc/passwd`
```bash
while IFS=:
read user pass uid gid desc home_dir shell
do
    echo "El usuario $user tiene el UID $uid"
done < /etc/passwd
```

# DO UNTIL

```bash
n=0
# Mientras esto sea cierto
while [ $n -lt 10 ]
do
    echo $n
    n=$(( n + 1))
done

# (esto es lo mismo pero de otra forma)
# DO UNTIL EJECUTA EL CÓDIGO AL MENOS 1 VEZ. LUEGO MIRA LA CONDICIÓN
n=0
until [ n -eq 10 ]
do
    echo $n
    n=$(( n +1 ))
done
```

Lista con valores: (imprimirá 3 líneas, una con cada variable de $provincia que hemos ennumerado)
```bash
for provincia in León Zamora Salamanca
do
    echo $provincia 
done
```

```bash
for file in /etc/passwd /bin/noexisto
do
    if [ -f $file ]
    then   
        echo "El fichero $file existe"
    else
        echo "El fichero $file no existe"
done
```

Ver quién está conectado al sistema
```bash
for var in $(who)
do
    echo $var
done
```

# Emplear rutas de archivos usando `comodines`
Empleando comodines, expande la búsqueda p.e a directorios.
```bash
for file in /bin/a*
do
    echo $file
done
```

```bash

```

```bash

```

```bash

```


