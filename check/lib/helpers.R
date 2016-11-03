

# Master map with tesselations at spray level
leaflet_village_master_voronoi_buffer_spray_house_number <- function(house_numbers = NULL){
  
  color_numbers <- as.numeric(factor(village_df$status))
  the_colors <- ifelse(village_df$status,
                       'darkgreen',
                       'darkred')
  status_colors <- data_frame(status = village_df$status,
                               color = the_colors)
  colors <- left_join(census_spatial_ll@data,
                      status_colors %>% filter(!duplicated(status)),
                      by = 'status') %>%
    dplyr::select(color) %>%
    unlist %>%
    as.character()
  
  status_df <- 
    census_spatial_ll@data %>%
    group_by(status) %>%
    tally %>%
    left_join(status_colors %>% filter(!duplicated(status)))
  
  
  ll <-  
    leaflet() %>%
    # addProviderTiles("OpenStreetMap.Mapnik") %>%
    addProviderTiles("Esri.WorldImagery") 
    # addProviderTiles("CartoDB.PositronOnlyLabels") %>%
    # addProviderTiles("Stamen.Watercolor") %>% 
    # addProviderTiles("Stamen.Toner") %>%
    # addProviderTiles('Stamen.TonerLabels') 
  
  # Now loop through and add borders
  for (i in 1:nrow(vvb_ll_spray)){
    message(i)
    this_status <- status_df$status[i]
    if(!is.na(this_status)){
      # Get the points only
      sub_census <- census_spatial_ll[which(census_spatial_ll$status == this_status),]
      if(nrow(sub_census) > 0){
        sub_census_projected <- 
          census_spatial[which(census_spatial$status == this_status),]
        
        # Get the border
        border <- gConvexHull(sub_census)
        the_border <- border
        
        # Get the non-buffered voronoi border
        border_voronoi <-
          vv_spray_ll[vv_spray_ll$status == this_status,]
        
        # Get the voronoi buffered border
        border_voronoi_buffered <-
          vvb_ll_spray[vvb_ll_spray$status == this_status,]
        
        if(length(border_voronoi_buffered@polygons) > 0 &
           (!class(border_voronoi_buffered)[[1]] %in% c('SpatialPoints', 'NULL'))){
          this_color <- status_df$color[i]
          ll <-
            ll %>%
            addPolygons(data = border_voronoi_buffered, 
                         color = this_color,
                         # dashArray = '1,5',
                         opacity = 0.6, weight = 1) 
        }
      }
    }
  }
  
  # Add all points
  if(is.null(house_numbers)){
    sub_data <- census_spatial_ll
  } else if (nchar(house_numbers) == 0){
    sub_data <- census_spatial_ll 
  } else{
    sub_data <-
      census_spatial_ll[which(grepl(house_numbers, census_spatial_ll$house_number,
                                    fixed = TRUE)),]
  }
    ll <-
      ll %>%
      addCircleMarkers(lng = sub_data$lng,
                       lat = sub_data$lat,
                       color = colors,
                       fillColor = colors,
                       radius = 2.5,
                       opacity = 0,
                       fillOpacity = 0.5,
                       popup = paste0('Household: ', 
                                      sub_data$house_number, 
                                      ' Village number: ',
                                      sub_data$village_number,
                                      ifelse(sub_data$within_1k_voronoi_buffer,
                                             ' In buffer',
                                             ' In core'),
                                      ifelse(is.na(sub_data$status),
                                             ' NO SPRAY',
                                             ifelse(sub_data$status,
                                                    ' SPRAY',
                                                    ' NO SPRAY'))))
    
    # Set view
    if(nrow(sub_data) == 1){
      ll <- ll %>%
        addMarkers(lng = sub_data$lng,
                   lat = sub_data$lat,
                   popup = paste0('Household: ', 
                                  sub_data$house_number, 
                                  ' Village number: ',
                                  sub_data$village_number,
                                  ifelse(sub_data$within_1k_voronoi_buffer,
                                         ' In buffer',
                                         ' In core'),
                                  ifelse(is.na(sub_data$status),
                                         ' NO SPRAY',
                                         ifelse(sub_data$status,
                                                ' SPRAY',
                                                ' NO SPRAY'))))
      ll <- ll %>%
      setView(mean(sub_data$lng, na.rm = TRUE),
              mean(sub_data$lat, na.rm = TRUE),
              zoom = 12)
    } else {
      ll <- ll  %>%
        fitBounds(min(sub_data$lng, na.rm = TRUE),
                  min(sub_data$lat, na.rm = TRUE),
                  max(sub_data$lng, na.rm = TRUE),
                  max(sub_data$lat, na.rm = TRUE))
    }
    
    
    
  x <- SpatialPolygons(mop_ll@polygons)
  proj4string(x) <- proj4string(mop_ll)
  # Add polygon
  ll <-
    ll %>%
    addPolylines(data = x)
  # 
  
  return(ll)
}
