#!/bin/bash

#Script de Automatizacion de copias de seguridad basico

backupRootDir="/backups/filesystem" ;
backupZipFile="/backups/amime_"`date +%F`.bak.tar.bzip2 ;

if [[ ! -d $backupRootDir ]];
then
    mkdir $backupRootDir ;
fi

declare -A directoryMap ;
directoryMap[/etc/]="$backupRootDir/etc/" ;
directoryMap[/usr/local/]="$backupRootDir/usr/local/" ;
directoryMap[/var/]="$backupRootDir/var/" ;
directoryMap[/boot/]="$backupRootDir/boot/" ;
directoryMap[/home/]="$backupRootDir/home/" ;
directoryMap[/root/]="$backupRootDir/root/" ;



#Copiar con rsync (incremental?) de los directorios mapeados
echo "Iniciando sincronizacion de archivos..." ;

for key in "${!directoryMap[@]}";
do
    srcDir="$key" ;
    bkpDir=" ${directoryMap[$key]}" ;

    #rsync - mantener permisos, vervose, transmision comprimida y eliminar archivos si se elimino en original
    echo "Sincronizando $srcDir con $bkpDir" ;
    rsync -avvz --delete $srcDir $bkpDir > $backupRootDir/rsync.log;
done

echo "Sincronizacion Terminada" ;

#Comprimir backup

if [[ ! -f $backupZipFile ]] ;
then
        tar -cjf "$backupZipFile" "$backupRootDir/" ;
        chmod 600 $backupZipFile ;
else
        echo "Detectada archivo comprimido con fecha de hoy, usando esta copia" ;
fi
