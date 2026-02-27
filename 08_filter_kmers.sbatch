#!/bin/bash -l
#SBATCH -J kmeria_08
#SBATCH --output=kmeria_08-%j.output
#SBATCH --error=kmeria_08-%j.error
#SBATCH -t 240:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128G

set -euo pipefail

echo "Starting at: $(date)"

#Again, double check if you have R installed as well as the required packages. 1st specify the R script, then the association merged file, then the output file, then the number of threads, and finally the pvalue threshold that you will use

Rscript /home/plunarod/pistachio/code/01_Pvera/filter_pvalues_on_a_threshold.R \
 /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/all_kmer_chunks_variant_and_pvalue.txt \
 /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/06_pvalues_thresholds_flowers/kmer_gwas_pvalue_filtered_bonferroni_threshold \
 32 \
 1.03e-10
