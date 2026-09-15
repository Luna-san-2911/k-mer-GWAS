#!/bin/bash -l
#SBATCH -J depth_calculation
#SBATCH --output=depth_calculation-%j.output
#SBATCH --error=depth_calculation-%j.error
#SBATCH -t 1:00:00
#SBATCH --qos=munoz
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G

set -euo pipefail

echo "Running on host: $(hostname)"
echo "Starting at: $(date)"

input_dir="/blue/munoz/plunarodriguez/01_KMERIA_WGS/input/fastq"
output="/blue/munoz/plunarodriguez/01_KMERIA_WGS/input/info_files/depth.txt"

for file in "$input_dir"/*_R1.fq.gz; do
    sample=$(basename "$file" _R1.fq.gz)

    gzip -cd -- "$file" |
        awk -v sample="$sample" \
            'END {
                reads = NR / 4
                kmeria_depth = (reads * 150 / 600000000) * 0.8
                printf "%s\t%.6f\t4\n", sample, kmeria_depth
            }' >> "$output"
done

echo "depth calculation finished at: $(date)"
