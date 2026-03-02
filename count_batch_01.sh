#!/bin/bash -l
#SBATCH -J kmeria_01
#SBATCH --output=kmeria_01-%j.output
#SBATCH --error=kmeria_01-%j.error
#SBATCH -t 240:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G

set -euo pipefail

#Be aware that your sequence files should be ID_R1.fq.gz, if you have other labeling or it does not matches your sample list, it will not work
#And always specify the paths as mentioned in kmeria pipeline before running anything

echo "Starting at: $(date)"

S="/group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/01_kmer_counts/count_batch_*.sh"

# Loop over all scripts and submit each
for script in $S; do
    echo "Submitting $script..."
    bash "$script"
done

echo "kmeria 01 finished at: $(date)"
