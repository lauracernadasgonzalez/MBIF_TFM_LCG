#!/usr/bin/bash

parentales="/home/laura.cernadas/00TFM/datos/reads/linaje/parental_trad_lineages.tsv" 
variantes="/home/laura.cernadas/00TFM/datos/reads/variant_calling/variantes_con_parentales.tsv"

cd /home/laura.cernadas/00TFM/datos/reads/variant_calling
mkdir -p archivos_variantes_parental #creamos un directorio para guardar los archivos de variantes asociadas a cada parental

directorio_output="archivos_variantes_parental"


# Iterar sobre cada línea del archivo de parentales
while IFS=$'\t' read -r -a linea_parental; do
    parental="${linea_parental[2]}"  # Obtener el parental de la tercera columna
    archivo_salida="$directorio_output/${parental}.tsv"
    
    # Iterar sobre cada línea del archivo de variantes
    while IFS=$'\t' read -r -a linea_variante; do
        if [[ "${linea_variante[2]}" == "$parental" ]]; then
            # Guardar la línea en el archivo de salida correspondiente
            echo -e "${linea_variante[@]}" >> "$archivo_salida"
        fi
    done < "$variantes"
done < "$parentales"
