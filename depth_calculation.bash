#!/bin/bash -l
#SBATCH -J depth_calculation
#SBATCH --output=depth_calculation-%A_%a.output
#SBATCH --error=depth_calculation-%A_%a.error
#SBATCH -t 24:00:00
#SBATCH --qos=munoz-b
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH --array=1-259%20

set -euo pipefail

input_dir="/blue/munoz/plunarodriguez/01_KMERIA_WGS/input/fastq"
result_dir="/blue/munoz/plunarodriguez/01_KMERIA_WGS/input/info_files/depth_results"

mkdir -p "$result_dir"

mapfile -d '' files < <(
    find -L "$input_dir" -maxdepth 1 -type f -name '*_R1.fq.gz' -print0 |
    sort -z
)

index=$((SLURM_ARRAY_TASK_ID - 1))

if (( index >= ${#files[@]} )); then
    echo "ERROR: No file exists for array index $SLURM_ARRAY_TASK_ID" >&2
    exit 1
fi

file="${files[$index]}"
sample=$(basename "$file" _R1.fq.gz)
result="$result_dir/${SLURM_ARRAY_TASK_ID}.txt"

gzip -cd -- "$file" |
awk -v sample="$sample" '
    END {
        reads = NR / 4
        kmeria_depth = (reads * 150 / 600000000) * 0.8
        printf "%s\t%.6f\t4\n", sample, kmeria_depth
    }
' > "$result"

echo "Finished: $sample"


####
#Once this finishes run this to merge the files:
#result_dir="/blue/munoz/plunarodriguez/01_KMERIA_WGS/input/info_files/depth_results"
#output="/blue/munoz/plunarodriguez/01_KMERIA_WGS/input/info_files/depth.txt"

#: > "$output"

#for i in $(seq 1 259); do
#    result="$result_dir/${i}.txt"

#    if [[ ! -s "$result" ]]; then
#        echo "ERROR: Missing or empty file: $result" >&2
#        exit 1
#    fi

#    cat "$result" >> "$output"
#done

#echo "Created $output with $(wc -l < "$output") rows."
