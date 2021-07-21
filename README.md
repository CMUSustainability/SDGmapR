
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SDGmapR

<!-- badges: start -->
<!-- badges: end -->

The goal of `SDGmapR` is to provide an open-source foundation for the
systematic mapping to the United Nations Sustainable Development Goals
(SDGs). In this R package one can find publicly available SDG keyword
datasets in the `tidy` data format, the [2019 UN Official SDG color
scheme](https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/01/SDG_Guidelines_AUG_2019_Final.pdf),
and several functions related to the mapping of text to particular sets
of keywords.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("pwu97/SDGmapR")
```

## Publicly Available SDG Keywords

The table below lists publicly available SDG keywords that have been
published online. Some of the lists have weights associated with every
keyword, while some do not. For the purposes of the `SDGmapR` package,
we will assign an equal weight of 1.0 to every word if weights are not
given. Note that some datasets cover SDG 17, while some do not.

| Source                                                                                                                             | Dataset                | CSV                                                                                  | SDG17 |
|:-----------------------------------------------------------------------------------------------------------------------------------|:-----------------------|:-------------------------------------------------------------------------------------|:------|
| [Core Elsevier (Work in Progress)](https://data.mendeley.com/datasets/87txkw7khs/1)                                                | `elsevier_keywords`    | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier_keywords.csv)    | No    |
| [Improved Elsevier Top 100](https://data.mendeley.com/datasets/9sxdykm8s4/2)                                                       | `elsevier100_keywords` | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier100_keywords.csv) | No    |
| [SDSN](https://ap-unsdsn.org/regional-initiatives/universities-sdgs/)                                                              | `sdsn_keywords`        | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/sdsn_keywords.csv)        | Yes   |
| [University of Auckland (Work in Progress)](https://www.sdgmapping.auckland.ac.nz/)                                                | `auckland_keywords`    |                                                                                      | Yes   |
| [University of Toronto (Work in Progress)](https://data.utoronto.ca/sustainable-development-goals-sdg-report/sdg-report-appendix/) | `toronto_keywords`     |                                                                                      | Yes   |

## Example SDGMapR Usage

We can map to one SDG with the `count_sdg_keywords` function that adds
up the weights of the keywords found. We can find the keywords for one
SDG with the `tabulate_sdg_keywords` that returns the words as a vector,
which we can view in the `tidy` format by applying `unnest()` to our
result.

``` r
library(tidyverse)
library(SDGmapR)

# Load first 100 #tidytuesday tweets
tweets <- read_rds(url("https://github.com/rfordatascience/tidytuesday/blob/master/data/2019/2019-01-01/tidytuesday_tweets.rds?raw=true")) %>%
  head(10000)

# Map to SDG 1 using Improved Elsevier Top 100 Keywords
tweets_sdg1 <- tweets %>%
  mutate(sdg_1_weight = count_sdg_keywords(text, 1),
         sdg_1_words = tabulate_sdg_keywords(text, 1)) %>%
  arrange(desc(sdg_1_weight)) %>%
  select(text, sdg_1_weight, sdg_1_words)

# View SDG 1 matched keywords
tweets_sdg1 %>%
  unnest(sdg_1_words)
#> # A tibble: 537 x 3
#>    text                                                 sdg_1_weight sdg_1_words
#>    <chr>                                                       <dbl> <chr>      
#>  1 My first #tidytuesday submission, week 5. Pretty ba…         41.8 poverty    
#>  2 My first #tidytuesday submission, week 5. Pretty ba…         41.8 unemployme…
#>  3 My first #tidytuesday submission, week 5. Pretty ba…         41.8 employment 
#>  4 My first #tidytuesday submission, week 5. Pretty ba…         41.8 income     
#>  5 #TidyTuesday #rstats my latest tidy tuesday submiss…         33.2 poverty    
#>  6 #TidyTuesday #rstats my latest tidy tuesday submiss…         33.2 poor       
#>  7 #TidyTuesday #rstats my latest tidy tuesday submiss…         33.2 income     
#>  8 #TidyTuesday - average income by state &amp; percen…         29.5 poverty    
#>  9 #TidyTuesday - average income by state &amp; percen…         29.5 income     
#> 10 #TidyTuesday - average income by state &amp; percen…         29.5 people     
#> # … with 527 more rows
```

We can map to a different set of keywords by adding an additional input
into our function, using the `cmu250` (CMU Top 250 Keywords) dataset of
SDG keywords instead of the default `elsevier1000` dataset of SDG
keywords.

``` r
# Map to SDG 3 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_keywords(text, 3, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,565 x 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "The differences if regions of UK were most interesting - notice …          8
#>  2 "Deaths per 1k people over the past ~25 years, by cause of death …          7
#>  3 "Over time, the causes of death change -- but to all countries ch…          7
#>  4 "I forgot to mention, I also used data from #TidyTuesday Week 4 i…          4
#>  5 "Cancer-related and Diabetes-related mortality in India has follo…          4
#>  6 "Happy #TidyTuesday! Looking at the change in malaria mortality r…          3
#>  7 "My #TidyTuesday submission. Looking at cause of death with the l…          3
#>  8 "#tidytuesday getting back into the keywords game this week with …          2
#>  9 "#TidyTuesday, #r4ds, @thomas_mock \nNo animation this week (I di…          2
#> 10 "Malaria dataset for #TidyTuesday this week. Did a bunch of explo…          2
#> # … with 1,555 more rows

# Map to SDG 5 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_keywords(text, 5, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,565 x 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "#TidyTuesday showing the Top 10 Female occupations and their mal…          6
#>  2 "#TidyTuesday #r4ds @thomas_mock \nHow do genders compare as work…          5
#>  3 "My first #TidyTuesday submission! Investigating college major in…          5
#>  4 "More #TidyTuesday. Gender pay gap vs. (1) total compensation by …          5
#>  5 "#tidytuesday getting back into the keywords game this week with …          4
#>  6 "#TidyTuesday week 2. Took a look at the relationship between % o…          4
#>  7 "#TidyTuesday I see many similar approaches. I first looked at th…          4
#>  8 "For this week's #TidyTuesday I decided to go to the point and ex…          4
#>  9 "Need plans for Tuesday 11th December? \nRedCat Digital and Habit…          3
#> 10 "Have some ⏳ during the holiday/weekend and want to hone your #rs…          3
#> # … with 1,555 more rows

# Map to SDG 7 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_keywords(text, 7, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,565 x 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "#TidyTuesday Week32\n\nUS Wind Turbine Data - Texas is the Wind …          6
#>  2 "#TidyTuesday  week 32. Midwest dominance when it comes to wind t…          5
#>  3 "Wind Turbines in the US: Top  5 manufacturers. #TidyTuesday #rst…          5
#>  4 "Took a look at voter turnout data for Week 28 of #TidyTuesday. M…          5
#>  5 "1/2 The @R4DScommunity welcomes you to a very windy week 32 of #…          4
#>  6 "Finally finished up Tardy #TidyTuesday for the wind turbine data…          4
#>  7 "#tidytuesday Very interesting dataset on Invasive Species threat…          4
#>  8 "I just love dark plots in ggplot2. Graph 1 is a network graph of…          3
#>  9 "After a brief hiatus, I am back!\n\nWeek 32 #TidyTuesday: Using …          3
#> 10 "D32 of #100DaysofCode More R for Data Sciecne #rstats and took s…          3
#> # … with 1,555 more rows
```

<!-- What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so: -->
<!-- ```{r cars} -->
<!-- summary(cars) -->
<!-- ``` -->
<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this. You could also use GitHub Actions to re-render `README.Rmd` every time you push. An example workflow can be found here: <https://github.com/r-lib/actions/tree/master/examples>. -->
<!-- You can also embed plots, for example: -->
<!-- ```{r pressure, echo = FALSE} -->
<!-- plot(pressure) -->
<!-- ``` -->
<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN. -->
