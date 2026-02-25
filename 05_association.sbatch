#!/bin/bash -l
#SBATCH -J kmeria_05
#SBATCH --output=kmeria_05-%j.output
#SBATCH --error=kmeria_05-%j.error
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
#Do not run this in a directory that doesn't has a lot of space, the output files will fill it
#Run it in gmonroegrp2

bash /group/gmonroegrp2/chaehee/Pablo/pistachio_pop_analysis/02_Pistacia_all/kmeria/05_association/asso_job.sh

echo "kmeria 05 finished at: $(date)"
