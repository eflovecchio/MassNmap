Este script sirve para poder realizar un nmap sobre una lista de objetivos del cual va a sacar un output individual, nmap hoy en día no tiene esta funcionalidad y si queres escanear por ejemplo 100 IP's tenes que tirar un escaneo entero del cual si se cancela perdes los datos.

esto puede serle muy util al pentester para poder llevar un orden de los datos recolectados por equipo y para no perder los escaneos si se frena el escaneo o surjen problemas de conectividad.

Sugiero mover el massnmap.sh al /usr/bin/ para ejecutarlo de manera global, una vez que vos ejecutas el script los resultados van a ir en la carpeta actual de la shell
sudo cp massnmap.sh /usr/bin/massnmap

Dentro del script tenes para indicar las ejecuciones simultaneas que va a realizar, por default está en 10 escaneos de IP en simultaneo pero esto se puede cambiar directo de la variable del script.
![image](https://github.com/eflovecchio/MassNmap/assets/95314924/47adda06-8ef9-47b6-b6e2-40070dfbedf4)

En el primer parametro indicamos la lista de IP's
En el segundo parametro indicamos el comando de nmap con "" sin indicar el output (tenes que modificarlo directo del script, hace output en .txt normal y xml), "nmap -sVC --script vuln -p-"

ejemplo de uso:
massnmap.sh lista_ip.txt "nmap -sVUC --script vuln -p-"
![image](https://github.com/eflovecchio/MassNmap/assets/95314924/01ae305c-469d-4b81-a2f2-a2b4138d4963)
Una vez ejecutado podemos ver que nos indica cuantas IP estamos escaneando, el comando utilizado, que IP's se estan ejecutando ahora y si está en progreso o completado junto a la hora de que se terminó el escaneo.
