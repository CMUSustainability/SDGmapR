# Load libraries
library(tidyverse)

# Load UN SDG color scheme
sdg_colors <- data.frame(
  goal = c(1:17),
  color = c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2',
            '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
            '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')
) %>%
  mutate(color = str_to_upper(color))

# Load Elsevier Query keywords
elsevier_keywords_goal1 <- data.frame(
  keyword = c("poverty", "income.*", "finance.*", "distributional effect",
  "distributional effects", "child labor", "child labour", "development aid",
  "social protection", "microfinanc.*", "micro-financ.*", "resilience of the poor",
  "(?=.*(resilien.*))(?=.*poor)", "safety net", "safety nets", "economic resource",
  "economic resources", "welfare", "food bank", "food banks")
) %>%
  mutate(goal = 1,
         weight = 1)
elsevier_keywords <- rbind(elsevier_keywords_goal1) %>%
  left_join(sdg_colors, by = "goal") %>%
  select(goal, keyword, weight, color)
# write.csv(elsevier_keywords, "datasets/elsevier_keywords.csv", row.names = FALSE)

# Load Elsevier Top 100 keywords
elsevier100_keywords <- read_csv("datasets/elsevier100_keywords.csv") %>%
  select(goal, keyword, weight, color)

# Load SDSN keywords
sdsn_keywords <- read_csv("datasets/sdsn_keywords.csv") %>%
  mutate(keyword = str_replace(keyword, "/", "|")) %>%
  select(goal, keyword, weight, color)

# Load Core Elsevier keywords
elsevier_keywords <- data.frame() %>%
  left_join(sdg_colors, by = "goal")

# Use datasets
usethis::use_data(elsevier_keywords, overwrite = TRUE)
usethis::use_data(elsevier100_keywords, overwrite = TRUE)
usethis::use_data(sdg_colors, overwrite = TRUE)
usethis::use_data(sdsn_keywords, overwrite = TRUE)

