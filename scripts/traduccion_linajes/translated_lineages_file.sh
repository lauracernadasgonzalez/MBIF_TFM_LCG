#!/usr/bin/bash
linaje="/home/laura.cernadas/00TFM/datos/reads/linaje" #ruta completa a la carpeta de linajes
cd "$linaje"
script_translate="/home/laura.cernadas/00TFM/scripts/translate_lineages.py"


# Iterar sobre cada línea del archivo listado_linajes.txt
while IFS= read -r linaje; do
    # Ejecutar el script de Python para traducir el linaje
    traducciones=$(python3 "$script_translate" "$linaje")
    
    # Agregar las traducciones al final de la línea correspondiente
    echo -e "Original: $linaje\t$traducciones" >> trad_lineages
done < listado_linajes.txt








