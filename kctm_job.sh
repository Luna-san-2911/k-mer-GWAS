#!/bin/bash
# Local execution job: kmeria_kctm
# Log files: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_job.log, /gr
oup/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_job.err

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

echo '========================================'
echo 'K-mer Matrix Construction'
echo '========================================'

# Using KMC sorted k-mer databases
# Create list of sorted k-mer database files in CORRECT ORDER
# Using sample order from: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sampl
e_order.txt
if [ ! -f /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt ]; th
en
    echo 'ERROR: Sample order file not found: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/0
1_kmer_counts/sample_order.txt'
    exit 1
fi

# Generate sample list based on original order
> /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_sort_k31.list
while IFS= read -r sample; do
    kmer_file="/group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/${sample}_sort_k3
1"
    if [ -f "${kmer_file}.kmc_pre" ] && [ -f "${kmer_file}.kmc_suf" ]; then
        echo "${kmer_file}" >> /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices
/sample_sort_k31.list
    else
        echo "WARNING: K-mer files not found for sample: $sample"
        echo "Expected: ${kmer_file}.kmc_pre and ${kmer_file}.kmc_suf"
    fi
done < /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt

# Check if sample list is not empty
if [ ! -s /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_sort_k31.list ]; then
    echo 'ERROR: No sorted k-mer files found in /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts'
    exit 1
fi

echo "Found $(wc -l < /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_sort_k31.list) samples for matrix construction"

# Print sample list for verification
echo "Sample order:"
cat /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_sort_k31.list
echo ""

# Build k-mer count matrix
kmeria kctm -i /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_sort_k31.list \
    -o /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_k31 \
    -v --no-header -b 10000

# Save sample order used in kctm for verification
cat /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/sample_sort_k31.list | xargs -n1 basename | sed 's/_sort_k31$//' > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_sample_order.txt

echo 'K-mer matrix construction completed successfully'
echo 'Sample order saved to: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_sample_order.txt'
