#!/usr/bin/python3
from pango_aliasor.aliasor import Aliasor
import pandas as pd
import os
import re
import argparse
import sys




# Recuperamos la información del Github de Pango_designation
aliasor = Aliasor()


# Función de traducción
def TranslateToInterest(target_var: str):
    long_var = aliasor.uncompress(target_var)
    last = target_var
    for i in range(7,0,-1): 
        partial_comp = aliasor.partial_compress(long_var,up_to=i)
        if partial_comp == last:
            continue
        else:
            print(partial_comp)


    print(long_var)

with open('/home/laura.cernadas/00TFM/datos/reads/linaje/listado_linajes.txt', 'r') as archivo:
	for linea in archivo:
		print(linea,"traducción:")
		TranslateToInterest(linea) 

