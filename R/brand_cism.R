#' Brand CISM
#' 
#' Add a CISM watermark to any plot
#' @export

brand_cism <- function(){
  annotate('text', 
           x= -Inf, 
           y = -Inf, 
           label = "Centro de Investigação em Saude de Manhiça. www.manhica.org", 
           color = 'darkgreen',
           alpha = 0.3,
           vjust= -1, 
           hjust= -1,
           size = 2)
}