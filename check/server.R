
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# Source global environment level variables
source('global.R', local = TRUE)

shinyServer(function(input, output) {
  
  password_ok <- reactive({
    x <- FALSE
    x <- input$password == correct_password
    if(is.na(x)){
      x <- FALSE
    }
    if(x){
      x <- 'ok'
    } else {
      x <- 'not okay'
    }
    return(as.character(x))
  })
  
  password_ok_text <- renderText({
    password_ok()
  })
  
  output$password_evaluation <- 
    renderText({
      if(nchar(input$password) < 3){
        ''
      } else
        if(password_ok() == 'ok'){
          'Password correct. Proceed to the data tab.'
        } else {
          'Password incorrect.'
        }
    })
  
  output$the_map <-
    renderLeaflet(
      if(password_ok() == 'ok'){
        leaflet_village_master_voronoi_buffer_spray_house_number(house_numbers = input$house_numbers)
      } else {
        leaflet() %>%
          addProviderTiles("Stamen.Watercolor") %>%
          setView(-82, 29, zoom = 5)
      }
      )
  
  sub_data <- reactive({
    if(password_ok() != 'ok'){
      x <- census_spatial_ll@data[-1,]
    } else 
    if(is.null(input$house_numbers)){
      x <- census_spatial_ll@data[0,]
    } else {
      x <- 
        census_spatial_ll@data %>%
        filter(grepl(input$house_numbers, 
                     house_number, fixed = TRUE))
    }
    x <-
      x %>%
      dplyr::select(village_number,
                    local_village_name,
                    locality,
                    house_number,
                    lng,
                    lat,
                    status)
    x
  })
  
  output$the_table <- 
    renderDataTable({
      if(password_ok() != 'ok'){
        x <- census_spatial_ll[-1,]
      } else {
        x <- sub_data()
      }
      x
    })
  
  output$the_text1 <-
    renderText({
      the_data <- sub_data()
      if(nrow(the_data) == 1){
        paste0('Copy this house number for entry on the next tab: ')
      } else {
        ''
      }
    })
  
  output$the_text2 <-
    renderText({
      the_data <- sub_data()
      if(nrow(the_data) == 1){
        paste0(the_data$house_number)
      } else {
        ''
      }
    })
  
  
  output$frame <- renderUI({
    my_test <- tags$iframe(src='https://docs.google.com/forms/d/e/1FAIpQLSeJ5N_fHqQT-zgOxWDBpNAHk9Aul3hio9xUug6jBPxHANPtMQ/viewform?embedded=true', 
                           height=600, 
                           width=535,
                           frameborder='0',
                           marginheight='0',
                           marginwithd='0')
    print(my_test)
    my_test
  })
  
})

