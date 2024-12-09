## Secret Dump All Users

Este script de Bash permite realizar un volcado de contraseñas de usuarios en un servidor Windows utilizando la herramienta secretsdump.py de Impacket. Puedes obtener las contraseñas en texto plano o hashes NTLM/LM para un listado de usuarios. El script admite autenticación tanto con contraseña en texto plano como con hashes NTLM/LM.

  
## Requisitos
Antes de ejecutar el script, asegúrate de que tu sistema cumple con los siguientes requisitos:

Python 3: Necesario para ejecutar secretsdump.py.

Impacket: Biblioteca de Python para interactuar con servidores SMB, que incluye secretsdump.py.

Para instalar Impacket, ejecuta:
```
pip install impacket
```
Kali Linux: El script utiliza la ruta predeterminada de Kali para secretsdump.py (/usr/share/doc/python3-impacket/examples/secretsdump.py).

  
## Instalación
Clonar el repositorio:
```
git clone https://github.com/alequinterok/secret_dump_all_users.git
cd secret_dump_all_users
```
Instalar Impacket (si no lo tienes ya instalado):
```pip install impacket```

  
## Uso
El script permite obtener contraseñas o hashes para un listado de usuarios de un servidor Windows mediante la autenticación con un usuario administrador.

  
## Sintaxis

```./secret_dump_all_users.sh -s <servidor> -u <usuario_admin> -p <password_admin> -f <usuarios_file> [-H <LMHASH:NTHASH>]```  


**Parámetros**

**-s** <direccion_servidor>: Dirección IP o nombre del servidor de destino.  
**-u** <usuario_admin>: Nombre de usuario con privilegios de administración en el servidor.  
**-p** <password_admin>: Contraseña en texto plano del usuario administrador (opcional si usas hash).  
**-f** <usuarios_file>: Archivo de texto que contiene el listado de usuarios.  
**-H** <LMHASH:NTHASH>: Hash NTLM/LM del usuario administrador (opcional).  

**Ejemplos de uso**
- Usar contraseña en texto plano:
  ```./secret_dump_all_users.sh -s 192.168.1.10 -u admin -p admin123 -f usuarios.txt```

- Usar hashes NTLM/LM:
  ```./secret_dump_all_users.sh -s 192.168.1.10 -u admin -f usuarios.txt -H "LMHASH:NTHASH"```

    
## Validaciones
El script realiza varias comprobaciones antes de ejecutarse:

Python 3: Verifica que Python 3 esté instalado.  
Impacket: Verifica que la biblioteca Impacket esté instalada.  
Archivo secretsdump.py: Comprueba que el archivo secretsdump.py se encuentre en la ruta predeterminada de Kali Linux.  
Archivo de usuarios: Verifica que el archivo que contiene los usuarios esté presente y accesible.  
Conectividad del servidor: Realiza un ping al servidor de destino para comprobar que es accesible.
