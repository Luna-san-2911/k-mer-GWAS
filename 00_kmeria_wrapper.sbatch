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
#Samples is a .txt file with only one column and the name of the samples, no header
#Depth file should have no headers, samples in col1, depth in col2 and ploidy in col3
#Phenotype file requires to specify col1, when you have your samples ID in col1, and the phenotype in col2

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
