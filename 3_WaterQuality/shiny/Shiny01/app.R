##Load USGS Water Use data and enable visualization by state
# 1. Create table from URL (for a user specified year...) > useTbl
# 2. Load fips->stateName crosswalk table (fipsTbl), join with use data
# 3. Join data with State Map
# 4. Select attribute and show variable

#Load libraries
library(shiny)
library(dplyr)
library(magrittr)
library(ggplot2)
library(maps)
library(mapdata)

# #Load data (remove last column named 'X', which is just an artifact)
# theURL <- 'http://water.usgs.gov/watuse/data/2010/usco2010.txt'
# dataTbl = read.table(theURL, sep='\t',header=TRUE) %>%
#   select(-X) #Removes the "X" column
# 
# #Load the Fips remap table
# theURL <- "https://raw.githubusercontent.com/johnpfay/WaterAccounting/ExploreData/RWorkspace/ShinySandbox/stfipstable.csv"
# fipsTbl <- read.csv(theURL) %>%
#   select(one_of(c("FIPS.Code","State.Name")))
# 
# #Join state names
# dataTbl <- left_join(dataTbl,fipsTbl,by = c("STATEFIPS" = "FIPS.Code"))
# 
# #Drop non-data fields
# dataTbl <- select(dataTbl,-(STATE:YEAR))
# 
# #Group records on states and compute sum of values
# stateTbl = group_by(dataTbl,State.Name) %>%
#   select(-contains("PCp")) %>% #Remove per-capita columns
#   summarise_each(funs(mean(., na.rm = TRUE)))

theURL <- "https://raw.githubusercontent.com/johnpfay/WaterAccounting/ExploreData/RWorkspace/ShinySandbox/StateData.csv"
stateTbl = read.csv(theURL,header=TRUE)

#Join to state map
states <- map_data("state") 
allData <- left_join(states,stateTbl,c("region" = "State.Name"))

#Generate a list of variables (skipping the first item: "State.Name")
useVars <- colnames(stateTbl)[-1:-2]

##Clean up: Remove dataTbl and fipsTbl
#remove(dataTbl,fipsTbl,stateTbl)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("USGS Water use data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("useParam",
                     "Select parameter",
                     useVars)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("usMap")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$usMap <- renderPlot({
     #Make series of user variable
     userSeries = select(allData,one_of(input$useParam))
     # Generate map
     p <- ggplot()
     p <- p + geom_polygon(data=allData, aes(x=long, y=lat, group=group, fill=userSeries),colour="white"
     ) + scale_fill_continuous(low = "thistle2", high = "darkred", guide="colorbar")
     P1 <- p + theme_bw()  + labs(fill = "legend" 
                                  ,title = "Title, 2010", x="", y="")
     P1 + scale_y_continuous(breaks=c()) + scale_x_continuous(breaks=c()) + theme(panel.border = element_blank())

   })
}

# Run the application 
shinyApp(ui = ui, server = server)

