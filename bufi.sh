#!/bin/bash
# Proyecto Final Laboratorio - Buscador de ficheros
# Sergio Esteban Tarrero
# Proyecto ejecutado en CentOS 7 con interfaz gráfica
# Versión 3.4 25-1-20

#VARIABLES

DIRECTORIO=$1 
OPCION=$2  
OPCIONEXTRA=$3
IMPRIMIR=$4

# Usamos una flag para que nos haga un \n entre los archivos que se sacan por pantalla
let FLAG=0

# MENÚ
function Menu ()
{
    echo -e "\nForma de usar el programa: "
    echo -e "\e[92m<directorio> <opción de búsqueda> <opción extra> <acción>\e[39m \n"
    echo -e "Ejemplo: /home/sergio/downloads/pruebas -t -d \n"
    echo -e "\e[96mCtrl + l\e[39m para limpiar la shell"
    echo -e "\n\e[41mIMPORTANTE:\e[49m Todos los comandos introducidos deben estar escritos en minúsculas \n"
}

# LISTAR --> pone en una lista los ficheros
function Listar ()
{
    if [[ ${FLAG} = 1 ]]
    then
        lista+=("\n")
    fi

    lista+=($fichero)

    FLAG=1
}

# Primera comprobación para ver si existe el directorio introducido
if [[ ! -r ${DIRECTORIO} ]]
then

    echo -e "\n\e[41mERROR 1:\e[49m El directorio introducido no existe, pruebe otro \n"

    Menu
else

    case "${OPCION}" in

    # Se abre un Switch para la PRIMERA opción
    
        "-t") # Caso de buscar por tipo de archivo

            case "${OPCIONEXTRA}" in
                
                "-f") # Mira solo los ficheros normales, (Ej: .txt y fotos)
                    for fichero in "${DIRECTORIO}"/*;
                    do
                        if [[ -r "$fichero" && -f "$fichero" ]] 
                        then
                            Listar
                        fi
                    done
                ;;
                
                "-d") # Mira solo los directorios
                    for fichero in "${DIRECTORIO}"/*;
                    do
                        if [[ -r "$fichero" && -d "$fichero" ]] 
                        then
                            Listar
                        fi
                    done
                ;;

                "-") # Muestra todo
                    for fichero in "${DIRECTORIO}"/*;
                    do
                        Listar
                    done
                ;;

                *) # Control de errores
                    echo -e "\n\e[41mERROR 2:\e[49m Solo se pueden introducir los comandos -f, -d y -"
                    Menu
                ;;
            esac # cierra la opción extra
            ;;
        
        "-n") # Caso buscar por NOMBRE DE ARCHIVO
            for fichero in "$DIRECTORIO"/*;
            do
                if [[ "$fichero" == *"${OPCIONEXTRA}"* ]];
                then
                    Listar
                fi

            done
        ;;

        "-p") # Caso buscar por PERMISOS DE ARCHIVO  
            case "$OPCIONEXTRA" in

                "-x") # Esribe que lea
                    for fichero in "$DIRECTORIO"/*;
                    do
                        if [[ -x "$fichero" && -f "$fichero" ]] || [[ -x "$fichero" && -d "$fichero" ]]
                        then
                            Listar    
                        fi
                    done
                    ;;

                "-r") # Poder leerlo
                    for fichero in "${DIRECTORIO}"/*;
                    do
                        if [[ -r "$fichero" && -f "$fichero" ]] || [[ -r "$fichero" && -d "$fichero" ]]
                        then
                            Listar
                        fi
                    done
                    ;;

                "-w") # Se puede escribir
                    for fichero in "$DIRECTORIO"/*;
                    do
                        if [[ -w "$fichero" && -f "$fichero" ]] || [[ -w "$fichero" && -d "$fichero" ]]
                        then
                            Listar
                        fi
                    done
                    ;;

                *) # Control de errores
                    echo -e "\n\e[41mERROR 3:\e[49m Solo se pueden introducir los comandos -t, -n y -w"
                    Menu
                ;;
                esac # cierra la opción extra 
            
            ;;

        "-c") # Caso buscar por TODO, hay que comprobarlo manualmente
            for fichero in "$DIRECTORIO"/*;
            do
                if [[ -r "$fichero" && -f "$fichero" && -s "$fichero" ]] 
                then
                    grep -c "$OPCIONEXTRA" "$fichero" &>/dev/null
                    if [[ $? -eq 0 ]]
                    then
                        Listar
                    fi
                fi
            done
        ;;

        *) # Control de errores
            echo -e "\n\e[41mERROR 4:\e[49m Solo se pueden introducir los comandos -x, -r, -p y -c"
            Menu
        ;;
    esac # cierra la opción principal

    case "${IMPRIMIR}" in
        
        "-print" | "" ) #IMPRIMIR LO FICHEROS
            shift                

            echo -e "${lista[@]}" # imprime la lista de todos
        ;;    

        *)
            echo -e "\n\e[41mERROR 5:\e[49m Solo se pueden introducir los comandos -print o -exec \n"
            Menu
        ;;
    esac
fi
