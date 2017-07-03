library(readxl)
library(tidyverse)
us <- read_excel('US_Moz_13-Nov Prova.xlsx')
us <- us[,!is.na(names(us))]
# Keep only a few columns
us <- 
  us %>%
  dplyr::select(Provincia,
                Distrito,
                Nome_US,
                NO_US,
                POSTO_ADMI,
                LOCALIDADE,
                AREA,
                CLASSIFICA,
                TIPO_US,
                NIVEL_US,
                Latitude,
                Longitude) %>%
  rename(province = Provincia,
         district = Distrito,
         name = Nome_US,
         number = NO_US,
         administrative_pst = POSTO_ADMI,
         locality = LOCALIDADE,
         area = AREA,
         classification = CLASSIFICA,
         type = TIPO_US,
         level = NIVEL_US,
         latitude = Latitude,
         longitude = Longitude)
devtools::use_data(us,
                   overwrite = TRUE)
