#!/usr/bin/bash

#Este es un script para extraer las variantes individuales de los archivos tsv (VCF) de cada muestra y crear una tabla de frecuencias 

variant_calling="/home/laura.cernadas/00TFM/datos/reads/variant_calling" #ruta al directorio que contiene los archivos VCF

reads="/home/laura.cernadas/00TFM/datos/reads" #ruta completa a las raw reads y archivo con los accession runs

cd "$reads"
for sample in $(cat run_accession_file.txt); do 
	cd "$variant_calling"
	awk 'NR > 1 {print}' ${sample}.ivar.tsv | cut -f2,3,4,16,17,18,19,20 >> variantes.txt
done
cd "$variant_calling"
sort -n -k 1 variantes.txt | uniq -c > frecuencia_variantes.txt
 

