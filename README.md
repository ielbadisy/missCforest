
# missCforest

`missCforest` is an Ensemble Conditional Trees algorithm for Missing
Data Imputation. It performs single imputation based on the [`Cforest`
algorithm](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-8-25)
which is an ensemble of [Conditional Inference
Trees](https://jmlr.org/papers/v16/hothorn15a.html).

The aim of `missCforest` is to produce a complete dataset using an
iterative prediction approach by predicting missing values after
learning from the complete cases.

## Installing

You can install the development version of `missCforest` as follow:

``` r
#install.packages("devtools")
devtools::install_github("ielbadisy/missCforest")
```

## Examples

``` r
library(missCforest)
#> Loading required package: partykit
#> Loading required package: grid
#> Loading required package: libcoin
#> Loading required package: mvtnorm

# import the GBSG2 dataset
library(TH.data)
#> Loading required package: survival
#> Loading required package: MASS
#> 
#> Attaching package: 'TH.data'
#> The following object is masked from 'package:MASS':
#> 
#>     geyser
data("GBSG2")

# consider the cens variable as a factor
GBSG2$cens <- as.factor(GBSG2$cens)

# introduce randomly 30% of NA to variables
datNA <- missForest::prodNA(GBSG2, 0.2)
head(datNA)
#>   horTh age menostat tsize tgrade pnodes progrec estrec time cens
#> 1    no  70     Post    21     II      3      NA     NA 1814 <NA>
#> 2   yes  56     Post    12     II      7      NA     77 2018 <NA>
#> 3   yes  58     <NA>    35     II     NA      52    271  712 <NA>
#> 4   yes  NA     Post    17   <NA>      4      60     NA   NA    1
#> 5  <NA>  NA     <NA>    NA     II     NA      26     65  772    1
#> 6    no  32      Pre    57    III     24       0     13  448 <NA>
```

You can impute all the missing values using all the possible
combinations of the imputation model formula:

``` r
impdat <- missCforest(datNA, .~., 
                      ntree = 300L,
                      minsplit = 20L,
                      minbucket = 7L,
                      alpha = 0.05,
                      cores = 4)  
head(impdat)
#>   horTh      age menostat    tsize tgrade    pnodes  progrec    estrec     time
#> 1    no 70.00000     Post 21.00000     II  3.000000 107.2613 188.43849 1814.000
#> 2   yes 56.00000     Post 12.00000     II  7.000000 115.5780  77.00000 2018.000
#> 3   yes 58.00000     Post 35.00000     II  5.829284  52.0000 271.00000  712.000
#> 4   yes 57.86864     Post 17.00000     II  4.000000  60.0000  77.58405 1051.515
#> 5    no 51.75196     Post 30.54075     II  5.685274  26.0000  65.00000  772.000
#> 6    no 32.00000      Pre 57.00000    III 24.000000   0.0000  13.00000  448.000
#>   cens
#> 1    0
#> 2    0
#> 3    1
#> 4    1
#> 5    1
#> 6    1
```

## Citing

To cite `missCforest` in publications please use:

> El Badisy I (2023). *missCforest: Ensemble Conditional Trees for
> Missing Data Imputation*. R package version 0.0.8,
> <https://CRAN.R-project.org/package=missCforest>.

A BibTeX entry for LaTeX users is

``` bibtex
  @Manual{,
    title = {missCforest: Ensemble Conditional Trees for Missing Data Imputation},
    author = {Imad {El Badisy}},
    year = {2023},
    note = {R package version 0.0.8},
    url = {https://CRAN.R-project.org/package=missCforest},
  }
```

## Contributing

-   If you encounter any bugs or have an idea for contribution, please
    [submit an issue](https://github.com/ielbadisy/missCforest/issues).

-   Please include a
    [reprex](https://reprex.tidyverse.org/articles/articles/learn-reprex.html)
    for reproducibility.
