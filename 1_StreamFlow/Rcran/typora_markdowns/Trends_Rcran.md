---
Title: Analysis of Streamflow Trends Using Rcran
Author: Lauren Patterson and John Fay
Date: Spring 2018
---

# Unit 1: Analysis of Streamflow Trends using Rcran

[TOC]

## Q3: Exploring trends in streamflow over time

### Background

Water security is becoming increasingly important as population and water demand continue to grow. This is especially true with changing climate conditions that introduce new variability into our expectations of water supply. Briefly, we want to know whether the average annual streamflow has changed over time. 



#### Obtaining Data

The method for installing and loading libraries, as well as downloading data from the USGS, are explained in the `Streamflow_Rcran.md` file. 

```R
#Load Libraries
library(dataRetrieval); library (ggplot2); library(EGRET); library(dplyr); library(magrittr)
library(lubridate); library(trend);   #calculates trends
library(leaflet);  #mapping
```

```R
#Download data
#Identify gauge to download
siteNo <- '02087500' #don't forget to add the zero if it is missing

#Identify parameter of interest
pcode = '00060' #discharge (cfs)

#Identify statistic code for daily values: 
scode = "00003"  #mean

#Identify start and end dates
start.date = "1930-10-01"
end.date = "2017-09-30"

#Load in data
neuse <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)
  summary(neuse); dim(neuse)
#rename columns to something more useful
  neuse <- renameNWISColumns(neuse); colnames(neuse)
#Create cms column to plot cubic meters per second
neuse$Flow_cms <- neuse$Flow*0.028316847
```



#### Aggregate Daily Data to Monthly and Annual for Trend Analysis

There is a lot of noise in daily streamflow data that makes it hard to pull out trends. Often, when looking at long-term trends, the data are aggregated by month and/or year. We will use pipes to aggregate the data by month and year. See previous questions for a brief explanation on how pipes work.

```R
#Look at trends based on monthly total streamflow
neuse$Year <- year(neuse$Date);   neuse$Month <- month(neuse$Date)
neuse$WaterYear <- ifelse(neuse$Month>=10,neuse$Year+1,neuse$Year)

#Use pipes to summarize by month
month.flow <- neuse %>%
  group_by(Year, Month) %>%
  summarise(Total_cms = sum(Flow_cms, na.rm=T), n=n()) %>%  round(3)
month.flow <- as.data.frame(month.flow);  

#lets also look at water year
annual.flow <- neuse %>%
  group_by(WaterYear) %>%
  summarise(Total_cms = sum(Flow_cms, na.rm=T), n=n()) %>%  round(3)
annual.flow <- as.data.frame(annual.flow);  
#remove those missing more than 10% 
annual.flow <- subset(annual.flow, n>=330)
```



#### Annual Trends

In excel, we were able to run a linear regression on annual streamflow trends. Let's replicate that activity in R now.

```R
#Create the plot
par(mar = c(5,5,3,5)) #set plot margins
plot(annual.flow$WaterYear, annual.flow$Total_cms, type='n', yaxt="n", 
     ylab="Total Streamflow (cms)", xlab = '', cex.lab=0.9)
axis(2, las=2, cex.axis=0.8)
box()

#Add the data to the plot
points(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8), cex=0.8, pch=19)  
lines(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8))  

############################################
# linear regression
############################################
linear = lm(Total_cms ~ WaterYear , data = annual.flow);  summary(linear)
  x.est <- as.data.frame(seq(1931,2020,1)); colnames(x.est)<-"WaterYear"
  y.est <- as.data.frame(predict(linear,x.est, interval="confidence"))
#Add to plot
  lines(x.est$WaterYear, y.est$fit, col="red", lty=2);
```

Oftentimes, time series data (such as water quantity or water quality) do not meet the assumptions of linear regressions. We won't go into those here, but for a list, see http://r-statistics.co/Assumptions-of-Linear-Regression.html. It is common for streamflow trends to be assessed using non-parametric methods, such as the Mann-Kendall (MK) test.  The MK test is appropriate for identifying where changes show a monotonic increase or decrease over time, and whether that change is significant. The MK test is often paired with Theil-Sen line to estimate the slope of the trend. This method is robust against outliers and essentially calculates the median of the slope between all pairs of sample points within your data. We calculate the MK test to get the significance of the trend and the Theil-Sen test to get the slope, intercept and confidence interval for plotting the data.

- The MK and Sen test are located in the `trend` library. Make sure you have installed and loaded this library. Both tests require the data to be provided as a `time series object`. The function `ts(data column of interest, time of first observation, number of observations per unit of time)` is used to create a time-series object.  This function assumes the data are at equi-distant units of time. 
  - For example, if you are looking at annual data you would have a frequency of 1, because there is one point per unit of time. `ts(data,1930,1)`.
  - Or if you wanted to look at the annual trend but include monthly values you would have 12 observations per year (natural time period). In this case, `ts(data, 1930.083, 12)`. Where 1/12 = 0.083 and there are 12 months in each year.

```R
############################################  
# Mann Kendall test
############################################
#convert data into a time series object
temp.ts<-ts(annual.flow$Total_cms, start=min(annual.flow$WaterYear, freq=1));  
#run the mann kendall test
mk <- mk.test(temp.ts); mk
#run the sen slope test
sen <- sens.slope(temp.ts); sen
```

- To plot the regression we need to use the regression to estimate the trend for each point in time. Because the Sen test provides confidence intervals, we can also show the range of possibilities for the trend line.

```R
# create lines to plot on graph
#y-axis. We are using the equation y=a+b*x, where a is the intercept and b is the slope
  estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(annual.flow)[1]-1,1)),1)
#upper confidence interval
  upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(annual.flow)[1]-1,1)),1)
#lower confidence interval
  lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(annual.flow)[1]-1,1)),1)
```

- Plot the confidence interval as a `polygon` and the estimate as a `line`. The polygon command essentially draws a polygon based on `polygon(x vectors, y vectors)`. Oftentimes, drawing a polygon looks like `polygon(c(x,rev(x)), c(y2,rev(y1)))`. The first half of the x-vector is the value of x, corresponding to the part of the polygon tracing the upper curve. The second part is the reverse `rev` of x, corresponding to the part of the polygon that is tracing out the lower curve along the decreasing value of x. Similarly, the first part of the polygon (e.g. higher values) and the second part is the reverse (e.g lower values) of the polygon.

```R
#draw a polygon between the lower and upper confidence interval  
polygon(c(rev(annual.flow$WaterYear), (annual.flow$WaterYear)), c(rev(lowerc1), (upperc1)),  col=rgb(0,0,0.2,0.2), border=NA)
#draw the estimate
  lines(annual.flow$WaterYear, estimate, lty=2, col=rgb(0,0,.2,1))
#add a legend
legend("bottomleft",c("Annual Flow", "Linear Regression", "MK regression", "MK confidence 
		interval"), col=c("black","red",rgb(0,0,0.2),rgb(0,0,0.2,0.2)),
         pch=c(19,NA,NA,22), pt.cex=c(0.8,1,1,2), lty=c(1,2,2,NA), 				
       	 pt.bg=c(NA,NA,NA,rgb(0,0,0.2,0.2)), cex=0.8)
```

- Based on this plot, you can see that it is likely streamflow has decreased over time. However, we are not 100% confident that is true.



#### Does the trend change before or after Falls Lake was built?

Here, we will repeat the MK and Sen tests for subsets of the data (before Falls Lake, after Falls Lake) and plot those data on the same graph.

```R
#Create the plot
par(mar = c(5,5,3,5)) #set plot margins
  plot(annual.flow$WaterYear, annual.flow$Total_cms, type='n', yaxt="n", 
       ylab="Total Streamflow (cms)", xlab = '', cex.lab=0.9)
  axis(2, las=2, cex.axis=0.8)

#add the data
  points(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8), cex=0.8, pch=19)  
  lines(annual.flow$WaterYear, annual.flow$Total_cms, col=rgb(0,0,0,0.8))  
#draw a rectangle around the period Falls Lake was built (x1,y1,x2,y2)
rect(1980,0,1984,100000, col=rgb(0.7,0,0,0.2), border=NA)

#subset and run the MK test 
######################################
# Pre Falls Lake
#######################################
pre.falls <- subset(annual.flow, WaterYear<=1980)
#create time series
  temp.ts<-ts(pre.falls$Total_cms, start=min(pre.falls$WaterYear, freq=1));  
  mk <- mk.test(temp.ts); mk
  sen <- sens.slope(temp.ts); sen
#create lines to plot on graph
  estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(pre.falls)[1]-1,1)),1)
  upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(pre.falls)[1]-1,1)),1)
  lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(pre.falls)[1]-1,1)),1)
#plot the polygon and line on the graph
  polygon(c(rev(pre.falls$WaterYear), (pre.falls$WaterYear)), c(rev(lowerc1), (upperc1)),  
          col=rgb(0,0,0.2,0.2), border=NA)
  lines(pre.falls$WaterYear, estimate, lty=2, col=rgb(0,0,.2,1))

######################################
# Post Falls Lake
#######################################
post.falls <- subset(annual.flow, WaterYear>=1984)
#create time series
    temp.ts<-ts(post.falls$Total_cms, start=min(post.falls$WaterYear, freq=1));  
    mk <- mk.test(temp.ts); mk
 	sen <- sens.slope(temp.ts); sen
 # create lines to plot on graph
    estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(post.falls)[1]-1,1)),1)
    upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(post.falls)[1]-1,1)),1)
    lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(post.falls)[1]-1,1)),1)
#Plot the polygon and line on the graph   
    polygon(c(rev(post.falls$WaterYear), (post.falls$WaterYear)), c(rev(lowerc1), (upperc1)),  
            col=rgb(0,0,0.2,0.2), border=NA)
    lines(post.falls$WaterYear, estimate, lty=2, col=rgb(0,0,.2,1))
```

- What do you notice? This is often a challenge in looking at streamflow trends because the time period assessed can drastically change your results.

  ​

#### Are there seasonal trends over time?

Streamflow is greatly influenced by climate patterns and shifts in climate can occur seasonally. Let's look at each month to see what patterns may emerge. To do this, we are going to create a page for 12 plots to sit on in 3 rows and 4 columns. We will then use a `for loop` to subset the data, perform the trend test, and create a plot for each month of the year.

```R
#Create dataframe
month.stats <- as.data.frame(matrix(nrow=0,ncol=5)); 
#Create meaningful column headers
colnames(month.stats) <- c("Month", "Pval","Intercept","Slope","Nobs");

#set up plots frame
par(mfrow=c(3,4)) #3 rows and 4 columns
par(mar = c(2,3,2,2)) #set plot margins (how much white space is around each side of the plot)
      
#loop through each month  
for (i in 1:12) {
  zt <- subset(month.flow, Month==i);    #subset data
  temp.ts<-ts(zt$Total_cms, start=min(zt$Year, freq=1));  #create time series
  mk <- mk.test(temp.ts); mk          #mk test
  sen <- sens.slope(temp.ts); sen     #sen slope test
  
#fill dataframe so months can be directly compared
  month.stats[i,1] <- i;             month.stats[i,2]<-mk$pvalg;            
  month.stats[i,3]<-sen$intercept
  month.stats[i,4] <- sen$b.sen;     month.stats[i,5]<-sen$nobs;
  
# create lines to plot on graph
  estimate<-round((sen$intercept+sen$b.sen*seq(0,dim(zt)[1]-1,1)),1)
  upperc1<-round((sen$intercept+sen$b.sen.up*seq(0,dim(zt)[1]-1,1)),1)
  lowerc1<-round((sen$intercept+sen$b.sen.lo*seq(0,dim(zt)[1]-1,1)),1)

#plot each month
  plot(zt$Year, zt$Total_cms, type='n', yaxt="n", main=i, ylab="", xlab = '', cex.lab=0.9)
  	axis(2, las=2, cex.axis=0.8)
  	points(zt$Year, zt$Total_cms, col=rgb(0,0,0,0.8), cex=0.8, pch=19)  
  	lines(zt$Year, zt$Total_cms, col=rgb(0,0,0,0.2))  
  	polygon(c(rev(zt$Year), (zt$Year)), c(rev(lowerc1), (upperc1)),  col=rgb(0,0,0.2,0.2), 
            border=NA)
    lines(zt$Year, estimate, lty=2, col=rgb(0,0,0.2,1))
}
month.stats
```

- When you look at the table, how many months show a positive trend? A negative trend? Are any trends significant at the 0.05 level? the 0.10 level? Which months?



#### How does the annual trend for this site compare with sites across North Carolina?

Often, it is good practice to put your results in the context of a broader geography (stream reaches, river basin, state). Here we are going to run the analysis for sites across North Carolina and plot the results.

- First, find sites that meet your criteria in NC

```R
#What sites are available in NC?
nc.sites <- readNWISdata(stateCd="NC", parameterCd = pcode, service = "site", 
                         seriesCatalogOutput=TRUE)
length(unique(nc.sites$site_no));   #tells you how many sites are present

#Filter the data using pipes!
nc.sites2 <- filter(nc.sites, parm_cd %in% pcode) %>%     #says only sites with discharge data
  filter(stat_cd %in% scode) %>%                          #only those with mean daily
  filter(begin_date <= "1960_01_01") %>%  filter(end_date >= "2010_01_01") %>%  #in this range
  mutate(period = as.Date(end_date) - as.Date("1970-01-01")) %>%        #how many days of data
  filter(period > 30*365)                 #only keep those with more than 30 years of data

length(unique(nc.sites2$site_no))
```



- Next, create a data frame to hold the stats for each site. Then create a for loop that reads in the site data, aggregates to annual flow, and calculates the mk and sen test.

```R
#calculate unique sites
unique.sites <- unique(nc.sites2$site_no)

#set up data frame  
stats <- as.data.frame(matrix(nrow=0,ncol=7));        
#provide column names
colnames(stats) <- c("Site", "Pval","Intercept","Slope","Nobs","StartYr","EndYr"); 
#set dates of interest
start.date = "1970-10-01"
end.date = "2017-09-30"

#Loop through each site and calculate statistics
for (i in 1:length(unique.sites)){
#read in data
  zt <- readNWISdv(siteNumbers = unique.sites[i], parameterCd = pcode, statCd = scode, 
                   startDate=start.date, endDate = end.date)
  zt <- renameNWISColumns(zt);
  zt$Flow_cms <- zt$Flow*0.028316847
  zt$Year <- year(zt$Date)
    
 #use pipes to aggregate the flow by year
    annual.flow <- zt %>%  
  		group_by(Year) %>%
      	summarise(Total_cms = sum(Flow_cms, na.rm=T), n=n()) %>%  round(3)
    annual.flow <- as.data.frame(annual.flow);  
  
  #run trend test
    temp.ts<-ts(annual.flow$Total_cms, start=min(annual.flow$Year, freq=1));
    	mk <- mk.test(temp.ts); 
    	sen <- sens.slope(temp.ts); 
    
  #fill dataframe
    stats[i,1] <- as.character(unique.sites[i]);             stats[i,2]<-round(mk$pvalg,3);         stats[i,3]<-round(sen$intercept,3)
    stats[i,4] <- round(sen$b.sen,3);                        stats[i,5]<-sen$nobs;                   stats[i,6]<-min(zt$Year);                                stats[i,7] <- max(zt$Year);
}
summary(stats)

#remove sites with less than 30 years observations
stats <- subset(stats, Nobs>=30); dim(stats)
```



#### Plot trends across the state using leaflet

I want to represent each site as a triangle. I want the triangle to point upwards for positive slopes and downwards for negative slopes. Furthermore, I want to color the triangle based on the direction (red color for negative and blue color for positive) and bold color for significant slopes with pastels for insignificant slopes. Leaflet does not have an automatic way to create such markers. Therefore, we need to create a function to make this icon. I did not write this function - I searched for someone else's code who had already ran into this problem. This is a great way to learn how to code.

```R
#Function to grab pch icons and transform to leaflet markers. Notice the function comes pre-loaded, but when you call the function you can change those values.

#parameters (pch is the type of point, width and height are the size of the icon, bg sets the background to be transparent, and color tells the icon to be black)
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
```



Now that I know what the function looks like, I can create the variables I want to load into the function to draw symbols based on significance and slope. I will do this by adding a column to color by `Direction` and `Significance`.

```R
#Add a column with the pch (triangle direction) I want based on the slope
#(2 is an upward triangle, 6 a downward triangle)
stats$Direction <- ifelse(stats$Slope>0, 2, 6)  
  stats$Direction <- ifelse(stats$Slope==0, 19, stats$Direction)  #19 is a circle
table(stats$Direction)

#Add a column with the colors I want to use based on Signficance
stats$Significance <- ifelse(stats$Slope>0 & stats$Pval<=0.05, "blue","lightgrey")
  stats$Significance <- ifelse(stats$Slope>0 & stats$Pval>0.05, "lightblue",stats$Significance)
  stats$Significance <- ifelse(stats$Slope<0 & stats$Pval>0.05, "lightpink",stats$Significance)
  stats$Significance <- ifelse(stats$Slope<0 & stats$Pval<=0.05, "red",stats$Significance)
table(stats$Significance)
```



Now, I call the function `pchIcons` into a new variable I created called  `iconFiles`.  When I am plotting the data into `leaflet`, I will include the variable `iconFiles`.

`iconFiles = pchIcons(stats$Direction, 20, 20, col = stats$Significance, lwd = 4)`



Now I want to plot the data on leaflet. Notice, that the data I want to plot is in the `stats` table, while the data holding the location of the sites is in the `nc.sites2` table. I need to merge these two tables together using `merge()`. This function works by: `merge(table1, table2, by column in table 1, by column in table 2)`, where the columns in table 1 and table 2 should be a unique identifier that links the two tables together. In this case, it will be the site number.

```R
#I need to merge the stats data with the site information (contains latitude and longitude)
#To do this I used the merge() function and I match the data based on the column holding the unique identifier
stats.merge <- merge(stats, nc.sites2[,c(2,5:6,22:23)], by.x="Site", by.y="site_no"); 

#Map results
leaflet(data=stats.merge) %>%                            #data to plot
  addProviderTiles("CartoDB.Positron") %>%               #creates background map
  addMarkers(~dec_long_va,~dec_lat_va,                   #adds markers with location
             icon = ~ icons(                              
               iconUrl = iconFiles,                      #markers look like triangles
               popupAnchorX = 20, popupAnchorY = 0
             ),
            popup=~paste0(Site,": ",StartYr,"-",EndYr)  #data to show up popup
  ) %>% addLegend("bottomright",                        #add legend to map
                  values=c("red","lightpink","lightblue","blue"), 
                  color=c("red","lightpink","lightblue","blue"),
                  labels= c("Significant Decrease","Insignificant Decrease","Insignificant 
						Increase", "Significant Increase"),
                  opacity = 1)
```



Based on the map, what can you say about how annual streamflow volume has changed since 1970? Can you find your site?



##### On your own exercises

- Run this analysis for the Neuse River Basin (look at notes from `Streamflow.md` on how to subset sites to a river basin. You will have to find the HUC for the Neuse).

- Run this analysis using a different time period (e.g. 1930 to present). How does map change?

- Run this analysis for a different state.

  ​



