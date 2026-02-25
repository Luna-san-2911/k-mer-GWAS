#!/bin/bash -l
#SBATCH -J kmeria_02
#SBATCH --output=kmeria_02-%j.output
#SBATCH --error=kmeria_02-%j.error
#SBATCH -t 240:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G

set -euo pipefail

echo "Starting at: $(date)"

bash /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/02_kmer_matrices/kctm_job.sh

echo "kmeria 02 finished at: $(date)"
