#!/bin/bash
# Local execution job: kmeria_m2b
# Log files: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/convert_job.log, /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/convert_job.err

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

echo '========================================'
echo 'Converting to BIMBAM Format'
echo '========================================'

# Convert k-mer matrices to BIMBAM format
kmeria m2b --in /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/03_filtered_matrices \
    --out /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam \
    --threads 32 \
    --bgzf-threads 16 \
    --quantile-norm \
    --verbose \
    --stats

# Create a sketch sample for PCA and kinship calculation
kmeria sketch /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/*.bimbam.gz -n 8000000 > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling.bimbam

# Generate sample list from original sample order
if [ -f /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt ]; then
    echo 'Using original sample order from: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt'
    cp /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/tmp_sample.list
else
    echo 'WARNING: Original sample order not found, using depth file'
    cut -f1 /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/depth_155Pistacia.tsv | sort | uniq > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/tmp_sample.list
fi

# Convert BIMBAM to VCF format
kmeria b2g -i /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling.bimbam \
    -s /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/tmp_sample.list \
    --no-validate \
    -o /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling.vcf

# Convert VCF to PLINK binary format
plink --vcf /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling.vcf \
    --make-bed \
    --out /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling

echo 'Conversion to BIMBAM format completed successfully'
