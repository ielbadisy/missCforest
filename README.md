
# missCforest

`missCforest` is an Ensemble Conditional Trees algorithm for Missing
Data Imputation. It performs single imputation based on the `Cforest`
algorithm.

The goal of `missCforest` is to produce a complete dataset using an
iterative prediction approach by predicting missing values by learning
from the complete cases.

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
# import the iris dataset 
data(iris)

# introduce randomly 30% of NA to variables
irisNA <- generateNA(iris, 0.3)
summary(irisNA)
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
#>  Min.   :4.400   Min.   :2.000   Min.   :1.000   Min.   :0.100  
#>  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
#>  Median :5.700   Median :3.000   Median :4.200   Median :1.400  
#>  Mean   :5.805   Mean   :3.018   Mean   :3.696   Mean   :1.268  
#>  3rd Qu.:6.400   3rd Qu.:3.200   3rd Qu.:5.100   3rd Qu.:1.900  
#>  Max.   :7.900   Max.   :4.100   Max.   :6.700   Max.   :2.500  
#>  NA's   :45      NA's   :45      NA's   :45      NA's   :45     
#>        Species  
#>  setosa    :34  
#>  versicolor:36  
#>  virginica :35  
#>  NA's      :45  
#>                 
#>                 
#> 
```

You can impute all the missing values using all the possible
combinations of the imputation model formula:

``` r
irisImp <- missCforest(irisNA, .~.)  
summary(irisImp)
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width    
#>  Min.   :4.400   Min.   :2.000   Min.   :1.000   Min.   :0.1000  
#>  1st Qu.:5.425   1st Qu.:2.900   1st Qu.:1.700   1st Qu.:0.5296  
#>  Median :5.982   Median :3.007   Median :4.256   Median :1.3641  
#>  Mean   :5.858   Mean   :3.054   Mean   :3.756   Mean   :1.2422  
#>  3rd Qu.:6.100   3rd Qu.:3.277   3rd Qu.:5.100   3rd Qu.:1.8000  
#>  Max.   :7.900   Max.   :4.100   Max.   :6.700   Max.   :2.5000  
#>        Species  
#>  setosa    :50  
#>  versicolor:51  
#>  virginica :49  
#>                 
#>                 
#> 
```
