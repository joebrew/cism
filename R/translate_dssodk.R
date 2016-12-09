#' translate dssodk
#' 
#' Translate columns of dssodk.
#' @param dictionary A dictionary dataframe. Should be generated via
#' \code{\url{get_dssodk_dictionary}}
#' @param tab An in-memory dataframe corresponding to the \code{table_name}.
#' Can be left \code{NULL} if \code{table_name} is identical to the name of the object in memory.
#' @param table_name The name (as a character vector of length one) of the table
#' to be translated
#' @param variable The name (as a character vector of length one) of the 
#' variable to be translated
#' @return A one column dataframe in which the variable name will be the 
#' Portugese language question pertaining to the \code{variable}, and
#' the values of the dataframe will be the Portuguese-language values in the 
#' dictionary
#' @export

translate_dssodk <- function(dictionary,
                             tab = NULL,
                             table_name,
                             variable){
  require(dplyr)
  
  # If no tab, try to get
  if(is.null(tab)){
    tab <- get(table_name, envir = .GlobalEnv)
  }
  
  # Change the name of the variable so as to work smoothly with dplyr
  the_variable <- variable
  
  # Select only the variable needed
  tab <- tab %>%
    dplyr::select_(variable)
  # Rename to old
  names(tab) <- 'old'
  
  # Subset the dictionary
  sub_dictionary <- dictionary %>%
    filter(table == table_name,
           variable == the_variable) 
  
  # Make sure types match
  class_dictionary <- class(sub_dictionary$old)
  class_tab <- class(tab$old)
  if(class_tab != class_dictionary){
    sub_dictionary$old <- as.character(sub_dictionary$old)
    tab$old <- as.character(tab$old)
  }
  
  # Perform the translation
  tab <- tab %>%
    left_join(sub_dictionary,
              by = 'old') %>%
    dplyr::select(answer_port) 
  
  names(tab) <- sub_dictionary$question_port[1]
  
  return(tab)
}