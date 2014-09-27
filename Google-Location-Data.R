## From the Educate R blog
## http://educate-r.org//2014/09/26/googlelocations/


library(rjson)
json_file <- "Takeout/LocationHistory.json"
json_data <- fromJSON(file = json_file)
latlong <- data.frame(do.call("rbind", json_data[[2]]))
latlong2 <- subset(latlong, select = c(latitudeE7, longitudeE7))
latlong2$latR <- as.numeric(paste0(substr(as.character(latlong2$latitudeE7), 1, 2), 
    ".", substr(as.character(latlong2$latitudeE7), 3, 4)))
latlong2$longR <- as.numeric(paste0(substr(as.character(latlong2$longitudeE7), 1, 3), 
    ".", substr(as.character(latlong2$longitudeE7), 4, 5)))

library(maps)
library(ggplot2)

states <- map_data("state")

p <- ggplot(states) + 
    geom_polygon(aes(x = long, y = lat, group = group), 
        fill = "white", color = "black") + 
    theme_bw() + 
    theme(axis.text = element_blank(), line = element_blank(), 
        rect = element_blank(), axis.title = element_blank())
p + geom_point(data = latlong2, aes(x = longR, y = latR), 
    alpha = .01, color = "red", size = 3)