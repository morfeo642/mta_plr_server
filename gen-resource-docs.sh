#!/bin/sh

# Este archivo genera la documentación para un recurso específico.

if [ $# -eq 0 ]; then 
	echo "Error de sintaxis; La sintaxis es: "$0 "nombre-del-recurso"
	exit 1
fi

RESOURCE_NAME=$1

if [ ! -d $RESOURCE_NAME ]; then
	echo "El recurso \""$RESOURCE_NAME"\" no existe" 
	exit 1
fi

DOC_PATH=docs


# Crear un directorio para la documentación de este recurso en docs/

if [ ! -d $DOC_PATH ]; then
	mkdir $DOC_PATH	
fi

cd $DOC_PATH 

if [ ! -d $RESOURCE_NAME ]; then
	mkdir $RESOURCE_NAME	
fi


cd $RESOURCE_NAME

# Copiar el archivo Doxygen para generar la documentación.
cp ../DoxyfileTemplate ./Doxyfile

#  Añadir algunas variables al fichero de configuración.

echo "INPUT = \""../../$RESOURCE_NAME/"\"" >> Doxyfile
echo "PROJECT_NAME = \""$RESOURCE_NAME"\"" >> Doxyfile

# No queremos generar la documentación para los scripts comunes
# (common/server.lua ...)

echo "EXCLUDE = \""../../$RESOURCE_NAME/common/"\"" >> Doxyfile

# Generar la documentación

doxygen Doxyfile

