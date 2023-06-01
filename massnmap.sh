#!/bin/bash

# Verifica si se proporcionó un archivo de lista de IP's y un comando de Nmap como parámetros
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Debe proporcionar un archivo de lista de IP's y un comando de Nmap como parámetros."
    exit 1
fi

# Archivo con la lista de direcciones IP (una IP por línea)
input_file="$1"

# Comando de Nmap (sin el nombre del archivo de salida)
nmap_command="${@:2}"

# Nombre del archivo de progreso
progress_file="progreso.txt"

# Número de escaneos simultáneos
num_concurrent_scans=2

# Calcula la cantidad de scans completados
num_completed_scans=$(cat $progress_file | grep Completado | wc -l)


# Variable para contar el número de escaneos en progreso
num_scans_in_progress=0

# Cuenta las lineas que hay en el archivo proporcionado
total_lines=($(wc -l < "$input_file"))

# Función para mostrar el progreso de cada escaneo cada 5 segundos
function mostrar_progreso() {
    while true; do
        sleep 2
        clear
        echo "=========================== MassNmap =========================="
        echo "$num_completed_scans / $total_lines"
        cat  "$progress_file"
        echo "==============================================================="
    done
}
# Limpia el archivo de progreso antes de comenzar
echo "" > "$progress_file"

# Inicia la función de progreso en segundo plano
mostrar_progreso &

# Función para ejecutar el escaneo de una IP
function ejecutar_escaneo() {
    ip=$1
    # Agrega la IP al archivo de progreso con el estado "En progreso"
    echo "IP: $ip - Estado: En progreso" >> "$progress_file"
    # Ejecuta el comando de Nmap para la IP con el nombre de archivo de salida
    eval "$nmap_command -oN ${ip}.txt $ip"
    # Verifica si el escaneo se completó exitosamente
    if [ $? -eq 0 ]; then
        
        # Obtiene la hora local en formato "hora:minuto"
        hora_completado=$(date +"%H:%M")
        # Actualiza el estado de la IP a "Completado" con la hora de finalización
        sed -i "s/IP: $ip - Estado: En progreso/IP: $ip - Estado: Completado - Hora Completado: $hora_completado/g" "$progress_file"
    else
        echo "Error al ejecutar el escaneo para la IP: $ip" >> "$progress_file"
    fi
}

# Lee las IP's del archivo y ejecuta los escaneos
while IFS= read -r ip; do
    # Verifica si la línea es una IP válida
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # Verifica si se alcanzó el límite de escaneos simultáneos
        if [ $num_scans_in_progress -ge $num_concurrent_scans ]; then
            # Espera a que finalice algún escaneo antes de continuar
            wait -n
            ((num_scans_in_progress--))
        fi

        # Ejecuta el escaneo en segundo plano
        ejecutar_escaneo "$ip" &
        ((num_scans_in_progress++))
    fi
done < "$input_file"

# Espera a que finalicen los escaneos restantes
wait
# Limpia el archivo de progreso antes de comenzar
echo "" > "$progress_file"

# Variable para contar el número de escaneos en progreso
num_scans_in_progress=0

# Variable para contar el número de escaneos completados
num_scans_completed=0

# Lee las IP's del archivo y ejecuta los escaneos
while IFS= read -r ip; do
    # Verifica si la línea es una IP válida
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # Verifica si se alcanzó el límite de escaneos simultáneos
        if [ $num_scans_in_progress -ge $num_concurrent_scans ]; then
            # Espera a que finalice algún escaneo antes de continuar
            wait -n
            ((num_scans_in_progress--))
        fi

        # Ejecuta el escaneo en segundo plano
        ejecutar_escaneo "$ip" &
        ((num_scans_in_progress++))
    fi
done < "$input_file"

# Espera a que finalicen los escaneos restantes
wait

# Finaliza la función de progreso
kill $progress_pid >/dev/null 2>&1

# Muestra el progreso final
clear
echo "===== Progreso de escaneos ====="
cat "$progress_file"
echo "==============================="

# Verifica si todos los escaneos se han completado
if [ $num_scans_completed -eq $(wc -l < "$input_file") ]; then
    echo "El escaneo se ha finalizado."
fi
                                                                       
