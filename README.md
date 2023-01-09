
# missCforest

`missCforest` is an Ensemble Conditional Trees algorithm for Missing
Data Imputation. It performs single imputation based on the [`Cforest`
algorithm](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-8-25)
which is an ensemble of [Conditional Inference
Trees](https://cran.r-project.org/web/packages/partykit/vignettes/ctree.pdf).

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
#> 1    no  70     Post    21     II      3      48     NA 1814    1
#> 2  <NA>  56     Post    12     II      7      61     77   NA    1
#> 3   yes  58     Post    35     II      9      52    271   NA <NA>
#> 4   yes  59     <NA>    17     II      4      60     29   NA    1
#> 5    no  73     Post    35     II      1      26     65  772 <NA>
#> 6    no  32      Pre    NA    III     24       0     13  448    1
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
#>   horTh age menostat    tsize tgrade pnodes progrec   estrec      time cens
#> 1    no  70     Post 21.00000     II      3      48 167.7129 1814.0000    1
#> 2    no  56     Post 12.00000     II      7      61  77.0000  702.0501    1
#> 3   yes  58     Post 35.00000     II      9      52 271.0000  970.1270    1
#> 4   yes  59     Post 17.00000     II      4      60  29.0000 1136.3656    1
#> 5    no  73     Post 35.00000     II      1      26  65.0000  772.0000    1
#> 6    no  32      Pre 41.20225    III     24       0  13.0000  448.0000    1
```
