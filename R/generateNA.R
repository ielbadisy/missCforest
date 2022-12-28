
#' Generate Missing Values Completely at Random
#' 
#' Introducing a proportion of missing values given a dataframe. 
#'
#' @param dat complete data.frame.  
#' @param pmiss proportion of NA.
#' @param seed seed value to ensure reproducibility.
#'
#' @return data.frame with the desired proportion of missing values.
#' 
#' @export
#'
#' @examples
#' 
#' data(iris)
#' # introduce 30% of NA
#' irisNA <- generateNA(iris, 0.3)
#' # check the proportion of NA 
#'  mean(is.na(irisNA))

generateNA <- function(dat, pmiss = 0.2, seed = 123) {
  
  stopifnot(pmiss >= 0, pmiss <= 1, is.atomic(dat) || is.data.frame(dat))
  
  set.seed(seed)  
  
  generate_na_vec <- function(z, pmiss) {
    
    n <- length(z) 
    
    z[sample(n, floor(pmiss * n))] <- NA
    z
  } 
  
  # vector or matrix
  if (is.atomic(dat)) return(generate_na_vec(dat, pmiss))
  
  # data frame
  
  v <- if (is.null(names(pmiss))) names(dat) else intersect(names(pmiss), names(dat))
  dat[, v] <- Map(generate_na_vec, dat[, v, drop = FALSE], pmiss)
  dat
  
}

