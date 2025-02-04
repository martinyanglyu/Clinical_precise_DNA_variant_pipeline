# Clinical_precise_DNA_variant_pipeline (CPDV)
This is the pipeline that used for clinical precise variant calling from whole genome sequencing (will update it for whole exome sequencing late). This pipeline was tested in NF1 assoicated tumors such as Plexform and MPNST.
* Raw data : fastq files
* Samples types: Normal, tumor and PDX
* Output: Germline SNV, Germline structure variant, Somatic SNV, Somatic structure variant, Copy number variant, Clonality
* Data structure
  /storage1/fs1/hirbea/Active/           # Base directory (genomes, BAM, FASTQ folders)

```
│
├── BAM/                                # Main BAM directory (user-defined BAM_path)
│   ├── Sample1.bam                     # Original BAM file (input)
│   ├── Sample1.sorted_by_name.bam      # Name-sorted BAM file (temporary)
│   ├── Sample1_xeno.bam                # BAM file after Xenograft removal (PDX only)
│   ├── Sample1_mark_dup.bam            # BAM file after marking duplicates
│   ├── Sample1_after_BQSR.bam          # BAM file after Base Quality Score Recalibration
│   ├── Sample1.bai                     # BAM index file
│   ├── mark_dups_metrics.txt           # MarkDuplicate metrics output
│   ├── Sample1_before_bqsr.report      # BQSR report before recalibration
│   ├── Sample1_after_bqsr.report       # BQSR report after recalibration
│   ├── coord_AnalyzeCovariates.pdf     # BQSR covariate comparison plot
│   ├── Sample1_readcount.txt           # Read count output file
│   └── Readme_file_annotation.txt      # Documentation of analysis steps
│
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
 
