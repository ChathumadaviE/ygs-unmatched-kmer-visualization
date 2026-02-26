# ygs_unmatched_kmers_plot.R
# Visualize the proportion of single-copy unmatched kmers along chromosomes
# for male and female samples using YGS output.

library(ggplot2)
library(tidyverse)
library(grid)

#-----------------------------
# User-configurable parameters
#-----------------------------

# Paths to YGS output files (tab-delimited, no header)
# Columns are assumed to be:
#   V1 = chromosome/window ID
#   V2 = window start
#   V3 = window end
#   V4 = proportion of single-copy unmatched kmers (P_SC_UK)
ygs_male_file   <- "ygs_male.tsv"
ygs_female_file <- "ygs_female.tsv"

# Chromosome order for faceting (adjust to your genome)
chromosome_levels <- c("ChrZ", "Chr02", "WSDR")

plot_title <- "E. texana YGS analysis"
x_label    <- "Position (Mb)"
y_label    <- "Proportion of single-copy unmatched kmers per 10 kb window"

#-----------------------------
# Load data
#-----------------------------

ygsM <- read.table(ygs_male_file, header = FALSE, stringsAsFactors = FALSE)
ygsF <- read.table(ygs_female_file, header = FALSE, stringsAsFactors = FALSE)

colnames(ygsM) <- c("chr_window", "pos_start", "pos_end", "P_SC_UK")
colnames(ygsF) <- c("chr_window", "pos_start", "pos_end", "P_SC_UK")

# Add chromosome factor in desired order
ygsM$chrorder <- factor(ygsM$chr_window, levels = chromosome_levels)
ygsF$chrorder <- factor(ygsF$chr_window, levels = chromosome_levels)

# Convert window midpoint to Mb (simple example: use window end position)
ygsM <- ygsM %>%
  mutate(position_Mb = (pos_end - pos_start) / 1e6)

ygsF <- ygsF %>%
  mutate(position_Mb = (pos_end - pos_start) / 1e6)

#-----------------------------
# Combined plot
#-----------------------------

p <- ggplot() +
  geom_line(
    data = ygsM,
    aes(x = position_Mb, y = P_SC_UK),
    size = 0.8,
    color = "blue"
  ) +
  geom_line(
    data = ygsF,
    aes(x = position_Mb, y = P_SC_UK),
    size = 0.8,
    color = "red"
  ) +
  facet_wrap(~ chrorder, scales = "free_x") +
  theme_bw()

# Add labels, title, and custom “legend” text
labels <- grobTree(
  textGrob("Male",   x = 0, y = 0.95, hjust = 0,
           gp = gpar(col = "blue", fontsize = 12)),
  textGrob("Female", x = 0, y = 0.90, hjust = 0,
           gp = gpar(col = "red", fontsize = 12))
)

ygs_plot <- p +
  ggtitle(plot_title) +
  xlab(x_label) +
  ylab(y_label) +
  annotation_custom(labels) +
  ylim(0, 120)

print(ygs_plot)
