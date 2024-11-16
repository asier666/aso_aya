CÓDIGO
```bash


#!/bin/bash


# FUNCIONES
# FUNCION VERIFICAR IP
function verificarip {
if [[ $direccion =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
then
        n=1
        until [ $n -eq 5 ]
        do
                octeto=$(echo $direccion | cut -d'.' -f $n)
                if ((octeto < 0 || octeto > 255))
                then
                        return 1
                else
                    return 0
                fi
                n=$(( $n+1 ))
        done
else
        return 1
fi
}

# ESCANEOPUERTOS
function escaneopuertos {
        echo "---------------------------------------------------"
        echo "          Detección de puertos abiertos             "
        echo "---------------------------------------------------"
        echo "Iniciando el escaneo de puertos..."
        IFS=
        while read pu
        do
                for j in {79..81} #CAMBIAR A TODO EL RANGO DE PUERTOS
                do 
                        nc -zv -w1 $pu $j
                if [ $? -eq 0 ]
                then
                    SERVICIO=$(grep ",$j," tcp.csv | cut -d',' -f3)
                        echo "Puerto $j servicio $SERVICIO"
                else
                        echo "No puertos"
                fi
                done
        done < redes_encontradas.txt
        }

# PING IPS/24
function rastreoips {
subred=$(echo $direccion | cut -d'.' -f 1-3)
                echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                archivo_usuario="archivo_usuario.txt"
                > $archivo_usuario
                for i in {1..26}   #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!
                do
                        ttl=$(ping -w 1 -c 1 $subred.$i | grep -oP 'ttl=\K\d+')
                        ping -w 1 -c 1 $subred.$i > /dev/null
                        if [ $? -eq 0 ]
                        then
                                echo $subred.$i >> "$redes_encontradas"
                                echo " /=== DIRECCION $subred.$i ===\ " >> "$archivo_usuario"
                                echo -e "\e[5;35m===/===/===/===/===/===/===/===/===/===\e[0m"
                                echo -e "\e[32m Equipo encontrado en la dirección \e[1;32m$subred.$i\e[0m"
                                if [ $ttl -ge 127 ]
                                then
                                        echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mWindows\e[0m"
                                        echo "TTL = $ttl -> Windows" >> "$archivo_usuario"
                                elif [ $ttl -le 64 ]
                                then
                                        echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mLinux\e[0m"
                                        echo "TTL = $ttl -> Linux" >> "$archivo_usuario"
                                else
                                        echo -e "Sistema operativo desconocido detectado con TTL \e[1;31mm$ttl \e[0m"
                                        echo "TTL = $ttl -> Desconocido" >> "$archivo_usuario"
                                fi

                        fi
                done
                echo "yasta"
                }

read -p "Introduce una dirección de red " usrred
barra=$(echo $usrred | cut -d'/' -f 2)
direccion=$(echo $usrred | cut -d'/' -f 1)
verificarip
if [ $? -ne 0 ]
then
    echo "Esa ip no esta bien, prueba de nuevo"

fi
echo "Dirección bien" 

rastreoips

escaneopuertos
```