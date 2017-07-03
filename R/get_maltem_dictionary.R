#' get dssodk dictionary
#'
#' Get a dictionary for the following maltem tables:
#' HOUSEHOLD
#' MEMBER
#' @import gsheet
#' @export

get_maltem_dictionary <- function(){
  dictionary_url <- 'https://docs.google.com/spreadsheets/d/1-WuEEEbdlaU7UPsNr8cSio7aJa3d3EUtLH4W8ekGH00/edit#gid=0'
  dictionary <- gsheet2tbl(dictionary_url)
  return(dictionary)

}
