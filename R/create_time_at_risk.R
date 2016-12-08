#' Create time at risk
#' 
#' Using census migration data, create a dataframe of "time at risk", ie the 
#' time during which someone lived in Manhiça.
#' @param user A username, as a character vector of length one, with access
#' to the openhds database
#' @param password The password corresponding to \code{username}
#' @param port The port to use. for the database connection. 
#' By default 3306; should be 4706 if not at the CISM.
#' @param host The host to use for the database connection. 
#' By default "sap.manhica.net".
#' @return A \code{data.frame} with one row for each person's 
#' uninterrupted period of residency
#' @export
#' @examples

create_time_at_risk <- function(user,
                                password,
                                port = 3306,
                                host = 'sap.manhica.net'){
  require(dplyr)
  
  # Define connection 
  connection_options <- list('dbname' = 'openhds',
                             'host' = 'sap.manhica.net',
                             'port' = port,
                             'user' = user,
                             'password' = password)
  con <- do.call('src_mysql', connection_options)
  
  
  # Get the residency table
  residency <- 
    tbl(con,
      'residency') %>%
    collect(n = Inf)
}