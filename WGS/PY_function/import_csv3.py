import csv
import sys
import re
import os

def extract_patient(library_name):
    library_name_substring = library_name[0:6].upper().replace("_", "-")
    return library_name_substring

def extract_common_part(fastq):
    return re.sub(r'R[12].*', '', fastq)

def classify_sample(library_name):
    library_name = library_name.upper()
    if 'PDX' in library_name:
        return 'PDX'
    elif 'CELL' in library_name or 'PB' in library_name:
        return 'CellLine' if 'CELL' in library_name else 'Normal'
    else:
        return 'Tumor'

def process_sample_data(input_file, output_path):
    # Define file paths for output
    tumor_file = os.path.join(output_path, "Samplemap_tumor.csv")
    pdx_file = os.path.join(output_path, "Samplemap_PDX.csv")

    # Get the base directory of the input file to prepend to the fastq paths
    base_dir = os.path.dirname(os.path.abspath(input_file))

    with open(input_file, mode='r') as file:
        reader = csv.DictReader(file, delimiter=',')
        
        # Prepare to write to the CSV files
        with open(tumor_file, mode='w', newline='') as tumor_outfile, \
             open(pdx_file, mode='w', newline='') as pdx_outfile:

            # Writers for each file
            tumor_writer = csv.writer(tumor_outfile)
            pdx_writer = csv.writer(pdx_outfile)

            # Write headers for each file
            tumor_writer.writerow(['patient', 'sample', 'lane', 'fastq_1', 'fastq_2'])
            pdx_writer.writerow(['patient', 'sample', 'lane', 'fastq_1', 'fastq_2'])

            # Dictionaries to hold fastq pairs for Tumor and PDX samples
            tumor_pairs = {}
            pdx_pairs = {}

            # Process each row
            for row in reader:
                fastq = row['FASTQ']
                lane = row['Flowcell Lane']
                library_name = row['Library Name'].strip()
                patient_id = extract_patient(library_name)
                sample_type = classify_sample(library_name)
                common_part = extract_common_part(fastq)

                # Key for fastq pairs (patient_id, sample_type, lane)
                key = (patient_id, sample_type, lane)

                # Initialize or update the fastq_pairs dictionary
                if 'R1' in fastq:
                    if key not in tumor_pairs and sample_type != 'PDX':
                        tumor_pairs[key] = [os.path.join(base_dir, fastq), '']
                    elif key not in pdx_pairs and sample_type == 'PDX':
                        pdx_pairs[key] = [os.path.join(base_dir, fastq), '']
                elif 'R2' in fastq:
                    if key in tumor_pairs:
                        tumor_pairs[key][1] = os.path.join(base_dir, fastq)
                    elif key in pdx_pairs:
                        pdx_pairs[key][1] = os.path.join(base_dir, fastq)

            # Write Tumor, Normal, and CellLine pairs to the tumor CSV
            for key, value in tumor_pairs.items():
                tumor_writer.writerow([key[0], key[1], key[2], value[0], value[1]])

            # Write PDX pairs to the PDX CSV
            for key, value in pdx_pairs.items():
                pdx_writer.writerow([key[0], key[1], key[2], value[0], value[1]])

    print(f"Files have been created in the output path: {output_path}")

def main():
    if len(sys.argv) < 3:
        print("Usage: python transform_samples.py <input_file_path> <output_path>")
        sys.exit(1)
    
    input_file_path = sys.argv[1]
    output_path = sys.argv[2]

    # Ensure output directory exists
    os.makedirs(output_path, exist_ok=True)

    process_sample_data(input_file_path, output_path)

if __name__ == "__main__":
    main()
