#!/bin/bash

# Performing Quality control using FASTQC
fastqc "path to the fastq folder" -o "path where to save the fastqc report"

# Performing Trimming of the reads that failed the fastq
# here I am running the trimming for pair-end FASTQ files which end with END1 and END2 for mate pairs. 
for i in `ls -1 *END1*.fastq.gz | sed 's/\_END1.fastq.gz//'`; do echo java -jar /data0/local/trimmomatic-0.39/dist/jar/trimmomatic-0.39.jar PE -phred33 "path to the files that failed QC"/$i\_END1.fastq.gz "path to the files that failed QC"/$i\_END2.fastq.gz "path where you want to save the trimmed fastq files"/$i\paired_END1_trimmed.fq.gz "path where you want to save the trimmed fastq files"/$i\unpaired_END1_trimmed.fq.gz "path where you want to save the trimmed fastq files"/$i\paired_END2_trimmed.fq.gz "path where you want to save the trimmed fastq files"/$i\unpaired_END2_trimmed.fq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:30 MINLEN:36 >> /home/nchalas/final_trim.sh; done

# after the output of the above command is saved to the .sh file run it using the bash command
bash final_trim.sh

# after trimming the reads repeat the FASTQC check on the trimmed reads to know the quality 

# Performing mapping
# the following command is for paired-end sequences
hisat2 -q -x "path to the genome reference file" -1 "path to the files that passed the qc"/Sample_END1.fastq.gz -2 "path to the files that passed the qc"/Sample_END2.fastq.gz -S "path to the output file"

#samfiles obtained using the hisat2 can be viewed and sorted by using samtools

samtools view "samfilename"
samtools view -bS "samfilename" > "bamfile"
# -b specifies that the ouput is bam file while S specifies that the input is sam file

samtools sort "bamfile" > "sorted_bamfile"


# Performing abundance estimation
featureCounts -p -S 2 -a ../hg38/Homo_sapiens.GRCh38.106.gtf -o "path to save the counts" <"path to .sam/.bamfile">

