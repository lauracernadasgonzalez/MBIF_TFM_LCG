#!/usr/bin/bash

#Este es un script para extraer las variantes asociadas a cada linaje de entre todas las muestras y almacenarlas en archivos dedicados a cada variante.

archivo_variantes="/home/laura.cernadas/00TFM/datos/reads/variant_calling/variantes_por_linaje.tsv"  #archivo del que se van a extraer las variantes
archivo_id_linajes="/home/laura.cernadas/00TFM/datos/reads/linaje/listado_linajes.txt" #archivo con la lista de los nombres de los linajes que se utilizaran para la busqueda con grep

cd /home/laura.cernadas/00TFM/datos/reads/variant_calling
mkdir -p archivos_variantes_linaje

directorio_output="archivos_variantes_linaje"

while IFS= read -r linea; do #bucle para leer cada linea del archivo
	archivo_output="${directorio_output}/${linea}.txt" #Genera un nombre de archivo único para cada búsqued
	grep "$linea" "$archivo_variantes" >> "$archivo_output" #Utiliza grep para buscar la línea en el archivo de búsqueda y guarda las coincidencias en el archivo de destino correspondiente.
done < $archivo_id_linajes

	


