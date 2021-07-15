library(tidyverse)

count_goal <- Vectorize(function(text, goal_num, keywords="elsevier2",
                       count_repeats=FALSE) {
    # Initalize total weight
    tot_weight <- 0

    # Select the right keyword set
    if (keywords == "elsevier2") {
      goal_df <- elsevier2_keywords %>%
        filter(goal == goal_num)
    } else if (keywords == "sdsn") {
      goal_df <- sdsn_keywords %>%
        filter(goal == goal_num)
    }

    # Get the keywords and weights
    goal_keywords <- goal_df %>% select(keyword) %>% pull(1)
    goal_weights <- goal_df %>% select(weight) %>% pull(1)

    # Add up the keyword weights
    for (idx in 1:nrow(goal_df)) {
      if (str_detect(text, paste0("\\b", goal_keywords[idx], "\\b"))) {
        if (count_repeats) {
          keyword_cnt <- str_count(text, paste0("\\b", goal_keywords[idx], "\\b"))
          tot_weight <- tot_weight + keyword_cnt * goal_weights[idx]
        } else {
          tot_weight <- tot_weight + goal_weights[idx]
        }
      }
    }

    return (as.numeric(tot_weight))
})

count_goals <- function(text, keywords="elsevier2",
                       count_repeats=FALSE) {
  tot_weight <- 0
  return (as.numeric(tot_weight))
}
