#!/bin/bash -l
#SBATCH -J kmeria_09
#SBATCH --output=kmeria_09-%j.output
#SBATCH --error=kmeria_09-%j.error
#SBATCH -t 240:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=256G

set -euo pipefail

echo "Starting at: $(date)"

# Define the association results file
assoc_file="/group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/06_pvalues_thresholds_flowers/kmer_gwas_pvalue_filtered_bonferroni_threshold_significant_variants.txt"

# Create a FASTA file from significant k-mers (assumes header line)
# We extract the k-mer (column 1) and its p-value (column 2 in result file, it had only the significant kmers)

awk '{printf ">asso_kmer%d_%s\n%s\n", NR, $2, $1}' "$assoc_file" > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/sigkmer.assoc.fasta

# Extract reads containing significant k-mers from each sample reads, it handles paired end
# 31 is the kmer length

KMERFASTA=/group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/sigkmer.assoc.fasta

for r1 in /group/gmonroegrp2/chaehee/Pablo/pistachio/raw_reads/all_155samples/*_R1.fq.gz; do
    sample=$(basename "$r1" _R1.fq.gz)
    r2="/group/gmonroegrp2/chaehee/Pablo/pistachio/raw_reads/all_155samples/${sample}_R2.fq.gz"
    outprefix=/group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/"${sample}_sigkmer_asso"

    echo "Processing $sample ..."
    kmeria fkr \
          $r1 \
          $r2 \
          $KMERFASTA \
          31 \
          $outprefix
done

# Merge all extracted read files
# Note: Ensure the glob '*' only matches the intended files

cat /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/*_sigkmer_asso_R1.fastq.gz > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/trait_assoc_R1.fastq
cat /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/*_sigkmer_asso_R2.fastq.gz > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/trait_assoc_R2.fastq

# Map the associated reads to the linear genome
REF=/group/gmonroegrp2/chaehee/Pablo/pistachio/genome_sequence/Pvera_Kerman_RefGen_v1.fasta

minimap2 -x sr \
         -t 64 \
         $REF \
         /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/trait_assoc_R1.fastq \
         /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/trait_assoc_R2.fastq \
         -o /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/07_map_kmer_to_linear_genome_flower/trait_aln.paf

echo "Kmeria 09 finished at: $(date)"
