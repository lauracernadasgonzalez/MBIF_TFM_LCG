#!/usr/bin/bash

# Script del flujo bioinformático

#Definición de variables

reads="/home/laura.cernadas/00TFM/datos/reads" #ruta completa a las raw reads
genoma_referencia=$"/home/laura.cernadas/00TFM/datos/genoma_referencia/GCF_009858895.2_ASM985889v3_genomic.fna" #ruta completa al genoma de referencia en formato FASTA
genoma_gff=$"/home/laura.cernadas/00TFM/datos/genoma_referencia/genomic.gff" #ruta completa al genoma de referencia anotado
reads_trimmed="/home/laura.cernadas/00TFM/datos/reads/reads_trimmed" #ruta completa a las lecturas limpias
alignments="/home/laura.cernadas/00TFM/datos/reads/alignment" #ruta completa a la carpeta de archivos de alineamiento


#Procesos fuera de la iteración

pangolin --update #Actualización base de datos Pangolin
cd "$reads"
mkdir -p analisis_calidad 
mkdir -p reads_trimmed
mkdir -p alignment
mkdir -p variant_calling
mkdir -p consensus
mkdir -p linaje 
bwa index $genoma_referencia #Indexado del genoma de referencia

#Iteración para el análisis de todas las muestras
 
for sample in $(cat run_accession_file.txt); do 
	echo "Analizando $sample" #analisis de calidad con FastQC
	fastqc ${sample}_1.fastq.gz -o analisis_calidad
    fastqc ${sample}_2.fastq.gz -o analisis_calidad
	echo "Análisis de $sample completado" 
	
	echo "Realizando limpieza de $sample" #limpieza con FastP
	fastp -i ${sample}_1.fastq.gz -I ${sample}_2.fastq.gz -o ${sample}_1.trimmed.fastq.gz -O ${sample}_2.trimmed.fastq.gz --detect_adapter_for_pe --cut_tail 25 --cut_front 25 --cut_mean_quality 25 -l 100 --html ${sample}_fastp.html --json ${sample}_fastp.json
	mv ${sample}_1.trimmed.fastq.gz ${sample}_2.trimmed.fastq.gz ${sample}_fastp.html ${sample}_fastp.json $reads/reads_trimmed/
	echo "Filtrado y recorte de $sample realizado"

	cd $reads_trimmed
	echo "Mapeando $sample al genoma de referencia" #mapeo de las lecturas limpias al genoma de referencia indexado, ordenado de los archivos de alineamiento, conversion SAM a BAM e indexado de los BAM.
	bwa mem -Y -M -R '@RG\tID:\tSM:' -t 2 $genoma_referencia ${sample}_1.trimmed.fastq.gz ${sample}_2.trimmed.fastq.gz | samtools sort | samtools view -b -F 4 -@ 2 -o ${sample}.sort.bam
	samtools index ${sample}.sort.bam
	mv ${sample}.sort.bam $alignments
	mv ${sample}.sort.bam.bai $alignments
	echo "Mapeo de $sample al genoma de referencia realizado"

	cd $alignments
	#analisis de calidad del mapeo con qualimap
	echo "Realizando analisis de calidad del mapeo de $sample"	
	qualimap bamqc -bam ${sample}.sort.bam -nt 2 -gff $genoma_gff -outdir qualimap_${sample} 
	echo "Analisis calidad de mapeo realizada"

	echo "Llamada de variantes de $sample" #llamada de variantes
	samtools mpileup -A -d 0 -B -Q 0 ${sample}.sort.bam | ivar variants -r $genoma_referencia -g $genoma_gff -p ${sample}.ivar
	mv ${sample}.ivar.tsv $reads/variant_calling/
	echo "Llamada de variantes de $sample realizada"
	
	echo "Extracción de secuencia consenso de $sample" #extraccion de la secuencia consenso
	samtools mpileup -A -d 0 -B -Q 0 ${sample}.sort.bam | ivar consensus -q 20 -t 0.8 -m 30 -n N -p ${sample}.ivar
	mv ${sample}.ivar.fa $reads/consensus/
	mv ${sample}.ivar.qual.txt $reads/consensus/ 
	echo "Extracción de la secuencia consenso de $sample finalizada"
	
	cd $reads/consensus/ #determiancion de linaje con Pangolin
	echo "Determinando linaje de $sample"
	pangolin ${sample}.ivar.fa --outdir $reads/linaje/${sample}.pangolin --outfile ${sample}.csv -t 2 --max-ambig 0.3 	
	echo "Determinación de linaje finalizada"	

done

