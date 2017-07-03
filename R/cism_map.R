#' cism map
#'
#' Generate simple maps of variables. Meant to show one of 3 different kinds of maps:
#' 1. A simple point map with no coloring
#' 2. A point map with coloring by a categorical variable
#' 3. A point map with coloring by a numeric variable

#' @param lng A numeric vector of longitude coordinates
#' @param lat A numeric vector of latitude coordinates
#' @param x A variable to be plotted. If \code{NULL} (the default), the locations only
#' will be plotted
#' @param fspdf A fortified spatial polygons dataframe
#' @param type Either "numeric" or "factor". If \code{NULL} (the default), this function
#' will try to guess the type of variable. Ignored if both \code{x} and \code{y} are supplied.
#' @param make_simple Whether to simplify a categorical variable to fewer than \code{n_simplify}
#' categories. Ignored unless \code{y} is \code{NULL} and \code{x} is categorical.
#' @param n_simple The number of categories to simplify \code{x} to.
#' Ignored unless \code{y} is \code{NULL} and \code{x} is categorical.
#' @import ggplot2
#' @import dplyr
#' @import RColorBrewer
#' @import sp
#' @return A plot
#' @export

cism_map <- function(lng,
                     lat,
                     x = NULL,
                     fspdf = NULL,
                     type = NULL,
                     make_simple = TRUE,
                     n_simple = 10,
                     opacity = 0.5,
                     point_size = 1){

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

  # Make plot
  if(!is.null(fspdf)){
    # Add shapefile outline if relevant
    g <- ggplot() +
      geom_polygon(data = fspdf,
                   aes(x = long,
                       y = lat,
                       group = group),
                   fill = NA,
                   color = 'black',
                   alpha = 0.3)
  } else {
    g <- ggplot()
  }
  if(is.null(x)){
    g <- g +
      coord_map() +
      geom_point(data = plot_df,
                 aes(x = lng,
                     y = lat),
                 color = 'darkorange',
                 alpha = opacity,
                 size = point_size)

  } else if(type == 'numeric'){
    g <- g +
      coord_map() +
      geom_point(data = plot_df,
                 aes(x = lng,
                     y = lat,
                     color = x),
                 alpha = opacity,
                 size = point_size) +
      scale_colour_gradient(name = '',
                            low = "darkgreen",
                            high = "darkorange",
                            space = "Lab",
                            na.value = "grey50",
                            guide = "colourbar")
  } else if (type == 'factor'){
    cols <- colorRampPalette(brewer.pal(9, 'Spectral'))(length(unique(plot_df$x)))
    g <- g +
      coord_map() +
      geom_point(data = plot_df,
                 aes(x = lng,
                     y = lat,
                     color = x),
                 alpha = opacity,
                 size = point_size) +
      scale_color_manual(name = '',
                        values = cols) +
      guides(colour = guide_legend(override.aes = list(size=5)))
  }

  g <- g +
    brand_cism(subtitle = TRUE) +
    theme_cism() +
    xlab('Longitude') +
    ylab('Latitude')
  return(g)
}

