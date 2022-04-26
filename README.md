
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SDGmapR

<!-- badges: start -->
<!-- badges: end -->

The goal of `SDGmapR` is to provide an open-source foundation for the
systematic mapping to the United Nations Sustainable Development Goals
(SDGs). In this R package one can find publicly available [SDG keyword
datasets](https://github.com/pwu97/SDGmapR/tree/main/datasets) in the
`tidy` data format, the [UN Official SDG color
scheme](https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/01/SDG_Guidelines_AUG_2019_Final.pdf)
and [SDG
Descriptions](https://github.com/pwu97/SDGmapR/blob/main/datasets/sdg_desc_cleaned.csv),
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
we will assign an equal weight of one to every word if weights are not
given. Note that the column for `SDG17` will represent whether the
dataset has keywords related to SDG17.

| Source                                                                                                                             | Dataset                | CSV                                                                                          | SDG17 |
|:-----------------------------------------------------------------------------------------------------------------------------------|:-----------------------|:---------------------------------------------------------------------------------------------|:------|
| [Core Elsevier (Work in Progress)](https://data.mendeley.com/datasets/87txkw7khs/1)                                                | `elsevier_keywords`    | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier_keywords_cleaned.csv)    | No    |
| [Improved Elsevier Top 100](https://data.mendeley.com/datasets/9sxdykm8s4/2)                                                       | `elsevier100_keywords` | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier100_keywords_cleaned.csv) | No    |
| [SDSN](https://ap-unsdsn.org/regional-initiatives/universities-sdgs/)                                                              | `sdsn_keywords`        | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/sdsn_keywords_cleaned.csv)        | Yes   |
| [CMU Top 250 Words](https://www.cmu.edu/leadership/the-provost/provost-priorities/sustainability-initiative/sdg-definitions.html)  | `cmu250_keywords`      | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/cmu250_keywords_cleaned.csv)      | No    |
| [CMU Top 500 Words](https://www.cmu.edu/leadership/the-provost/provost-priorities/sustainability-initiative/sdg-definitions.html)  | `cmu500_keywords`      | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/cmu500_keywords_cleaned.csv)      | No    |
| [CMU Top 1000 Words](https://www.cmu.edu/leadership/the-provost/provost-priorities/sustainability-initiative/sdg-definitions.html) | `cmu1000_keywords`     | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/cmu1000_keywords_cleaned.csv)     | No    |
| [University of Auckland (Work in Progress)](https://www.sdgmapping.auckland.ac.nz/)                                                | `auckland_keywords`    |                                                                                              | Yes   |
| [University of Toronto (Work in Progress)](https://data.utoronto.ca/sustainable-development-goals-sdg-report/sdg-report-appendix/) | `toronto_keywords`     |                                                                                              | Yes   |

## Example SDGMapR Usage

We can map to one SDG with the `count_sdg_keywords` function that adds
up the weights of the keywords found. We can find the keywords for one
SDG with the `tabulate_sdg_keywords` that returns the words as a vector,
which we can view in the `tidy` format by applying `unnest()` to our
result.

``` r
library(tidyverse)
library(SDGmapR)

# Load first 1000 #tidytuesday tweets
tweets <- readRDS(url("https://github.com/rfordatascience/tidytuesday/blob/master/data/2019/2019-01-01/tidytuesday_tweets.rds?raw=true")) %>%
  head(1000)

# Map to SDG 1 using Improved Elsevier Top 100 Keywords
tweets_sdg1 <- tweets %>%
  mutate(sdg_1_weight = count_sdg_weights(text, 1),
         sdg_1_words = tabulate_sdg_keywords(text, 1)) %>%
  arrange(desc(sdg_1_weight)) %>%
  select(text, sdg_1_weight, sdg_1_words)

# View SDG 1 matched keywords
tweets_sdg1 %>%
  unnest(sdg_1_words)
#> # A tibble: 100 × 3
#>    text                                                 sdg_1_weight sdg_1_words
#>    <chr>                                                       <dbl> <chr>      
#>  1 "#TidyTuesday #rstats my latest tidy tuesday submis…         33.2 poverty    
#>  2 "#TidyTuesday #rstats my latest tidy tuesday submis…         33.2 poor       
#>  3 "#TidyTuesday #rstats my latest tidy tuesday submis…         33.2 income     
#>  4 "#TidyTuesday - average income by state &amp; perce…         29.5 poverty    
#>  5 "#TidyTuesday - average income by state &amp; perce…         29.5 income     
#>  6 "#TidyTuesday - average income by state &amp; perce…         29.5 people     
#>  7 "#TidyTuesday changed state selection method! avg c…         26.6 poverty    
#>  8 "#TidyTuesday changed state selection method! avg c…         26.6 income     
#>  9 "#tidytuesday week 29\nBusiness major gives highest…         15.2 unemployme…
#> 10 "#tidytuesday week 29\nBusiness major gives highest…         15.2 employment 
#> # … with 90 more rows
```

We can map to a different set of keywords by adding an additional input
into our function, using the `cmu250` (CMU Top 250 Keywords) dataset of
SDG keywords instead of the default `elsevier1000` dataset of SDG
keywords.

``` r
# Map to SDG 3 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_weights(text, 3, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,000 × 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "Deaths per 1k people over the past ~25 years, by cause of death …      44.1 
#>  2 "Working on cancer mortality rate in the European Union. #rstats,…      38.1 
#>  3 "my 📈 for #TidyTuesday ! Boxplots really highlight the outliers,…       5.22
#>  4 "Top 5 countries with Malaria Mortality #TidyTuesday #rstats #gga…       4.63
#>  5 "Happy #TidyTuesday! Looking at the change in malaria mortality r…       4.63
#>  6 "For this week's #TidyTuesday, I looked at decrease in malaria mo…       4.63
#>  7 "#TidyTuesday week 33: Malaria deaths. Decided to stay simple. Ba…       4.28
#>  8 "D37 of #100DaysofCode. Another attempt at #TidyTuesday, playing …       4.28
#>  9 "Malaria dataset for #TidyTuesday this week. Did a bunch of explo…       4.28
#> 10 "1/2 The @R4DScommunity welcomes you to a somber week 33 of #Tidy…       4.28
#> # … with 990 more rows

# Map to SDG 5 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_weights(text, 5, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,000 × 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "#TidyTuesday week 9 submission.  Gender disparity in DC &amp; Ma…      12.6 
#>  2 "For this week's #TidyTuesday I decided to go to the point and ex…      12.0 
#>  3 "#TidyTuesday week 2. Took a look at the relationship between % o…      10.2 
#>  4 "#TidyTuesday #r4ds @thomas_mock \nHow do genders compare as work…      10.1 
#>  5 "#TidyTuesday submission for last week (oops) showing the Gender …       9.97
#>  6 "Exploring college majors and the gender pay imbalance. Overview …       9.97
#>  7 "#TidyTuesday\nNobody *had* to answer this survey did they?  Weir…       9.97
#>  8 "#TidyTuesday Gender disparity in salary for science and engineer…       9.97
#>  9 "First ever #TidyTuesday post :) Looking back at an old #week4 da…       9.97
#> 10 "Quick #TidyTuesday before bed! Looking at college majors by gend…       9.97
#> # … with 990 more rows

# Map to SDG 7 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_weights(text, 7, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,000 × 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "#TidyTuesday Week32\n\nUS Wind Turbine Data - Texas is the Wind …      13.5 
#>  2 "After a brief hiatus, I am back!\n\nWeek 32 #TidyTuesday: Using …       8.53
#>  3 "D32 of #100DaysofCode More R for Data Sciecne #rstats and took s…       8.53
#>  4 "Inspired by @drob on a @DataCamp podcast, I created a Jekyll blo…       8.53
#>  5 "Finally finished up Tardy #TidyTuesday for the wind turbine data…       8.53
#>  6 "#TidyTuesday  week 32. Midwest dominance when it comes to wind t…       6.43
#>  7 "Wind Turbines in the US: Top  5 manufacturers. #TidyTuesday #rst…       6.43
#>  8 "1/2 The @R4DScommunity welcomes you to a very windy week 32 of #…       5.5 
#>  9 "Loved the screencast 💻👨‍💻 by @drob last #tidytuesday, looking at…       5.5 
#> 10 "Bonus #TidyTuesday chart showing changes in total wind output an…       4.54
#> # … with 990 more rows
```

## Frequently Asked Questions (FAQs)

Q: What are the `cmu1000`, `cmu500`, and `cmu250` datasets? Why
![250](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;250 "250"),
![500](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;500 "500"),
and
![1000](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;1000 "1000")?

A: These are SDG keyword datasets created by Carnegie Mellon University
(CMU). The number stands for approximately how many words are in each
SDG for that dataset. For instance, for the `cmu500` dataset, we would
expect roughly
![500](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;500 "500")
words in SDG6.

Q: Is there any easy way to customize the SDG keyword dataset and add in
and my own assessment of their weights?

A: Yes! Instead of passing in one of the known SDG keyword datasets, you
can directly pass in your own SDG keyword dataset. All you have to do is
ensure that the columns match up with `goal`, `keyword`, `pattern`,
`weight`, and `color`.

Q: How were the weights generated for each keyword?

A: Very loosely, they were extrapolated from the [Elsevier SDG Keyword
weights](https://elsevier.digitalcommonsdata.com/datasets/9sxdykm8s4/2).
Using Google’s Word2Vec, we assigned the weight of each word to be a
weighted proportion of defined Elsevier keywords, or keywords that were
in Word2Vec’s dataset, based on how often they were a 100 nearest
neighbors in terms of semantic similarity.

## Acknowledgements

Thank you to Jingwen Mu and Kevin Kang from the University of Auckland
for discussions and insights about regular expression matchings with the
SDG keywords.

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
