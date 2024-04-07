#!/usr/bin/bash

# Script de conteo de la frecuencia de variantes en cada parental. Obtenemos archivos con el contaje de las variantes ordenados por posicion (.sorted)

directorio="/home/laura.cernadas/00TFM/datos/reads/variant_calling/archivos_variantes_parental/"
cd "$directorio"


nuevo_directorio="/home/laura.cernadas/00TFM/datos/reads/variant_calling/archivos_variantes_parental/variantes_tabla"

for archivo in *.tsv; do
	nuevo_archivo="${archivo%.tsv}_variantes_aas.tsv"
	awk '{print $4, $5, $6, $8, $10, $11}' "$archivo" | sort -n > "$nuevo_directorio/$nuevo_archivo"
done 

cd $nuevo_directorio
for archivo in "$nuevo_directorio"/*_aas.tsv; do
	echo "Procesando archivo: $archivo"
    
    
    # Nuevo nombre de archivo para el resultado
    nuevo_archivo="${archivo}_con_conteo"
    
    # Imprimir encabezado en el nuevo archivo
    echo -e "Posicion_nt\tAlelo_1\tAlelo_2\tAA1\tAA2\tPosicion_AA\tConteo" > "$nuevo_archivo"
    
    # Contar las apariciones de cada línea única y escribir en el nuevo archivo
	awk 'NR>1 {conteo[$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7]++} END {for (linea in conteo) print linea, conteo[linea]}' "$archivo" >> "${nuevo_archivo}"    
	sort -n "$nuevo_archivo" > "${nuevo_archivo}.sorted"
    
    echo "Archivo procesado: $archivo. Resultado almacenado en $nuevo_archivo"
done



