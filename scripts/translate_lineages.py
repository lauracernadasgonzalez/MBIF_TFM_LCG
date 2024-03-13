#!/usr/bin/python3  

# Script para ejecutarse en python3
# Importamos las bibliotecas necesarias
from pango_aliasor.aliasor import Aliasor
import pandas as pd
import os
import re
import argparse
import sys




# Recuperamos la información del Github de Pango_designation
aliasor = Aliasor()


# Definimos la función de traducción
def TranslateToInterest(target_var: str): #nombre de la funcion 'TranslateTointerest'; toma un argumento en forma de cadena 'target_var'
    long_var = aliasor.uncompress(target_var) #utiliza 'uncompress' para descomprimir 'target_var' y lo asigna a 'long_var'.
    last = target_var
    for i in range(7,0,-1): #bucle for que itera del 7 al 1 de 1 en 1 (descendiente)
        partial_comp = aliasor.partial_compress(long_var,up_to=i) #llamada al metodo de compresion parcial con los argumentos
        if partial_comp == last: #verifica si la variable partial_comp es igual a last
            continue #Si son iguales, la ejecución pasa a la siguiente iteración del bucle sin realizar ninguna otra acción.
        else:
            print(partial_comp) #si partial_comp es diferente de last, imprime el valor de partial_comp.

	print(long_var)

#En resumen, este bucle itera sobre varios niveles de compresión parcial de long_var, comenzando desde el nivel 7 y disminuyendo hasta el nivel 1, imprimiendo los resultados de cada nivel de compresión parcial que no sean iguales al resultado del nivel anterior.




# Lectura de las variantes a traducir
input = sys.argv[1] #lee el primer argumento pasado al script desde la línea de comandos
TranslateToInterest(input) #llama a la funcion con dicho argumento
