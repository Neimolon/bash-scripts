#!/bin/bash

#Todo: Pedir respuesta de confirmacion del usuario
#ToDo: Preguntar al usuario si quiere reiniciar el gestor de ventanas ("restart lightdm" en el caso de XFCE)
#Fix: Para no depender de la existencia de diferentes arcivos de configuracion, debería guardarse la configuracion en este escript y simplemente añadirla o quitarla del archivo xorg.conf

file="/etc/hosts"
ruta_ahorro="/etc/X11/xorg.conf.ahorro"
ruta_performance="/etc/X11/xorg.conf.performance"

if [ -f "$ruta_ahorro" ]
then
	#echo "Quieres activar el modo ahorro[XORG] (s/n) TODO!!!!"
	mv /etc/X11/xorg.conf /etc/X11/xorg.conf.performance
	mv /etc/X11/xorg.conf.ahorro /etc/X11/xorg.conf
	echo "Activada configuracon de ahorro:
	         Powermizer Activado y bloqueado en el perfil de consmo mas bajo para evitar el bug de nVidia en el que al activar dos pantallas en vez de escalar rendimiento queda bloqueado en el de maximo rendimiento"
	exit 0
fi

if [ -f "$ruta_performance" ]
then
    #echo "Quieres activar el modo rendimiento[XORG] (s/n) TODO!!!!"
	echo "Se va a activar el modo rendimiento"
    mv /etc/X11/xorg.conf /etc/X11/xorg.conf.ahorro
	mv /etc/X11/xorg.conf.performance /etc/X11/xorg.conf
	exit 0
fi
