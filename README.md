# RNA-seq-Pipeline

RNA sequencing is used to learn more about which genes are expressed (turned on) in different types of cells and when and how these genes are expressed.

<p align="center">
  <img src="RNAworkflow.png" width="300" height="400" alt="Alt Text">
</p>

## What is FASTQ format ?
The FASTQ files have 4 lines for each sequence :
1.	A sequence identifier with information about the sequencing run and the cluster. The exact contents of this line vary by based on the BCL to FASTQ conversion software used.
2.	The sequence (the base calls; A, C, T, G and N).
3.	A separator, which is simply a plus (+) sign.
4.	The base call quality scores. These are Phred +33 encoded, using ASCII characters to represent the numerical quality scores.

<p align="center">
  <img src="FASTQ file.png" width="600" height="200" alt="Alt Text">
</p>




