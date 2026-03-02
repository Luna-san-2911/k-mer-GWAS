#!/bin/bash
# Local execution job: kmeria_filter
# Log files: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/03_filtered_matrices/filter_job.log, /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/03_filtered_matrices/filter_job.err

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

echo '========================================'
echo 'K-mer Matrix Filtering'
echo '========================================'

# Verify sample order consistency
if [ -f /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt ] && [ -f /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_sample_order.txt ]; then
    echo 'Checking sample order consistency...'
    if ! diff -q /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_sample_order.txt > /dev/null 2>&1; then
        echo 'WARNING: Sample order mismatch detected!'
        echo 'Count order: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt'
        echo 'KCTM order: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_sample_order.txt'
        diff /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_sample_order.txt || true
    else
        echo '✓ Sample order is consistent'
    fi
else
    echo 'WARNING: Cannot verify sample order (order files not found)'
fi
echo ''

# Filter k-mer matrix
kmeria filter -i /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices \
    -o /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/03_filtered_matrices \
    -t 32 \
    -c 1000 \
    -p 2 \
    -s 0.6 \
    --output-format compressed \
    -v \
    -d /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/depth_155Pistacia.tsv

echo 'K-mer matrix filtering completed successfully'
