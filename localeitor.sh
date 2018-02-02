#!/bin/bash


#SCRIPT PARA IMPORTACION DE SITIOS DESDE GIT A ENTORNO LOCAL
#CREA LA CARPETA DE PROYECTO 
#IMPORTA EL REPOSITORIO
#CREA UN VIRTUALHOST PARA APACHE Y LO REINICIA
#AÑADE LA RUTA A HOSTS
#
#LA URL LOCAL ES: <nombrerepo>.local
#DOCUMENT ROOT se localiza en /var/www/<nombrerepo>.local/<nombrerepo>
#
# V0.0.1 - VERSION DE PRUEBAS 
WEB_ROOT="/var/www";
WEB_USER="user";
WEB_GROUP="group";
WEB_ADMIN_MAIL="user@mail.com";

#Elevar privilegios
#[ "$UID" -eq 0 ] || exec sudo -u "$WEB_USER" bash "$0" "$@"


#Preguntamos por el Repositorio,
#Creamos Carpetas e importamos repositorio
echo "¿De que repositorio de GitLab vas a copiar el sitio? "; 
read GIT_REPO 

if [ -n $GIT_REPO  ]
then
    #validate git url
    echo "Comprobado la Ruta del Repositorio: $GIT_REPO...";
    git ls-remote "$GIT_REPO" &>-
    if [ "$?" -ne 0 ]; then
        echo "[ERROR] Unable to read from '$GIT_REPO'"
        exit 1;
    fi
    
    echo "Ruta correcta, Configurando variables..."
    REPO_NAME=$(echo $GIT_REPO |cut -d '/' -f 2 |cut -d '.' -f 1); 
    SITE_NAME="$REPO_NAME.local"    
    SITE_DIR="$WEB_ROOT/$SITE_NAME";
    LOG_DIR="$WEB_ROOT/$SITE_NAME/log"
    DOC_ROOT="$SITE_DIR/$REPO_NAME";    

    #echo "REPO NAME:$REPO_NAME";
    #echo "SITE NAME:$SITE_NAME";
    #echo "SITE DIR:$SITE_DIR";
    #echo "DOC ROOT:$DOC_ROOT";

else
    echo "ERROR:No se ha introducido un repositorio";
    exit 1;    
fi

echo "Creando estructura"
mkdir "$SITE_DIR";
mkdir "$LOG_DIR";
touch "$LOG_DIR/error.log";
touch "$LOG_DIR/access.log";


echo "Clonando Repositorio $GIT_REPO en $DOC_ROOT";
git clone "$GIT_REPO" "$DOC_ROOT";

echo "Recuerde!!!: Debe obteber los archivos de configuracion de la zona de desarrollo";
#ToDo

echo "Estructura de carpetas creada exitosamente!!";

echo "Modificando archivo hosts";
#Añadimos el sitio a hosts locales
#ToDo: Comprobar si ya existe la linea el el archivo hosts para no llenarlo de basura
echo "127.0.0.1 $SITE_NAME" | sudo tee -a /etc/hosts > /dev/null ;

#Creamos VirtualHost
echo "Creando Virtual Host";
echo "
<VirtualHost $SITE_NAME:80>
        ServerName $SITE_NAME
        ServerAdmin $WEB_ADMIN_MAIL
        DocumentRoot $DOC_ROOT

        ErrorLog $LOG_DIR/error.log
        CustomLog $LOG_DIR/access.log combined
</VirtualHost>

<IfModule mod_ssl.c>
    <VirtualHost $SITE_NAME:443>

        ServerName $SITE_NAME
        ServerAdmin $WEB_ADMIN_MAIL
        DocumentRoot $DOC_ROOT

        ErrorLog $LOG_DIR/error.log
        CustomLog $LOG_DIR/access.log combined

        SSLEngine on
        SSLCertificateFile    /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

    </VirtualHost>
</IfModule>
" |sudo tee "/etc/apache2/sites-available/$SITE_NAME.conf" > /dev/null

sudo -u root chown root:root "/etc/apache2/sites-available/$SITE_NAME.conf";
sudo -u root ln -s "/etc/apache2/sites-available/$SITE_NAME.conf" "/etc/apache2/sites-enabled/$SITE_NAME.conf";

echo "Reiniciando Apache";

sudo -u root service apache2 restart;

#ToDO - Importación de Base de Datos
echo "Recuerde!!!: Debe importar la base de datos a local y reemplazar la URL para adecuarla a la nueva configuración";	
