#!/bin/sh

if [ $# -eq 0 ]; then 
	echo "Error de sintaxis; La sintaxis es: "$0" nombre-del-recurso [descripcion]" 
	exit 1
fi

if [ $# -eq 1 ]; then 
	RESOURCE_DESCRIPTION="Recurso del juego MTA-SA"	
else
	RESOURCE_DESCRIPTION=$2	
fi


RESOURCE_NAME=$1

if [ -d $RESOURCE_NAME ]; then 
	echo "EL recurso \""$RESOURCE_NAME"\" ya existe"
	exit 1
fi

# Tiene autor el recurso ? 
if [ !AUTHOR ]; then 
	AUTHOR=$(basename ~)	
fi

# creamos el directorio para el módulo.
mkdir $RESOURCE_NAME

cd $RESOURCE_NAME

# Creamos el archivo meta.xml
echo "<!-- Este es un recurso para el juego MTA:SA -->" > meta.xml
echo "<meta>" >> meta.xml
echo "	<info name=\""$RESOURCE_NAME"\" author=\""$AUTHOR"\" version=\"1.0.0\" description=\""$RESOURCE_DESCRIPTION"\" />" >> meta.xml
echo "  <!-- Todos los recursos dependerán del recurso module -->" >> meta.xml
echo "	<!-- Scripts comunes para todos los recursos -->" >> meta.xml
echo "  <script src=\"common/server.lua\" type=\"server\" />" >> meta.xml
echo "	<script src=\"common/client.lua\" type=\"client\" />" >> meta.xml
echo "	<!-- Funciones que deben ser exportadas explicitamente para que todos los " >> meta.xml
echo "	modulos funcionen -->" >> meta.xml
echo "	<export function=\"__set\" type=\"server\"/>" >> meta.xml
echo "	<export function=\"__get\" type=\"server\"/>" >> meta.xml
echo "	<export function=\"__set\" type=\"client\"/>" >> meta.xml
echo "	<export function=\"__get\" type=\"client\"/>" >> meta.xml
echo "</meta>" >> meta.xml


# Copiamos los scripts necesarios.
mkdir "common"
cp ../common/* ./common/

cd ..

