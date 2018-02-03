#Yes/No Dialog - Implementar en ifs
read -p "Are you sure? " -n 1 -r choice
echo    # (optional) move to a new line
if [[ $choice =~ ^[Yy]$ ]]
then
    echo "yes!"
else
    echo "no!"    
fi

#--------------
#chmod files and Dir
#find /opt/lampp/htdocs -type d -exec chmod 755 {} \;

#Archivos
#find /opt/lampp/htdocs -type f -exec chmod 644 {} \;

#--------------
#!/bin/bash
#Comando para cuando XFCE corrompe la session al cerrar y no inicia bien el fondo ni los iconos

rm -R ~/.cache/sessions/*