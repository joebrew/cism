#' cism plot
#' 
#' Generate simple visualizations of variables. Meant to show one of 3 different kinds of charts:
#' 1. A bar chart (for counts of categorical variables)
#' 2. A histogram (for distributions of numeric variables)
#' 3. A x-y correlation chart (if two variables are supplied)

#' @param x A variable to be plotted alone, or the x-axis of a two variable plot
#' @param y An option second variable to be plotted on the y-axis
#' @param type Either "numeric" or "factor". If \code{NULL} (the default), this function
#' will try to guess the type of variable. Ignored if both \code{x} and \code{y} are supplied.
#' @param make_simple Whether to simplify a categorical variable to fewer than \code{n_simplify}
#' categories. Ignored unless \code{y} is \code{NULL} and \code{x} is categorical.
#' @param n_simple The number of categories to simplify \code{x} to.
#' Ignored unless \code{y} is \code{NULL} and \code{x} is categorical.
#' @param trend Whether to overlay a trend line.
#' Ignored unless \code{y} is not \code{NULL} and both \code{x} and \code{y} are numeric.
#' @return A plot
#' @export

cism_plot <- function(x,
                      y = NULL,
                      type = NULL,
                      make_simple = TRUE,
                      n_simple = 10,
                      trend = FALSE){
  
  # Packages
  require(ggplot2)
  require(dplyr)
  
  # Convert everything to data.frame to avoid problems with tbl_df
  x <- data.frame(x)$x
  if(!is.null(y)){
    y <- data.frame(y)$y
  }
  
  # Get the type
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
  
  # Make into a dataframe for plotting
  plot_df <- data.frame(x = x)
  
  # Make plot
  if(!is.null(y)){
    if(type != 'numeric'){
      stop('Only numeric variables can be plotted in a x-y chart')
    }
    plot_df$y <- y
    
    g <- ggplot(data = plot_df,
                aes(x = x,
                    y = y)) +
      geom_point(color = 'darkorange',
                 alpha = 0.6) +
      theme_cism() +
      xlab('') +
      ylab('')
    
    # Add trend
    if(trend){
      g <- g +
        geom_smooth(color = 'darkgreen',
                    fill = 'yellow')
    }
    
  } else if(type == 'factor'){
    plot_data <- 
      plot_df %>%
      group_by(x) %>%
      tally %>%
      ungroup %>%
      filter(!is.na(x)) #%>%
      # arrange(n) %>%
      # mutate(x = factor(x, levels = x))
    g <- 
      ggplot(data = plot_data,
             aes(x = x,
                 y = n)) +
      geom_bar(stat = 'identity',
               fill = 'darkorange',
               alpha = 0.6,
               color = 'darkgreen') +
      theme_cism() +
      xlab('') +
      ylab('N')
    # If large, make vertical axes
    if(nrow(plot_data) > 3){
      g <- g +
        theme(axis.text.x = element_text(angle = 90))
    }
  } else if (type == 'numeric'){
    g <- 
      ggplot(data = plot_df,
           aes(x = x)) +
      geom_density(fill = 'darkorange',
                   alpha = 0.6,
                   color = 'darkgreen') +
      xlab('') +
      ylab('Density') +
      theme_cism()
  }
  
  g <- g +
    brand_cism()
  return(g)
}

