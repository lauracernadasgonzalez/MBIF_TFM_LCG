#!/usr/bin/python3
import os

directorio = "/home/laura.cernadas/00TFM/datos/reads/variant_calling/archivos_variantes_parental"

# Iterar sobre cada archivo en el directorio
for archivo in os.listdir(directorio):
	conteo_lineas = {}
	with open(os.path.join(directorio, archivo), "r") as f:
		for linea in f:
			linea = linea.strip()
			conteo_lineas[linea] = conteo_lineas.get(linea, 0) + 1
	nombre_archivo_salida = os.path.splitext(archivo)[0] + "_aas_conteo.tsv"
	with open(os.path.join(directorio, nombre_archivo_salida), "w") as f:
            # Escribir encabezados de las columnas
            f.write("Linea\tConteo\n")
            # Escribir cada línea y su conteo en el archivo
            for linea, conteo in conteo_lineas.items():
                f.write(f"{linea}\t{conteo}\n")
