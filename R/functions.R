library(tidyverse)

#' @title Count SDG keywords in a given text
#'
#' @description Determine the total weights of all SDG keywords that exist in a given text
#' for a given goal.
#'
#' @param text The target text to check SDG keywords
#' @param goal_num The SDG goal we intend to check keywords for
#' @param keywords The specific data set from which to draw keywords (ex. "elsevier", "sdsn")
#' @param count_repeats Whether or not to count repeats for the keywords
#'
#' @return A number representing the weight of words for an SDG
#'
#' @examples
#' count_goal("Poverty entails more than the lack of income and productive resources
#' to ensure sustainable livelihoods.", 1)
count_sdg_keywords <- Vectorize(function(text, goal_num, keywords="elsevier100",
                       count_repeats=FALSE) {
    # Initalize total weight
    tot_weight <- 0

    # Select the right keyword set
    if (keywords == "elsevier100") {
      goal_df <- elsevier100_keywords %>%
        filter(goal == goal_num)
    } else if (keywords == "sdsn") {
      goal_df <- sdsn_keywords %>%
        filter(goal == goal_num)
    } else if (keywords == "elsevier") {
      goal_df <- elsevier_keywords %>%
        filter(goal == goal_num)
    } else if (keywords == "cmu250") {
      goal_df <- cmu250_keywords %>%
        filter(goal == goal_num)
    } else if (keywords == "cmu500") {
      goal_df <- cmu500_keywords %>%
        filter(goal == goal_num)
    } else if (keywords == "cmu1000") {
      goal_df <- cmu1000_keywords %>%
        filter(goal == goal_num)
    }

    # Get the keywords and weights
    goal_keywords <- goal_df %>% select(keyword) %>% pull(1)
    goal_weights <- goal_df %>% select(weight) %>% pull(1)

    # Add up the keyword weights
    for (idx in 1:nrow(goal_df)) {
      if (str_detect(str_to_lower(text), goal_keywords[idx])) {
        if (count_repeats) {
          keyword_cnt <- str_count(str_to_lower(text), goal_keywords[idx])
          tot_weight <- tot_weight + keyword_cnt * goal_weights[idx]
        } else {
          tot_weight <- tot_weight + goal_weights[idx]
        }
      }
    }

    return (as.numeric(tot_weight))
})

#' @title Count SDGs keywords in a given text
#'
#' @description Determine the total weights of all SDGs keywords that exist in a given text
#' for a given goal.
#'
#' @param text The target text to check SDGs keywords
#' @param keywords The specific data set from which to draw keywords (ex. "elsevier", "sdsn")
#' @param count_repeats Whether or not to count repeats for the keywords
#'
#' @return A number representing the weight of words for all SDGs
#'
#' @examples
#' count_sdgs_keywords("Poverty entails more than the lack of income and productive resources
#' to ensure sustainable livelihoods.")
count_sdgs_keywords <- function(text, keywords="elsevier2",
                       count_repeats=FALSE) {
  tot_weight <- 0
  for (goal in 1:16) {
    tot_weight <- tot_weight + count_sdg_keywords(str_to_lower(text), goal, keywords,
                                                  count_repeats)
  }
  return (as.numeric(tot_weight))
}

################ Tabulate functions ################

#' @title Tabulate SDG keywords in a given text
#'
#' @description Tabulate all SDG keywords that exist in a given text
#' for a given goal.
#'
#' @param text The target text to check SDG keywords
#' @param goal_num The SDG goal we intend to check keywords for
#' @param keywords The specific data set from which to draw keywords (ex. "elsevier", "sdsn")
#' @param count_repeats Whether or not to count repeats for the keywords
#'
#' @return A vector of keywords representing a particular SDG
#'
#' @examples
#' tabulate_sdg_keywords("Poverty entails more than the lack of income and productive resources
#' to ensure sustainable livelihoods.", 1)
tabulate_sdg_keywords <- Vectorize(function(text, goal_num, keywords="elsevier100",
                                         count_repeats=FALSE) {

  # Select the right keyword set
  if (keywords == "elsevier100") {
    goal_df <- elsevier100_keywords %>%
      filter(goal == goal_num)
  } else if (keywords == "sdsn") {
    goal_df <- sdsn_keywords %>%
      filter(goal == goal_num)
  } else if (keywords == "elsevier") {
    goal_df <- elsevier_keywords %>%
      filter(goal == goal_num)
  } else if (keywords == "cmu250") {
    goal_df <- cmu250_keywords %>%
      filter(goal == goal_num)
  } else if (keywords == "cmu500") {
    goal_df <- cmu500_keywords %>%
      filter(goal == goal_num)
  } else if (keywords == "cmu1000") {
    goal_df <- cmu1000_keywords %>%
      filter(goal == goal_num)
  }

  # Get the keywords and weights
  goal_keywords <- goal_df %>% select(keyword) %>% pull(1)
  goal_weights <- goal_df %>% select(weight) %>% pull(1)

  words <- c()
  # Get keywords in a vector
  for (idx in 1:nrow(goal_df)) {
    if (str_detect(str_to_lower(text), goal_keywords[idx])) {
      words <- c(words, goal_keywords[idx])
    }
  }

  return (as.vector(words))
})

### Map to SDG weights
map_sdgs_weights <- function(df, keywords="elsevier100", count_repeats=FALSE) {
  new_df <- df %>%
    mutate(`SDG1` = count_sdg_keywords(text, 1, keywords, count_repeats),
           `SDG2` = count_sdg_keywords(text, 2, keywords, count_repeats),
           `SDG3` = count_sdg_keywords(text, 3, keywords, count_repeats),
           `SDG4` = count_sdg_keywords(text, 4, keywords, count_repeats),
           `SDG5` = count_sdg_keywords(text, 5, keywords, count_repeats),
           `SDG6` = count_sdg_keywords(text, 6, keywords, count_repeats),
           `SDG7` = count_sdg_keywords(text, 7, keywords, count_repeats),
           `SDG8` = count_sdg_keywords(text, 8, keywords, count_repeats),
           `SDG9` = count_sdg_keywords(text, 9, keywords, count_repeats),
           `SDG10` = count_sdg_keywords(text, 10, keywords, count_repeats),
           `SDG11` = count_sdg_keywords(text, 11, keywords, count_repeats),
           `SDG12` = count_sdg_keywords(text, 12, keywords, count_repeats),
           `SDG13` = count_sdg_keywords(text, 13, keywords, count_repeats),
           `SDG14` = count_sdg_keywords(text, 14, keywords, count_repeats),
           `SDG15` = count_sdg_keywords(text, 15, keywords, count_repeats),
           `SDG16` = count_sdg_keywords(text, 16, keywords, count_repeats))
  return (new_df)
}

map_sdgs_keywords <- function(df, keywords="elsevier100", count_repeats=FALSE) {
  new_df <- df
  return (new_df)
}

