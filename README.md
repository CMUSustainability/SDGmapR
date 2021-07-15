
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SDGmapR

<!-- badges: start -->
<!-- badges: end -->

The goal of `SDGmapR` is to provide an open-source foundation for the
systematic mapping to the United Nations Sustainable Development Goals
(SDGs). In this R package are popular publicly available SDG keyword
datasets in the `tidy` data format for use in data anaylsis, the United
Nations Official SDG color scheme, and several functions related to the
mapping of text to particular sets of keywords.

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
given.

| Source                                                                                                          | Dataset                |
|:----------------------------------------------------------------------------------------------------------------|:-----------------------|
| [Elsevier](https://data.mendeley.com/datasets/87txkw7khs/1)                                                     |                        |
| [Improved Elsevier](https://data.mendeley.com/datasets/9sxdykm8s4/2)                                            | `elsevier100_keywords` |
| [SDSN](https://ap-unsdsn.org/regional-initiatives/universities-sdgs/)                                           | `sdsn_keywords`        |
| [University of Auckland](https://www.sdgmapping.auckland.ac.nz/)                                                | `auckland_keywords`    |
| [University of Toronto](https://data.utoronto.ca/sustainable-development-goals-sdg-report/sdg-report-appendix/) | `toronto_keywords`     |

## Example SDGMapR Usage

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
