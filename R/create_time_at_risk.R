#' Create time at risk
#' 
#' Using census migration data, create a dataframe of "time at risk", ie the 
#' time during which someone lived in Manhiça.
#' @param residency A residency table of identical format to the \code{residency} table in the \code{openhds} database
#' @param individual A individual table of identical format to the \code{individual} table in the \code{openhds} database
#' @param location A location table of identical format to the \code{location} table in the \code{openhds} database
#' @return A \code{data.frame} with one row for each person's 
#' uninterrupted period of residency
#' @export
#' @examples
#' residency <- get_data(tab = 'residency', dbname = 'openhds')
#' individual <- get_data(tab = 'individual', dbname = 'openhds')
#' location <- get_data(tab = 'location', dbname = 'openhds')
#' time_at_risk <- create_time_at_risk(residency = residency, individual = individual, location = location)

create_time_at_risk <- function(residency,
                                individual,
                                location){
  
  # Packages
  require(dplyr)
  
  # Perform selections and join
  # get variables from the episodes of residence
  result <- residency %>%
    dplyr::select(individual_uuid, 
                  startType,
                  startDate,
                  endType, 
                  endDate, 
                  location_uuid) %>%
    # order by individual and date
    arrange(individual_uuid, startDate) %>%
    # join with individual details
    left_join(individual %>%
                dplyr::select(uuid,
                              dob,
                              extId,
                              firstName,
                              middleName,
                              lastName,
                              father_uuid,
                              mother_uuid,
                              gender) %>%
                # rename extId so as to not conflict with location extId
                rename(individual_extId = extId),
              by = c('individual_uuid' = 'uuid')) %>%
    # join with location-level details
    left_join(location %>%
                dplyr::select(uuid,
                              accuracy,
                              altitude,
                              extId,
                              longitude,
                              latitude,
                              locationName,
                              locationLevel_uuid) %>%
                # rename extId so as to not conflict with individual extId
                rename(location_extId = extId),
              by = c('location_uuid' = 'uuid'))
  
  # Make date objects
  result$startDate <- as.Date(result$startDate)
  result$endDate <- as.Date(result$endDate)
  result$dob <- as.Date(result$dob)
  
  # Return result
  return(result)
}
