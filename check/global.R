library(dplyr)
library(leaflet)
library(RColorBrewer)
library(rgeos)
library(sp)
library(yaml)

# Load data from zambezia
load('data/census.RData')

# Load functions from same place
source('lib/helpers.R')

# Read password
correct_password <- yaml.load_file('credentials/password.yaml')$PASSWORD
