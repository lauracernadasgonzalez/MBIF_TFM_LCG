#!/usr/bin/bash

#Este es un script para crear un archivo tsv en el que aparezca cada muestra, su linaje asociado y las variantes encontradas en ese linaje.

reads="/home/laura.cernadas/00TFM/datos/reads" #ruta completa a las raw reads y archivo con los accession runs
variant_calling="/home/laura.cernadas/00TFM/datos/reads/variant_calling" #ruta al directorio que contiene los archivos VCF
linaje="/home/laura.cernadas/00TFM/datos/reads/linaje" #ruta completa a la carpeta de linajes

#NC_045512.2

region="NC_045512.2"

cd "$reads"
for sample in $(cat run_accession_file.txt); do 
	cd "$variant_calling"
	awk 'NR > 1 {print}' ${sample}.ivar.tsv | cut -f1,2,3,4,16,17,18,19,20 >> variantes_por_muestra.txt
	chmod 777 variantes_por_muestra.txt
	sed -i "s/$region/$sample/g" variantes_por_muestra.txt
done

cd "$reads"
for sample in $(cat run_accession_file.txt); do 
	cd $linaje
	variante=$(grep "^$sample" linajes.tsv | cut -f 2)
	cd $variant_calling
	grep "^$sample" variantes_por_muestra.txt | awk -v reemplazo="$variante" 'BEGIN {FS=OFS="\t"} {$2=reemplazo FS $2} 1' >> variantes_por_linaje.tsv 
done
	
