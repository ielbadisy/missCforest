#' Ensemble Conditional Trees for Missing Data Imputation
#'
#'
#' Single imputation based on the Ensemble Conditional Trees Cforest algorithm.
#'
#' @param dat \code{data.frame} containing continuous and/or categorical variables to be imputed.
#' @param formula \code{formula} description of the imputation model. Details about imputation model specification are provided below.
#' @param ntree number of trees to grow for the forest.
#' @param minsplit minimum sum of weights in a node in order to be considered for splitting in a single tree.
#' @param minbucket minimum sum of weights in a terminal node of a single tree.
#' @param alpha statistical significance level (alpha).
#' @param cores number of cores to use or in most cases how many child processes will be run simultaneously.
#' This option is initialized at 4 to ensure fast execution.
#'
#'
#' @section Imputation model specification:
#'
#' Formula for defining the imputation model is of the form
#'
#' \code{[imputed_variables ~ predictors]}
#'
#' The variables to be imputed are specified on the left-side and
#' the predictors to be used for imputation are specified on the right-side of the formula.
#' The user can specify a customized imputation model using the formula argument.
#' By default, latter is set to  \code{[. ~ .]} which corresponds to the situation where all variables that contain missing values will be imputed by the rest of variables.
#'
#' @section Details:
#'
#' \bold{missCforest} can be used for numerical, categorical, or mixed-type data imputation.
#' Missing values are imputed through ensemble prediction using Conditional Inference
#' Trees (Ctree) as base learners (Hothorn, Hornik, and Zeileis 2006). \bold{Ctree} is a non-parametric
#' class of regression and classification trees embedding recursive partitioning into the theory
#' of conditional inference (Strasser and Weber 1999).
#' The \bold{missCforest} algorithm redefines the imputation problem as a prediction one using single imputation approach.
#' Iteratively, missing values are predicted based on the _the complete cases set updated at each iteration_.
#' No stopping criterion is pre-defined, the imputation process ends when the missing data are all imputed. This algorithm
#' is robust to outliers and gives a particular attention to the association structure between covariates (i.e. variables used for imputation) and th outcome (i.e. variable to be imputed)
#' since the recursive partitioning of Conditional Trees is based on the multiple tests procedures.
#'
#' @return complete (i.e. imputed) data.frame.
#'
#' @export
#'
#' @references
#'
#' Hothorn T, Hornik K, Zeileis A (2006). "Unbiased Recursive Partitioning: A Conditional
#' Inference Framework" Journal of Computational and Graphical Statistics, 15(3), 651–674.
#'
#' Strobl, C., Boulesteix, A. L., Zeileis, A., & Hothorn, T. (2007). Bias in random forest
#' variable importance measures: Illustrations, sources and a solution. BMC bioinformatics, 8(1), 1-21.
#'
#' Strasser H, Weber C (1999). "On the Asymptotic Theory of Permutation Statistics."
#' Mathematical Methods of Statistics, 8, 220–250.
#'
#' @import partykit

#'
#'
#' @examples
#' \donttest{

#' library(missCforest)
#'
#' # import the iris dataset
#' data(iris)
#'
#' # introduce randomly 30% of NA to variables
#' irisNA <- generateNA(iris, 0.3)
#' summary(irisNA)
#'
#' # impute all the missing values using all the possible combinations of the imputation model formula
#' irisImp <- missCforest(irisNA, .~.)
#' summary(irisImp)
#' }

missCforest <- function(dat, formula = .~., ntree = 100L,
                        minsplit = 20L, minbucket = 7L, alpha = 0.05, cores = 1){

  stopifnot(inherits(formula,"formula"))

  dat <- as.data.frame(unclass(dat),stringsAsFactors=TRUE)

  impy <- get_impy(formula, dat)
  impx <- get_impx(formula, dat)


  formulas <- paste(impy, "~", deparse(formula[[3]]))

  for (i in seq_along(impx)) {
    i_var <- impx[i]
    i_impy <- setdiff(impy, impx[i])
    formula <- paste(impx[i], "~", paste(i_impy, collapse= "+"))

    i_model <- imputer(cforest,
                       data=dat,
                       formula=as.formula(formulas[i]),
                       ntree = ntree,
                       minsplit = minsplit,
                       minbucket = minbucket,
                       alpha = alpha,
                       cores = cores,
                       na.action=na.omit)

    i_na <- is.na(dat[, i_var])

    dat[i_na, i_var] <- predict(i_model, newdata=dat[i_na,,drop=FALSE])
  }
  dat
}
