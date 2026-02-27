#!/bin/bash -l
#SBATCH -J kmeria_07
#SBATCH --output=kmeria_07-%j.output
#SBATCH --error=kmeria_07-%j.error
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

#Be sure to have R installed in your environment
#You must specify first the R script (It is in this repository), then the merged file of the association, then the prefix you want for your output file (the whole path), then the number of threads, then the pvalue threshold (the most common is 0.05), and finally the kmer size yoou had

Rscript /home/plunarod/pistachio/code/01_Pvera/calc_gwas_threshold_new.R \
 /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/all_kmer_chunks_variant_and_pvalue.txt \
 /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/06_pvalues_thresholds_flowers/kmer_gwas_pvalue \
 32 \
 0.05 \
 31

echo "Kmeria 07 finished at: $(date)"
