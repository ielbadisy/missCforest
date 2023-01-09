
# missCforest

`missCforest` is an Ensemble Conditional Trees algorithm for Missing
Data Imputation. It performs single imputation based on the [`Cforest`
algorithm](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-8-25)
which is an ensemble of [Conditional Inference
Trees](https://jmlr.org/papers/v16/hothorn15a.html).

The aim of `missCforest` is to produce a complete dataset using an
iterative prediction approach by predicting missing values after
learning from the complete cases.

## Installation

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
#> 1    no  70     Post    21     II      3      NA     66 1814    1
#> 2  <NA>  56     Post    12     II      7      61     77 2018    1
#> 3   yes  58     Post    35     II      9      52    271  712    1
#> 4   yes  NA     <NA>    NA     II      4      NA     29   NA    1
#> 5    no  NA     Post    NA     II      1      26     65  772    1
#> 6  <NA>  32      Pre    57    III     24      NA     13   NA    1
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
#>   horTh      age menostat    tsize tgrade pnodes  progrec estrec      time cens
#> 1    no 70.00000     Post 21.00000     II      3 88.68623     66 1814.0000    1
#> 2   yes 56.00000     Post 12.00000     II      7 61.00000     77 2018.0000    1
#> 3   yes 58.00000     Post 35.00000     II      9 52.00000    271  712.0000    1
#> 4   yes 53.31934     Post 27.15198     II      4 64.72325     29  970.5889    1
#> 5    no 56.31297     Post 25.92921     II      1 26.00000     65  772.0000    1
#> 6    no 32.00000      Pre 57.00000    III     24 48.91202     13  521.7364    1
```
