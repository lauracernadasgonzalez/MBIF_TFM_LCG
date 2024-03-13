#!/bin/bash
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d 'result=read_run&query=tax_tree(2697049)%20AND%20country%3D%22Spain%22%20AND%20collection_date%3C2023-12-31%20AND%20collection_date%3E2023-09-01&fields=run_accession%2Cexperiment_title%2Ctax_id%2Ccountry&format=tsv' "https://www.ebi.ac.uk/ena/portal/api/search" > ena_metadata_curl.txt

tail -n +2 ena_metadata_curl.txt | awk '{print $1}' > run_accession_file.txt
mkdir -p reads/

for run in $(cat run_accession_file.txt); do
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${run:0:6}/0${run: -2}/${run}/${run}_1.fastq.gz
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${run:0:6}/0${run: -2}/${run}/${run}_2.fastq.gz
	mv ${run}_1.fastq.gz ${run}_2.fastq.gz reads/
	done
