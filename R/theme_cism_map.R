#' CISM theme for maps
#'
#' Apply the CISM look to a ggplot2-generated visualization. Specific for
#' maps (no x labels, etc.)

#' @return A ggtheme object meant to be used in conjunction with a call to ggplot()
#' @import RColorBrewer
#' @import ggplot2
#' @import extrafont
#' @export

theme_cism_map <- function(){
  theme_cism() %+replace% 
    theme(
      panel.border = element_blank(),
      panel.grid = element_blank(), 
      panel.spacing = unit(0,
                           "lines"), 
      legend.justification = c(0, 0), 
      legend.position = c(0, 
                          0),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank())
}
  