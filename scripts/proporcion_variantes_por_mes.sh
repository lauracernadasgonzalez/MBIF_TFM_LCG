#!/usr/bin/bash

#Este es un script para obtener la proporción de cada variante en cada uno de los meses de estudio

reads="/home/laura.cernadas/00TFM/datos/reads" #ruta completa a las raw reads y archivo con los accession run
linaje="/home/laura.cernadas/00TFM/datos/reads/linaje" #ruta completa a la carpeta de linajes

metadata="/home/laura.cernadas/00TFM/datos/ena_metadata_curl.txt" #ruta completa a los metadatos

cd "$reads" #directorio en el que se encuentra el archivo run_accession_file.txt
for sample in $(cat run_accession_file.txt); do #bucle for para iterar el proceso sobre cada muestra del archivo
	cd "$linaje" #directorio de los archivos de determinación de linaje a cada muestra
	chmod -R 777 $linaje #añadimos todos los permisos al directorio
	awk 'NR > 1 {print}' ${sample}.pangolin/${sample}.csv | sed 's/,/\t/g' | cut -f 1,2 >> linajes.tsv 
	buscar="Consensus_${sample}.ivar_threshold_0.8_quality_20"
	reemplazar="${sample}"
	chmod 777 linajes.tsv
	sed -i "s/$buscar/$reemplazar/g" linajes.tsv #obtenemos un archivo con dos columnas: el nombre de la muestra y el linaje asociado
	fecha=$(awk 'NR > 1 {print}' $metadata | grep "$sample" | cut -f 3) #extraemos las fechas del archivo de metadatos
	grep "^$sample" linajes.tsv | awk -v fecha="$fecha" '{print $0 "\t" fecha}' >> linajes_fecha.tsv #añadimos una tercera columna con las fechas de cada muestra
done 

cd "$linaje" 

cat linajes_fecha.tsv | tr -d '-' | sort -n -k 3 > linajes_fecha_sorted #ordenamos el archivo por fecha 

awk -F'\t' '{count[$2]++; lines[$2]=lines[$2] $0 "\n"} END {for (word in count) print "Coincidencia:", word, "Cantidad:", count[word], "\n", lines[word]}' linajes_fecha_sorted.tsv > coincidencias_linajes #hacemos un contaje de las coincidencias para cada linaje y lo redirigimos junto a dichas coincidencias a un nuevo archivo

#separamos los linajes por mes y obtenemos la cuenta de cada uno
grep "202309" coincidencias_linajes | sort -k 2 > septiembre_linajes.tsv
cut -f 2 septiembre_linajes.tsv | uniq -c >>septiembre_linajes.tsv
grep "202310" coincidencias_linajes | sort -k 2 > octubre_linajes.tsv
cut -f 2 octubre_linajes.tsv | uniq -c >> octubre_linajes.tsv
grep "202311" coincidencias_linajes | sort -k 2 > noviembre_linajes.tsv
cut -f 2 noviembre_linajes.tsv | uniq -c >> noviembre_linajes.tsv
grep "202312" coincidencias_linajes | sort -k 2 > diciembre_linajes.tsv
cut -f 2 diciembre_linajes.tsv | uniq -c >> diciembre_linajes.tsv 









