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

   
   # For source code installations
 #  cd /your_path/KEMRIA/
 #  make && make install
 #  make clean
```
NOTE: For some reason some commands do not work if I do not change the permissions before. As a general rule I always activate the environemnte and then do the export and chmod before running anything

# KMERIA wrapper

This command is really useful, it takes less than a minute and it will create all the scripts you need for running the whole pipeline. The only thing you have to do is specify the path to your files and directories.

I created a .sbatch file with further notes and specifications of this step. You can find it here (MAKE THIS A LINK TO YOUR CODE)

# 01_
