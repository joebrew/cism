#' Get weather
#'
#' Get weather data from www.wunderground.com
#' @param station A weather station. For example, "FQMA" (Maputo), "CDG"
#' (Charles de Gaulle airport in Paris, France), "JFK" (John F. Kennedy
#' airport in New York City, USA), etc.
#' @param start_year The year for which you would like to start getting data
#' @param end_year The year for which you would like to stop getting data
#' @param save Whether to save the retrieved data locally
#' @param load_saved Whether load, if applicable, previously saved data
#' @return A dataframe of weather data
#' @import data.table
#' @export

get_weather <- function(station = "FQMA", # CDG, BGT, ATL, JFK
                                start_year = 2014,
                                end_year = 2016,
                                save = TRUE,
                                load_saved = TRUE){

  # Define a filename
  file_name <- paste0('weather_',
                      station,
                      '_',
                      start_year,
                      '_',
                      end_year,
                      '.RData')

  if(load_saved & file_name %in% dir()){
    load(file_name)
  } else {

    # Format station name
    station <- toupper(gsub(" ", "%20", station))

    # Adjust dates
    start_date <- as.Date(paste0(start_year, '-01-01'))
    end_date <- as.Date(paste0(end_year, '-12-31'))
    if(end_date > Sys.Date()){
      end_date <- Sys.Date() - 1
    }

    # Parse date components
    start_day <- as.numeric(format(start_date, "%d"))
    start_month <- as.numeric(format(start_date, "%m"))
    start_year <- as.numeric(format(start_date, "%Y"))
    end_day <- as.numeric(format(end_date, "%d"))
    end_month <- as.numeric(format(end_date, "%m"))
    end_year <- as.numeric(format(end_date, "%Y"))

    # Get years
    years <- start_year:end_year

    # For each year, get the data and store in list
    results_list <- list()

    for (i in 1:length(years)){
      try({
        this_year <- years[i]
        this_start_month <- 1
        this_start_day <- 1
        if(this_year == end_year){
          this_end_month <- as.numeric(format(end_date, '%m'))
          this_end_day <- as.numeric(format(end_date, '%m'))
        } else {
          this_end_month <- 12
          this_end_day <- 31
        }
        # Define link format for airports
        link <- paste0("http://www.wunderground.com/history/airport/",
                       station,
                       "/", this_year,
                       "/", this_start_month,
                       "/", this_start_day,
                       "/CustomHistory.html?dayend=", this_end_day,
                       "&monthend=", this_end_month,
                       "&yearend=", this_year,
                       "&req_city=NA&req_state=NA&req_statename=NA&format=1")

        #     # Read in data from link
        df <- suppressWarnings(fread(link))
        names_df <- names(df)
        df <- data.frame(df)
        names(df) <- names_df

        # Keep only the first 20 columns (through cloud cover)
        df <- df[,1:21]

        # Fix date
        names(df)[1] <- 'date'
        df$date <- as.Date(df$date, format = '%Y-%m-%d')
        # Fix other names
        names(df) <-
          tolower(gsub(' |[/]', '_', names(df)))

        # Keep only certain columns
        df <- df[,!grepl('sea_level|visibility|wind|gust|dew', names(df))]

        #   # Standardize names
        names(df) <- c("date",
                       "temp_max",
                       "temp_mean",
                       "temp_min",
                       "humidity_max",
                       "humidity_mean",
                       "humidity_min",
                       "precipitation",
                       "cloud_cover")
        #
        # Add a location column
        df$location <- toupper(as.character(station))

        # print url source
        message(paste0('Data retrieved for ', this_year))

        # Stick results into list
        results_list[[i]] <- df
      })
    }

    # Bind together results
    x <- do.call('rbind', results_list)

  }

  # Save if applicable
  if(save){
    save(x, file = file_name)
  }
  return(x)
}
