## code to prepare `DATASET` dataset goes here

library(tidyverse)

# Load Elsevier keywords
elsevier_keywords <- read_csv("datasets/elsevier_keywords.csv")

# Load UN SDG color scheme
sdg_colors <- data.frame(
  goal = c(1:17),
  color = c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2',
            '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
            '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')
)

# Load SDSN keywords
sdsn_keywords <- read_csv("datasets/sdsn_keywords.csv")

# Use datasets
usethis::use_data(elsevier_keywords, overwrite = TRUE)
usethis::use_data(sdsn_keywords, overwrite = TRUE)
usethis::use_data(sdg_colors, overwrite = TRUE)
