#' @import stats

# extract the predictors from the formula
get_impy <- function(formula, dat){
  x <- colnames(attr(terms(formula, data=dat),"factors"))
  if (!is.null(x)) gsub("`(.*?)`","\\1",x) else x
}


# extract the outcome to be imputed from the formula
get_impx <- function(formula, dat){
  if (length(formula) < 3) return(character(0))
  formula[[3]] <- formula[[2]]
  formula[[2]] <- 1
  x <- colnames(attr(terms(formula, data=dat),"factors"))
  if (!is.null(x)) gsub("`(.*?)`","\\1",x) else x
}


# run the imputation model (i.e. imputer)
imputer <- function(fun, ...){
  args <- list(...)
  tryCatch(do.call(fun,args), error = function(e){
    p <- all.vars(list(...)[[1]])[[1]]
    a <- deparse(sys.call(-4L)[[2]])
  })
}
