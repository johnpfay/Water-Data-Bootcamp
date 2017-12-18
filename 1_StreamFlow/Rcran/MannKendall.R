#Read in USGS data - monthly streamflow statistics
install.packages("dataRetrieval", repos=c("http://owi.usgs.gov/R", getOption("repos")))
library(dataRetrieval);  library (ggplot2);  library(EGRET)
library(dplyr); library(magrittr); library(lubridate)
library(trend)

#access vignette if needed
rm(list=ls()) #removes anything stored in memory

#################################################################################################################################
##############                                  DOWNLOAD DATA                                        ############################
#################################################################################################################################
#Identify gauge to download
siteNo <- '02087500' #don't forget to add the zero if it is missing

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
neuse <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)
  summary(neuse); dim(neuse)
#rename columns to something more useful
  neuse <- renameNWISColumns(neuse); colnames(neuse)

#Create cms column to plot cubic meters per second
neuse$Flow_cms <- neuse$Flow*0.028316847
  summary(neuse)
#################################################################################################################################



#################################################################################################################################
##############                                 Summarize by Month and Year                               ############################
#################################################################################################################################
neuse$Year <- year(neuse$Date);   neuse$Month <- month(neuse$Date)
neuse$WaterYear <- ifelse(neuse$Month>=10,neuse$Year+1,neuse$Year)
#Maximum Annual Flow
month.flow <- neuse %>%
  group_by(Year, Month) %>%
  summarise(Total_cms = sum(Flow_cms, na.rm=T), n=n()) %>%  round(3)
month.flow <- as.data.frame(month.flow);  

annual.flow <- neuse %>%
  group_by(WaterYear) %>%
  summarise(Total_cms = sum(Flow_cms, na.rm=T), n=n()) %>%  round(3)
annual.flow <- as.data.frame(annual.flow);  
annual.flow
#remove those missing more htan 10%
annual.flow <- subset(annual.flow, n>=330)
#################################################################################################################################



#################################################################################################################################
##############                                 Annual Trends                               ############################
#################################################################################################################################
#Plot Annual Flow over time
par(mar = c(5,5,3,5)) #set plot margins
plot(annual.flow$WaterYear, annual.flow$Total_cms, type='n', yaxt="n", 
     ylab="Total Streamflow (cms)", xlab = '', cex.lab=0.9)
axis(2, las=2, cex.axis=0.8)
  points(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8), cex=0.8, pch=19)  
  lines(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8))  
  abline(v=10, lty=4, col="black")

############################################
# linear regression
############################################
linear = lm(Total_cms ~ WaterYear , data = annual.flow);  summary(linear)
  x.est <- as.data.frame(seq(1931,2020,1)); colnames(x.est)<-"WaterYear"
  y.est <- predict(linear,x.est, interval="confidence")
  y.est <- as.data.frame(y.est)
  
  #Add to plot
  lines(x.est$WaterYear, y.est$fit, col="red", lty=2);

############################################  
# Mann Kendall test
############################################
temp.ts<-ts(annual.flow$Total_cms, start=min(annual.flow$WaterYear, freq=1));  
  mk <- mk.test(temp.ts); mk
  sen <- sens.slope(temp.ts); sen
  sen$b.sen*sen$nobs;
  sen$b.sen.up*sen$nobs;  sen$b.sen.lo*sen$nobs
  sen$intercept  
  
  # create lines to plot on graph
  estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(annual.flow)[1]-1,1)),1)
  upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(annual.flow)[1]-1,1)),1)
  lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(annual.flow)[1]-1,1)),1)
  
  polygon(c(rev(annual.flow$WaterYear), (annual.flow$WaterYear)), c(rev(lowerc1), (upperc1)),  col=rgb(0,0,0.2,0.2), border=NA)
  lines(annual.flow$WaterYear, estimate, lty=2, col=rgb(0,0,.2,1))
  legend("bottomleft",c("Annual Flow", "Linear Regression", "MK regression", "MK confidence interval"), col=c("black","red",rgb(0,0,0.2),rgb(0,0,0.2,0.2)),
         pch=c(19,NA,NA,22), pt.cex=c(0.8,1,1,2), lty=c(1,2,2,NA), pt.bg=c(NA,NA,NA,rgb(0,0,0.2,0.2)), cex=0.8)
  box()
################################################################################################################################
  

################################################################################################################################  
#    Is there a difference before or after Falls Lake dam?
################################################################################################################################
par(mar = c(5,5,3,5)) #set plot margins
  plot(annual.flow$WaterYear, annual.flow$Total_cms, type='n', yaxt="n", 
       ylab="Total Streamflow (cms)", xlab = '', cex.lab=0.9)
  axis(2, las=2, cex.axis=0.8)
  points(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8), cex=0.8, pch=19)  
  lines(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8))  
  rect(1981,0,1984,100000, col=rgb(0.7,0,0,0.2), border=NA)

######################################
# Pre Falls Lake
#######################################
pre.falls <- subset(annual.flow, WaterYear<=1980)
  temp.ts<-ts(pre.falls$Total_cms, start=min(pre.falls$WaterYear, freq=1));  #frequency is 12 so each month is calculated separtely
  mk <- mk.test(temp.ts); mk
  sen <- sens.slope(temp.ts); sen
  sen$b.sen*sen$nobs;
  sen$b.sen.up*sen$nobs;  sen$b.sen.lo*sen$nobs
  sen$intercept  
  
  # create lines to plot on graph
  estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(pre.falls)[1]-1,1)),1)
  upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(pre.falls)[1]-1,1)),1)
  lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(pre.falls)[1]-1,1)),1)
  
  polygon(c(rev(pre.falls$WaterYear), (pre.falls$WaterYear)), c(rev(lowerc1), (upperc1)),  col=rgb(0,0,0.2,0.2), border=NA)
    lines(pre.falls$WaterYear, estimate, lty=2, col=rgb(0,0,.2,1))

######################################
# Post Falls Lake
#######################################
post.falls <- subset(annual.flow, WaterYear>=1984)
    temp.ts<-ts(post.falls$Total_cms, start=min(post.falls$WaterYear, freq=1));  #frequency is 12 so each month is calculated separtely
    mk <- mk.test(temp.ts); mk
    sen <- sens.slope(temp.ts); sen
    sen$b.sen*sen$nobs;
    sen$b.sen.up*sen$nobs;  sen$b.sen.lo*sen$nobs
    sen$intercept  
    
    # create lines to plot on graph
    estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(post.falls)[1]-1,1)),1)
    upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(post.falls)[1]-1,1)),1)
    lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(post.falls)[1]-1,1)),1)
    
    polygon(c(rev(post.falls$WaterYear), (post.falls$WaterYear)), c(rev(lowerc1), (upperc1)),  col=rgb(0,0,0.2,0.2), border=NA)
      lines(post.falls$WaterYear, estimate, lty=2, col=rgb(0,0,.2,1))
#################################################################################################################################
      
      
      
#################################################################################################################################
##############                                 Seasonal Trends                               ############################
#################################################################################################################################
#Create dataframe
month.stats <- as.data.frame(matrix(nrow=0,ncol=5)); colnames(month.stats) <- c("Month", "Pval","Intercept","Slope","Nobs");

#set up plots frame
par(mfrow=c(3,4))
par(mar = c(2,3,2,2)) #set plot margins
      
#loop through each month  
for (i in 1:12) {
  zt <- subset(month.flow, Month==i)
  
  temp.ts<-ts(zt$Total_cms, start=min(zt$Year, freq=1));
  mk <- mk.test(temp.ts); mk
  sen <- sens.slope(temp.ts); sen
  sen$b.sen*sen$nobs;
  sen$b.sen.up*sen$nobs;  sen$b.sen.lo*sen$nobs
  
  #fill dataframe
  month.stats[i,1] <- i;             month.stats[i,2]<-mk$pvalg;            month.stats[i,3]<-sen$intercept
  month.stats[i,4] <- sen$b.sen;     month.stats[i,5]<-sen$nobs;
  
  # create lines to plot on graph
  estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(zt)[1]-1,1)),1)
  upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(zt)[1]-1,1)),1)
  lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(zt)[1]-1,1)),1)

  plot(zt$Year, zt$Total_cms, type='n', yaxt="n", main=i,
       ylab="", xlab = '', cex.lab=0.9)
  axis(2, las=2, cex.axis=0.8)
  points(zt$Year, zt$Total_cms, col=rgb(0,0,0,0.8), cex=0.8, pch=19)  
  lines(zt$Year, zt$Total_cms, col=rgb(0,0,0,0.2))  
  polygon(c(rev(zt$Year), (zt$Year)), c(rev(lowerc1), (upperc1)),  col=rgb(0,0,0.2,0.2), border=NA)
    lines(zt$Year, estimate, lty=2, col=rgb(0,0,.2,1))
}
month.stats

#Are there any signficant trends?
#Repeat for 1930-1980 - are there any signficant trends?
#Repeat for 1984-2017...

#separate data frames for comparison
keep.month <- month.flow
all.years <- month.stats

month.flow <- subset(keep.month, Year<1980)
pre.falls <- month.stats #for when you run analysis before 1979

month.flow <- subset(keep.month, Year>=1984)
post.falls <- month.stats # for when you run analysis after 1984
#################################################################################################################################






#################################################################################################################################
##############                                 Annual Trends in NC                               ############################
#################################################################################################################################
#What sites are available in NC?
nc.sites <- readNWISdata(stateCd="NC", parameterCd = pcode, service = "site", seriesCatalogOutput=TRUE)
  length(unique(nc.sites$site_no))

#filter data
nc.sites2 <- filter(nc.sites, parm_cd %in% pcode) %>%
  filter(stat_cd %in% scode) %>%
  filter(begin_date <= "1960_01_01") %>%  filter(end_date >= "2010_01_01") %>%
  mutate(period = as.Date(end_date) - as.Date("1970-01-01")) %>%
  filter(period > 30*365) #30 years of data
length(unique(nc.sites2$site_no))

#calculate unique sites
unique.sites <- unique(nc.sites2$site_no)

#set up data frame  
stats <- as.data.frame(matrix(nrow=0,ncol=7));        colnames(stats) <- c("Site", "Pval","Intercept","Slope","Nobs","StartYr","EndYr"); 
start.date = "1970-10-01"
end.date = "2017-09-30"

#Loop through each site and calculate statistics
for (i in 1:length(unique.sites)){
  zt <- readNWISdv(siteNumbers = unique.sites[i], parameterCd = pcode, statCd = scode, startDate=start.date, endDate = end.date)
    zt <- renameNWISColumns(zt);
  zt$Flow_cms <- zt$Flow*0.028316847
  zt$Year <- year(zt$Date)
    
  #summarize annual
    annual.flow <- zt %>%  group_by(Year) %>%
      summarise(Total_cms = sum(Flow_cms, na.rm=T), n=n()) %>%  round(3)
    annual.flow <- as.data.frame(annual.flow);  
  
  #run trend test
    temp.ts<-ts(annual.flow$Total_cms, start=min(annual.flow$Year, freq=1));
    mk <- mk.test(temp.ts); 
    sen <- sens.slope(temp.ts); 
    
  #fill dataframe
    stats[i,1] <- as.character(unique.sites[i]);             stats[i,2]<-round(mk$pvalg,3);            stats[i,3]<-round(sen$intercept,3)
    stats[i,4] <- round(sen$b.sen,3);                        stats[i,5]<-sen$nobs;                     stats[i,6]<-min(zt$Year)
    stats[i,7] <- max(zt$Year);
    
    print(i)
}
summary(stats)

#remove sites with less than 30 years observations
stats <- subset(stats, Nobs>=30); dim(stats)
 

####Set up markers to be triangles - easier to do with maps, but can be done with leaflet
#Function to grab pch icons and transform to leaflet markers
pchIcons = function(pch = 1, width = 30, height = 30, bg = "transparent", col = "black", ...) {
  n = length(pch)
  files = character(n)
  # create a sequence of png images
  for (i in seq_len(n)) {
    f = tempfile(fileext = '.png')
    png(f, width = width, height = height, bg = bg)
    par(mar = c(0, 0, 0, 0))
    plot.new()
    points(.5, .5, pch = pch[i], col = col[i], cex = min(width, height) / 8, ...)
    dev.off()
    files[i] = f
  }
  files
}


#Plot results on a map by symbol and color
stats$Direction <- ifelse(stats$Slope>0, 2, 6)    #shapes based on pch values
  stats$Direction <- ifelse(stats$Slope==0, 19, stats$Direction)
  table(stats$Direction)

stats$Significance <- ifelse(stats$Slope>0 & stats$Pval<=0.05, "blue","lightgrey")
  stats$Significance <- ifelse(stats$Slope>0 & stats$Pval>0.05, "lightblue",stats$Significance)
  stats$Significance <- ifelse(stats$Slope<0 & stats$Pval>0.05, "lightpink",stats$Significance)
  stats$Significance <- ifelse(stats$Slope<0 & stats$Pval<=0.05, "red",stats$Significance)
  table(stats$Significance)
  
iconFiles = pchIcons(stats$Direction, 20, 20, col = stats$Significance, lwd = 4)


#merge with site lat/long
stats.merge <- merge(stats, nc.sites2[,c(2,5:6,22:23)], by.x="Site", by.y="site_no"); dim(stats.merge)

#Map results
library(leaflet)
leaflet(data=stats.merge) %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(~dec_long_va,~dec_lat_va,
             icon = ~ icons(
               iconUrl = iconFiles,
               popupAnchorX = 20, popupAnchorY = 0
             ),
            popup=~paste0(Site,": ",StartYr,"-",EndYr)
  ) %>% addLegend("bottomright", 
                  values=c("red","lightpink","lightblue","blue"), color=c("red","lightpink","lightblue","blue"),
                  labels= c("Significant Decrease","Insignificant Decrease","Insignificant Increase", "Significant Increase"),
                  opacity = 1)
 


  
  
  
  
  
  
  
  