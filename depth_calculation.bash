for file in *_R1.fq.gz; do
    [[ -e "$file" ]] || continue

    sample=${file%_R1.fq.gz}
    reads=$(gzip -cd -- "$file" | awk 'END {printf "%.0f", NR/4}')
    kmeria_depth=$(awk -v reads="$reads" \
        'BEGIN {printf "%.6f", (reads * 150 / 600000000) * 0.8}')

    printf "%s\t%s\n" "$sample" "$kmeria_depth" >> "kmeria_depth.txt"
done
