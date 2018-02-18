#' Get a bibtex entry from a doi number
#' 
#' Convert a doi (digital object identifier) to a bibtex entry
#' @param x A doi
#' @param cat_it Whether to cat the output (as opposed to returning a vector)
#' @return A bibtex formatted bibliography entry
#' @export

doi_to_bib <- function(x = '10.1371/journal.pone.0008500',
                       cat_it = TRUE){
  x <- gsub("http://dx.doi.org/", "", x, fixed = TRUE)
  x <- gsub("https://dx.doi.org/", "", x, fixed = TRUE)
  x <- gsub("www.dx.doi.org/", "", x, fixed = TRUE)
  x <- gsub("dx.doi.org/", "", x, fixed = TRUE)
  out <- paste0('curl -LH "Accept: text/bibliography; style=bibtex" https://doi.org/',
                x)
  out <- system(out, intern = TRUE)
  if(cat_it){
    out <- gsub(', title', ', \ntitle', out, fixed = TRUE)
    out <- gsub('},', '},\n', out, fixed = TRUE)
    cat(out)
  } else {
    return(out) 
  }
}
