# k-mer-GWAS

Hola! Hi!

This repository was built as a guide to run k-mer based GWAS.
It requires as inputs: short-reads data, phenotype data, ploidy info, and sequencing depth per sample.
As output you will get of course the k-mer based GWAS manhattan plot and other files that could be useful (i.e. k-mer matrix, k-mer-vcf).

This pipeline is based on KMERIA (https://www.researchsquare.com/article/rs-7347406/v1) + some issues fixed that I found while running the pipeline + extra scripts and notes

Enjoy!

# Preparing the input files

1. Short-reads
   
3. Phenotype
4. Ploidy
5. Sequencing depth

Great! Now that you have all the input files in the correct format we can start with KMERIA

# Installation

Just follow exactly the code from KMERIA
```   
   # Clone the KMERIA repository:
   git clone https://github.com/Sh1ne111/KMERIA.git

   # To avoid GNU C++ Runtime Library conflicts, you can create a conda virtual environment to ensure all dependent libraries are installed correctly.
   conda env create -f kmeria_env.yaml
   conda activate kmeriaenv 

   # htslib
   export LD_LIBRARY_PATH=/your_path/KMERIA/lib:$LD_LIBRARY_PATH

   # Change Permissions
   chmod 755 /your_path/KMERIA/bin/*
   chmod 755 /your_path/KMERIA/external_tools/*
   chmod 755 /your_path/KMERIA/bimbamAsso/*

   #Add PATH environment
   export PATH=/your_path/KMERIA/bin:/your_path/KMERIA/bimbamAsso:/your_path/KMERIA/external_tools:$PATH


```
NOTE: For some reason some commands do not work if I do not change the permissions before. As a general rule I always activate the environemnte and then do the export and chmod before running anything

# KMERIA wrapper

This command is really useful
```perl kmeria_wrapper.pl```
It takes less than a minute and it will create all the .sh files you need for running the whole pipeline. The only thing you have to do is specify the path to your files and directories.

In addition, I created a .sbatch file to submit this job to the HPC file with further notes and specifications. You can find it here (MAKE THIS A LINK TO YOUR CODE)

# 01_Count

This purpose of this step is to count kmers of the size you specify in all the reads of all your samples.

kmeria_wrapper.pl will create a lot of count_batch_*.sh files inside your 01_kmer_counts/ directory. Each of this .sh files has one pair of samples, so as I had 155 samples, I had 77 files (the count starts from 0).

Given this, I created a .sbatch file with a loop to submit all the .sh files. You can find it here (MAKE THIS A LINK TO YOUR CODE)

As the output, you will get a .kmc_pre and .kmc_surf for each sample in the 01_kmer_counts/ directory. These are binary files storing the kmer counts.

NOTE: If there are mismatches with sample names, the .sh files will be empty or have 'sample not found', double check that all your input files follow the same sample order and name.

# 02_Kmer_matrices

This job builds matrices from the counts produced in step 01_Count.

For this step, only one .sh file was produced by kmeria_wrapper.pl which is kctm_job.sh and is located at 02_kmer_matrices/ directory.
Further details and notes of these step can be found HERE (MAKE THIS A LINK TO YOUR CODE).
In this case, and up to steo 5, the .sbatch script is only for submitting.

The output matrices will be at the 02_kmer_matrices/ directory and as binary files under the name sample_k31.*.bin. (it is k31 as I choose 31nt as the lenght of my kmers, the * are numbers)

# 03_Filter_matrices

As the directory 03_filtered_matrices/ says, the purpose of this step is to filter the matrices, retain only high quality kmers at a populational level.
Description of the filtering as further notes of this step can found here (MAKE THIS A LINK TO YOUR CODE)

You can find the filtered matrices in the 03_filtered_matrices/ directory with the same name as the matrices but with the prefix filtered_

# 04_Bimbam
