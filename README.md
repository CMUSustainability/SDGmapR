
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

| Source                                                                                                          | Dataset              | CSV                                                                               | SDG\_17 |
|:----------------------------------------------------------------------------------------------------------------|:---------------------|:----------------------------------------------------------------------------------|:--------|
| [Elsevier](https://data.mendeley.com/datasets/87txkw7khs/1)                                                     |                      |                                                                                   | NO      |
| [Improved Elsevier](https://data.mendeley.com/datasets/9sxdykm8s4/2)                                            | `elsevier2_keywords` | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier_keywords.csv) | NO      |
| [SDSN](https://ap-unsdsn.org/regional-initiatives/universities-sdgs/)                                           | `sdsn_keywords`      | [Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/sdsn_keywords.csv)     | YES     |
| [University of Auckland](https://www.sdgmapping.auckland.ac.nz/)                                                | `auckland_keywords`  |                                                                                   | YES     |
| [University of Toronto](https://data.utoronto.ca/sustainable-development-goals-sdg-report/sdg-report-appendix/) | `toronto_keywords`   |                                                                                   | YES     |

## Example SDGMapR Usage

``` r
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
#> ✓ tibble  3.1.0     ✓ dplyr   1.0.5
#> ✓ tidyr   1.1.3     ✓ stringr 1.4.0
#> ✓ readr   1.4.0     ✓ forcats 0.5.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(SDGmapR)

# Load first 100 #tidytuesday tweets
tweets <- read_rds(url("https://github.com/rfordatascience/tidytuesday/blob/master/data/2019/2019-01-01/tidytuesday_tweets.rds?raw=true")) %>%
  head(100)

# Map to SDG 1
tweets %>%
  mutate(sdg_1_weight = count_sdg_keywords(text, 1)) %>%
  select(text, sdg_1_weight)
#> # A tibble: 100 x 2
#>    text                                                             sdg_1_weight
#>    <chr>                                                                   <dbl>
#>  1 "#tidytuesday getting back into the keywords game this week wit…         5.45
#>  2 "#tidytuesday despite what they say NY hotdog stands have some …         0   
#>  3 "I realize it's a Sunday night but I wasn't too happy with my l…         0   
#>  4 "@thomas_mock Maybe a shorter one line subtitle, like \"Weekly …         3.53
#>  5 "#BeckyG #TidyTuesday https://t.co/2gMf6QLVz1"                           0   
#>  6 "#ArianaGrande #thankunext #TidyTuesday https://t.co/2g3ZrEbZIL"         0   
#>  7 "The @R4DScommunity welcomes you to week 38 of #TidyTuesday!  W…         0   
#>  8 "#r4ds community, please vote on a #TidyTuesday hex-sticker! \n…         0   
#>  9 "The @R4DScommunity welcomes you to week 37 of #TidyTuesday!  W…         0   
#> 10 "@jschwabish @jsonbaik @awunderground Hey @jschwabish this is a…         3.53
#> # … with 90 more rows

# Map to all SDGs
tweets %>%
  mutate(`sdg_total_weight` = count_sdgs_keywords(text)) %>%
  select(text, sdg_total_weight)
#> # A tibble: 100 x 2
#>    text                                                         sdg_total_weight
#>    <chr>                                                                   <dbl>
#>  1 "#tidytuesday getting back into the keywords game this week…            73.2 
#>  2 "#tidytuesday despite what they say NY hotdog stands have s…             8.1 
#>  3 "I realize it's a Sunday night but I wasn't too happy with …            11.8 
#>  4 "@thomas_mock Maybe a shorter one line subtitle, like \"Wee…            11.2 
#>  5 "#BeckyG #TidyTuesday https://t.co/2gMf6QLVz1"                           0   
#>  6 "#ArianaGrande #thankunext #TidyTuesday https://t.co/2g3ZrE…             0   
#>  7 "The @R4DScommunity welcomes you to week 38 of #TidyTuesday…             5.63
#>  8 "#r4ds community, please vote on a #TidyTuesday hex-sticker…             0   
#>  9 "The @R4DScommunity welcomes you to week 37 of #TidyTuesday…             0   
#> 10 "@jschwabish @jsonbaik @awunderground Hey @jschwabish this …             7.24
#> # … with 90 more rows
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
