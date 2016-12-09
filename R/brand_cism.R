#' Brand CISM
#' 
#' Add a CISM watermark to any plot
#' @export

brand_cism <- function(subtitle = TRUE){
  if(subtitle){
    labs(subtitle = "www.manhica.org",
         size = 2)
  } else {
    annotate('text', 
             x= -Inf, 
             y = -Inf, 
             label = "www.manhica.org", 
             color = 'darkgreen',
             alpha = 0.3,
             vjust= -1, 
             hjust= -1,
             size = 2)
  }

}