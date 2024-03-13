#!/usr/bin/bash
nuevo_directorio="/home/laura.cernadas/00TFM/datos/reads/variant_calling/archivos_variantes_parental/variantes_tabla"
cd $nuevo_directorio

for archivo in "$nuevo_directorio"/*.sorted; do
	head -n 1 "$archivo" > "${archivo}_prevalence"
	awk 'NR>1' $archivo | sort -nr -k 7 >> "${archivo}_prevalence"
done
