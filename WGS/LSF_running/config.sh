# config.sh - Configuration for WGS Pipeline


# Project Paths
Project_path="/storage1/fs1/hirbea/Active/GEM_WGS"
csv_file="$Project_path/Sample_test_1sample.csv"
#csv_file="$Project_path/TOR_tumor_sample.csv"
Paired_BAM_table="$Project_path/Paired_Bam_files.csv"
GATK_HOME="$Project_path/gatk"
 

# Compute Resource Allocation
timeLimit="168"   # Time limit in hours
memory="120G"     # Memory requirement
cores=12        # Number of cores


# Storage and Reference Paths
STORAGE_ALLOCATION="hirbea"
Ref_path="/storage1/fs1/${STORAGE_ALLOCATION}/Active/WGS_GEM_reference"
PY_function_path="/storage1/fs1/hirbea/Active/lyu.yang/PY_function"



# LSF Settings
export GATK_HOME
export PATH=$GATK_HOME:$PATH


export CONDA_ENVS_DIRS="/storageN/fs1/${STORAGE_ALLOCATION}/Active/conda/envs/"
export CONDA_PKGS_DIRS="/storageN/fs1/${STORAGE_ALLOCATION}/Active/conda/pkgs/"

# LSF Docker Volume Mapping

STORAGE_ALLOCATION="hirbea"
export LSF_DOCKER_VOLUMES="/opt/thpc:/opt/thpc /scratch1/fs1/ris:/scratch1/fs1/ris /storage1/fs1/${STORAGE_ALLOCATION}/Active:/storage1/fs1/${STORAGE_ALLOCATION}/Active"


# Base directory for reference genomes
genomes_base="/storage1/fs1/hirbea/Active/WGS_GEM_reference"
Mouse_Reference_bwa="${genomes_base}/bwa/Mus_musculus.GRCm38.dna_rm.primary_assembly.fa.gz"
Reference="Hg38"
Hg38_Reference_bwa="${genomes_base}/bwa/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta"
Hg38_Reference="${genomes_base}/resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta"
dbSNP="${genomes_base}/somatic-hg38/dbSNP_INDEL/hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf.gz"
Hg38_indels="${genomes_base}/somatic-hg38/dbSNP_INDEL/hg38_v0_Homo_sapiens_assembly38.known_indels.vcf.gz"
Mills_1000G_indels="${genomes_base}/somatic-hg38/dbSNP_INDEL/hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
Af_only_gnomad="${genomes_base}/somatic-hg38/somatic-hg38_af-only-gnomad.hg38.vcf.gz"
pon_vcf="${genomes_base}/somatic-hg38/somatic-hg38_1000g_pon.hg38.vcf.gz"
interval_list="${genomes_base}/resources_broad_hg38_v0_wgs_calling_regions.hg38.interval_list"
interval_bed="${genomes_base}/resources_broad_hg38_v0_wgs_calling_regions.hg38.bed"
interval_bed_gz="${genomes_base}/resources_broad_hg38_v0_wgs_calling_regions.hg38.bed.gz"
Hg38_Reference_dict="${genomes_base}/resources_broad_hg38_v0_Homo_sapiens_assembly38.dict"
cache_vep_dir="${genomes_base}/vep"




#if [ ! -f "$interval_bed" ]; then
#  /gatk/gatk IntervalListToBed -I "$interval_list" -O "$interval_bed"
#  bgzip -f "$interval_bed"
#  tabix -f "${interval_bed}.gz"
#fi
