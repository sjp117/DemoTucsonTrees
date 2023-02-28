library(shiny)
library(rgdal)
library(leaflet)
library(leafpop)

# get data

treeData <- readOGR("https://services3.arcgis.com/9coHY2fvuFjG9HQX/arcgis/rest/services/Tree_Equity_Scores_Tucson/FeatureServer/3/query?outFields=*&where=1%3D1&f=geojson")

# Define UI for app that draws a map ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Tucson AZ Trees"),
    
    # Sidebar layout with input and output definitions ----
    
    # Main panel for displaying outputs ----
    mainPanel(
        
        leafletOutput("trees", height="90vh")
        
    )
)

# Define server logic required to draw map ----
server <- function(input, output) {
    
    output$trees <- renderLeaflet({
        trees <- leaflet()
        trees <- addTiles(trees)
        trees <- addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, popup = popupTable(treeData),
                             opacity = 1.0, fillOpacity = 0.5, map = trees,data = treeData,
                             fillColor = ~colorQuantile("YlGn", TreeEquityScore)(TreeEquityScore),
                             highlightOptions = highlightOptions(color = "white", weight = 2,
                                                                 bringToFront = TRUE))
        
    })
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)