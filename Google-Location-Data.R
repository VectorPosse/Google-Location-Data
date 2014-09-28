## From the Educate R blog
## http://educate-r.org//2014/09/26/googlelocations/


library(RJSONIO)
library(data.table)
library(dplyr)
library(ggmap)
library(maps)
library(ggplot2)

json_file <- "Takeout/LocationHistory.json"
json_data <- fromJSON(json_file)
latlong <- as.data.frame(do.call("rbind", (json_data[[2]])))
latlong2 <- latlong %>%
    select(lat = latitudeE7, long = longitudeE7) %>%
    lapply(unlist) %>%
    data.frame() %>%
    mutate(lat = lat/10000000, long = long/10000000)

png("Google-Location-Data-US.png", width = 960, height = 960)
qmap(location = "united states", zoom = 4) +
    geom_point(data = latlong2, aes(x = long, y = lat), 
               alpha = .1, color = "blue", size = 6)
dev.off()

png("Google-Location-Data-SLC.png", width = 960, height = 960)
qmap(location = "salt lake city") +
    geom_point(data = latlong2, aes(x = long, y = lat), 
        alpha = .1, color = "blue", size = 6)
dev.off()

## Original code doesn't work. Taking the first three characters and inserting a 
## decimal only works if there a two digits in the degrees:
#
# latlong2$latR <- as.numeric(paste0(substr(as.character(latlong2$latitudeE7), 1, 2), 
#     ".", substr(as.character(latlong2$latitudeE7), 3, 4)))
# latlong2$longR <- as.numeric(paste0(substr(as.character(latlong2$longitudeE7), 1, 3), 
#     ".", substr(as.character(latlong2$longitudeE7), 4, 5)))

# states <- map_data("state")

# png(filename="Google-Location-Data.png", )
# p <- ggplot(states) + 
#     geom_polygon(aes(x = long, y = lat, group = group), 
#         fill = "white", color = "black") + 
#     theme_bw() + 
#     theme(axis.text = element_blank(), line = element_blank(), 
#         rect = element_blank(), axis.title = element_blank())
# p + geom_point(data = latlong2, aes(x = long, y = lat), 
#     alpha = .01, color = "red", size = 3)
# dev.off()
