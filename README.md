# Precise DNA Variant Calling (PDVC)
This is the pipeline that used for precise DNA variant calling from whole genome sequencing (will update it for whole exome sequencing late). This pipeline was tested in complex variant tumors such as  NF1 assoicated tumors: Plexform and MPNST.
* Raw data : fastq files
* Samples types: Normal, tumor and PDX
* Output: Germline SNV, Germline structure variant, Somatic SNV, Somatic structure variant, Copy number variant, Clonality
* Input Data structure
  
```
│
├── BAM/                                # Main BAM directory (user-defined BAM_path)
├── Fastq/                              # FASTQ output directory (extracted from BAM)
│   ├── Sample1_R1.fastq                # Forward reads
│   ├── Sample1_R2.fastq                # Reverse reads
│
└── Reference_Genomes/                  # Reference genome files
    ├── bwa/
    ├── hg38/
    ├── mm10/
    └── ...
```
# Whole genome sequencing data analysis (GEM data, need details and link)
1. Data downloaded from EGA
2. Make Samplemap based on this template
 
