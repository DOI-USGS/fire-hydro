library(targets)

tar_option_set(packages = c("tidyverse", "sf", "rmapshaper", "units", "arcgislayers", "tigris", "ggplot2"))

# Load function scripts
tar_source(c("01_fetch/src", "02_process/src", "03_visualize/src"))

# Load target list files
tar_source(c("01_fetch.R", "02_process.R", "03_visualize.R"))

# Define pipeline
c(p1_targets_list, p2_targets_list, p3_targets_list)
