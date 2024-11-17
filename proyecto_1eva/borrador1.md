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
        echo " "
        IFS=
        while read pu
        do
                for j in {79..81} #CAMBIAR A TODO EL RANGO DE PUERTOS
                do 
                        echo "Escaneando puerto $j en $pu..."
                        nc -zv -w1 $pu $j 2>/dev/null
                        
                if [ $? -eq 0 ]
                then
                        echo "Puerto $j abierto"
                        if [ -f "tcp.csv" ]
                        then
                                SERVICIO=$(grep ",$j," tcp.csv | cut -d',' -f3)
                                echo "Servicio: $SERVICIO"
                        else
                                echo "Servicio desconocido. No se pudo encontrar el archivo tcp.csv"
                        fi
                else
                        echo "Puerto $j cerrado"
                        echo " "
                fi
                done
        done < redes_encontradas.txt
        }

# PING IPS/24
function rastreoips24 {
subred=$(echo $direccion | cut -d'.' -f 1-3)
                echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                
                > $archivo_usuario
                for i in {20..26}   #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!
                do
                        ttl=$(ping -w 1 -c 1 $subred.$i | grep -oP 'ttl=\K\d+')
                        ping -w 1 -c 1 $subred.$i > /dev/null
                        if [ $? -eq 0 ]
                        then
                                echo $subred.$i >> "$redes_encontradas"
                                echo " /=== DIRECCION $subred.$i ===\ " >> $archivo_usuario
                                echo -e "\e[5;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                                echo " "
                                echo -e "\e[32m Equipo encontrado en la dirección \e[1;32m$subred.$i\e[0m"
                                if [ $ttl -ge 127 ]
                                then
                                        echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mWindows\e[0m"
                                        echo "TTL = $ttl -> Windows" >> $archivo_usuario
                                elif [ $ttl -le 64 ]
                                then
                                        echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mLinux\e[0m"
                                        echo "TTL = $ttl -> Linux" >> $archivo_usuario
                                else
                                        echo -e "Sistema operativo desconocido detectado con TTL \e[1;31mm$ttl \e[0m"
                                        echo "TTL = $ttl -> Desconocido" >> $archivo_usuario
                                fi
                                echo " "
                        fi
                done
                }

# PING IPS/16
function rastreoips16 {
subred=$(echo $direccion | cut -d'.' -f 1-2)
                echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                
                > $archivo_usuario
                for j in {0..2}   #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!
                do
                        i=1
                        echo "Escaneando red $subred.$j.0..."
                        until [ $i -eq 25 ] #CAMBIAR PARA EL RANGO
                        do
                                ttl=$(ping -w 1 -c 1 $subred.$j.$i | grep -oP 'ttl=\K\d+')
                                ping -w 1 -c 1 $subred.$j.$i > /dev/null
                                if [ $? -eq 0 ]
                                then
                                        echo $subred.$j.$i >> "$redes_encontradas"
                                        echo " /=== DIRECCION $subred.$j.$i ===\ " >> $archivo_usuario
                                        echo -e "\e[5;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                                        echo " "
                                        echo -e "\e[32m Equipo encontrado en la dirección \e[1;32m$subred.$j.$i\e[0m"
                                        if [ $ttl -ge 127 ]
                                        then
                                                echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mWindows\e[0m"
                                                echo "TTL = $ttl -> Windows" >> $archivo_usuario
                                        elif [ $ttl -le 64 ]
                                        then
                                                echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mLinux\e[0m"
                                                echo "TTL = $ttl -> Linux" >> $archivo_usuario
                                        else
                                                echo -e "Sistema operativo desconocido detectado con TTL \e[1;31mm$ttl \e[0m"
                                                echo "TTL = $ttl -> Desconocido" >> $archivo_usuario
                                        fi
                                        echo " "
                                fi
                                i=$(( $i+1 ))
                        done
                done
                }

# PING IPS/8
function rastreoips8 {
subred=$(echo $direccion | cut -d'.' -f 1)
                echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                
                > $archivo_usuario
                for k in {168..169}  #CAMBIAR PARA EL RANGO
                do
                        j=0
                        echo "Escaneando red $subred.$k.0.0..."
                        until [ $j -eq 2 ] #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!   
                        do
                                i=1
                                echo "Escaneando red $subred.$k.$j.0..."
                                until [ $i -eq 25 ] #CAMBIAR PARA EL RANGO
                                do
                                        ttl=$(ping -w 1 -c 1 $subred.$k.$j.$i | grep -oP 'ttl=\K\d+')
                                        ping -w 1 -c 1 $subred.$k.$j.$i > /dev/null
                                        if [ $? -eq 0 ]
                                        then
                                                echo $subred.$k.$j.$i >> "$redes_encontradas"
                                                echo " /=== DIRECCION $subred.$k.$j.$i ===\ " >> $archivo_usuario
                                                echo -e "\e[5;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                                                echo " "
                                                echo -e "\e[32m Equipo encontrado en la dirección \e[1;32m$subred.$k.$j.$i\e[0m"
                                                if [ $ttl -ge 127 ]
                                                then
                                                        echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mWindows\e[0m"
                                                        echo "TTL = $ttl -> Windows" >> $archivo_usuario
                                                elif [ $ttl -le 64 ]
                                                then
                                                        echo -e "Sistema operativo detectado con TTL \e[1;32m$ttl => \e[1;33mLinux\e[0m"
                                                        echo "TTL = $ttl -> Linux" >> $archivo_usuario
                                                else
                                                        echo -e "Sistema operativo desconocido detectado con TTL \e[1;31mm$ttl \e[0m"
                                                        echo "TTL = $ttl -> Desconocido" >> $archivo_usuario
                                                fi
                                                echo " "
                                        fi
                                        i=$(( $i+1 ))
                                done
                                j=$(( $j+1 ))
                        done
                done
                }

## CÓDIGO
hora_ini=$(date +%s)
read -p "Introduce una dirección de red " usrred
verificarip
if [ $? -ne 0 ]
then
    echo "Esa ip no esta bien, prueba de nuevo"

fi
echo "Dirección bien" 
read -p "Introduce un nombre de archivo para guardar los resultados: " usrfile
read -p "Elige la extensión del archivo de resultados (csv o json): " usrext

echo $usrfile
case $usrext in
        csv)
        echo "$usrfile"
        archivo_usuario=$usrfile.csv
        echo "1. $archivo_usuario"
        if [ ! -f $archivo_usuario ]
        then
                touch $archivo_usuario
        fi
        echo "Los resultados se guardarán en $archivo_usuario";;
        json)
        archivo_usuario="$usrfile.json"
        echo "Los resultados se guardarán en $usrfile.json";;
        *)
        archivo_usuario="$usrfile"
        echo "Los resultados se guardarán en $usrfile";;
esac

echo "2. $archivo_usuario"
barra=$(echo $usrred | cut -d'/' -f 2)
direccion=$(echo $usrred | cut -d'/' -f 1)
echo $barra
# SELECTOR SEGÚN BARRA
case $barra in
        24)
                rastreoips24;;
        16)
                rastreoips16;;
        8)
                rastreoips8;;
        *)
             echo "Direccion no valida";;
esac   

escaneopuertos


hora_fin=$(date +%s)
tiempo_ejecucion=$(($hora_fin - $hora_ini))

echo "El programa ha tardado $tiempo_ejecucion segundos en ejecutarse"
echo "Salida"
```