#!/bin/bash

# Verificar si el script se está ejecutando con permisos de superusuario
if [[ "$(id -u)" -ne 0 ]]; then
  echo "Por favor, ejecute este script como superusuario."
  exit 1
fi

# Actualizar el sistema
echo "Actualizando el sistema..."
apt-get update && apt-get upgrade -y

# Instalar paquetes necesarios
echo "Instalando paquetes necesarios..."
apt-get install -y curl git

# Clonar un repositorio de ejemplo
echo "Clonando un repositorio de ejemplo..."
git clone https://github.com/octocat/Hello-World.git

# Cambiar al directorio del repositorio clonado
cd Hello-World || exit

# Crear un archivo de ejemplo en el repositorio clonado
echo "Creando un archivo de ejemplo..."
echo "Este es un archivo de ejemplo." > ejemplo.txt

# Comprobar que el archivo se ha creado correctamente
if [[ -f "ejemplo.txt" ]]; then
  echo "El archivo de ejemplo se ha creado correctamente."
else
  echo "Error: No se pudo crear el archivo de ejemplo."
  exit 1
fi

# Mostrar el contenido del archivo de ejemplo
echo "Contenido del archivo de ejemplo:"
cat ejemplo.txt

echo "Script ejecutado con éxito."
