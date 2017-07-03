#' get dictionary
#'
#' Get a dictionary for the following databases:
#' 1. Manhica (dssodk) with the following tables
#' HOUSEHOLD_ECONOMICS_CORE,
#' LOCATION_DETAILS_CORE,
#' INDIVIDUAL_DETAILS_CORE
#' 2. Magude (round 1) with the following tables
#' 3. Magude (round 2) with the following tables
#' @param questions If \code{TRUE}, will return a dictionary of
#' census questions;
#' the alternative (\code{FALSE}) is to return the dictionary of the answers
#' @param manhica If \code{TRUE}, will return a dictionary for manhica;
#' the alternative (\code{FALSE}) is to return the dictionary for Magude
#' @param round Which round of census (only applicable to Manhica)
#' @import gsheet
#' @export

get_dictionary <- function(questions = TRUE,
                                  manhica = TRUE,
                                  round = 1){

  if(questions){
    if(manhica){
      url <- 'https://docs.google.com/spreadsheets/d/12X6ofKxfqXaEdMC2Jy6EpSqS-SWuUiC4_oBmSWquaV4/edit#gid=0'
    } else {
      if(round == 1){
        url <- 'https://docs.google.com/spreadsheets/d/1Q09pULHEZXa1UErguCDeLrSluXOQTT0yTrFHeAhV8Ho/edit?usp=sharing'
      } else if(round == 2){
        url <- 'https://docs.google.com/spreadsheets/d/1j6HIEvtwKypXeGwrVqxwv6joSAT4gd72LIh3S0WhRro/edit?usp=sharing'
      }
    }
  } else {
    # Answers!
    if(manhica){
      url <- 'https://docs.google.com/spreadsheets/d/13w2ZA9zfxbr-Zc4wjooH1ScfeZfw_7_AbSY00RCd-uY/edit#gid=0'
    } else {
      if(round == 1){
        url <- 'https://docs.google.com/spreadsheets/d/1-WuEEEbdlaU7UPsNr8cSio7aJa3d3EUtLH4W8ekGH00/edit?usp=sharing'
      } else if(round == 2){
        url <- 'https://docs.google.com/spreadsheets/d/1QsDeDXbqai5jY8Y6HMSiTKjDQiV2gPUzTPDYJHBemao/edit?usp=sharing'
      }
    }
  }
  dictionary <- gsheet2tbl(url)
  return(dictionary)
}
