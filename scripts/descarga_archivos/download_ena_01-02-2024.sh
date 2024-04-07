#!/bin/bash

#script de descarga de los archivos de lecturas de secuecnciación y del archivo de metadatos

cd /home/laura.cernadas/00TFM/datos

curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d 'result=read_run&query=tax_eq(2697049)%20AND%20country%3D%22Spain%22%20AND%20collection_date%3E%3D2023-09-01%20AND%20collection_date%3C%3D2023-12-31&fields=run_accession%2Cexperiment_title%2Ccollection_date%2Ccountry%2Cinstrument_platform&format=tsv' "https://www.ebi.ac.uk/ena/portal/api/search" > ena_metadata_curl.txt

tail -n +2 ena_metadata_curl.txt | awk '{print $1}' > run_accession_file.txt
mkdir -p reads/
mv run_accession_file.txt reads/
cd reads/

for run in $(cat run_accession_file.txt); do
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${run:0:6}/0${run: -2}/${run}/${run}_1.fastq.gz
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${run:0:6}/0${run: -2}/${run}/${run}_2.fastq.gz
done
