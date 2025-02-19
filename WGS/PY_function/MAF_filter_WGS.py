#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to filter and annotate MAF file based on tumor and normal allele frequencies.
"""

import pandas as pd
import os
import argparse

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Filter and annotate MAF file")
    parser.add_argument("--maf_file_path", required=True, help="Path to the input MAF file")
    parser.add_argument("--normal_ID", required=True, help="Name of the normal sample type")
    parser.add_argument("--tissue_ID", required=True, help="Name of the tissue sample type")
    args = parser.parse_args()

    # Assign variables from arguments
    maf_file_path = args.maf_file_path
    normal_type = args.normal_ID
    tissue_type = args.tissue_ID

    # Determine output path
    final_path = os.path.dirname(maf_file_path)
    file_name = os.path.join(final_path, f"{tissue_type}_filtered_WGS_variants.maf")

    # Read the MAF file and process it
    print(f"Processing MAF file: {maf_file_path}")
    MAF_file = pd.read_csv (maf_file_path,sep="\t",header=1,na_filter=False,low_memory=False)
    MAF_file_mod = MAF_file.drop("AF", axis=1)
    AF_select=[ col for col in MAF_file_mod.columns if "AF" in col]
    MAF_file["MAX_AF"]=MAF_file[AF_select].max(axis=1)
    MAF_file["MAX_AF"]=MAF_file["MAX_AF"].replace(to_replace="",value=0)
    MAF_file["MAX_AF"]=MAF_file["MAX_AF"].astype("float64")

   # Filter the MAF file
    MAF_file_2=MAF_file[MAF_file['t_alt_count']!=""]
    MAF_file_3=MAF_file_2[MAF_file['t_alt_count']!="."]
    MAF_file_3=MAF_file_3[MAF_file['n_alt_count']!="."]
    MAF_file_3=MAF_file_3[MAF_file['n_alt_count']!=""]
    MAF_file_3["Tumor_AF"]=MAF_file_3["t_alt_count"].astype(int)/MAF_file_3["t_depth"].astype(int)
    MAF_file_3["Normal_AF"]=MAF_file_3["n_alt_count"].astype(int)/MAF_file_3["n_depth"].astype(int)

    MAF_filter = MAF_file_3[(MAF_file_3['t_depth'].astype(int) > 5) & 
                        (MAF_file_3["n_depth"].astype(int) > 5) & 
                        ((MAF_file_3["MAX_AF"] < 0.05) | (MAF_file_3["MAX_AF"].isnull())) &
                        (MAF_file_3["BIOTYPE"] == "protein_coding") &
                        (MAF_file_3["Tumor_AF"] > 0.05) & 
                        (MAF_file_3["Normal_AF"] < 0.05)]
    MAF_filter["Tumor_Sample_Barcode"] = tissue_type
    MAF_filter["Matched_Norm_Sample_Barcode"] = normal_type


    # Save the filtered MAF file
    print(f"Saving filtered MAF to: {file_name}")
    MAF_filter.to_csv(file_name, index=False, sep="\t")
    with open(file_name, 'r') as original: 
        data = original.read()
    with open(file_name, 'w') as modified: 
        modified.write("#version 2.4\n" + data)
    print(f"Filtered MAF file saved with version header added.")

if __name__ == "__main__":
    main()









