#!/usr/bin/bash

# Assign arguments to variables
specimanID="$1"
org_BAM="$2"
lane="$3"
Lib_name="$4"
f1="$5"
f2="$6"
individualID="$7"
Tissue_type="$8"
BAM_file="$9"
BAM_bai=${BAM_file%.bam}.bai

BAM_path=$(dirname $BAM_file)
Config_file="${10}"
source "$Config_file"

# Check if the input file exists
if [[ ! -f "$Paired_BAM_table" ]]; then
    bash $PY_function_path/Samplemap_to_pairedbam.sh $csv_file $Paired_BAM_table
  
fi


docker="19781121/strelka2-manta:v4"
# Path settings
PATH="/opt/conda/bin:/usr/local/cuda/bin:$PATH"

# Read the CSV file row-by-row, skipping the header
tail -n +2 "$Paired_BAM_table" | while IFS=$'\t' read -r tumor_BAM normal_BAM variant_calling_out individualID
do 
  #port=$((port + 1))
  job_name="${tumor_BAM}_Variant_calling"
  Variant_calling_path=$variant_calling_out
  Final_path="$Variant_calling_path/Variant_calling_MAF"
  tumor_sample_name=$(basename "$tumor_BAM" .bam)
  MAF=${Final_path}/${tumor_sample_name}_filtered_WGS_variants.maf
  if bjobs -J "$job_name" 2>/dev/null | grep -q -e "RUN" -e "PEND"; then
     echo "Job $job_name is already running or pending. Skipping..."
  else 
   if [ ! -f $MAF ]; then
    echo "variant calling is starting"
    echo "Current port is: $port" 
    bsub -cwd "$GATK_HOME" -q general -n "$cores" -M "$memory" -G compute-hirbea \
       -a "docker($docker)" -W "${timeLimit}:00" \
       -o "$GATK_HOME/output_$(date +%Y%m%d_%H%M%S)_${tumor_BAM}_Variant_calling.txt" \
       -J "$job_name" \
       -R "span[hosts=1] rusage[mem=$memory]" /bin/bash $PY_function_path/mutect2_strelka_v1.sh "$tumor_BAM" "$normal_BAM" "$variant_calling_out" "$Config_file"
    else 
     echo "MAF file exists"
    fi
  fi
   # Increment the port by 1
  
 
    echo "-------------------------"
done


