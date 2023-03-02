# import libraries

library(shiny) # for creating dashboard
library(rgdal) # for reading geojson file/link
library(leaflet) # for map
library(leafpop) # extra function for leaflet

# get data

treeData <- rgdal::readOGR("https://services3.arcgis.com/9coHY2fvuFjG9HQX/arcgis/rest/services/Tree_Equity_Scores_Tucson/FeatureServer/3/query?outFields=*&where=1%3D1&f=geojson")

# Information about the data can be fond here:
# https://data-cotgis.opendata.arcgis.com/datasets/cotgis::tree-equity-scores-tucson-1/about

# Data License Detail:

# The City of Tucson provides the data for use "as is." The areas depicted by 
# this feature class are approximate, and are not accurate to surveying or engineering 
# standards. The maps shown here are for illustration purposes only and are not 
# suitable for site-specific decision making. Information found here should not 
# be used for making financial or any other commitments. 

# The City of Tucson provides this information with the understanding that it is 
# not guaranteed to be accurate, correct or complete and conclusions drawn from 
# such information are the responsibility of the user. While every effort has 
# been made to ensure the accuracy, correctness and timeliness of materials presented, 
# the City of Tucson assumes no responsibility for errors or omissions, even if 
# The City of Tucson is advised of the possibility of such damage.

# Define UI for app that draws a map ----

ui <- fluidPage(
    
    # App title ----
    titlePanel("Tucson AZ Trees"),
    
    # Sidebar layout with input and output definitions ----
    
    # Main panel for displaying outputs ----
    mainPanel(
        
        leaflet::leafletOutput("trees", height="90vh")
        
    )
)

# Define server logic required to draw map ----

server <- function(input, output) {
    
    output$trees <- leaflet::renderLeaflet({
        trees <- leaflet::leaflet() 
        trees <- leaflet::addTiles(trees) %>% leaflet::addProviderTiles("CartoDB.Voyager")
        trees <- leaflet::addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, popup = leafpop::popupTable(treeData),
                             opacity = 1.0, fillOpacity = 0.5, map = trees,data = treeData,
                             fillColor = ~colorQuantile("RdYlGn", TreeEquityScore)(TreeEquityScore),
                             highlightOptions = highlightOptions(color = "white", weight = 2,
                                                                 bringToFront = TRUE))
        
    })
    
}

# Create Shiny app ----

shinyApp(ui = ui, server = server)