#Read in USGS data - monthly streamflow statistics
install.packages("dataRetrieval", repos=c("http://owi.usgs.gov/R", getOption("repos")))

library(dataRetrieval); library(EGRET)
library (ggplot2);  library(trend); library(lubridate)
library(dplyr); library(magrittr); library(leaflet)


#access vignette if needed
rm(list=ls()) #removes anything stored in memory


#################################################################################################################################
##############                                 Load in site data                               ############################
#################################################################################################################################
#set working directlry
swd <- "c:/Users/lap19/Documents/Class/Data Boot Camp/Unit3 Water Quality/"

#read in the csv files  
sites <- read.csv(paste0(swd,"station.csv"), sep=',',header=TRUE); dim(sites)
  sites[1:3,]

#plot sites
map <-  leaflet(data=sites) %>% 
    addProviderTiles("CartoDB.Positron") %>%
    addCircleMarkers(~LongitudeMeasure,~LatitudeMeasure,
                     color = "red", radius=3, stroke=FALSE,
                     fillOpacity = 0.8, opacity = 0.8,
                     popup=~MonitoringLocationName)  
map
  
# subset to only include those with a drainage area exceeding 25 square miles
sites2 <- subset(sites, DrainageAreaMeasure.MeasureValue >= 25); dim(sites)

#where are sites located?
leaflet(data=sites) %>%  
    addProviderTiles("CartoDB.Positron") %>%
    addCircleMarkers(~LongitudeMeasure,~LatitudeMeasure,
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~MonitoringLocationName) %>%
    addCircleMarkers(~sites2$LongitudeMeasure,~sites2$LatitudeMeasure,
                 color = "blue", radius=3, stroke=FALSE,
                 fillOpacity = 0.8, opacity = 0.8,
                 popup=~MonitoringLocationName)
#Notice there are numerous NA values... therefore we will look at all data
#Notice for Jordan Lake... the two values we will be most interested in are: Haw River at SR 1943 and 
#All the names on Jordan Lake are "Jordan Lake"... change popup name to see options
leaflet(data=sites) %>%  
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~LongitudeMeasure,~LatitudeMeasure,
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~MonitoringLocationIdentifier)
 

#reduce columns to those needed
sites <- sites[,c(1,3:4,8:9,12:13)]


#################################################################################################################################
##############                                 Load in measurement data                               ############################
#################################################################################################################################
results <- read.csv(paste0(swd,"result.csv"), sep=',',header=TRUE); dim(results)
  names(results)

unique(results$HydrologicEvent);
unique(results$CharacteristicName)

#filter data
nitrogen <-results %>% 
          filter(ActivityMediaSubdivisionName=="Surface Water") %>% 
          filter(HydrologicEvent != "Storm" & HydrologicEvent != "Flood" & HydrologicEvent != "Spring breakup" & HydrologicEvent != "Drought") %>%
          filter(CharacteristicName=="Nitrogen, mixed forms (NH3), (NH4), organic, (NO2) and (NO3)") %>%
          filter(ResultSampleFractionText=="Total")
dim(nitrogen)

#check that filters worked
unique(nitrogen$HydrologicEvent); unique(nitrogen$ActivityMediaSubdivisionName)
unique(nitrogen$CharacteristicName);  unique(nitrogen$ResultSampleFractionText)

#reduce to needed columns
nitrogen <- nitrogen[,c(1,7,22,31:35,59:61)]

#set data below detection limits equal to 1/2 the detection limit
nitrogen$TotalN <- ifelse(nitrogen$ResultDetectionConditionText=="Not Detected", nitrogen$DetectionQuantitationLimitMeasure.MeasureValue/2, nitrogen$ResultMeasureValue)
#convert mg/l as No3 to mg/l as N
#The atomic weight of nitrogen is 14.0067 and the molar mass of nitrate anion (NO3) is 62.0049 g/mole
#Therefore, to convert Nitrate-NO3 (mg/L) to Nitrate-N (mg/L):  Nitrate-N (mg/L) = 0.2259 x Nitrate-NO3 (mg/L)
#Nitrate-NO3 (mg/L) = 4.4268 x Nitrate-N (mg/L) 

nitrogen$TotalN <- ifelse(nitrogen$ResultMeasure.MeasureUnitCode=="mg/l NO3", nitrogen$TotalN*0.2259, nitrogen$TotalN)
nitrogen$TotalN <- ifelse(nitrogen$DetectionQuantitationLimitMeasure.MeasureUnitCode=="mg/l NO3", nitrogen$TotalN*0.2259, nitrogen$TotalN)



#################################################################################################################################
##############                                 Merge sites and measurements                              ############################
#################################################################################################################################
nitrogen.data <- merge(sites, nitrogen, by.x="MonitoringLocationIdentifier", by.y="MonitoringLocationIdentifier"); dim(nitrogen.data)
  nitrogen.data$Year <- year(nitrogen.data$ActivityStartDate);                    table(nitrogen.data$Year)
  nitrogen.data$Month <- month(nitrogen.data$ActivityStartDate);                  table(nitrogen.data$Month)

#ED to know which sites to keep or remove
unique.sites <- unique(nitrogen.data$MonitoringLocationIdentifier)
  n.sites <- length(unique.sites)

#Create dataframe of information on: n samples, start year, end year
site.info <- nitrogen.data %>%
  group_by(MonitoringLocationIdentifier) %>%
  summarise(n=n(), StartYear=min(Year), EndYear=max(Year))
site.info <- as.data.frame(site.info) 
site.info$Range <- site.info$EndYear-site.info$StartYear
site.info

#Limit data to those with more than 10 years data and still operating
site.info <- filter(site.info, Range>=10 & EndYear==2017); site.info
df <- nitrogen.data[nitrogen.data$MonitoringLocationIdentifier %in% unique(site.info$MonitoringLocationIdentifier), ]; dim(df)

#Where are they located
leaflet(data=df) %>%  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~LongitudeMeasure,~LatitudeMeasure,
                   color = "red", radius=5, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~MonitoringLocationIdentifier)


#Jordan Lake Rules are for Nitrogen as pounds per year
####Plot nitrogen over time at each site
unique.site <- unique(df$MonitoringLocationIdentifier)

#convert activity date into a data
df$Date <- as.Date(df$ActivityStartDate, "%Y-%m-%d")
df$Year <- year(df$Date);   df$Month <- month(df$Date)


i=1
for (i in length(unique.site)){
  zt <- filter(df, MonitoringLocationIdentifier == unique.site[i])
  
  #group by date - take average of a day
  foo <- zt %>% group_by(Date) %>% 
    summarise(AverageN = mean(TotalN, na.rm=TRUE), Year=mean(Year), Month=mean(Month))
  foo <- as.data.frame(foo)
  
  foo$color <- rgb(0.596,0.961,1,0.5)
  foo$color <- ifelse(foo$Month==1, rgb(0.478,0.772,0.804,0.8), foo$color)
  foo$color <- ifelse(foo$Month==2, rgb(0.325,0.525,0.545,0.8), foo$color)  
  foo$color <- ifelse(foo$Month==3, rgb(0.792,1,0.439,0.8), foo$color)    
  foo$color <- ifelse(foo$Month==4, rgb(0.635,0.804,0.352,0.8), foo$color)    
  foo$color <- ifelse(foo$Month==5, rgb(0.333,0.420,0.184,0.8), foo$color)  
  foo$color <- ifelse(foo$Month==6, rgb(1,0.447,0.337,0.8), foo$color)
  foo$color <- ifelse(foo$Month==7, rgb(0.804,0.357,0.114,0.8), foo$color)  
  foo$color <- ifelse(foo$Month==8, rgb(0.545,0,0,0.8), foo$color)  
  foo$color <- ifelse(foo$Month==9, rgb(1,0.765,0.059,0.8), foo$color)  
  foo$color <- ifelse(foo$Month==10, rgb(0.804,0.584,0.047,0.8), foo$color)  
  foo$color <- ifelse(foo$Month==11, rgb(0.545,0.396,0.031,0.8), foo$color)  
  
  #create a plot
  par(mfrow=c(1,1))
  layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE), widths=c(2,2), heights=c(1.5,1.5))
  par(mar = c(2,5,2,2)) #set plot margins
  
  #Plot single graph on top row
  plot(foo$Date, foo$AverageN, type='n', yaxt="n", main=zt$MonitoringLocationIdentifier[i], ylab="Total Nitrogen (mg/l)", xlab = '', cex.lab=0.9, ylim=c(0,6))
    axis(2, las=2, cex.axis=0.8)
  lines(foo$Date, foo$AverageN, col=rgb(0,0,0,0.4))  
  points(foo$Date, foo$AverageN, col=foo$color, cex=0.8, pch=19)  
  
  legend_order <- matrix(1:12,ncol=4,byrow = TRUE)
  legend("topright", c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),
         pch=19, col=c(rgb(0.478,0.772,0.804,0.8),rgb(0.325,0.525,0.545,0.8),rgb(0.792,1,0.439,0.8),rgb(0.635,0.804,0.352,0.8),rgb(0.333,0.420,0.184,0.8),
                       rgb(1,0.447,0.337,0.8),rgb(0.804,0.357,0.114,0.8),rgb(0.545,0,0,0.8),rgb(1,0.765,0.059,0.8),rgb(0.804,0.584,0.047,0.8),
                       rgb(0.545,0.396,0.031,0.8), rgb(0.596,0.961,1,0.5)), ncol=4)
  
  #Add blank months to foo in case
  blank.months <- as.data.frame(matrix(nrow=12,ncol=5)); colnames(blank.months) <- colnames(foo)
  months.tab <- as.data.frame(table(foo$Month)); colnames(months.tab)<-c("Month","Freq");
  k=1
  for (j in 1:12){
    check <- j; 
    check.zt <- subset(months.tab, Month==j)
  
    if(dim(check.zt)[1]==0){
      blank.months$Month[k]=check;   blank.months$AverageN[k]=0
      k=k+1    
    }
  }
  blank.months <- blank.months[!is.na(blank.months$Month),]
  blank.months
  foo.mo <- rbind(foo, blank.months)
  
  boxplot(foo.mo$AverageN~foo.mo$Month, yaxt="n", ylab="Total Nitrogen (mg/l)", ylim=c(0,6), yaxs='i',
          col=c(rgb(0.478,0.772,0.804,0.8),rgb(0.325,0.525,0.545,0.8),rgb(0.792,1,0.439,0.8),rgb(0.635,0.804,0.352,0.8),rgb(0.333,0.420,0.184,0.8),
                rgb(1,0.447,0.337,0.8),rgb(0.804,0.357,0.114,0.8),rgb(0.545,0,0,0.8),rgb(1,0.765,0.059,0.8),rgb(0.804,0.584,0.047,0.8)), pch=19, cex=0.7)
  axis(2, las=2)
  mtext("Nitrogen by Month", side=3, line=-2)
  abline(h=0.01, col="black", lwd=1)
  
  
  #Add blank years to foo in case
  blank.years <- as.data.frame(matrix(nrow=12,ncol=5)); colnames(blank.years) <- colnames(foo)
  year.tab <- as.data.frame(table(foo$Year)); colnames(year.tab)<-c("Year","Freq");
  year.tab$Year <- as.numeric(as.character(year.tab$Year))
  k=1
  
  for (j in min(year.tab$Year):max(year.tab$Year)){
    check <- j; 
    check.zt <- subset(year.tab, Year==check)
    
    if(dim(check.zt)[1]==0){
      blank.years$Year[k]=check;   blank.years$AverageN[k]=0
      k=k+1    
    }
  print(check)
  }
  blank.years <- blank.years[!is.na(blank.years$Year),]
  blank.years
  
  foo.yr <- rbind(foo, blank.years)
  
  boxplot(foo.yr$AverageN~foo.yr$Year, yaxt="n", ylab="Total Nitrogen (mg/l)", ylim=c(0,6), col="grey", pch=19, cex=0.7)
  axis(2, las=2)
  mtext("Nitrogen by Year", side=3, line=-2)
  abline(h=10, col="red", lwd=2, lty=4)
}


#################################################################################################################################
####                        Plot 2017 Nitrogen contribution by size                                            ####################
#################################################################################################################################
nitrogen.data$Year <- year(nitrogen.data$ActivityStartDate)
last.year <- filter(nitrogen.data, Year==2017)
last.year.n <- last.year %>%
  group_by(MonitoringLocationIdentifier) %>%
  summarize(AveN = mean(TotalN, na.rm=T), LongitudeMeasure = mean(LongitudeMeasure), LatitudeMeasure = mean(LatitudeMeasure))
last.year.n <- as.data.frame(last.year.n)

last.year.n$AveN <- round(last.year.n$AveN,3)

leaflet(data=last.year.n) %>%  
  addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(~LongitudeMeasure,~LatitudeMeasure,
                   color = "red", radius=~AveN*5, stroke=FALSE,
                   fillOpacity = 0.6, opacity = 0.8,
                   popup=~paste0(MonitoringLocationIdentifier, "<br>",
                          "Average 2017 N: ", AveN, " mg/l"))






#################################################################################################################################
##############                                 Jordan Lake Thresholds  --HAW BRANCH                          ############################
#################################################################################################################################
#USGS-0209699999 is the arm of the Haw River and there is a USGS stream gauge site nearby: USGS 02096960
#Identify gauge to download
siteNo <- '02096960' 
#Identify parameter of interest: https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
pcode = '00060' #discharge (cfs)
#Identify statistic code for daily values: https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html
scode = "00003"  #mean
#Identify start and end dates
start.date = "1970-10-01"
end.date = "2017-12-31"

#Load in data using the site ID
q <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)
  q <- renameNWISColumns(q); colnames(q)
q.siteInfo <- attr(q, "siteInfo")
q$Year <- year(q$Date);  q$Month <- month(q$Date)

haw.n <- filter(df, MonitoringLocationIdentifier == "USGS-0209699999")
#where are sites located?
leaflet(data=q.siteInfo) %>%  
  addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(~dec_lon_va,~dec_lat_va,
                   color = "blue", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm) %>%
  addCircleMarkers(~haw.n$LongitudeMeasure[1],~haw.n$LatitudeMeasure[2],
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~haw.n$MonitoringLocationName[1])


#Calculate total volume of water each year
q$Flow_MGD <- 646317*q$Flow/1000000
q.year <- q %>% 
  group_by(Year) %>%  
  summarise(Total_MGD = sum(Flow_MGD, na.rm=T), n=n())
q.year <- as.data.frame(q.year)
q.year <- filter(q.year, n>=350)


#calculate the average Nitrate concentration
n.year <- haw.n %>% 
  group_by(Year) %>%  
  summarise(AveN = mean(TotalN, na.rm=T), n=n())
n.year <- as.data.frame(n.year)



#For days with a water quality measurement - what was the daily flow?
haw.n <- merge(n.year, q.year, by.x="Year", by.y="Year")
lbspergal <- 8.34
haw.n$Pounds <- haw.n$Total_MGD*haw.n$AveN*lbspergal

par(mfrow=c(1,1))
par(mar = c(2,5,2,2)) #set plot margins

#Plot single graph on top row
plot(haw.n$Year, haw.n$Pounds/1000000, type='n', yaxt="n", main="Haw River Branch", ylab="Annual Nitrogen Load (million lbs)", xlab = '', cex.lab=0.9)
  axis(2, las=2, cex.axis=0.8)
  lines(haw.n$Year, haw.n$Pounds/1000000, col=rgb(0,0,0,0.4))  
  points(haw.n$Year, haw.n$Pounds/1000000, col=rgb(0,0,0,0.6), cex=1, pch=19)  
abline(h=2567000/1000000, col="red", lty=4, lwd=2)





#################################################################################################################################
##############                                 Jordan Lake Thresholds  --NEW HOPE CREEK                          ############################
#################################################################################################################################
#USGS-0209768310 is the arm of the Haw River and there are three usgs gauges upstream on different tributaries
#Identify gauge to download
siteNo <- c('02097314', '02097517','0209741955')
#Identify parameter of interest: https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
pcode = '00060' #discharge (cfs)
#Identify statistic code for daily values: https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html
scode = "00003"  #mean
#Identify start and end dates
start.date = "1970-10-01"
end.date = "2017-12-31"

#Load in data using the site ID
q <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)
q <- renameNWISColumns(q); colnames(q)
q.siteInfo <- attr(q, "siteInfo")
q$Year <- year(q$Date);  q$Month <- month(q$Date)
#If flow is unknown set to NA
q$Flow <- ifelse(q$Flow <0,NA, q$Flow)

newhope.n <- filter(df, MonitoringLocationIdentifier == "USGS-0209768310")
#where are sites located?
leaflet(data=q.siteInfo) %>%  
  addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(~dec_lon_va,~dec_lat_va,
                   color = "blue", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm) %>%
  addCircleMarkers(~newhope.n$LongitudeMeasure[1],~newhope.n$LatitudeMeasure[2],
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~newhope.n$MonitoringLocationName[1])

#Calculate total volume of water each year
q$Flow_MGD <- 646317*q$Flow/1000000
q.year <- q %>% 
  group_by(Year) %>%  
  summarise(Total_MGD = sum(Flow_MGD, na.rm=T), n=n())
q.year <- as.data.frame(q.year)
q.year <- filter(q.year, n>=350*3)


#calculate the average Nitrate concentration
n.year <- newhope.n %>% 
  group_by(Year) %>%  
  summarise(AveN = mean(TotalN, na.rm=T), n=n())
n.year <- as.data.frame(n.year)


#For days with a water quality measurement - what was the daily flow?
newhope.n <- merge(n.year, q.year, by.x="Year", by.y="Year")
lbspergal <- 8.34
newhope.n$Pounds <- newhope.n$Total_MGD*newhope.n$AveN*lbspergal

par(mfrow=c(1,1))
par(mar = c(2,5,2,2)) #set plot margins

#Plot single graph on top row
plot(newhope.n$Year, newhope.n$Pounds/1000, type='n', yaxt="n", main="New Hope Arm", ylab="Annual Nitrogen Load (thousand lbs)", xlab = '', cex.lab=0.9, ylim=c(0,800))
  axis(2, las=2, cex.axis=0.8)
  lines(newhope.n$Year, newhope.n$Pounds/1000, col=rgb(0,0,0,0.4))  
  points(newhope.n$Year, newhope.n$Pounds/1000, col=rgb(0,0,0,0.6), cex=1, pch=19)  
abline(h=641021/1000, col="red", lty=4, lwd=2)

#Likely underestimates because missing several tributary contributions
#Jordan Lake at teh reservoir is 1,689 mi2. The Haw River Branch is 1,275 mi2. A tributary downstream of newhope.n is 12 mi2
#The upstream drainage are of the 3 sites are: 76.9, 21.1, and 41 mi2

site.da <- 76.9+21.2+41
remaining.da <- 1689-1275-12
fraction <- 0.75

adjust.da <- remaining.da*fraction
newhope.n$adj.pounds <- newhope.n$Pounds*adjust.da/site.da

plot(newhope.n$Year, newhope.n$adj.pounds/1000, type='n', yaxt="n", main="New Hope Arm", ylab="Annual Nitrogen Load (thousand lbs)", xlab = '', cex.lab=0.9, ylim=c(0,1000))
axis(2, las=2, cex.axis=0.8)
  lines(newhope.n$Year, newhope.n$Pounds/1000, col=rgb(0,0,0,0.4))  
  points(newhope.n$Year, newhope.n$Pounds/1000, col=rgb(0,0,0,0.6), cex=1, pch=19)  

  lines(newhope.n$Year, newhope.n$adj.pounds/1000, col=rgb(0.5,0,0,0.4), lty=2)  
  points(newhope.n$Year, newhope.n$adj.pounds/1000, col=rgb(0.5,0,0,0.4), cex=1, pch=19)  
abline(h=641021/1000, col="red", lty=4, lwd=2)
mtext(paste0("Adjust by ", fraction, " drainage area fraction"), side=3, line=-2)




#SAVE DATA OUT FOR TABLEAU
#write csv
write.csv(df, paste0(swd,'/tableau/nitrogen.csv'),row.names=FALSE)
write.csv(haw.n, paste0(swd, '/tableau/hawbranch.csv'),row.names=FALSE)
write.csv(newhope.n, paste0(swd, '/tableau/newhope.csv'),row.names=FALSE)

