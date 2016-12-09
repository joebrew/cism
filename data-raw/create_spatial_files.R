library(devtools)
library(raster)
library(ggplot2)
library(maptools)

devtools::use_data_raw()


# Get mozambique shapefile
moz0 <- getData('GADM', country = 'MOZ', level = 0)
moz1 <- getData('GADM', country = 'MOZ', level = 1)
moz2 <- getData('GADM', country = 'MOZ', level = 2)
moz3 <- getData('GADM', country = 'MOZ', level = 3)

# Subset to manhica
man2 <- moz2[moz2@data$NAME_2 == 'Manhiça',]
man3 <- moz3[moz3@data$NAME_2 == 'Manhiça',]

# Subset to magude
mag2 <- moz2[moz2@data$NAME_2 == 'Magude',]
mag3 <- moz3[moz3@data$NAME_2 == 'Magude',]

# Subset to mopeia mopeia
mop2 <- moz2[moz2@data$NAME_2 == 'Mopeia',]
mop3 <- moz3[moz3@data$NAME_2 == 'Mopeia',]

# Fortify
moz0_fortified <- fortify(moz0, region = 'NAME_ENGLISH')
moz1_fortified <- fortify(moz1, region = 'NAME_1')
moz2_fortified <- fortify(moz2, region = 'NAME_2')
moz3_fortified <- fortify(moz3, region = 'NAME_3')

man2_fortified <- fortify(man2, region = 'NAME_2')
man3_fortified <- fortify(man3, region = 'NAME_3')

mag2_fortified <- fortify(mag2, region = 'NAME_2')
mag3_fortified <- fortify(mag3, region = 'NAME_3')

mop2_fortified <- fortify(mop2, region = 'NAME_2')
mop3_fortified <- fortify(mop3, region = 'NAME_3')

objects <- ls()
for (i in 1:length(objects)){
  eval(parse(text = paste0("devtools::use_data(", objects[i], ", overwrite = TRUE)")))
}
