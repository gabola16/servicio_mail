#!/bin/bash
if [ "$1" == "--help" -o "$1" == "-h" ]; then
echo "Esta es la ayuda"
echo "servicio.sh [usuario asunto contenido]"
elif [ "$1" != "" ];then
    if [ "$2" != ""  ]; then
        if [ "$3" != ""  ]; then
                pu=`cat /etc/passwd | cut -d: -f1 | grep "^$1$"`
                if [ -z "$pu" ];then
                    echo "No existe el usuario $1"
                else
                    echo "$3" | mail -s "$2" $1
                fi
        else
            echo "Faltan parametros"
        fi
    else 
        echo "Faltan parametros"
    fi
else
        echo ""
fi
if [ "$1" == "" ];then
    echo "------------------------"
    es=`sudo service postfix status | grep -E "Docs:"`
    if [ -z "$es" ];then
        while true
        do
            echo "1. Instalar"
            echo "2. Salir"
            read -p "Diga un parametro: " var
            if [ "$var" == "1" -o "$var" == "2" ]; then
                if [ "$var" == "1" ]; then
                    sudo apt update
                    sudo apt-get -y install postfix
                    sudo apt-get -y install mailutils
                    break
                else 
                    echo "Adios"
                    break
                fi
            else
                echo "Error en el parametro"
                continue 
            fi
        done  
   fi    
while true 
    do
    if [ "$var" == "2" ]; then          
        break
    fi
    echo "MENU"
    echo "1. Desinstalar"
    echo "2. Ver Estado y cambiarlo"
    echo "3. Bandeja de entrada"
    echo "4. Enviar correos"
    echo "5. Salir"
    read -p "Diga un parametro: " vari
        if [ "$vari" == "1" -o "$vari" == "2" -o "$vari" == "3" -o "$vari" == "4" -o "$vari" == "5" ]; then
            echo ""
        else
            echo "Error en el parametro"
            continue 
        fi
    if [ "$vari" == "1" ]; then
        sudo apt -y remove postfix
        sudo apt -y remove mailutils
        sudo apt -y autoremove
        break
    elif [ "$vari" == "2" ]; then
        esta=`sudo service postfix status | grep "(dead)"`
        if [ -z "$esta" ];then
            esta=`sudo service postfix status | grep "(exited)"`
            if [ -z "$esta" ];then
                echo "Error en el servicio postfix"
            else
            
                while true
                    do
                        read -p "Esta corriendo lo quiere parar: (S)i,(N)o: " res
                        if [ "$res" == "S" -o "$res" == "s" ];then
                            sudo service postfix stop
                            break
                        elif [ "$res" == "N" -o "$res" == "n" ];then
                            break   
                        else
                            continue
                        fi
                    done
            fi   
        else
            while true
                do
                    read -p "No esta corriendo lo quiere arrancar: (S)i,(N)o: " res
                    if [ "$res" == "S" -o "$res" == "s" ];then
                        sudo service postfix start
                        break
                    elif [ "$res" == "N" -o "$res" == "n" ];then
                        break
                    else
                        continue
                    fi
            done
        fi
        
    elif [ "$vari" == "3" ]; then
        mail -H | tr -s ">" " "
        while true
            do
                    echo "- (S)alir"
                    read -p "- Cual correo quiere ver: " op
                    num=`mail -H | tr -s ">" " " | cut -d" " -f3 | grep "^$op$"`
                    if [ "$op" == "S" -o "$op" == "s" ];then
                        break
                    elif [ -z "$num" ];then
                        continue
                    else
                        echo "$num" | mail
                        break
                    fi
            done
    elif [ "$vari" == "4" ]; then
        read -p "Usuario: " usu
        read -p "Asunto: " asu
        read -p "Contenido: " con
        pu=`cat /etc/passwd | cut -d: -f1 | grep "^$usu$"`
        if [ -z "$pu" ];then
            echo "No existe ese usuario $1"
        else
            echo "$con" | mail -s "$asu" $usu
        fi

    elif [ "$vari" == "5" ]; then
        echo "Adios"
        break
    fi
    done
fi
