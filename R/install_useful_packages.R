#' Install useful packages
#' 
#' Install some subjectively useful packages
#' @export

install_useful_packages <- function(){
  
  # Define packages
  pkgs <- c('tidyverse',
            'raster',
            'rgdal',
            'sp',
            'maptools',
            'rgeos',
            'tidyr',
            'RColorBrewer',
            'rmarkdown',
            'tufte')
  
  # Only install those which don't already have
  pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
  
  if(length(pkgs) > 0){
    for (i in 1:length(pkgs)){
      install.packages(pkgs[i])
    }
  }
}