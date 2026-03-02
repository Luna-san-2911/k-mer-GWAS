#!/bin/bash
# Local execution job: kmeria_asso
# Log files: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/asso_job.log, /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/asso_job.err

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

echo '========================================'
echo 'Association Analysis'
echo '========================================'

# Generate PCA for covariates
echo 'Calculating PCA...'
plink --bfile /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling \
    --allow-extra-chr \
    --allow-no-sex \
    --pca 20 \
    --out /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/pca/samplPCA

# Format PCA output as covariate file
cat /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/pca/samplPCA.eigenvec | awk '{print $1,$2,"1",$3,$4,$5}' > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/pca/PCA.txt

# Calculate kinship matrix using bimbamKin
echo 'Calculating kinship matrix...'
bimbamKin /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/sampling.bimbam \
    /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/kinship/sampling.BN.kinMat \
    -b -d 10

# Generate sample list file for bimbamAsso
echo 'Generating sample list...'
if [ -f /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt ]; then
    echo 'Using original sample order from: /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt'
    cat /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/sample_order.txt | awk '{print $1,$1}' > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/sample.list
else
    echo 'WARNING: Using depth file for sample order'
    cut -f1 /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/depth_155Pistacia.tsv | awk '{print $1,$1}' > /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/sample.list
fi

# Run association analysis
echo 'Running association analysis...'
kmeria asso --tool bimbamAsso \
    -i /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam \
    -p /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/filtered/flower_phenotype_kmeria_155Pistacia.txt \
    -n 1 \
    -o /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association \
    -t 32 \
    --verbose \
    --bimbam-gzip \
    --out-precision 5 \
    -s /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/sample.list \
    -c /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/pca/PCA.txt \
    -k /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/kinship/sampling.BN.kinMat \
    2>&1 | tee /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/asso.log

echo 'Association analysis completed successfully'
