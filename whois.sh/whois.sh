#! /bin/bash


#Comprobar que no se haya buscado antes

function checked_list(){
	
	if [[ $(cat ./checked/* |grep "^$1$" | wc -l) > 0 ]]
	then
		echo "El dominio $1 ya había sido probado y esta en la lista correspondiente, busca otro dominio";
	else
		echo "Buscando $1 en la base de datos whois";
		check_availability "$1";
	fi 

}	


	
#Preguntar a whois la disponibilidad del dominio
#y guardarla en las listas
function check_availability(){
	whois_response=$(whois $1);

	if [[ $(echo "$whois_response" |grep 'No match for\|NOT FOUND' |wc -l ) > 0  ]] 
	then
		echo "$1 esta libre";
		echo $1 >> ./checked/domains.free;
	else
		echo "$1 está ocupado";
		echo $1 >> ./checked/domains.used;
	fi
}


##main

ext=(com xxx);

if [[ -f ./words/"$1" ]]
then
	echo "Se va a usar las palabras del archivo ./words/$1 ";
	
	
	echo "Combinacion entre palabras activada nivel 0";

	cat "./words/$1" | while read word
	do
		for extension in "${ext[@]}"
		do
			#Test Domain on List &&  Whois Database
			checked_list "$word.$extension";	
			#echo "$word.$extension";	
		done
	done
	
	echo "Combinacion entre palabras activada nivel 1";
	
	cat "./words/$1" | while read word1
	do
		cat "./words/$1" | while read word2
		do
			for extension in "${ext[@]}"
			do
				#Test Domain on List &&  Whois Database
				checked_list "$word1$word2.$extension";	
				#echo "$word.$extension";	
			done
		done
	done
else	
	for keywd in $@
	do
		echo "Comprobando la palabra \"$keywd\" para extensiones \"${ext[@]}\"";
		for extension in "${ext[@]}"
		do
			#Test Domain on List &&  Whois Database
			checked_list "$keywd.$extension";	
			#echo "$keywd.$extension";	
		done
	done

echo "ALL DONE!!";
fi
