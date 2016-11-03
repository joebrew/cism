library(shinythemes)

# Source global environment level variables
source('global.R', local = TRUE)

ui <-
  navbarPage(
    title = 'CISM Mopeia data verification app',
    theme = shinytheme("united"),
    
    tabPanel('Password',
             h3('To use this application, please enter your password'),
             fluidRow(
               column(6,
                      textInput('password',
                                label = 'Password')),
               column(6,
                      textOutput('password_evaluation'),
                      tags$head(tags$style("#password_evaluation{color: red;
                                           font-size: 40px;
                                           font-style: italic;
                                           }"))))),
    tabPanel('Data',
             fluidRow(column(6,
                             helpText('Write the house number',
                                      'or just a part of the house number',
                                      '(for example: the village number).'),
                             textInput('house_numbers',
                                       'House number',
                                       value = NULL),
                             textOutput('the_text1'),
                             textOutput('the_text2'),
                             tags$head(tags$style("#the_text2{color: red;
                                           font-size: 40px;
                                           font-style: italic;
                                           }"))),
                      column(6,
                             leafletOutput('the_map'))),
             fluidRow(column(12,
                             dataTableOutput('the_table')))),
    tabPanel('Input',
             fluidRow(column(12,
                             htmlOutput('frame'),
                             p('Access this form directly at ',
                               'https://docs.google.com/forms/d/e/1FAIpQLSeJ5N_fHqQT-zgOxWDBpNAHk9Aul3hio9xUug6jBPxHANPtMQ/viewform')))))