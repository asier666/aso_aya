CÓDIGO
```bash
#!/bin/bash

# FUNCIONES
# FUNCION Dibujo
function dibujo {
        echo "
     ......................................................................................     
     .:@@@@@@-:---------------------------------------------------------:.%@%@%@+..@@%@@@@.     
     .+@#..*@#:--------------------------------------------------------::%@+=.+@%.:@@-:@@*.     
     ...:#@@:.:-------------------------------------------------------:-*:-@@@@..@*-%@@@...     
     .@@@@...:-------------------------------------------------------::+-+-....##-::*=...:.     
     .#@#%@@..:--------------------------------------------------:...-#:=*:+@%*=:-%@:.:---.     
     ..*@+*@@..------------------------------------------------:..%#%%::=#=::-=+%@:..-----.     
     ...+@=+@@..:--------------------------------------------:..*%%+-:=*#=**##:....-------.     
     .-:.@%**@@-..-----------------------------------------:..*@%+--=+++=**=:-*@%:.:------.     
     .--..@%=+%@#.:--------------------------------------...@@%=-.:::::...:=#@*:=@@..:----.     
     .---.:@+-=#@-..........:-----------------------:....:@%+=::--=+*#@@@--:::+#=:=%+..---.     
     .---:.#@==+%@@@@@@@##=..........................-*@@#+---::=*@=---:=##-+-.:=%=:#%...:.     
     .----.:@##**+==++*#%@@@@@@@@@@@@@@@@@@@@@@@@@@@%@%+==--===+%==:====-=*@:-#-::+#==@@-..     
     .----.-@+****#***++++==+====-=------------:::%@@::-===-=-=#+-:==-::--===++*@+::+@+=+@.     
     .----.+@#**+++++++++=====++=================:*-@:.::::=+=+=--::----*#%@@%#+--##:::#%*.     
     .----..@%*+++++++=+++++++++++++=======+====-:=@+@=:--:::*%@@@@@@@@@@:.....=%#*%@@#*...     
     .----:.=@*++**+***+++++=+==========+========+-=%@@@@@@@@#...........::---:.........:-.     
     .-----:.@@**++**+=***+++++**######**=+=+==+=**=+*...+@+*..:-:------------------------.     
     .------..@@++*++=+@*@@@@@@@@@@%%%%*@*++===+=%*=*@.......:----------------------------.     
     .-------..@#+*#=+#@.-#.............-@+++==-=%*=+@.:----------------------------------.     
     .--------.*@#*++++@:-#+.:---------:.@#=++===#*==@-.----------------------------------.     
     .--------..#@++*++%@:=%+......::---.=@*=+===+#+-*#.....:-----------------------------.     
     .---------..@*=+===%%--+#@@@#+:......:@==++==**+=+%@@=:.......:----------------------.     
     .---------.:@%==+++=*@#****%@@@@@@@::.%*--=--=*##%%%@@@@@@@@@=-----------------------.     
     .--------:.*@@#*===+++*%#=:........::.@%=-===--+=......:-...::-----------------------.     
     .--------::@@*=**#+---==+*%@@@@@*:...+%**+=--=-=+#%@%+.......:-----------------------.     
     .---------.=@@@@@@@%*+==++**+=+*@@@@+@@+===++=----===*#@@@%@:..:---------------------.     
     .---------:.......=%@@@@%%%#@@@@@@@#..-@@@@%##*+==--==+===+*@@#----------------------.     
     .--------------::............--......:......:=*#%%##***%@%@%#+.:=--------------------.     
     ......................................................................................
     
     "
}

# VERIFICAR IP CORRECTA
function verificarip {
if [[ $direccion =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
then
        n=1
        ok=0
        until [ $n -eq 5 ]
        do
                #Comprueba que cada octeto esté dentro del rango
                octeto=$(echo $direccion | cut -d'.' -f $n)
                if ((octeto < 0 || octeto > 255))
                then
                        ok=1
                fi
                n=$(( $n+1 ))
        done
else
        ok=1
fi
}

# ESCANEOPUERTOS
function escaneopuertos {
         echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo -e "          \e[1;39mDetección de puertos abiertos\e[0m             "
         echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo "     Iniciando el escaneo de puertos..."
        echo " "
        IFS=
        while read pu
        do
                # Rango de puertos a escanear
                for j in {79..81} #CAMBIAR A TODO EL RANGO DE PUERTOS
                do 
                        echo -e "Escaneando puerto $j en \e[1;39;45m$pu...\e[0m"
                        nc -zv -w1 $pu $j 2>/dev/null
                        
                if [ $? -eq 0 ]
                then
                        echo -e "\e[33mPuerto $j:\e[0m"
                        echo -e "Estado: \e[1;32mABIERTO\e[0m"
                        if [ -f "tcp.csv" ]
                        then
                                SERVICIO=$(grep ",$j," tcp.csv | cut -d',' -f3)
                                echo -e "Servicio: \e[1;33m$SERVICIO\e[0m"
                                echo " "
                        else
                                echo -e "\e[1;33mServicio desconocido. \e[1;31mNo se pudo encontrar el archivo tcp.csv\e[0m"
                                echo " "
                        fi
                else
                        echo -e "\e[33mPuerto $j:\e[0m"
                        echo -e "Estado: \e[31mCERRADO\e[0m"
                        echo " "
                fi
                done
        done < redes_encontradas.txt
        }

# PING IPS/24
function rastreoips24 {
subred=$(echo $direccion | cut -d'.' -f 1-3)
                #echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                
                > $archivo_usuario
                echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                echo -e "          \e[1;39mDetección de equipos conectados\e[0m             "
                echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                echo "     Iniciando el escaneo de equipos..."
                echo " "
                echo "Escaneando red $subred..."

                # 192.168.0.XX
                for i in {20..26}   #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!
                do
                        ttl=$(ping -w 1 -c 1 $subred.$i | grep -oP 'ttl=\K\d+')
                        ping -w 1 -c 1 $subred.$i > /dev/null
                        if [ $? -eq 0 ]
                        then
                                echo $subred.$i >> "$redes_encontradas"
                                
                                #echo -e "\e[2;33m----------------------------------------------------\e[0m"
                                #echo " "
                                echo -e "\e[32m[+] Equipo encontrado en la dirección \e[1;32m$subred.$i\e[0m"
                                if [ $ttl -ge 127 ]
                                then
                                        echo -e "TTL = \e[1;32m$ttl\e[0m"
                                        echo -e "Sistema operativo: \e[5;35mWindows\e[0m"
                                       
                                        ### CSV O JSON
                                        case $usrext in
                                                csv)
                                                echo "$subred.$i,$ttl,Windows" >> $archivo_usuario;;
                                                
                                                json)
                                                echo "{"Direccion":{"IP":"$subred.$i","TTL":"$ttl","SO":"Windows"}}" >> $archivo_usuario;;
                                                *)
                                                echo " === $subred.$i === " >> $archivo_usuario
                                                echo "TTL = $ttl" >> $archivo_usuario
                                                echo "Sistema Operativo: Windows" >> $archivo_usuario
                                                echo " " >> $archivo_usuario;;
                                        esac  
                                
                                elif [ $ttl -le 64 ]
                                then
                                        echo -e "TTL = \e[1;32m$ttl\e[0m"
                                        echo -e "Sistema operativo: \e[5;36mLinux\e[0m"
                                        ### CSV O JSON
                                        case $usrext in
                                                csv)
                                                echo "$subred.$i,$ttl,Linux" >> $archivo_usuario;;
                                                
                                                json)
                                                echo "{"Direccion":{"IP":"$subred.$i","TTL":"$ttl","SO":"Linux"}}" >> $archivo_usuario;;
                                                *)
                                                echo " === $subred.$i === " >> $archivo_usuario
                                                echo "TTL = $ttl" >> $archivo_usuario
                                                echo "Sistema Operativo: Linux" >> $archivo_usuario
                                                echo " " >> $archivo_usuario;;
                                        esac
                                else
                                        echo -e "TTL = \e[1;32m$ttl\e[0m"
                                        echo -e "Sistema operativo: \e[1;33mDesconocido\e[0m"
                                        ### CSV O JSON
                                        case $usrext in
                                                csv)
                                                echo "$subred.$i,$ttl,Desconocido" >> $archivo_usuario;;
                                                
                                                json)
                                                echo "{"Direccion":{"IP":"$subred.$i","TTL":"$ttl","SO":"Desconocido"}}" >> $archivo_usuario;;
                                                *)
                                                echo " === $subred.$i === " >> $archivo_usuario
                                                echo "TTL = $ttl" >> $archivo_usuario
                                                echo "Sistema Operativo: Desconocido" >> $archivo_usuario
                                                echo " " >> $archivo_usuario;;
                                        esac
                                fi
                                echo " "
                        fi
                done
                }

# PING IPS/16
function rastreoips16 {
subred=$(echo $direccion | cut -d'.' -f 1-2)
                #echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                
                > $archivo_usuario
                 echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                echo -e "          \e[1;39mDetección de equipos conectados\e[0m             "
                echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                echo "     Iniciando el escaneo de equipos..."
                echo " "

                # 192.168.XXX.0
                for j in {109..111}   #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!
                do
                        i=1 #CAMBIAR PARA EL RANGO
                        echo "Escaneando red $subred.$j.0..."

                        # 192.168.0.XXX
                        until [ $i -eq 25 ] #CAMBIAR PARA EL RANGO
                        do
                                ttl=$(ping -w 1 -c 1 $subred.$j.$i | grep -oP 'ttl=\K\d+')
                                ping -w 1 -c 1 $subred.$j.$i > /dev/null
                                if [ $? -eq 0 ]
                                then
                                        echo $subred.$j.$i >> "$redes_encontradas"
                                        
                                        #echo -e "\e[5;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                                        #echo " "
                                        echo -e "\e[32m[+] Equipo encontrado en la dirección \e[1;32m$subred.$j.$i\e[0m"
                                        if [ $ttl -ge 127 ]
                                        then
                                                echo -e "TTL = \e[1;32m$ttl\e[0m"
                                                echo -e "Sistema operativo: \e[5;35mWindows\e[0m"
                                               ### CSV O JSON
                                        case $usrext in
                                                csv)
                                                echo "$subred.$j.$i,$ttl,Windows" >> $archivo_usuario;;
                                                
                                                json)
                                                echo "{"Direccion":{"IP":"$subred.$j.$i","TTL":"$ttl","SO":"Windows"}}" >> $archivo_usuario;;
                                                *)
                                                echo " === $subred.$j.$i === " >> $archivo_usuario
                                                echo "TTL = $ttl" >> $archivo_usuario
                                                echo "Sistema Operativo: Windows" >> $archivo_usuario
                                                echo " " >> $archivo_usuario;;
                                        esac  

                                        elif [ $ttl -le 64 ]
                                        then
                                                echo -e "TTL = \e[1;32m$ttl\e[0m"
                                                echo -e "Sistema operativo: \e[5;36mLinux\e[0m"
                                                ### CSV O JSON
                                                case $usrext in
                                                        csv)
                                                        echo "$subred.$j.$i,$ttl,Linux" >> $archivo_usuario;;
                                                        
                                                        json)
                                                        echo "{"Direccion":{"IP":"$subred.$j.$i","TTL":"$ttl","SO":"Linux"}}" >> $archivo_usuario;;
                                                        *)
                                                        echo " === $subred.$j.$i === " >> $archivo_usuario
                                                        echo "TTL = $ttl" >> $archivo_usuario
                                                        echo "Sistema Operativo: Linux" >> $archivo_usuario
                                                        echo " " >> $archivo_usuario;;
                                                esac  
                                        else
                                                echo -e "TTL = \e[1;32m$ttl\e[0m"
                                                echo -e "Sistema operativo: \e[1;33mDesconocido\e[0m"
                                                ### CSV O JSON
                                                case $usrext in
                                                        csv)
                                                        echo "$subred.$j.$i,$ttl,Desconocido" >> $archivo_usuario;;
                                                        
                                                        json)
                                                        echo "{"Direccion":{"IP":"$subred.$j.$i","TTL":"$ttl","SO":"Desconocido"}}" >> $archivo_usuario;;
                                                        *)
                                                        echo " === $subred.$j.$i === " >> $archivo_usuario
                                                        echo "TTL = $ttl" >> $archivo_usuario
                                                        echo "Sistema Operativo: Desconocido" >> $archivo_usuario
                                                        echo " " >> $archivo_usuario;;
                                                esac
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
                #echo $subred
                redes_encontradas="redes_encontradas.txt"
                > $redes_encontradas
                
                > $archivo_usuario
                 echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                echo -e "          \e[1;39mDetección de equipos conectados\e[0m             "
                echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                echo "     Iniciando el escaneo de equipos..."
                echo " "

                # 192.XXX.0.0
                for k in {168..169}  #CAMBIAR PARA EL RANGO
                do
                        j=109 #CAMBIAR PARA EL RANGO
                        echo "Escaneando red $subred.$k.0.0..."

                        # 192.168.XXX.0
                        until [ $j -eq 111 ] #CAMBIAR PARA QUE HAGA TODO EL RANGO!!!   
                        do
                                i=1
                                echo "Escaneando red $subred.$k.$j.0..."

                                # 192.168.0.XXX
                                until [ $i -eq 25 ] #CAMBIAR PARA EL RANGO
                                do
                                        ttl=$(ping -w 1 -c 1 $subred.$k.$j.$i | grep -oP 'ttl=\K\d+')
                                        ping -w 1 -c 1 $subred.$k.$j.$i > /dev/null
                                        if [ $? -eq 0 ]
                                        then
                                                echo $subred.$k.$j.$i >> "$redes_encontradas"
                                                #echo -e "\e[5;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
                                                #echo " "
                                                echo -e "\e[32m[+] Equipo encontrado en la dirección \e[1;32m$subred.$k.$j.$i\e[0m"
                                                if [ $ttl -ge 127 ]
                                                then
                                                        echo -e "TTL = \e[1;32m$ttl\e[0m"
                                                        echo -e "Sistema operativo: \e[5;35mWindows\e[0m"
                                                         ### CSV O JSON
                                                        case $usrext in
                                                                csv)
                                                                echo "$subred.$k.$j.$i,$ttl,Windows" >> $archivo_usuario;;
                                                                
                                                                json)
                                                                echo "{"Direccion":{"IP":"$subred.$k.$j.$i","TTL":"$ttl","SO":"Windows"}}" >> $archivo_usuario;;
                                                                *)
                                                                echo " === $subred.$k.$j.$i === " >> $archivo_usuario
                                                                echo "TTL = $ttl" >> $archivo_usuario
                                                                echo "Sistema Operativo: Windows" >> $archivo_usuario
                                                                echo " " >> $archivo_usuario;;
                                                        esac  
                                                elif [ $ttl -le 64 ]
                                                then
                                                        echo -e "TTL = \e[1;32m$ttl\e[0m"
                                                        echo -e "Sistema operativo: \e[5;36mLinux\e[0m"
                                                         ### CSV O JSON
                                                        case $usrext in
                                                                csv)
                                                                echo "$subred.$k.$j.$i,$ttl,Linux" >> $archivo_usuario;;
                                                                
                                                                json)
                                                                echo "{"Direccion":{"IP":"$subred.$k.$j.$i","TTL":"$ttl","SO":"Linux"}}" >> $archivo_usuario;;
                                                                *)
                                                                echo " === $subred.$k.$j.$i === " >> $archivo_usuario
                                                                echo "TTL = $ttl" >> $archivo_usuario
                                                                echo "Sistema Operativo: Linux" >> $archivo_usuario
                                                                echo " " >> $archivo_usuario;;
                                                        esac
                                                else
                                                        echo -e "TTL = \e[1;32m$ttl\e[0m"
                                                        echo -e "Sistema operativo: \e[1;33mDesconocido\e[0m"
                                                        ### CSV O JSON
                                                        case $usrext in
                                                                csv)
                                                                echo "$subred.$k.$j.$i,$ttl,Desconocido" >> $archivo_usuario;;
                                                                
                                                                json)
                                                                echo "{"Direccion":{"IP":"$subred.$k.$j.$i","TTL":"$ttl","SO":"Desconocido"}}" >> $archivo_usuario;;
                                                                *)
                                                                echo " === $subred.$k.$j.$i === " >> $archivo_usuario
                                                                echo "TTL = $ttl" >> $archivo_usuario
                                                                echo "Sistema Operativo: Desconocido" >> $archivo_usuario
                                                                echo " " >> $archivo_usuario;;
                                                        esac
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
dibujo
read -p "Introduce una dirección de red " usrred

barra=$(echo $usrred | cut -d'/' -f 2)
direccion=$(echo $usrred | cut -d'/' -f 1)
## ERROR SI LA IP NO ESTÁ BIEN
verificarip
if [ $ok -ne 0 ]
then
        echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo -e "          \e[1;39mERROR EN LA EJECUCIÓN\e[0m             "
        echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo -e "\e[31mEl formato de la dirección IP introducida no es correcto.\e[0m"
        echo -e "Algo está mal en la dirección \e[1;31m$usrred\e[0m"
        echo " "
        echo -e "\e[33mComprueba que la barra sea /8, /16 o /24 y que el rango de la red esté entre 0 y 255.\e[0m"
        echo " "
        exit
fi
echo -e "Introduce un \e[0;45mnombre de archivo\e[0m para guardar los resultados \e[1;33m(Si está vacío se guardará como \e[0;45mdefaultresults\e[0m\e[1;33m)\e[0m: "

read usrfile

# Si no se introduce nombre, establecer a
if [ -z "$usrfile" ]
then
        usrfile=defaultresults
fi
echo -e "Elige la \e[0;45mextensión del archivo\e[0m de resultados: \e[1;33mcsv\e[0m o \e[1;33mjson\e[0m (Dejar vacío para formato legible sin extensión): "
read usrext
echo " "

# Crear archivo redes_encontradas.txt
if [ ! -f $redes_encontradas ]
then
        touch $redes_encontradas
fi

# Muestra dónde se guardan
case $usrext in
        csv)
        archivo_usuario=./logs/$usrfile.csv
        if [ ! -d ./logs/ ]
        then
                mkdir logs
        fi
        if [ ! -f $archivo_usuario ]
        then
                touch $archivo_usuario
        fi
        echo -e "Los resultados se guardarán en \e[0;45m$archivo_usuario\e[0m";;
        json)
        archivo_usuario=./logs/$usrfile.json
        echo -e "Los resultados se guardarán en \e[0;45m$archivo_usuario\e[0m";;
        *)
        archivo_usuario=./logs/$usrfile
        echo -e "Los resultados se guardarán en \e[0;45m$archivo_usuario\e[0m";;
esac

# Rastreo IPs según barra
case $barra in
        24)
                rastreoips24;;
        16)
                rastreoips16;;
        8)
                rastreoips8;;
        *)
             echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo -e "          \e[1;39mERROR EN LA EJECUCIÓN\e[0m             "
                echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
    echo -e "\e[31mEl formato de la barra de la dirección IP introducida no es correcto.\e[0m"
    echo -e "Algo está mal en la barra \e[1;31m/$barra\e[0m"
    echo " "
    echo -e "\e[33mComprueba que la barra sea /8, /16 o /24.\e[0m"
        echo " "
        exit
esac   

# Escaneo puertos
escaneopuertos

hora_fin=$(date +%s)

# Calculo tiempo ejecución
tiempo_ejecucion=$(($hora_fin - $hora_ini))

        echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo -e "          \e[1;32mEscaneo de Red Completado\e[0m            "
        echo -e "\e[2;35moxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxxoxxXXXxx\e[0m"
        echo "  [-] Equipos encontrados en la red:"
        cat $redes_encontradas
        echo " "
        echo -e "Los resultados se han guardado en el fichero \e[1;32m$usrfile.$usrext\e[0m"
echo -e "El programa ha tardado \e[1;32m$tiempo_ejecucion segundos\e[0m en ejecutarse"
echo -e "\e[1;36mGracias por usar nuestro programa\e[0m"
echo " "
```