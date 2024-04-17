# Installation of Packages
Install.packages(“fastqcr”)

if (!require(“BiocManager”, quietly = TRUE))
    install.packages(“BiocManager”)
  BiocManager::install(“Rhisat2”)

BiocManager::install(“Rsubread”)

# loading Libraries
library(fastqcr)
library(“Rhisat2”)
library(Rsubread)

# Running FASTQC to check the quality of each fastq file 

fastqc.install()
fastqc(fq.dir = “path to the fastq directory“, qc.dir = “path where to save the qc reports“)
qc <- qc_aggregate(qc.dir = “path where to save the qc reports“)

# Checking if the quality check is passed or failed and storing the failed files into a seperate folder so that trimming can be run on only those files later on
for (i in c(seq(2,nrow(qc),11))){
  if (qc[i,]$status == “FAIL”){
     file.copy(from = paste0(“PATH OF THE FILES”, qc[i,]$sample, “.fastq.gz”), to = “path where yo want to save the failed files”)
  } else {file.copy(from = paste0(“PATH OF THE FILES”, qc[i,]$sample, “.fastq.gz”), to = “path where yo want to save the passed files”)
}

# Run trimmomatic for trimming using the command line (file - RNASeq-Pipeline.sh)

# Run mapping on the files which passed the QC
# strsplit is done to get the only the exact sample name from my file names, that does not need to be done if you want to save your files with the exact name as the fastq files.
  
files_list = list.files("path to the files passed the qc", pattern = "\\.fastq.gz")
sequences = list()
for (i in strsplit(files_list, split = ' ')){
  sequences = append(sequences, paste0("path to the files passed the qc", i))
}
for(i in c(seq(1,length(sequences),2))){
  hisat2(sequences = sequences[i:(i+1)], index = "path to reference genome file" , type = "paired",  outfile = paste0("path where save the mapping file/Sample_",strsplit(sequences[i],"_")[[1]][2],".sam"))
}


# Running abundance estimation using subread

mapped_list = list.files("path to the folder with mapping files")
sequences = list()
for (i in strsplit(mapped_list," ")){
  sequences = append(sequences, paste0("path to the folder with mapping files", i))
}
for (i in sequneces){
  step4_counts <- featureCounts(i, isGTFAnnotationFile = TRUE, annot.ext = "path to the annot file (Homo_sapiens.GRCh38.106.gtf)" , primaryOnly = TRUE, 
                                GTF.attrType = "gene_id", isPairEnded = TRUE, nthreads = 4, countMultiMappingReads = FALSE, countReadPairs = FALSE)
  write.csv(step4_counts$counts, paste0("path where to save the counts files", i, "_counts"))
  write.csv(step4_counts$annotation, paste0("path where to save the counts files", i, "_annotation"))
  write.csv(step4_counts$stat, paste0("path where to save the counts files", i,"_stat"))
}

