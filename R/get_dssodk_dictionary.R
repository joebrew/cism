#' get dssodk dictionary
#'
#' Get a dictionary for the following dssodk tables:
#' HOUSEHOLD_ECONOMICS_CORE,
#' LOCATION_DETAILS_CORE,
#' INDIVIDUAL_DETAILS_CORE
#' @import gsheet
#' @export

get_dssodk_dictionary <- function(){
  dictionary_url <- 'https://docs.google.com/spreadsheets/d/13w2ZA9zfxbr-Zc4wjooH1ScfeZfw_7_AbSY00RCd-uY/edit#gid=0'
  dictionary <- gsheet2tbl(dictionary_url)
  return(dictionary)

}
