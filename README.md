Este script sirve para poder realizar un nmap sobre una lista de objetivos del cual va a sacar un output individual, nmap hoy en día no tiene esta funcionalidad y si queres escanear por ejemplo 100 IP's tenes que tirar un escaneo entero del cual si se cancela perdes los datos.

esto puede serle muy util al pentester para poder llevar un orden de los datos recolectados por equipo y para no perder los escaneos si se frena el escaneo o surjen problemas de conectividad.

Sugiero mover el massnmap.sh al /usr/bin/ para ejecutarlo de manera global, una vez que vos ejecutas el script los resultados van a ir en la carpeta actual de la shell

En el primer parametro indicamos la lista de IP's
En el segundo parametro indicamos el comando de nmap con "" sin indicar el output (tenes que modificarlo directo del script, hace output en .txt normal y xml), "nmap -sVC --script vuln -p-"

ejemplo de uso:
massnmap.sh lista_ip.txt "nmap -sVUC --script vuln -p-"
