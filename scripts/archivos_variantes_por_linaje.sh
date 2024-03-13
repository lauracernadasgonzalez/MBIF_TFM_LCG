#!/usr/bin/bash

#Este es un script para crear un archivo tsv en el que aparezca cada muestra, su linaje asociado y las variantes encontradas en ese linaje.

reads="/home/laura.cernadas/00TFM/datos/reads" #ruta completa a las raw reads y archivo con los accession runs
variant_calling="/home/laura.cernadas/00TFM/datos/reads/variant_calling" #ruta al directorio que contiene los archivos VCF
linaje="/home/laura.cernadas/00TFM/datos/reads/linaje" #ruta completa a la carpeta de linajes


region="NC_045512.2" #contenido del campo "region" que cambiaremos por el nombre de cada muestra

cd "$reads"
for sample in $(cat run_accession_file.txt); do 
	cd "$variant_calling"
	awk 'NR > 1 {print}' ${sample}.ivar.tsv | cut -f1,2,3,4,16,17,18,19,20 >> variantes_por_muestra.txt #extraemos del archivo de variantes de cada muestra los campos que nos interesan 
	chmod 777 variantes_por_muestra.txt #damos todos los permisos al archivo
	sed -i "s/$region/$sample/g" variantes_por_muestra.txt #sustituimos el campo region por el nombre de cada muestra
done
#obtenemos el archivo variantes_por_muestra.txt en el que se asocia cada variante a la muestra de la que se obtuvo

cd "$reads"
for sample in $(cat run_accession_file.txt); do 
	cd $linaje
	variante=$(grep "^$sample" linajes.tsv | cut -f 2)
	cd $variant_calling
	grep "^$sample" variantes_por_muestra.txt | awk -v reemplazo="$variante" 'BEGIN {FS=OFS="\t"} {$2=reemplazo FS $2} 1' >> variantes_por_linaje.tsv 
done
#obtenemos variantes_por_linaje.txt; al archivo anterior se le añade en el segundo campo el linaje asociado a cada muestra.

cd $linaje
sort -k 2 linajes.tsv | cut -f 2 | uniq > listado_linajes.txt #creamos un archivo unicamente con la lista de todos los linajes determinados 

archivo_variantes="/home/laura.cernadas/00TFM/datos/reads/variant_calling/variantes_por_linaje.tsv"  #archivo del que se van a extraer las variantes
archivo_id_linajes="/home/laura.cernadas/00TFM/datos/reads/linaje/listado_linajes.txt" #archivo con la lista de los nombres de los linajes que se utilizaran para la busqueda con grep

cd /home/laura.cernadas/00TFM/datos/reads/variant_calling
mkdir -p archivos_variantes_linaje #creamos un directorio para guardar los archivos de variantes asociadas a cada linaje

directorio_output="archivos_variantes_linaje"

while IFS= read -r linea; do #bucle para leer cada linea del archivo
	archivo_output="${directorio_output}/${linea}.txt" #genera un nombre de archivo único para cada búsqueda
	grep "$linea" "$archivo_variantes" >> "$archivo_output" #utiliza grep para buscar la línea en el archivo de búsqueda y guarda las coincidencias en el archivo de destino correspondiente.
done < $archivo_id_linajes

#obtenemos un archivo por cada linaje con sus variantes asociadas



	
