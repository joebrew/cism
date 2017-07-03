#' Simplify a categorical variable
#' 
#' Simplify the levels of an over-leveled factor by combining small levels. 
#' @param var The factor or character vector to be simplified
#' @param n The number of desired levels
#' @param other What to replace elements whose counts are not in the top n with
#' @param empty_as_other Whether to count empty (ie, "") elements as other
#' @return A factor vector of identical length as var
#' @export

simplify <- function(var, n = 10, other = NA, empty_as_other = FALSE){
  var <- as.character(var)
  if(empty_as_other){
    var[which(var == '')] <- other
  }
  x <- as.data.frame(table(var)) 
  if(!is.null(nrow(x))){
    x <- x[rev(order(x$Freq)),]
    keeps <- x$var[1:n]
    var <- ifelse(var %in% keeps, var, other)
    var <- factor(var)
  }
  return(var)
}