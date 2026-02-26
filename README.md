# YGS unmatched kmer visualization in R

This repository contains an R script to visualize the proportion of
single-copy unmatched kmers along chromosomes for male and female
samples using YGS output.

The script reads tab-delimited YGS result files for males and females,
then generates a faceted line plot showing the signal along each
chromosome.

## Files

- `ygs_unmatched_kmers_plot.R`  
  Main R script to load YGS output, process it, and generate the plot.

- `ygs_male.tsv`, `ygs_female.tsv` (optional example files)  
  Example YGS outputs with the expected column structure (you can
  replace these with your own data).

## Expected input format

Each YGS file should be a tab-delimited text file without a header,
with four columns:

1. `V1` – chromosome/window identifier (e.g., `ChrZ`, `Chr02`, `WSDR`)  
2. `V2` – window start position (bp)  
3. `V3` – window end position (bp)  
4. `V4` – proportion of single-copy unmatched kmers (`P_SC_UK`)  

The script renames these columns to:

- `chr_window`, `pos_start`, `pos_end`, `P_SC_UK`

and adds a `chrorder` factor for faceting.

## Requirements

- R (version 3.0+)
- Packages:
  - `ggplot2`
  - `tidyverse`
  - `grid`

Install packages (if needed):

```r
install.packages("ggplot2")
install.packages("tidyverse")
