#!/bin/bash -l
#SBATCH -J kmeria_wrapper
#SBATCH --output=kmeria_wrapper-%j.output
#SBATCH --error=kmeria_wrapper-%j.error
#SBATCH -t 23:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=32G

set -euo pipefail

echo "Running on host: $(hostname)"
echo "Starting at: $(date)"

#Input is directory to fastq files
#Output is a directory were the scripts and directories will be created, eventually they will have the files produced by the pipeline
#Samples is a .txt file with only one column with the name of the samples, no header
#Depth file should have no headers, samples in col1, depth in col2 and ploidy in col3
#Phenotype file requires to specify 1, when you have your samples names in col1, and the phenotype in col2

#The path you see here to kmeria_wrapper follows where I cloned the github repository
#My output directory had memory space. Take this into account as kmer-matrices and bimbam result big files

#Threads specify the number of threads for the next jobs. With 32 threads and 155 paired end WGS samples I could run the full Kmeria pipeline in 1 day
#I reccomend using kmc as it is better for big dataset such as the one I had
#--min-abund and --max-abund are set to filter kmers abundance. However, when using kmc --max-abund does not filter, it just counts until 1000. If you want to get rid of repetitive regions you can later edit the 03_filter step
#As you can see trhe --pheno-col says 1. It works like this, even if in my ohentoyoe file the phenotype is in the second column and the samples names in column 1
#Bimbam-tools was useful to run a linear mixed model gwas and is faster. If you want to use gemma you have to create .bed files which takes some time.

perl /home/plunarod/KMERIA/scripts/kmeria_wrapper.pl --step all \
  --input /group/gmonroegrp2/chaehee/Pablo/pistachio/raw_reads/all_155samples \
  --output /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria \
  --samples /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/samples_155Pistacia.txt \
  --threads 32 \
  --kmer 31 \
  --min-abund 5 \
  --max-abund 1000 \
  --batch-size 2 \
  --use-kmc \
  --kmc-memory 32 \
  --ploidy 2 \
  --depth-file /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/depth_155Pistacia.tsv \
  --pheno /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/flower_phenotype_kmeria_155Pistacia.txt \
  --pheno-col 1 \
  --use-bimbam-tools

echo "kmeria finished at: $(date)"
