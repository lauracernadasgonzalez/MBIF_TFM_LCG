#!/usr/bin/bash

#Este es un script para crear un archivo tsv en el que aparezca cada muestra, su linaje asociado, el parental en el que se agrupa y las variantes encontradas en ese linaje. Luego se extraen las variantes por parental y se crea un archivo para cada uno.

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
#obtenemos variantes_por_linaje.tsv; al archivo anterior se le añade en el segundo campo el linaje asociado a cada muestra.

variantes="/home/laura.cernadas/00TFM/datos/reads/variant_calling/variantes_por_linaje.tsv"
parentales="/home/laura.cernadas/00TFM/datos/reads/linaje/parental_trad_lineages.tsv"
nuevo_archivo="/home/laura.cernadas/00TFM/datos/reads/variant_calling/variantes_con_parentales.tsv"

# Procesar cada línea del archivo "variantes_por_linaje.tsv"
while IFS=$'\t' read -r muestra linaje restante; do
    
 # Buscar el linaje en el archivo de parentales y obtener el parental asociado
    parental=$(awk -v linaje="$linaje" '$1 == linaje {print $3}' "$parentales")
    
    # Eliminar caracteres de nueva línea de parental
    parental=$(echo "$parental" | tr -d '\n')
    
    # Agregar el parental al lado de la línea y eliminar los espacios en blanco de la derecha
    echo -e "$muestra\t$linaje\t$parental\t$restante" | sed 's/[[:space:]]*$//' >> "$nuevo_archivo"
done < "$variantes"

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
    done < "$nuevo_archivo"
done < "$parentales"

 
	
