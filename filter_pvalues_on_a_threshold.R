library(data.table)

# Command-line arguments
args <- commandArgs(trailingOnly = TRUE)
infile  <- args[1]             # Input file name
outfile <- args[2]             # Output prefix
threads <- as.numeric(args[3]) # Number of threads for fread
p_cut   <- as.numeric(args[4]) # P-value cutoff (e.g., 8.38e-09)

# Load only the column containing p-values
kmers <- fread(
  infile,
  nThread = threads,
  select = c(1,2),             # Adjust if your p-value column is not the 2nd column
  col.names = c("kmer", "p_wald")
)

# Ensure p-values are valid
kmers <- kmers[!is.na(p_wald) & p_wald > 0 & p_wald <= 1]

# Filter rows below cutoff
sig_kmers <- kmers[p_wald < p_cut]

# Save filtered rows to a file
fwrite(
  sig_kmers,
  file = paste0(outfile, "_significant_variants.txt"),
  sep = "\t",
  col.names = FALSE
)

# Print summary
cat("Total k-mers:", nrow(kmers), "\n")
cat("Significant k-mers (p <", p_cut, "):", nrow(sig_kmers), "\n")
