# Load libraries
library(tidyverse)

# Load UN SDG color scheme data frame
sdg_colors <- data.frame(
  goal = c(1:17),
  color = c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2',
            '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
            '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')) %>%
  mutate(color = str_to_upper(color))
# write.csv(sdg_colors, "datasets/sdg_colors_cleaned.csv", row.names = FALSE)

# Load CMU Keywords
cmu1000_keywords_raw <- data.frame()
for (goal in 1:16) {
  # Fetch CMU keywords for one SDG
  cur_keywords <- read_csv(paste0("datasets/cmu_sdg", goal, "_keywords.csv")) %>%
    arrange(elsevier_word, desc(frequency), desc(relevance_score)) %>%
    head(1000) %>%
    mutate(weight = relevance_score) %>%
    rename(goal = SDG) %>%
    left_join(sdg_colors, by = "goal")

  # Combine with resulting data frame
  cmu1000_keywords_raw <- rbind(cmu1000_keywords_raw, cur_keywords)
}

cmu1000_keywords <- cmu1000_keywords_raw %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  select(goal, keyword, pattern, weight, color)
write.csv(cmu1000_keywords, "datasets/cmu1000_keywords_cleaned.csv", row.names = FALSE)

cmu500_keywords <- cmu1000_keywords_raw %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  group_by(goal) %>%
  slice_max(order_by = relevance_score, n = 500) %>%
  ungroup() %>%
  select(goal, keyword, pattern, weight, color)
write.csv(cmu500_keywords, "datasets/cmu500_keywords_cleaned.csv", row.names = FALSE)

cmu250_keywords <- cmu1000_keywords_raw %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  group_by(goal) %>%
  slice_max(order_by = relevance_score, n = 250) %>%
  ungroup() %>%
  select(goal, keyword, pattern, weight, color)
write.csv(cmu250_keywords, "datasets/cmu250_keywords_cleaned.csv", row.names = FALSE)

# Load Elsevier Query keywords
elsevier_keywords_goal1 <- data.frame(
  keyword = c("poverty", "income.*", "finance.*", "distributional effect",
  "distributional effects", "child labor", "child labour", "development aid",
  "social protection", "microfinanc.*", "micro-financ.*", "resilience of the poor",
  "(?=.*(resilien.*))(?=.*poor)", "safety net", "safety nets", "economic resource",
  "economic resources", "welfare", "food bank", "food banks")) %>%
  mutate(goal = 1,
         weight = 1,
         pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b"))
elsevier_keywords <- rbind(elsevier_keywords_goal1) %>%
  left_join(sdg_colors, by = "goal") %>%
  select(goal, keyword, pattern, weight, color)
# write.csv(elsevier_keywords, "datasets/elsevier_keywords_cleaned.csv", row.names = FALSE)

# Load Elsevier Top 100 keywords
elsevier100_keywords <- read_csv("datasets/elsevier100_keywords.csv") %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  select(goal, keyword, pattern, weight, color)
# write.csv(elsevier_keywords, "datasets/elsevier100_keywords_cleaned.csv", row.names = FALSE)

# Load SDSN keywords
sdsn_keywords <- read_csv("datasets/sdsn_keywords.csv") %>%
  mutate(keyword = str_replace(keyword, "/", "|")) %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  select(goal, keyword, pattern, weight, color)
# write.csv(elsevier_keywords, "datasets/sdsn_keywords_cleaned.csv", row.names = FALSE)

# Use datasets
usethis::use_data(elsevier_keywords, overwrite = TRUE)
usethis::use_data(elsevier100_keywords, overwrite = TRUE)
usethis::use_data(cmu1000_keywords, overwrite = TRUE)
usethis::use_data(cmu500_keywords, overwrite = TRUE)
usethis::use_data(cmu250_keywords, overwrite = TRUE)
usethis::use_data(sdg_colors, overwrite = TRUE)
usethis::use_data(sdsn_keywords, overwrite = TRUE)

