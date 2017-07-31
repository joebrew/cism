#' Convert UTM to Latitude Longitude
#' 
#' Convert from UTM (Universal Transverse Mercator) to Latitude and Longitude
#' @param x A numeric vector of x coordinates, or a dataframe with two columns, named
#' x and y
#' @param y A numeric vector of y coordinates (optional; only necessary if x is a vector and not a dataframe)
#' @param zone The UTM zone in question. Defaults to 36 (Southern Mozambique)
#' @return A dataframe of latitude and longitude coordinates
#' @export

ll_from_utm <- function(x, y, zone = 36){
  # Create a spatial object
  require(sp)
  require(dplyr)
  if(is.data.frame(x)){
    us <- x
  } else {
    us <- data_frame(x,y)
  }
  us <- data.frame(us)
  max_id <- nrow(us)
  us$id <- 1:max_id
  
  # Remove NAs
  us <- us[!is.na(us$x) & 
             !is.na(us$y),]
  
  # Make spatial
  coordinates(us) <- ~x+y
  
  # Assing projection
  proj4string(us) <- CRS(paste0("+proj=utm +zone=", 
                                zone, 
                                " +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs"))
  # Convert to lat/lng
  us <- spTransform(us,
                    CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +towgs84=0,0,0"))
  
  # Extract the coordinates
  coords <- coordinates(us)
  
  # Turn into a dataframe
  coords <- data.frame(id = us@data$id,
                       x = coords[,1],
                       y = coords[,2])
  
  # Join to ids
  out <- left_join(x = data_frame(id = 1:max_id),
                   y = coords,
                   by = 'id') %>%
    dplyr::select(-id)
  return(out)
}