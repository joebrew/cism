library(devtools)
library(readr)
library(tidyr)
library(dplyr)
devtools::use_data_raw()

# World bank data url
# 'http://api.worldbank.org/v2/en/country/MOZ?downloadformat=csv'

# Read data
wb <- read_csv('API_MOZ_DS2_en_csv_v2.csv', skip = 4)
wb <- wb[,1:61]
names(wb)[5:ncol(wb)] <- paste0('y',
                                names(wb)[5:ncol(wb)])

# Make long
wb <- gather(wb,
             year,
             value,
             y1960:y2016)

# Clean up
wb$year <- as.numeric(gsub('y', '', wb$year))

# Rename
names(wb) <- c('country',
               'country_code',
               'indicator_name',
               'indicator_code',
               'year',
               'value')

# Don't save empty stuff
wb <-
  wb %>%
  group_by(indicator_code) %>%
  mutate(flag = length(which(!is.na(value))) == 0) %>%
  ungroup %>%
  filter(!flag) %>%
  dplyr::select(-flag)

# Save
devtools::use_data(wb,
                   overwrite = TRUE)

