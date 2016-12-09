#' interactive cism map
#' 
#' Generate simple interactive maps of variables. Meant to show one of 3 different kinds of maps:
#' 1. A simple point map with no coloring
#' 2. A point map with coloring by a categorical variable
#' 3. A point map with coloring by a numeric variable
#' This function is identical in input to \code{cism_map}, in all ways but three:
#' 1. Rather than returning a ggplot2 plot, it returns a leaflet html widget.
#' 2. It takes a spdf (regular SpatialPolygonsDataFrame) rather than a fspdf (fortified one).
#' 3. It takes an optional popup argument.

#' @param lng A numeric vector of longitude coordinates
#' @param lat A numeric vector of latitude coordinates
#' @param x A variable to be plotted. If \code{NULL} (the default), the locations only 
#' will be plotted
#' @param popup A character vector, of identical lenggth to \code{lat} and \code{lng}, 
#' containing information to be viewed upon clicking
#' @param spdf A spatial polygons dataframe
#' @param type Either "numeric" or "factor". If \code{NULL} (the default), this function
#' will try to guess the type of variable. Ignored if both \code{x} and \code{y} are supplied.
#' @param make_simple Whether to simplify a categorical variable to fewer than \code{n_simplify}
#' categories. Ignored unless \code{y} is \code{NULL} and \code{x} is categorical.
#' @param n_simple The number of categories to simplify \code{x} to.
#' Ignored unless \code{y} is \code{NULL} and \code{x} is categorical.
#' @return A plot
#' @export

cism_map_interactive <- function(lng,
                                 lat,
                                 x = NULL,
                                 popup = NULL,
                                 spdf = NULL,
                                 type = NULL,
                                 make_simple = TRUE,
                                 n_simple = 10,
                                 opacity = 0.5,
                                 point_size = 1){
  
  # Packages
  require(dplyr)
  require(leaflet)
  require(RColorBrewer)
  
  # Convert everything to data.frame to avoid problems with tbl_df
  lng <- data.frame(lng)$lng
  lat <- data.frame(lat)$lat
  
  # Make into a dataframe for plotting
  plot_df <- data.frame(lng = lng,
                        lat = lat)
  
  # Get the type
  if(!is.null(x)){
    x <- data.frame(x)$x
    if(!is.null(type)){
      # Type manually supplied
      if(!type %in% c('numeric', 'factor')){
        stop('type must either be left as NULL or be one of "factor" or "numeric".')
      }
    } else {
      # Guess the type
      type <- class(x)
      if(type == 'character'){
        type <- 'factor'
      } else if(type == 'Date'){
        type <- 'numeric'
      } else if(type == 'integer'){
        type <- 'numeric'
      }
    }
    # Simplify if relevant
    if(type == 'factor' & make_simple == TRUE){
      x <- simplify(x,
                    n = n_simple)
    }
    # Add to plotting dataframe
    plot_df$x <- x
  }
  
  # Removals
  remove_these <- which(is.na(plot_df$lng) | is.na(plot_df$lat))
  n <- length(remove_these)
  p <- round(n / nrow(plot_df) * 100, digits = 2)
  message(paste0('Removing ', n, ' observations of a total ',
                 nrow(plot_df), '. ', p, '%.'))
  plot_df <- plot_df[!(1:nrow(plot_df) %in% remove_these),]
  
  # Define popup
  if(is.null(popup)){
    popup <- row.names(plot_df)
  } else {
    popup <- as.character(popup)
  }
  
  # Make plot
  if(!is.null(spdf)){
    # Add shapefile outline if relevant
    g <- leaflet() %>%
      addProviderTiles('Esri.WorldImagery') %>%
      addPolylines(data = spdf,
                   color = 'black')
  } else {
    g <- leaflet() %>%
      addProviderTiles('Esri.WorldImagery')
  }
  if(is.null(x)){
    g <- g %>%
      addCircleMarkers(data = plot_df,
                       lng = ~lng,
                       lat = ~lat,
                       color = 'darkorange',
                       opacity = opacity,
                       radius = point_size,
                       popup = popup)
  } else {
    if(type == 'numeric'){
      pal <- colorNumeric(
        palette = "Blues",
        domain = plot_df$x
      )
      g <- g %>%
        addCircleMarkers(data = plot_df,
                         lng = ~lng,
                         lat = ~lat,
                         color = ~pal(x),
                         opacity = opacity,
                         radius = point_size,
                         popup = popup) %>%
        addLegend(position = 'bottomright',
                  pal = pal,
                  values = as.numeric(quantile(plot_df$x, na.rm = TRUE)))
    } else if (type == 'factor'){
      cols <- colorRampPalette(brewer.pal(9, 'Spectral'))(length(unique(plot_df$x)))
      pal <- colorFactor(cols, 
                         domain = unique(plot_df$x))
      
      factpal <- colorFactor(topo.colors(length(unique(plot_df$x))), plot_df$x)
      g <- g %>%
        addCircleMarkers(data = plot_df,
                         lng = ~lng,
                         lat = ~lat,
                         color = ~factpal(x),
                         opacity = opacity,
                         radius = point_size,
                         popup = popup) %>%
        addLegend(position = 'bottomright',
                  pal = factpal,
                  values = unique(plot_df$x))
    }
  } 
  return(g)
}

