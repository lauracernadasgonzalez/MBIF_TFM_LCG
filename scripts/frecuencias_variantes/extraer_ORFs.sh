#!/usr/bin/bash

# Script para extraer las variantes correspondientes a cada ORF/Proteina a partir de los archivos de frecuencia de variantes para cada parental. Obtenemos un archivo para cada ORF/Proteina de cada parental,entre ellos los correspondientes a spike (S).

directorio="/home/laura.cernadas/00TFM/datos/reads/variant_calling/archivos_variantes_parental/variantes_tabla"
cd "$directorio"
directorio_salida="/home/laura.cernadas/00TFM/datos/reads/variant_calling/archivos_variantes_parental/variantes_tabla/ORFs"

# Iterar sobre todos los archivos .sorted en el directorio
for archivo in "$directorio"/*.sorted; do
	nombre_archivo=$(basename "$archivo" _variantes_aas.tsv_con_conteo.sorted)  # Obtener el nombre del archivo sin la extensión .sorted

# Extraer entre los rangos de posiciones y redirigir a archivos correspondientes
    awk -v nombre="$nombre_archivo" '$1 >= 266 && $1 <= 21555 {print > nombre"_ORF1ab"}' "$archivo" 
	mv "${nombre_archivo}_ORF1ab" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 21563 && $1 <= 25384 {print > nombre"_S"}' "$archivo"
	mv "${nombre_archivo}_S" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 25393 && $1 <= 26220 {print > nombre"_ORF3a"}' "$archivo"
	mv "${nombre_archivo}_ORF3a" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 25765 && $1 <= 26220 {print > nombre"_ORF3b"}' "$archivo"
	mv "${nombre_archivo}_ORF3b" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 26245 && $1 <= 26472 {print > nombre"_E"}' "$archivo"
	mv "${nombre_archivo}_E" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 26523 && $1 <= 27191 {print > nombre"_M"}' "$archivo"
	mv "${nombre_archivo}_M" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 27202 && $1 <= 27387 {print > nombre"_ORF6"}' "$archivo"
	mv "${nombre_archivo}_ORF6" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 27394 && $1 <= 27759 {print > nombre"_ORF7a"}' "$archivo"
	mv "${nombre_archivo}_ORF7a" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 27756 && $1 <= 27887 {print > nombre"_ORF7b"}' "$archivo"
	mv "${nombre_archivo}_ORF7b" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 27894 && $1 <= 28259 {print > nombre"_ORF8"}' "$archivo"
	mv "${nombre_archivo}_ORF8" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 28274 && $1 <= 29533 {print > nombre"_N"}' "$archivo"
	mv "${nombre_archivo}_N" "$directorio_salida"
    awk -v nombre="$nombre_archivo" '$1 >= 29558 && $1 <= 29674 {print > nombre"_ORF10"}' "$archivo"
	mv "${nombre_archivo}_ORF10" "$directorio_salida"
done
