#!/bin/sh

if [ $# -eq 0 ]; then 
	echo "Error de sintaxis; La sintaxis es: "$0" recurso-a-eliminar"
	exit 1
fi

RESOURCE_NAME=$1

if [ ! -d $RESOURCE_NAME ]; then 
	echo "El recurso \""$RESOURCE_NAME"\" no existe"
	exit 1
fi


rm -v -f -R $RESOURCE_NAME

# Eliminar la documentación, si es que se ha generado.
if [ -d docs/$RESOURCE_NAME ]; then 
	rm -v -f -R docs/$RESOURCE_NAME
fi
