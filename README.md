
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
devtools::install_github("CMUSustainability/SDGmapR")
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
  select(text) %>%
  head(1000) %>%
  mutate(text = str_to_lower(text))

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
#>  1 "#tidytuesday #rstats my latest tidy tuesday submis…         33.2 poverty    
#>  2 "#tidytuesday #rstats my latest tidy tuesday submis…         33.2 poor       
#>  3 "#tidytuesday #rstats my latest tidy tuesday submis…         33.2 income     
#>  4 "#tidytuesday - average income by state &amp; perce…         29.5 poverty    
#>  5 "#tidytuesday - average income by state &amp; perce…         29.5 income     
#>  6 "#tidytuesday - average income by state &amp; perce…         29.5 people     
#>  7 "#tidytuesday changed state selection method! avg c…         26.6 poverty    
#>  8 "#tidytuesday changed state selection method! avg c…         26.6 income     
#>  9 "#tidytuesday week 29\nbusiness major gives highest…         15.2 unemployme…
#> 10 "#tidytuesday week 29\nbusiness major gives highest…         15.2 employment 
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
#>  1 "deaths per 1k people over the past ~25 years, by cause of death …      44.1 
#>  2 "working on cancer mortality rate in the european union. #rstats,…      38.1 
#>  3 "my 📈 for #tidytuesday ! boxplots really highlight the outliers,…       5.22
#>  4 "top 5 countries with malaria mortality #tidytuesday #rstats #gga…       4.63
#>  5 "happy #tidytuesday! looking at the change in malaria mortality r…       4.63
#>  6 "for this week's #tidytuesday, i looked at decrease in malaria mo…       4.63
#>  7 "#tidytuesday week 33: malaria deaths. decided to stay simple. ba…       4.28
#>  8 "d37 of #100daysofcode. another attempt at #tidytuesday, playing …       4.28
#>  9 "malaria dataset for #tidytuesday this week. did a bunch of explo…       4.28
#> 10 "1/2 the @r4dscommunity welcomes you to a somber week 33 of #tidy…       4.28
#> # … with 990 more rows

# Map to SDG 5 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_weights(text, 5, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,000 × 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "#tidytuesday week 9 submission.  gender disparity in dc &amp; ma…      12.6 
#>  2 "for this week's #tidytuesday i decided to go to the point and ex…      12.0 
#>  3 "#tidytuesday week 2. took a look at the relationship between % o…      10.2 
#>  4 "#tidytuesday #r4ds @thomas_mock \nhow do genders compare as work…      10.1 
#>  5 "#tidytuesday submission for last week (oops) showing the gender …       9.97
#>  6 "exploring college majors and the gender pay imbalance. overview …       9.97
#>  7 "#tidytuesday\nnobody *had* to answer this survey did they?  weir…       9.97
#>  8 "#tidytuesday gender disparity in salary for science and engineer…       9.97
#>  9 "first ever #tidytuesday post :) looking back at an old #week4 da…       9.97
#> 10 "quick #tidytuesday before bed! looking at college majors by gend…       9.97
#> # … with 990 more rows

# Map to SDG 7 using Elsevier Core keywords
tweets %>%
  mutate(sdg_weight = count_sdg_weights(text, 7, "cmu250")) %>%
  select(text, sdg_weight) %>%
  arrange(desc(sdg_weight))
#> # A tibble: 1,000 × 2
#>    text                                                               sdg_weight
#>    <chr>                                                                   <dbl>
#>  1 "#tidytuesday week32\n\nus wind turbine data - texas is the wind …      13.5 
#>  2 "after a brief hiatus, i am back!\n\nweek 32 #tidytuesday: using …       8.53
#>  3 "d32 of #100daysofcode more r for data sciecne #rstats and took s…       8.53
#>  4 "inspired by @drob on a @datacamp podcast, i created a jekyll blo…       8.53
#>  5 "finally finished up tardy #tidytuesday for the wind turbine data…       8.53
#>  6 "#tidytuesday  week 32. midwest dominance when it comes to wind t…       6.43
#>  7 "wind turbines in the us: top  5 manufacturers. #tidytuesday #rst…       6.43
#>  8 "1/2 the @r4dscommunity welcomes you to a very windy week 32 of #…       5.5 
#>  9 "loved the screencast 💻👨‍💻 by @drob last #tidytuesday, looking at…       5.5 
#> 10 "bonus #tidytuesday chart showing changes in total wind output an…       4.54
#> # … with 990 more rows
```

We can map course descriptions as well. Below, we show the package being
used to map the CMU course descriptions from Fall 2022 to the SDGs.

``` r
# Create dataframe of CMU course descriptions from Fall 2022
classes <- readxl::read_excel("datasets/cmu_f22_course_info.xlsx") %>%
  rename(semester = `Semester`,
         course_title = `Course Title`,
         course_num = `Course Number`,
         course_desc = `Course Description`) %>% 
  mutate(course_dept = substr(course_num, 1, 2),
         course_level = substr(course_num, 3, 5),
         course_level_specific = substr(course_num, 3, 3)) %>%
  mutate(text = paste(str_to_lower(course_title), str_to_lower(course_desc))) %>%
  # Clean the punctuation
  mutate(text = gsub("[^[:alnum:]['-]", " ", text)) %>%
  arrange(desc(semester)) %>%
  distinct(course_num, .keep_all = TRUE) %>%
  # Only select 5% of courses for the purposes of this Markdown file
  sample_frac(0.05)

# Perform the mapping
all_sdg_keywords <- data.frame()
for (goal_num in 1:17) {
  classes %>%
    mutate(goal = goal_num,
           keyword = tabulate_sdg_keywords(text, goal_num, keywords = "cmu250")) %>%
    unnest(keyword) -> cur_sdg_keywords
  
  all_sdg_keywords <- rbind(all_sdg_keywords, cur_sdg_keywords) 
}
all_sdg_keywords %>%
  left_join(cmu250_keywords, by = c("goal", "keyword")) %>%
  select(keyword, weight, semester, course_num, goal, color) %>%
  arrange(course_num) -> all_sdg_keywords

# View mapped keywords dataset
all_sdg_keywords
#> # A tibble: 938 × 6
#>    keyword       weight semester course_num  goal color  
#>    <chr>          <dbl> <chr>    <chr>      <dbl> <chr>  
#>  1 students        4.15 F22      05333          4 #C5192D
#>  2 learning        3.64 F22      05333          4 #C5192D
#>  3 skills          3.49 F22      05333          4 #C5192D
#>  4 student         1.13 F22      05333          4 #C5192D
#>  5 semester        0.67 F22      05333          4 #C5192D
#>  6 language        0.47 F22      05333          4 #C5192D
#>  7 development     0.59 F22      05333          8 #A21942
#>  8 technological   0.43 F22      05333          8 #A21942
#>  9 skills          0.41 F22      05333          8 #A21942
#> 10 environment     0.41 F22      05333          8 #A21942
#> # … with 928 more rows
```

## Frequently Asked Questions (FAQs)

Q: What are the `cmu1000`, `cmu500`, and `cmu250` datasets? Why 250,
500, and 1000?

A: These are SDG keyword datasets created by Carnegie Mellon University
(CMU). The number indicates approximately how many words are in each SDG
for that dataset. For instance, for the `cmu500` dataset, we would
expect roughly 500 words in SDG6. We initially created the dataset
`cmu1000` to represent the dataset with roughly 1000 words for each SDG,
and then we took the top 250 and 500 words based on keyword weight to
generate `cmu250` and `cmu500`.

Q: Is there any easy way to customize the SDG keyword dataset and add in
and my own assessment of their weights?

A: Yes! Instead of passing in one of the known SDG keyword datasets, you
can directly pass in your own SDG keyword dataset. All you have to do is
ensure that the columns match up with `goal`, `keyword`, `pattern`,
`weight`, and `color`.

Q: How were the weights generated for each keyword?

A: Very loosely, they were interpolated from the [Elsevier SDG Keyword
weights](https://elsevier.digitalcommonsdata.com/datasets/9sxdykm8s4/2).
Using Google’s Word2Vec, we assigned the weight of each word to be a
weighted proportion of defined Elsevier keywords, or keywords that were
in Word2Vec’s dataset, based on how often they were a 100 nearest
neighbors in terms of semantic similarity.

Q: Why didn’t you use compound expressions like “poverty AND economic
resources or”poverty AND (disaster OR disaster area)“?

A: We have attempted to use compound expressions for SDG mapping, but
found that in practice, the specific compound expressions for SDG
mapping were few and far between. For instance, when we tried to use
compound expressions for SDG mapping using [Elsevier’s newly released
dataset](https://figshare.com/articles/dataset/Keywords_and_search_strings_for_generating_SDG_training_sets/17294255),
we found that very few course descriptions had specific compound
expression matchings. Thus, we used keyword weights instead.

Q: Words like “student”, “semester”, and “homework” seem like very
general SDG4 keywords when mapping to SDG4. When mapping to course
descriptions, wouldn’t this tag almost every course with SDG4?

A: Yes. Thus, we filtered out words that were too general among course
descriptions. The specific list of words we excluded for SDG4 mapping in
mapping to course descriptions are: “education”, “educational”,
“school”, “schools”, “student”, “students”, “teaching”, “learning”,
“apprenticeship”, “skill”, “skills”, “curriculum”, “teachers”,
“trainees”, “trainee”, “teacher”, “classroom”, “educators”, “math”,
“classrooms”, “educator”, “graduates”, “diploma”, “undergraduates”,
“undergrad”, “course”, “mathematics”, “achievement”, “courses”,
“elementary”, “academic”, “training”, “pupils”, “undergraduate”,
“college”, “colleges”, “learners”, “algebra”, “reading”,
“comprehension”, “achievements”, “universities”, “faculty”,
“internship”, “principal”, “internships”, “career”, “maths”, “adult”,
“principals”, “curricula”, “grad”, “biology”, “university”, “semester”,
“scholars”, “literacy”, “exam”, “exams”, “tutoring”, “literacy”,
“syllabus”, “instructor”, “instructors”, “degree”, “classes”,
“language”, “science”, “instruction”, “campus”, “homework”,
“instructional”, “curricular”, “humanities”, “mentoring”, “teach”,
“employment”, “qualifications”, “coursework”, “graduate”.

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
