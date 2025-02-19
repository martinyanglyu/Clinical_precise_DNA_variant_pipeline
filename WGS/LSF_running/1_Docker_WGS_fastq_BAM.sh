#!/usr/bin/bash
#du -hsx .[^.]* * 2>/dev/null | sort -rh | head -10  


# Load configuration file
#CONFIG_FILE="$(dirname "$0")/config.sh"
#CONFIG_FILE="$(readlink -f "$(dirname "$0")/config.sh")"

CONFIG_FILE=$PWD/config.sh
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "Error: Config file '$CONFIG_FILE' not found!"
    exit 1
fi
 
###############################################################################################
#GATK_HOME="/storage1/fs1/hirbea/Active/MGI_240806-SR005025/gatk"
echo "GATK Home: $GATK_HOME"
export GATK_HOME
export PATH=$GATK_HOME:$PATH
# Correct path mapping for LSF_DOCKER_VOLUMES
export LSF_DOCKER_VOLUMES="/opt/thpc:/opt/thpc /scratch1/fs1/ris:/scratch1/fs1/ris /storage1/fs1/${STORAGE_ALLOCATION}/Active:/storage1/fs1/${STORAGE_ALLOCATION}/Active"
# Define a port if it is not already set (default example)
#port="8408"  # Default port, replace if necessary
#export LSF_DOCKER_PORTS="$port:$port"
export CONDA_ENVS_DIRS="/storageN/fs1/${STORAGE_ALLOCATION}/Active/conda/envs/"
export CONDA_PKGS_DIRS="/storageN/fs1/${STORAGE_ALLOCATION}/Active/conda/pkgs/"
export PATH="/opt/conda/bin:$PATH"
#################################################################################################
mkdir -p $GATK_HOME

# Print loaded configuration (for debugging)
echo "Using Reference Path: $Ref_path"

echo "Memory Allocation: $memory"
echo "Cores: $cores"

# Docker image (to be set in loop)
docker="19781121/wgs_pipeline:latest"
PATH="/opt/conda/bin:/usr/local/cuda/bin:$PATH"


# Check if docker image is provided
if [ -z "$docker" ]; then
  echo "Error: Docker image not provided. Use the -d option to specify the image."
  exit 1
fi

new_csv="${csv_file%.csv}_new.csv"
if grep -q $'\r$' "$csv_file"; then
 echo "$(tr -d '\r' < $csv_file)" > $new_csv
 echo "Converted file saved as $new_csv"
fi



tail -n +2 "$new_csv" | while IFS=$',\t' read -r specimanID org_BAM lane Lib_name fastq_1 fastq_2 individualID Tissue_type BAM_file; do 
  Outbam="${specimanID}.bam"
  echo $Outbam
  echo $org_BAM
  echo $individualID
  echo $BAM_file
  echo $Tissue_type
if [ -f "${BAM_path}/$Outbam" ]; then
    echo "BAM file $Outbam already exists. Skipping Fastq to BAM and alignment steps..."
    
 else 
  echo "bjob starting"
  echo $CONFIG_FILE
  
  bsub -cwd "$GATK_HOME" -q general -n "$cores" -M "$memory" -G compute-hirbea \
     -a "docker($docker)" -W "${timeLimit}:00" \
     -o "$GATK_HOME/output_$(date +%Y%m%d_%H%M%S)_${specimanID}_fastq_to_bam.txt" \
     -J "${specimanID}_fastq_to_bam" \
     -R "rusage[mem=$memory] span[hosts=1]" /bin/bash \
     $PY_function_path/WGS_Fastq_to_BAM_pipeline_v3.sh "$specimanID" "$org_BAM" "$lane" "$Lib_name" "$fastq_1" "$fastq_2" "$individualID" "$Tissue_type" "$BAM_file" "$CONFIG_FILE" 
  fi

done





