#!/bin/bash -l
#SBATCH -J kmeria_04
#SBATCH --output=kmeria_04-%j.output
#SBATCH --error=kmeria_04-%j.error
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

bash /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/04_bimbam/convert_job.sh


echo "kmeria 04 finished at: $(date)"
