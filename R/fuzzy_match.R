#' Fuzzy match
#'
#' Use approximate string matching to assign "similarity" scores to
#' potentially mis-entered data
#' @param x A character string
#' @param y A character string with which to match
#' if \code{NULL}, x will be used
#' @return A named matrix of similarity scores
#' @import stringdist
#' @export

fuzzy_match <- function(x,
                        y = NULL){

  # If no y, use x
  if(is.null(y)){
    y <- x
  }

  # Make evrything lower case
  x <- tolower(x)
  y <- tolower(y)

  # Generate placeholder for results
  results_matrix <- matrix(NA,
                           nrow = length(x),
                           ncol = length(y))

  # Calculate distance by row
  for (i in 1:nrow(results_matrix)){
    distance <- stringdist(a = x[i],
                           b = y,
                           method = 'jw')
    results_matrix[i,] <- distance
  }

  # Give dimension names
  dnames <- list(x = x,
                 y = y)
  dimnames(results_matrix) <- dnames

  # Return the results
  return(results_matrix)
}


