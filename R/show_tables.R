#' Show the names of tables of a database
#'
#' Show the names of tables of a database
#' @param dbname The name of the database from which you are getting data.
#' Examples include "openhds", "dss", "dssodk", "maltem_absenteeism", etc. If \code{NULL}
#' the function will try to use the \code{dbname} in your \code{connection_object}; if the \code{connection_object} is \code{NULL}, the function will
#' try to create a \code{connection_object} as described below.
#' @param host The name of the host from which you are getting data.
#' Examples include "sap.manhica.net".
#' If \code{NULL} the function will try to use the \code{host} in your \code{connection_object}; if the \code{connection_object} is \code{NULL}, the function will
#' try to create a \code{connection_object} as described below.
#' @param port The name of the port from which you are getting data.
#' This should be 3306 on-site, and 4706 off-site. If \code{NULL}
#' the function will try to use the \code{port} in your \code{connection_object}; if the \code{connection_object} is \code{NULL}, the function will
#' try to create a \code{connection_object} as described below.
#' @param user The user. If \code{NULL}
#' the function will try to use the \code{user} in your \code{connection_object}; if the \code{connection_object} is \code{NULL}, the function will
#' try to create a \code{connection_object} as described below.
#' @param password The password If \code{NULL}
#' the function will try to use the \code{pqssword} in your \code{connection_object}; if the \code{connection_object} is \code{NULL}, the function will
#' try to create a \code{connection_object} as described below.
#' @param connection_object An open connection to a CISM database (as created through \code{credentials_extract} and \code{credentials_connect} or \code{credentials_now}); if \code{NULL}, the function will try to create a \code{connection_object} by retrieving user information from the \code{credentials/credentials.yaml} 
#' in or somewhere upwards of the working directory.
#' @return A dataframe with two columns: \code{dbname} (the database in question) 
#' and \code{table} (the name of the table).
#' @export

show_tables <- function(dbname = NULL,
                        host = NULL,
                        port = NULL,
                        user = NULL,
                        password = NULL,
                        connection_object = NULL,
                        collect = TRUE){
  
  require(dplyr)
  require(DBI)
  
  # If not connection object, try to find one
  if(is.null(connection_object)){
    message(paste0('No connection_object provided. Will try ',
                   'to find a credentials file.'))
    # Get credentials
    the_credentials <- credentials_extract()
    
    # Replace dbname if necessary
    if(!is.null(dbname)){
      the_credentials$dbname <- dbname
    }
    # Replace host if necessary
    if(!is.null(host)){
      the_credentials$host <- host
    }
    # Replace port if necessary
    if(!is.null(port)){
      the_credentials$port <- port
    }
    # Replace user if necessary
    if(!is.null(user)){
      the_credentials$user <- user
    }
    # Replace dbname if necessary
    if(!is.null(password)){
      the_credentials$password <- password
    }
    
    # Establish the connection
    connection_object <- credentials_connect(the_credentials)
  }
  
  
  # Conformity of input
  if(is.null(connection_object)){
    stop('You must supply a connection object (use credentials_extract and credentials_connect, or simply credentials_now).')
  }
  
  # QUERY / CONNECT
  tables <- src_tbls(connection_object)
  
  # Make a dataframe of results
  results <- data.frame(dbname = dbname,
                        table = tables)
  
  return(results)}
