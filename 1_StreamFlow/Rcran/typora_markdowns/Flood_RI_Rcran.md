---
Title: Analysis of Flood Return Intervals Using RCran
Author: Lauren Patterson and John Fay
Date: Spring 2018
---

# Unit 1: Analysis of Flood Return Interval Using Rcran

[TOC]

## Q1: Evaluating 100-year flood frequency

### Background: Calculating return intervals

Our team hydrologist suggested that one method for evaluating the impacts of dam construction is to monitor changes in flood return intervals. Falls Lake is a flood control reservoir, so it should decrease the amount of downstream flooding.

 ![image3](../Excel/media/image3.png)

**Figure**: Reservoirs should moderate downstream flows. There is a flood control pool to hold flood waters that can be released slowly over time. There is also a conservation pool that holds water that can be released downstream during drier conditions to meet minimum streamflow requirements.



Flood insurance policy is built around the concept of the 100-year flood event. The housing industry has been working to explain what that risk actually means to homeowners with 30 year mortgages. Understanding the flood risk relative to mortage's is helpful for insurance companies to know. Has Falls Lake decreased the flood risk for downstream homes?

![image4](../Excel/media/image4.png)

Reservoirs decrease the likelihood of downstream flooding, but that often means development occurs in areas that would have been frequently flooded prior to the reservoir. We’ve seen examples of this just his year with Hurricane Harvey.



### Framing and executing the analysis

We will use Leopold’s (1994) flood frequency curve and the Weibull equation to calculate the recurrence interval. Here the return interval is computed as $\frac{n+1}{m}$ where `n` is the number of years of data and `m` is the rank of the year from largest to smallest (see this [link](https://en.wikipedia.org/wiki/Return_period) for more info). 	

*\* NOTE: The accuracy of a return interval is highly impacted by the length of the time series.*

So, for us to do this analysis, we need to first compute maximum annual discharge, i.e., extract the largest discharge observed from each water year. Next, sort and rank our data on max annual discharge and then compute a regression line from which we can determine the discharge of a 100 and 500 year flood. 



#### Obtaining Data

The method for installing and loading libraries, as well as downloading data from the USGS, are explained in the `Streamflow_Rcran.md` file. 

```R
#Load in libraries
library(dataRetrieval); library(EGRET); library (ggplot2)
library(dplyr); library(magrittr); library(lubridate)

#Download Data
#Identify gauge to download
siteNo <- '02087500' #don't forget to add the zero if it is missing

#Identify parameter of interest: 
pcode = '00060' #discharge (cfs)

#Identify statistic code for daily values: 
scode = "00003"  #mean

#Identify start and end dates
start.date = "1930-10-01"
end.date = "2017-09-30"

#Load in Ndata using the site ID
neuse <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)
#rename columns to something more useful
  neuse <- renameNWISColumns(neuse); colnames(neuse)
#Create cms column to plot cubic meters per second
neuse$Flow_cms <- neuse$Flow*0.028316847
```



#### Calculate the return interval using dplyr and pipes

For a basic understanding of variables and pipes, see the `Streamflow_Rcran.md` file.  Here we will use pipes to calculate the maximum daily streamflow within each water year. The water year can be calculated using `ifelse(condition, if true, if false)`, which essentially says if this condition is true then do 'x', otherwise do 'y'. Then use pipes to calculate the peak flow by water year.

```R
#Calculate year and month variables
neuse$Year <- year(neuse$Date);  neuse$Month <- month(neuse$Date)

#calculate the Water Year using ifelse
neuse$WaterYear <- ifelse(neuse$Month>=10, neuse$Year+1, neuse$Year)
#if the month is greater than 10, then WaterYear = Year+1, else WaterYear=Year

#Calculate the maximum annual flow by WaterYear
peak.flow <- neuse %>%
  group_by(WaterYear) %>%
  summarise(Peak_cms = max(Flow_cms, na.rm=T), n=n()) %>%  
  round(3)
  
peak.flow <- as.data.frame(peak.flow);
```

Next, we want to remove years that are missing a lot of data. We arbitrarily decide to throw out any years with less than 90% of the data available.

* `peak.flow <- subset(peak.flow, n>=(365-365*.1))`

Then we arrange the peak flows from the largest to the smallest value using  `arrange(data, column)` and `desc()` to arrange the values in descending order

* `peak.flow <- arrange(peak.flow, desc(Peak_cms)); peak.flow[1:5,]  ` , we check the first five values to make sure the data look correct.

Add a rank column using the command `rank()`. The `-` symbol in front of `peak.flow` tells R to rank the data with the highest value as (1) and the lowest value as (max n)

* ```R
  peak.flow$Rank <- rank(-peak.flow$Peak_cms); peak.flow[1:5,]
  ```

- Calculate return intervals in a new column named `ReturnInterval`
  - Determine how many years of data you have (e.g. count of year rows or max of rank).
  - Compute  $\frac{n+1}{m}$ where `n` is the number of years of data and `m` is the rank


- Calculate the Annual Exceedance Probability (just the inverse of RI) in a new column named `Pe`
  - $Pe = 1/RI$


```R
#Calculate return interval
n.years <- dim(peak.flow)[1]; n.years
peak.flow$ReturnInterval <- (n.years+1)/peak.flow$Rank; 
#calculate annual probability
peak.flow$AnnualProb <- round(1/peak.flow$ReturnInterval*100,3);  
peak.flow[1:5,]    #check results
```



#### Plot the data and compute a regression equation

For more information on commands to plot data, see `Streamflow_Rcran.md`. The Return Interval (x-axis) and sometimes the Peak Discharge (y-axis) are easier to see on a log plot. We convert the x-axis to log by including the command: `log="x"` in the `plot()` call. To add tick marks and labels on a log axis, we create the ticks manually and add them to the x-axis.

```R
#Plot the return interval with the peak flow
par(mfrow=c(1,1))     #one graph per plot
par(mar = c(5,5,3,5)) #set plot margins
plot(peak.flow$ReturnInterval, peak.flow$Peak_cms, log="x", type='n', yaxt="n", xlim=c(1,1000),      ylim=c(0,1000),
     ylab="Peak Streamflow (cms)", xlab = 'Return Interval (Years)')
  axis(2, las=2, cex.axis=0.9)
#create minor tick marks
  minor.ticks <- c(2,3,4,6,7,8,9,20,30,40,60,70,80,90,200,300,400,600,700,800,900)    
#add tick marks to the x-axis
  axis(1,at=minor.ticks,labels=FALSE, col="darkgray")                                 
box() #draw a box around the plot
#add points to the plot
  points(peak.flow$ReturnInterval, peak.flow$Peak_cms, col=rgb(0,0,0,0.6), cex=1.2, pch=19) 
```



Next we want to estimate the peak discharge at the 100, 200, 500, and 1000 year interval. To do that, we need to fit a regression to the data. We will try two types of regressions: (1) linear and (2) log.

- Linear regressions are called using the `lm(formula, data)` command. 
  - `RI.linear = lm(Peak_cms ~ ReturnInterval , data = peak.flow); RI.linear`
  - This returns the coefficients of the regression. To get the significance, standard error, r2 and f-statistic, use `summary(RI.linear)`


- Log regressions are also called using `lm()`, except one of the variables is set to `log()`.
  - `RI.log = lm(Peak_cms ~ log(ReturnInterval), data=peak.flow);  summary(RI.log)`


- We notice the log regression has the highest r2 value. Using `RI.log` we estimate the y-value at the 100, 200, 500 and 1000 year interval using the `predict()` function.

  ```R
  #set x.est values to the return interval
  x.est <- as.data.frame(c(100,200,500,1000)); colnames(x.est)<-"ReturnInterval"
  #estimate y values using predict(regression, x.est)
  y.est <- predict(RI.log,x.est, interval="confidence")
    y.est <- as.data.frame(y.est)

  #add the points to the chart
  points(x.est$ReturnInterval, y.est$fit, col="red", pch=2, lwd=2);
  legend("bottomright", c("Observed","Log Estimated"), pch=c(19,2), col=c("darkgray","red"))  
  ```

  ​

#### Use functions to calculate the return interval

For more information on how functions work in R, see `Streamflow_Rcran.md`.  Essentially we take all of the commands from above and stick them inside a function we name `flood_int`. The function will then return a data frame called `peak.flow` with the return interval and annual probabilities included.

```R
#create the flood_int function that reads in the data parameter
flood_int = function(data){ 
  #use pipes to calculate the maximum flow by water year
  peak.flow <- data %>%
    group_by(WaterYear) %>%
    summarise(Peak_cms = max(Flow_cms, na.rm=T), n=n()) %>%  round(3)
  peak.flow <- as.data.frame(peak.flow); 
  #remove rows missing more than 10% of data
  peak.flow <- subset(peak.flow, n>=(365-365*.1))
  
  #rank flows
  peak.flow <- arrange(peak.flow, desc(Peak_cms)); peak.flow[1:5,]
  peak.flow$Rank <- rank(-peak.flow$Peak_cms); peak.flow[1:5,]
  
  #calculate return interval
  n.years <- dim(peak.flow)[1]; n.years
  peak.flow$ReturnInterval <- (n.years+1)/peak.flow$Rank; peak.flow[1:5,]
  peak.flow$AnnualProb <- round(1/peak.flow$ReturnInterval*100,3);  peak.flow[1:5,]
  
  #return the data frame so it can be used outside of this function.
  return (peak.flow)
}
```

Now we can call this function to calculate the return interval for different periods of time. In this case, we will look at how the return interval has changed prior to 1979 (before Falls Lake reservoir) and after 1984 (following Falls Lake reservoir). 

- Call the function `flood_int` on a subset of the data (pre 1979)

  ```R
  #Call for the early period
  neuse.early <- subset(neuse, Date>="1930-01-01" & Date<="1979-12-31");        
  peak.flow.early <- flood_int(neuse.early)   ;
  ```
  -  Plot the new return interval and fit the regression over the original period of record (POR)

    ```R
    #set up plot
    par(mar = c(5,5,3,5)) #set plot margins
    plot(peak.flow.early$ReturnInterval, peak.flow.early$Peak_cms, log="x", type='n', yaxt="n", xlim=c(1,1000), ylim=c(0,1000),
         ylab="Peak Streamflow (cms)", xlab = 'Return Interval (Years)')
    axis(2, las=2, cex.axis=0.9)
    axis(1,at=minor.ticks,labels=FALSE, col="darkgray")                                 
      box()

    #plot original data 
    points(peak.flow$ReturnInterval, peak.flow$Peak_cms, col=rgb(0,0,1,0.5), cex=0.8, pch=19) 
    #plot data prior to 1979
    points(peak.flow.early$ReturnInterval, peak.flow.early$Peak_cms, col=rgb(0,0,0,0.6), cex=1.2, pch=19)  
     
    #linear regression
    RI.linear.early = lm(Peak_cms ~ ReturnInterval , data = peak.flow.early);
      summary(RI.linear.early)
    #log regression
    RI.log.early = lm(Peak_cms ~ log(ReturnInterval), data=peak.flow.early)
      summary(RI.log.early) 

    #Add regression points
      points(x.est$ReturnInterval, y.est$fit, col="black", pch=5, lwd=2);
      points(x.est$ReturnInterval, y.est.pre$fit, col="blue", pch=2, lwd=2);
    #add straight lines for points of interst
        abline(h=y.est.pre$fit[1], col="black", lty=3); abline(v=100, col="red", lty=3)
        abline(h=y.est$fit[1], col="blue", lty=3)
    legend("bottomright", c("Period of Record","1930-1979 data", "Est. Flow POR", "Est.Flow 1930-1979"), col=c("blue","black","blue","black"), pch=c(19,19,2,5))
    ```



- Call the function `flood_int` on a subset of the data (post 1984)

```R
#Subest data and call the function
neuse.late <- subset(neuse, Date>="1984-01-01");         
peak.flow.late <- flood_int(neuse.late);

#Plot the data
par(mar = c(5,5,3,5)) #set plot margins
plot(peak.flow.late$ReturnInterval, peak.flow.late$Peak_cms, log="x", type='n', yaxt="n", xlim=c(1,1000), ylim=c(0,1000),
     ylab="Peak Streamflow (cms)", xlab = 'Return Interval (Years)')
axis(2, las=2, cex.axis=0.9)
axis(1,at=minor.ticks,labels=FALSE, col="darkgray")                                 
box()

#plot points
points(peak.flow.late$ReturnInterval, peak.flow.late$Peak_cms, col=rgb(0.7,0.4,0,0.6), cex=1.2, pch=19)  

#linear regression
RI.linear.late = lm(Peak_cms ~ ReturnInterval , data = peak.flow.late);
  summary(RI.linear.late)
#log regression
RI.log.late = lm(Peak_cms ~ log(ReturnInterval), data=peak.flow.late)
  summary(RI.log.late)

#plot log points
y.est.post <- predict(RI.log.late,x.est, interval="confidence")
  y.est.post <- as.data.frame(y.est.post)
points(x.est$ReturnInterval, y.est.post$fit, col="goldenrod3", pch=12, lwd=2);

#plot original return intervals  
points(peak.flow$ReturnInterval, peak.flow$Peak_cms, col=rgb(0,0,1,0.5), cex=0.8, pch=19)  

#plot POR and early estimates
points(x.est$ReturnInterval, y.est$fit, col="blue", pch=2, lwd=2);
points(x.est$ReturnInterval, y.est.pre$fit, col="black", pch=5, lwd=2);

#draw ablines
abline(h=c(y100,y.est.pre$fit[1],y.est.post$fit[1]), col=c("blue","black","goldenrod3"), lty=3);
abline(v=100, col="black", lty=3)

legend("bottomright", c("Period of Record","1984-2017 data", "Est. Flow POR", "Est.Flow 1930-1979", "Est.Flow 1984-2017", "Est. Flow No Hurricane"), 
       col=c("blue","goldenrod3","blue","black","goldenrod3","red"), pch=c(19,19,2,5,12,16))

#remove 3 hurricane events
RI.log.hur <- lm(Peak_cms ~log(ReturnInterval), data=peak.flow.late[c(4:dim(peak.flow.late)[1]),])
  y.est.hur <- as.data.frame(predict(RI.log.hur,x.est, interval="confidence")); y.est.hur

#plot points
 points(x.est$ReturnInterval, y.est.hur$fit, col="red", pch=16, lwd=2);
  abline(h=y.est.hur$fit[1], col="red", lty=3)
```



####Create a table of return intervals

A table may be the easiest way to compare return intervals. To do this, create a data frame and fill in the desired values. Here we want the 100, 500, and 1000 year intervals. The number of years used to calculate the return interval and the adjusted r2.

```R
#create data frame
RI.table <- as.data.frame(matrix(nrow=4, ncol=6));    
#rename columns
colnames(RI.table) <- c("Date.Range", "RI_100yr","RI_500yr","RI_1000yr","Nyears","AdjustedR2")
#fill in columns
  RI.table$Date.Range <- c("1930-2017","1930-1979","1984-2017","Less 3 Hurricanes")
  RI.table$RI_100yr <- c(y.est$fit[1],y.est.pre$fit[1],y.est.post$fit[1], y.est.hur$fit[1])
  RI.table$RI_500yr <- c(y.est$fit[3],y.est.pre$fit[3],y.est.post$fit[3], y.est.hur$fit[3])
  RI.table$RI_1000yr <- c(y.est$fit[4],y.est.pre$fit[4],y.est.post$fit[4], y.est.hur$fit[4])
  RI.table$Nyears <- c(dim(peak.flow)[1], dim(peak.flow.early)[1], dim(peak.flow.late)[1],                             dim(peak.flow.late)[1]-3)
  RI.table$AdjustedR2 <- c(summary(RI.log)$adj.r.squared, summary(RI.log.early)$adj.r.squared, 
                          summary(RI.log.late)$adj.r.squared, summary(RI.log.hur)$adj.r.squared)
#View table
RI.table
```



#### Calculate the probability of an event in a 30 year mortgage

- Compute the the probability of the 100, 500, and 1,000 year flood occurring over the next 30 years as a binomial distribution: $Pe =1 - [1-(1/T)]^n$ where `T` is the return period (e.g. 100 years) and `n` is the number of years of interest (30 years in our case).
- To do this, we will use a for loop and print the results using `print()`. The `paste0()` function concatenates information into a string without including spaces. If you want to include spaces, simply use `paste()`.

```R
#set a vector with the return interval of interest
Rperiod = c(100,500,1000)
#set the number of years for the mortgage
n.years = 30
#for each return period (length of 3)
for (i in 1:3){
  print(paste0("Percent likelihood over ", n.years, " years for a ", Rperiod[i]," year flood: ",   round((1-(1-(1/Rperiod[i]))^n.years)*100,2), "%"))
}
```