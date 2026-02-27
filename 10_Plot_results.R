#Pistacia kmer gwas sex-trait linear model
library(tidyverse)
library(data.table)

#Load your paf file
data4<-fread('C:/Users/lunar/OneDrive/Escritorio/Files/trait_aln.paf')

#I am filtering reads with a mapping quality of 60, which are the most confident ones, but it is up to you
data4<-data4%>%
  filter(V12==60)

#This splitting is done to retrieve the pvalue of the kmer-reads
data4$p <- sapply(strsplit(as.character(data4$V1), "_"), function(x) x[3])
data4$p<-as.numeric(data4$p)

#Setting chromosomes as factors
data4$V6<-as.factor(data4$V6)

#Histogram plot

f<-ggplot(data4,aes(x=V8,fill = V6))+
  geom_histogram(color='black')+
  labs(y='Reads',
       x='Position (bp)',
       title='Sex k-mer GWAS (Q=60) - LM')+
  facet_wrap(.~V6)+
  theme_bw()+
  theme(legend.position = "none",
      axis.text.x = element_text(angle = 45,hjust=1))

ggsave(plot=f,
       filename = 'C:/Users/lunar/Downloads/pistachio/02_Pistacia_all/kmeria/figures/distribution_sex_kmer_linear_model.png',
       height = 6,
       width = 6,
       dpi = 600)

### Manhattan plot
data4 <- data4 %>%
  filter(!is.na(p), p > 0)

data4$logp <- -log10(data4$p)

# Ensure chromosomes are ordered properly
data4$V6 <- factor(data4$V6, levels = sort(unique(data4$V6)))

# Build cumulative positions correctly
# Get chromosome lengths
chr_info <- data4 %>%
  group_by(V6) %>%
  summarise(chr_len = max(as.numeric(V8))) %>%
  arrange(V6)

# Compute cumulative offsets
chr_info <- chr_info %>%
  mutate(offset = lag(cumsum(chr_len), default = 0))

# Join offsets back to main table
data4 <- data4 %>%
  left_join(chr_info, by = "V6") %>%
  mutate(BPcum = as.numeric(V8) + offset)

# Create chromosome centers for x-axis labels
axis_df <- data4 %>%
  group_by(V6) %>%
  summarise(center = (min(BPcum) + max(BPcum)) / 2)

# Plot

manhattan_plot <- ggplot(data4,
                         aes(x = BPcum,
                             y = logp,
                             color = V6)) +
  geom_point(alpha = 0.5, size = 2) +
  scale_x_continuous(breaks = axis_df$center,
                     labels = axis_df$V6)  +
  theme_bw() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45,hjust=1)) +
  labs(x = "Chromosome",
       y = expression(-log[10](p)),
       title = "Manhattan Plot Sex k-mer GWAS - LM")

ggsave(plot=manhattan_plot,
       filename = 'C:/Users/lunar/Downloads/pistachio/02_Pistacia_all/kmeria/figures/manhattan_sex_kmer_linear_model.png',
       height = 6,
       width = 6,
       dpi = 600)
