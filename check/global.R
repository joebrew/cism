library(dplyr)
library(leaflet)
library(RColorBrewer)
library(rgeos)
library(sp)
library(yaml)

# Load data from zambezia
# Saved via 
# save(vv, vvb, vvb_ll_spray, vvb_spray, vv_ll, vv_spray, vv_spray_ll, census_spatial_ll, village_df, census_spatial, mop_ll, vvb_ll, file = 'data/census.RData')
# census_spatial@data <- 
#   census_spatial@data %>%
#   dplyr::select(village_number,
#               local_village_name,
#               locality,
#               house_number,
#               lng,
#               lat,
#               status)
# census_spatial_ll@data <- 
#   census_spatial_ll@data %>%
#   dplyr::select(village_number,
#                 local_village_name,
#                 locality,
#                 house_number,
#                 lng,
#                 lat,
#                 status)
load('data/census.RData')

# Load functions from same place
source('lib/helpers.R')

# Read password
correct_password <- yaml.load_file('credentials/password.yaml')$PASSWORD
