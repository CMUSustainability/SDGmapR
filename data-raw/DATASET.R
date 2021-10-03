# Load libraries
library(tidyverse)
library(stringr)

# Load UN SDG color scheme data frame
sdg_colors <- data.frame(
  goal = c(1:17),
  color = c('#e5243b', '#DDA63A', '#4C9F38', '#C5192D', '#FF3A21', '#26BDE2',
            '#FCC30B', '#A21942', '#FD6925', '#DD1367', '#FD9D24', '#BF8B2E',
            '#3F7E44', '#0A97D9', '#56C02B', '#00689D', '#19486A')) %>%
  mutate(color = str_to_upper(color))
write.csv(sdg_colors, "datasets/sdg_colors_cleaned.csv", row.names = FALSE)

# Create data frame for SDG descriptions
sdg_desc <- data.frame(
  goal = c(1:17),
  short_desc = c("No Poverty", "Zero Hunger", "Good Health and Well-being",
                 "Quality Education", "Gender Equality", "Clean Water and Sanitation",
                 "Affordable and Clean Energy", "Decent Work and Economic Growth",
                 "Industry, Innovation and Infrastructure", "Reducing Inequality",
                 "Sustainable Cities and Communities",
                 "Responsible Consumption and Production", "Climate Action",
                 "Life Below Water", "Life On Land",
                 "Peace, Justice, and Strong Institutions",
                 "Partnerships for the Goals"),
  long_desc = c("End poverty in all its forms everywhere",
                "End hunger, achieve food security and improved nutrition and promote sustainable agriculture",
                "Ensure healthy lives and promote well-being for all at all ages",
                "Ensure inclusive and equitable quality education and promote lifelong learning opportunities for all",
                "Achieve gender equality and empower all women and girls",
                "Ensure availability and sustainable management of water and sanitation for all",
                "Ensure access to affordable, reliable, sustainable and modern energy for all",
                "Promote sustained, inclusive and sustainable economic growth, full and productive employment and decent work for all",
                "Build resilient infrastructure, promote inclusive and sustainable industrialization and foster innovation",
                "Reduce inequality within and among countries",
                "Make cities and human settlements inclusive, safe, resilient and sustainable",
                "Ensure sustainable consumption and production patterns",
                "Take urgent action to combat climate change and its impacts",
                "Conserve and sustainably use the oceans, seas and marine resources for sustainable development",
                "Protect, restore and promote sustainable use of terrestrial ecosystems, sustainably manage forests, combat desertification, and halt and reverse land degradation and halt biodiversity loss",
                "Promote peaceful and inclusive societies for sustainable development, provide access to justice for all and build effective, accountable and inclusive institutions at all levels",
                "Strengthen the means of implementation and revitalize the global partnership for sustainable development")) %>%
  mutate(long_desc = paste0(long_desc, "."))
write.csv(sdg_desc, "datasets/sdg_desc_cleaned.csv", row.names = FALSE)

# Load UN Targets
sdg_targets <- read_csv("datasets/sdg_targets_cleaned.csv") %>%
  rename(target = Target,
         target_desc = `Target Description`,
         keywords = Keywords) %>%
  mutate(goal = parse_number(sub("\\..*", "", target)),
         number = c(1:n())) %>%
  select(goal, number, target, target_desc) %>%
  arrange(goal)

# Load CMU Keywords
cmu1000_keywords_raw <- data.frame()
for (goal in 1:16) {
  # Fetch CMU keywords for one SDG
  cur_keywords <- read_csv(paste0("datasets/cmu_sdg", goal, "_keywords.csv")) %>%
    arrange(elsevier_word, desc(frequency), desc(relevance_score)) %>%
    head(1000) %>%
    mutate(weight = round(relevance_score / 50, 2)) %>%
    arrange(desc(weight)) %>%
    rename(goal = SDG) %>%
    left_join(sdg_colors, by = "goal")

  # Combine with resulting data frame
  cmu1000_keywords_raw <- rbind(cmu1000_keywords_raw, cur_keywords)
}

# Hard-code SDG17 keywords for now
cmu_sdg17_keywords <- data.frame(
  goal = 17,
  keyword = c("seminar", "independent", "research", "capacity", "development",
              "cooperation", "engagement", "thesis", "internship", "writing",
              "practicum", "entrepreneurship", "project", "innovation", "dissertation",
              "study", "client", "capstone", "experiential", "capacity development",
              "academic writing"),
  weight = 1,
  color = "19486A"
)

cmu1000_keywords <- cmu1000_keywords_raw %>%
  select(goal, keyword, weight, color) %>%
  rbind(cmu_sdg17_keywords) %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  mutate(pattern = str_replace_all(pattern, "#", ".")) %>%
  select(goal, keyword, pattern, weight, color)
write.csv(cmu1000_keywords, "datasets/cmu1000_keywords_cleaned.csv", row.names = FALSE)

cmu500_keywords <- cmu1000_keywords %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  group_by(goal) %>%
  slice_max(order_by = weight, n = 500) %>%
  ungroup() %>%
  select(goal, keyword, pattern, weight, color)
write.csv(cmu500_keywords, "datasets/cmu500_keywords_cleaned.csv", row.names = FALSE)

cmu250_keywords <- cmu1000_keywords %>%
  mutate(pattern = paste0("\\b(\\d*)", keyword, "(\\d*)\\b")) %>%
  group_by(goal) %>%
  slice_max(order_by = weight, n = 250) %>%
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
usethis::use_data(sdg_desc, overwrite = TRUE)
usethis::use_data(sdg_targets, overwrite = TRUE)
usethis::use_data(elsevier_keywords, overwrite = TRUE)
usethis::use_data(elsevier100_keywords, overwrite = TRUE)
usethis::use_data(cmu1000_keywords, overwrite = TRUE)
usethis::use_data(cmu500_keywords, overwrite = TRUE)
usethis::use_data(cmu250_keywords, overwrite = TRUE)
usethis::use_data(sdg_colors, overwrite = TRUE)
usethis::use_data(sdsn_keywords, overwrite = TRUE)


