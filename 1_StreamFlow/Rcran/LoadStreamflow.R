#Read in USGS data - monthly streamflow statistics
install.packages("dataRetrieval", repos=c("http://owi.usgs.gov/R", getOption("repos")))
library(dataRetrieval)
library(EGRET)
library (ggplot2)

#access vignette if needed
vignette("dataRetrieval", package="dataRetrieval")

#set working directory
swd <- "C://Users//Lauren Patterson//Documents//Class//Data Boot Camp//"

#################################################################################################################################
##############                                  DOWNLOAD DATA                                        ############################
#################################################################################################################################
#Identify gauge to download
siteNo <- '02087500' #Clayton, don't forget to add the zero if it is missing
siteNo <- '02089000' #Goldsboro, don't forget to add the zero if it is missing

#Identify parameter of interest: https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
pcode = '00060' #discharge (cfs)

#Identify statistic code for daily values: https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html
scode = "00003"  #mean

#Identify start and end dates
start.date = "1930-10-01"
end.date = "2017-09-30"

#pick service
serv <- "dv"


#Load in data using the site ID
neuse <- readNWISdata(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date, service = serv)
  summary(neuse); dim(neuse)
  
#OR You can use basic web retrievals (just remove the service call)
  #readNWISuv = unit data;            readNWISdv = daily data;            readNWISgwl = groundwater level
  #readNWISmeas = surface water;      readNWISpeak = peakflow;            readNWISqw = water quality
  #readNWISrating = rating curves;    readNWISpCode = parameter code      readNWISsite = Site data
  neuse <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)
  
#rename columns to something more useful
  neuse <- renameNWISColumns(neuse); colnames(neuse)

#see attributes
attributes(neuse)
#to access attributes in future: attr(neuse, "name of interest)
names(attributes(neuse))
  parameterInfo = attr(neuse, "variableInfo")
  siteInfo <- attr(neuse, "siteInfo")
#################################################################################################################################



#################################################################################################################################
##############                                  PLOT DATA                                        ############################
#################################################################################################################################
#Create cms column to plot cubic meters per second
neuse$Flow_cms <- neuse$Flow*0.028316847
  summary(neuse)
  
#Basic plot
par(mar = c(3,5,2,5)) #set plot margins
plot(neuse$Date, neuse$Flow_cms, type='n', yaxt="n", xlim=c(min(neuse$Date),max(neuse$Date)),
       ylab="Streamflow (cms)", xlab = '', main=siteInfo$station_nm)                   
       #yaxs="i", xaxs="i")#gets rid of spaces inside plot
  axis(2, las=2, cex.axis=0.9)
  lines(neuse$Date, neuse$Flow_cms, col="blue", lty=1, lwd=1)
  abline(v=as.Date("1984-01-01"), lty=3, col="black", lwd=2)
  
#OR
#Gplot
ts <- ggplot(data=neuse, aes(Date,Flow_cms)) +
      geom_line(colour="blue")
#make it prettier
ts <- ts + xlab("") + ylab("Streamflow (cms)") +
      ggtitle(siteInfo$station_nm)
ts
#################################################################################################################################



#################################################################################################################################
##############                                  SUMMARY STATISTICS                                        ############################
#################################################################################################################################
#How confident are we in the data?
total.n <- dim(neuse)[1]; total.n
table(neuse$Flow_cd)
confidence <- as.data.frame(table(neuse$Flow_cd))  #places table into a dataframe
  colnames(confidence)<-c("Category","Number")     #creates meaningful column names
  confidence$Percent <- confidence$Number/total.n*100
      confidence$Percent <- round(confidence$Percent,2)
confidence

#quick plot if interested
pie(confidence$Percent, labels=confidence$Category, col=c("cornflowerblue","lightblue","darkorange","orange"), cex=0.7)

#####################################################################################################################################
####                                    USING FUNCTIONS
#####################################################################################################################################
#create data frame
sum.stats <- as.data.frame(matrix(nrow=8, ncol=4))
  colnames(sum.stats) <- c("Statistics","p1930-2017","p1930-1979","p1984-2017")
#Fill in first column
  sum.stats$Statistics <- c("Min","10th percentile","25th percentile","Median","Mean","75th percentile", "90th percentile","Max")

#Function to fill in second column
  #data.frame[row number, column number]
gen_stats = function(data, column.no){
  sum.stats[1,column.no] <- min(data$Flow_cms);               
  sum.stats[2,column.no] <- quantile(data$Flow_cms, 0.10);             sum.stats[3,column.no] <- quantile(data$Flow_cms, 0.25);
  sum.stats[4,column.no] <- median(data$Flow_cms);                     sum.stats[5,column.no] <- mean(data$Flow_cms);
  sum.stats[6,column.no] <- quantile(data$Flow_cms, 0.75);             sum.stats[7,column.no] <- quantile(data$Flow_cms, 0.90);
  sum.stats[8,column.no] <- max(data$Flow_cms);               
  
  return(sum.stats)
}
sum.stats <- gen_stats(neuse, 2)
sum.stats$`p1930-2017` <- round(sum.stats$`p1930-2017`,3)
sum.stats

#Subset data and rerun function
neuse.pre1980 <- subset(neuse, Date<="1979-12-31");          summary(neuse.pre1980$Date)
neuse.post1984 <- subset(neuse, Date>="1984-01-01");         summary(neuse.post1984$Date)

#call the function to calculate summary statistics
sum.stats <- gen_stats(neuse.pre1980,3)
sum.stats <- gen_stats(neuse.post1984,4)

#round values
sum.stats[,c(2:4)]<- round(sum.stats[,c(2:4)],3)
  sum.stats

  
  #####################################################################################################################################
  ####                                    USING DPLYR AND PIPES
  #####################################################################################################################################
library(dplyr); library(magrittr)
  #create data frame
  sum.stats2 <- as.data.frame(matrix(nrow=8, ncol=4))
  colnames(sum.stats2) <- c("Statistics","p1930-2017","p1930-1980","p1984-2017")
  #Fill in first column
  sum.stats2$Statistics <- c("Min","p10","p25","Median","Mean","p75", "p90","Max")

sum.stats2 <- neuse %>%
    summarize(min = min(Flow_cms, na.rm=TRUE),
              p10 = quantile(Flow_cms, 0.10, na.rm=TRUE),
              p25 = quantile(Flow_cms, 0.25, na.rm=TRUE),
              median = median(Flow_cms, na.rm=TRUE),
              mean = mean(Flow_cms, na.rm=TRUE),
              p75 = quantile(Flow_cms, 0.75, na.rm=TRUE),
              p90 = quantile(Flow_cms, 0.90, na.rm=TRUE),
              max = max(Flow_cms, na.rm=TRUE)
              )
sum.stats2 <- as.data.frame(sum.stats2)

sum.stats2[2,] <- neuse %>%
  filter(Date<="1979-12-31") %>%
  summarize(min = min(Flow_cms, na.rm=TRUE),
            p10 = quantile(Flow_cms, 0.10, na.rm=TRUE),
            p25 = quantile(Flow_cms, 0.25, na.rm=TRUE),
            median = median(Flow_cms, na.rm=TRUE),
            mean = mean(Flow_cms, na.rm=TRUE),
            p75 = quantile(Flow_cms, 0.75, na.rm=TRUE),
            p90 = quantile(Flow_cms, 0.90, na.rm=TRUE),
            max = max(Flow_cms, na.rm=TRUE)
  )

sum.stats2[3,] <- neuse %>%
  filter(Date>="1984-01-01") %>%
  summarize(min = min(Flow_cms, na.rm=TRUE),
            p10 = quantile(Flow_cms, 0.10, na.rm=TRUE),
            p25 = quantile(Flow_cms, 0.25, na.rm=TRUE),
            median = median(Flow_cms, na.rm=TRUE),
            mean = mean(Flow_cms, na.rm=TRUE),
            p75 = quantile(Flow_cms, 0.75, na.rm=TRUE),
            p90 = quantile(Flow_cms, 0.90, na.rm=TRUE),
            max = max(Flow_cms, na.rm=TRUE)
  )
  
#reshape and round tables
final.stats <- as.data.frame(t(round(sum.stats2,3))); 
  final.stats$Statistics <- row.names(final.stats);
final.stats <- final.stats[,c(4,1,2,3)]; #reorder data frame
colnames(final.stats) <- c("Statistics","p1930-2017","p1930-1980","p1984-2017")
  final.stats  
#################################################################################################################################
  
  
  
#################################################################################################################################
##############                                  SEASONAL VARIATION?                                       ############################
#################################################################################################################################  
#add year and month values
library(lubridate)
neuse$Year <- year(neuse$Date);  neuse$Month <- month(neuse$Date)
  summary(neuse)  

#####################################################################################################################################
#Mean monthly flow  --> dplyr example
  #####################################################################################################################################
month.flow1 <- neuse %>%
  group_by(Month) %>%
  summarise(p1930to2017 = mean(Flow_cms, na.rm=T)) %>%  round(3)
  
month.flow2 <- neuse %>%
  filter(Date<="1979-12-31") %>%
  group_by(Month) %>%
  summarise(p1930to1980 = mean(Flow_cms, na.rm=T)) %>%  round(3)

month.flow3 <- neuse %>%
  filter(Date>="1984-01-01") %>%
  group_by(Month) %>%
  summarise(p1984to2017 = mean(Flow_cms, na.rm=T)) %>%  round(3)

#create dataframe and bind 3 tables together
month.flow <- as.data.frame(cbind(month.flow1, month.flow2[,2], month.flow3[,2])) 
  

#####################################################################################################################################
#Mean monthly flow  --> for loop example
#####################################################################################################################################
#set up data frame
month.flow <- as.data.frame(matrix(nrow=0,ncol=4));                 colnames(month.flow) <- c("Month","p1930to2017","p1930to1980","p1984to2017")
unique.month <- unique(neuse$Month)

for (j in 1:length(unique.month)){
  #subset data to month of interest
  zt <- subset(neuse, Month==unique.month[j])
  zt.early <- subset(zt, Year<=1979);             zt.late <- subset(zt, Year>=1984)
  
  #fill in dataframe
  month.flow[j,1]<-unique.month[j];                                      month.flow[j,2] <- round(mean(zt$Flow_cms, na.rm=TRUE),3)
  month.flow[j,3] <- round(mean(zt.early$Flow_cms, na.rm=TRUE),3);       month.flow[j,4] <- round(mean(zt.late$Flow_cms, na.rm=TRUE),3)     
}
month.flow
#May need to reorder
month.flow <- arrange(month.flow,Month) #automatically sorts ascending. If want to descend: arrange(month.flow,desc(Month))


#Plot results
#Basic plot
par(mar = c(3,5,2,5)) #set plot margins
plot(month.flow$Month, month.flow$p1930to2017, type='n', yaxt="n", xaxt="n", ylim=c(0,max(month.flow$p1930to2017)+10),
     ylab="Mean Streamflow (cms)", xlab = '', main=siteInfo$station_nm,
     yaxs="i", xaxs="i")#gets rid of spaces inside plot
  axis(2, las=2, cex.axis=0.9)
  axis(1, at=seq(1,12,1), labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), cex.axis=0.9)

  lines(month.flow$Month, month.flow$p1930to2017, col=rgb(0,0,0,0.5), lty=1, lwd=2)
  lines(month.flow$Month, month.flow$p1930to1980, col=rgb(0.8,0,0,1), lty=1, lwd=3)
  lines(month.flow$Month, month.flow$p1984to2017, col=rgb(0,0,0.8,1), lty=1, lwd=3)
legend("topright",c("Period of Record", "1930 to 1980", "1984 to 2017"), col=c(rgb(0,0,0,0.5), rgb(0.8,0,0,1), rgb(0,0,0.8,1)), lwd=c(2,3,3))
#################################################################################################################################



#################################################################################################################################
##############                                  LOAD MULTIPLE SITES FR ANALYSIS                      ############################
#################################################################################################################################  
#What sites are available in NC?
nc.sites <- readNWISdata(stateCd="NC", parameterCd = pcode, service = "site", seriesCatalogOutput=TRUE)
length(unique(nc.sites$site_no))

#filter data
nc.sites2 <- filter(nc.sites, parm_cd %in% pcode) %>%
             filter(stat_cd %in% scode) %>%
             filter(begin_date <= "1950_01_01") %>%  filter(end_date >= "2010_01_01") %>%
             mutate(period = as.Date(end_date) - as.Date(begin_date)) %>%
             filter(period > 30*365) #30 years of data
length(unique(nc.sites2$site_no))

#where are sites located?
library(leaflet)
leaflet(data=nc.sites2) %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~dec_long_va,~dec_lat_va,
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm)


#let's read in streams in the upper nuese
upper.neuse <- subset(nc.sites2, huc_cd=="03020201")
unique.sites <- unique(upper.neuse$site_no); length(unique.sites)   #how many unique sites are there?

#Load in and plot data
#Basic plot
par(mfrow=c(2,3))    #rows, columns
par(mar = c(2,2.5,2,2)) #set plot margins (bottom, left, top, right)
stream.col <- c(rgb(0,0,0,0.5),rgb(1,0,0,0.5),rgb(0,0,1,0.5),rgb(0,0.7,0,0.5),rgb(0.7,0.2,0,0.5), rgb(0.7,0,1,0.5))
legend.names <- upper.neuse[1:6,]$station_nm

for (i in 1:length(unique.sites)){
  zt <- readNWISdv(siteNumbers = unique.sites[i], parameterCd = pcode, statCd = scode)
  zt <- renameNWISColumns(zt);
  zt$Flow_cms <- zt$Flow*0.028316847

  plot(neuse$Date, neuse$Flow_cms, type='n', yaxt="n", xlim=c(as.Date("1920-01-01"),as.Date("2017-12-31")), ylim=c(0,300),
       ylab="Streamflow (cms)", xlab = '', main=legend.names[i])
  axis(2, las=2, cex.axis=0.9)
  lines(zt$Date,zt$Flow_cms,col=stream.col[i])  
  print(legend.names[i])
  }
dev.off()
  



  
  
  
  
  