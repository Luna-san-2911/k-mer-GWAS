#!/bin/bash -l
#SBATCH -J kmeria_06
#SBATCH --output=kmeria_06-%j.output
#SBATCH --error=kmeria_06-%j.error
#SBATCH -t 240:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=128G

set -euo pipefail

echo "Starting at: $(date)"

#I am using column 1 and 3 as column 1 has the kmer sequence and column 3 has its p-value
#Your results may start as filtered_sample given that in step 03 you filtered the matrices and added this prefix
#.ps files are those storing the pvalue

awk '{print $1, $3}' /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/filtered_sample*.ps > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/all_kmer_chunks_variant_and_pvalue.txt

echo "kmeria 06 finished at: $(date)"
