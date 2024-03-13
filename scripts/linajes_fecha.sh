#!/usr/bin/bash

#Este es un script para extraer de cada muestra el linaje asignado por pangolin

reads="/home/laura.cernadas/00TFM/datos/reads" #ruta completa a las raw reads y archivo con los accession run
linaje="/home/laura.cernadas/00TFM/datos/reads/linaje" #ruta completa a la carpeta de linajes

metadata="/home/laura.cernadas/00TFM/datos/ena_metadata_curl.txt" 

cd "$reads"
for sample in $(cat run_accession_file.txt); do
	cd "$linaje"
	chmod -R 777 $linaje
	awk 'NR > 1 {print}' ${sample}.pangolin/${sample}.csv | sed 's/,/\t/g' | cut -f 1,2 >> linajes.tsv 
	buscar="Consensus_${sample}.ivar_threshold_0.8_quality_20"
	reemplazar="${sample}"
	chmod 777 linajes.tsv
	sed -i "s/$buscar/$reemplazar/g" linajes.tsv
	fecha=$(awk 'NR > 1 {print}' $metadata | grep "$sample" | cut -f 3)
	grep "^$sample" linajes.tsv | awk -v fecha="$fecha" '{print $0 "\t" fecha}' >> linajes_fecha.tsv
done 

cat linajes_fecha.tsv | tr -d '-' | sort -n -k 3 > linajes_fecha_sorted
