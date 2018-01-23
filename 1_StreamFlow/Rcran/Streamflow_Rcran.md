---
Title: Analysis of Streamflow Data using Excel
Author: Lauren Patterson and John Fay
Date: Spring 2018
---

# Unit 1: Analysis of Streamflow Data using Rcran

[TOC]

## ♦ Background: How has Falls Lake affected streamflow?

Prior to 1978, flooding of the Neuse River caused extensive damage to public and private properties including roadways, railroads, industrial sites, and farmlands. The Falls Lake Project was developed by the U.S. Army Corps of Engineers to control damaging floods and to supply a source of water for surrounding communities. Construction of the dam began in 1978 and was completed in 1981. In addition to recreation opportunities, Falls Lake now provides flood control, water supply, water quality, and fish and wildlife conservation resources ([source](https://www.ncparks.gov/falls-lake-state-recreation-area/history)).

Now, some 3 dozen years after Falls Lake was constructed, we want to evaluate its impact on downstream streamflow, using this as an opportunity to examine some data analytic techniques, specifically ones using Microsoft Excel. These techniques will cover ways to get data into Excel and how to manage, wrangle, and analyze those data. 

This document begins with a review of the **analytical workflow** of most data projects. We apply this workflow to understand how streamflow has changed since Falls Lake was constructed. In doing so, we focus on using *Excel* to tackle the assignment, but companion documents will examine how *R* and *Python* can accomplish the same set of tasks in a scripting environment.

---

## ♦ Analytical workflow: A Preview

Data analysis projects follow a similar workflow, one that begins with a general question or objective that guides our process of turning data into actionable information. Let's begin by examining our workflow, depicted in the diagram below. 



![Data Analytics Process Streamflow](../Excel/media/Data Analytics Process Streamflow.png)



### 1. Clarifying the central question

Data analysis has a workflow that often begins with clarifying the central question. For example, our initial question is *"How has Falls Lake affected streamflow?"* This question has some useful specifics: We know where we'll be working (Falls Lake) and what the core dataset will be (streamflow). However, the question is vague on how we might evaluate the impact on streamflow. As a data analyst your first job is often to <u>clarify a basic question into one that is *actionable*</u>, that is taking a vague question and creating specific questions that shape data exploration and analysis to facilitates effective decision making. 

This step usually requires some communication between the the client, project managers, experts in the field, and you, the data analyst. (And let's hope it goes better than this meeting: https://www.youtube.com/watch?v=BKorP55Aqvg .) For our Falls Lake example, however, we'll assume this meeting took place and narrowed on on the following questions:

* How has the 100-year flood frequency changed since building the reservoir?
* How have 7-month minimum flows changed since building the reservoir?
* Are there trends in streamflow (increasing, same or decreasing) since building the reservoir?

While these are still a touch vague, our expert hydrologists will provide more specific guidance on these analyses below. 



### 2. What data do I need to answer the question? Do the data exist?

With our objectives clarified, our next step is to <u>identify the data needed for our analyses</u>. In our case, it's fairly obvious: we need long-term streamflow data at some point downstream (and not too far downstream) from Falls Lake. In other cases, it may not be as obvious and may require another conference with the project team to figure out what that ideal dataset may be. 

When a target dataset is identified, the following question is <u>whether those data exist</u>? Knowing where to look or whom to ask whether a certain dataset exists comes with experience and your networks (though web-search skills can be quite useful too). However, if you've exhausted your search and still can't find the proper dataset(s), your fallback is to look for **proxies**, or similar (existing) data that can be used in place of your [missing] data. In some cases, **models** can be used to derive suitable data to run your analysis. 

In this case, the data we want are provided by the USGS' *National Water Information System* (NWIS). 



### 3. Obtaining, exploring, and cleaning the data

Data come in a variety of forms and formats. Some datasets lend themselves to easy import and immediate analysis; others may not be digital-ready (e.g. hard-copies or PDFs) or have an inconsistent format rendering them essentially useless. As the saying goes, "your mileage may vary" with the dataset you find. While there are techniques, technologies, and some tricks in getting messy, seemingly irretrievable data into a workable format, that is not our focus. Rather, we'll cover some reliable techniques for <u>getting data into a workable, or **tidy** format</u> in Excel. More powerful techniques exist for obtaining and cleaning data exist in *R* and *Python* scripting languages that we'll examine a bit later.



### 4. Conducting the analysis and communicating the results

With the proper data in your analytical environment (e.g. *Excel*, *R*, *Python*), the remaining steps in the data analysis workflow involve answering your question(s). How this goes ultimately depends on your particular objectives, but in this exercise we will examine a few basic strategies for working with data. These include:

* Selecting and subsetting specific observations (rows) and variables (columns) of data.
* Reshaping or changing the layout of your data, e.g. pivoting or transforming rows and columns
* Grouping and summarizing data
* Combining datasets
* Graphing, charting, and plotting data




### 5. Post-mortem: evaluation and documentation

Often overlooked by the data analyst is the step of reviewing your analysis and documenting your work. When you've completed your analysis, you'll often reconvene with the team and assess whether you answered your central question effectively. If not, you'll need to tweak things until you do and perhaps cycle through the workflow again. This is where **documentation** can be hugely helpful. Documentation includes notes to yourself and to others covering in enough detail as to facilitate repeating the entire process. Documentation should include any non-obvious assumption or decision made in doing your analysis. This can be a bit cumbersome with Excel, but is done quite easily through comments in R or Python scripts. 



---

## ♦ Applying the Analytical Workflow: Falls Lake

### • Obtaining the data

The USGS actively supports Rcran development by building a community of practice. This community has developed several R packages that can be used to load and analyze streamflow data:  <https://owi.usgs.gov/R/packages.html>

The package we will be using to load data into R is the `dataRetrieval` library. Information on how to use this library can be found here: <https://owi.usgs.gov/R/dataRetrieval.html#2>



#### <u>Installing packages and loading libraries</u>

Rcran is open source, meaning anyone can create packages for other people to use. To access these packages you must first install them onto your machine. Installing packages only needs to be done on one occasion; however, you may decide to install packages every time you open your script if you think the package is being regularly updated.

There are 2 primary ways to install a package onto your machine. 

**Method 1 -** Manual

1. In the `menu` click on `Tools`  then `Install Packages`
2. Select the package(s) you wish to install. Start typing and it will provide options.

**Method 2 -** Code

`install.packages("XXX")`

You can install multiple packages by typing: `install.packages(c("XXX1","XXX2","XXX3"))`

The `c()` creates a list that r can read through.



For this project we will load in the following libraries:

- `dataRetrieval` - USGS package to download data directly to R
- `EGRET` - USGS package that contains some basic statistics for streamflow data
- `ggplot2` - popular plotting library in R
- `dplyr` and `magrittr` are used to link commands together by piping. Pipes, `%>%` link each call made in R to the previous call. We'll learn more on this later.
- `lubridate` - package used for dates and time
- `leaflet` - package used for maps

In the case of the USGS `dataRetrieval` package, the package is under active development. In this case you may want to reinstall the package each time you use it to make sure you have all the latest functionality.



Libraries are now installed on your screen, but they aren't loaded into your current session. You have to tell R to load the library for use using `library(XXX)`. 



#### <u>Download Data Directly from NWIS</u>

We will use the USGS packages to download data directly from the USGS. To do this we need to identify what we want to download. We need to define:

- `siteNumbers` - this is the USGS gauge containing the data we want to download

  - We will define the variable `siteNo` and assign it to Clayton gauge: `02087500`
    - `siteNo <- '02087500'`

- `parametercd` -  this is the parameter code... what we want to download from the gauge.

  - Parameter codes can be found here: https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
  - We will define the variable `pcode` and set it equal to `'00060'` which is the code for discharge.
    - `pcode = '00060'`

- `statCd` is the statistical code for daily values. We are interested in the mean.

  - Statistical codes can be found here:  https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html
  - We will define the variable `scode` and set it equal to `'00003'`
    - `scode = '00003'`

- We also can identify the start and the end date. In this case we will define the following:

  - `start.date = "1930-10-01"`

  - `end.date = "2017-09-30"`

    ​

- We can now put all this information to call the data from the USGS NWIS website. There are a couple of ways we can do this, but we will focus on the following: `readNWISdv`.  The `dv` stands for 'daily value'.

  - We will put the data into the variable `'neuse'`

    - `neuse <- readNWISdv(siteNumbers = siteNo, parameterCd = pcode, statCd = scode, startDate=start.date, endDate=end.date)`

  - It is a good idea to look at a summary of the data as well as the dimensions of the data:

    - `summary(neuse)` provides summary statistics of each column

    - `dim(neuse)` provides the dimensions in [rows columns]

      ​

- The `dataRetreival`package has an additional commands

  - `neuse <- renameNWISColumns(neuse)` provides meaningful column names to the data
    - You can see what the column names are by: `colnames(neuse)` 
  - You can access different attributes associated with this stream gauge. To know what that list is:
    - `names(attributes(neuse))`
  - From that list you can look at:
    - `parameterInfo <- attr(neuse, "variableInfo")` provides information on variables
    - `siteInfo <- attr(neuse, "siteInfo")`



---

### • Exploring the data`

Now that we have our data, we should explore and inspect the data before we dive into our analysis. This may expose irregularities in the data, stemming either from our import process or in the dataset itself. **Plots** and **summary statistics** are a quick way to reveal any data gaps or outliers. 

- **First, compute cms values from your cfs ones:**

  - Create a new column use `$`

    - ```R
      neuse$Flow_cms = neuse$Flow * 0.028316847
      	summary(neuse$Flow_cms)    #check to make sure works
      ```

      ​


#### Plot streamflow data to look for gaps/outliers

* **Basic Plots in R**:

  * Create the margins of your plot using `par`

    * `par(mar) = c(3,5,2,5))` where the margin is set for (bottom, left, top, right)

  * Plot the data... there are a lot of additions you can add to the plot with a `,`
    * Basic plot: `plot(xaxis, yaxis)`, so in this case 

      ```R
      plot(neuse$Date, nesue$Flow_cms)
      ```

    * `type`  tells the plot what type of plot you want. `n` tells the plot not to show points

    * `yaxt` and `xaxt` tell the plot what to do with the y and x axis

    * `ylim` and `xlim` tell the plot the min and max of the respective axes

    * `ylab` and  `xlab` set the labels for the respective axes. `main` sets the title for the plot.

      ```R
      plot(neuse$Date, neuse$Flow_cms, type='n', yaxt="n", xlim=c(min(neuse$Date),max(neuse$Date)),
             ylab="Streamflow (cms)", xlab = '', main=siteInfo$station_nm)                 
      ```

      ​

      * notice this creates an empty plot

      * `axes` lets you set up with more control the axis of interest. `1` is the x-axis. `2` is the y-axis.

      * `points()` and `lines()`  allow you to overlay data onto the plot as points or lines. Because there are so many points we want to plot the data as lines. There are many ways to stylize points and lines.

        * `col` sets the color, `lwd` sets the width,  `lty` sets the type of line

      * `abline` allows you to draw straight lines in the plot. `v` for vertical lines, `h` for horizontal lines. Here we can draw a vertical line around the time falls lake was constructed.

        ```R
         axis(2, las=2, cex.axis=0.9)
          lines(neuse$Date, neuse$Flow_cms, col="blue", lty=1, lwd=1)
          abline(v=as.Date("1984-01-01"), lty=3, col="black", lwd=2)
        ```

        ​

    ​


---

### ♦ Summarize and plot data

<u>Know your data.</u> Whenever you get data, it’s good practice to look at and understand the raw data to make sure it looks reasonable and you understand something about its quality and content. One of the first things to assess in the metadata is how confident you are in the quality of the data being used in your analysis. Is the data fit for purpose?

##### How confident are we in the data?

* If you noticed in the summary of the data there was a column with confidence codes on the quality of the data. 

* `table` creates a table that counts the number of occurrences for each category of confidence code.

  * notice the table is in an array. We want to put it into a data frame (similar to the `neuse` data) so we can manipulate the columns. The command `as.data.frame` puts the table into a format we can use.

    * ```R
      confidence <- as.data.frame(table(neuse$Flow_cd))
      	colnames(confidence)<-c("Category","Number")
      ```

      ​

  * `colnames` allows you to rename the columns.

  * To perform operations on the data you must call the column name. You do this by first listing the name of your data: `confidence` and then calling on the column of interest by using `$` and then the `column name`

    * ```R
      confidence$Percent <- confidence$Number/total.n*100
            confidence$Percent <- round(confidence$Percent,2)
      ```

- You can create a pie chart and set the color of the pie using the following command:

- ```R
  pie(confidence$Percent, labels=confidence$Category, col=c("cornflowerblue","lightblue","darkorange","orange"), cex=0.7)
  ```

  - You are creating the pie chart using the `percent` column and labeling the chart using the `category` column. 	`cex` refers to the size of the label.



##### Examine Summary Statistics of our Data

Summary statistics provide another quick way to examine our data for peculiarities. Here, we'll outline the process for computing min, max, mean, and percentiles from our data. There are many ways to accomplish this task. We will explore 2 methods: functions and piping (dplyr).

* Functions allow you to program a process you wish to repeat many times. Typically you call on this function to perform some task on some data. 

  * First we want to create a data frame to store the output from our function once it runs. A data frame is a matrix of rows and columns. Here will create a data frame with 8 rows and 4 columns.

  * We will then give the data frame meaningful column headers using `colnames`

  * And we will fill in the first column of data with the names of the statistics we wish to run.

    ```R
    #Create data frame
    sum.stats <- as.data.frame(matrix(nrow=8, ncol=4))
      colnames(sum.stats) <- c("Statistics","p1930-2017","p1930-1979","p1984-2017")
    #Fill in first column
    sum.stats$Statistics <- c("Min","10th percentile","25th percentile","Median","Mean","75th percentile", "90th percentile","Max")
    ```

  * Next we will right our function. The form of a function is: `function name` = `function(parameter1, parameter2, ...) {the tasks to perform}`

    ```R
    #Function to fill in second column
    gen_stats = function(data, column.no){   #we are calling our function with 2 parameters.
      #The first parameter is the data we want to go into the function. The second is the column we want to fill in our data frame.
      
      #Now we perform the task. We want to fill the sum.stats dataframe. To do this we run a stat and place that value into a specific row and column. 
        #data.frame[row number, column number]
      sum.stats[1,column.no] <- min(data$Flow_cms);               
      sum.stats[2,column.no] <- quantile(data$Flow_cms, 0.10);    
      sum.stats[3,column.no] <- quantile(data$Flow_cms, 0.25);
      sum.stats[4,column.no] <- median(data$Flow_cms);            
      sum.stats[5,column.no] <- mean(data$Flow_cms);
      sum.stats[6,column.no] <- quantile(data$Flow_cms, 0.75);    
      sum.stats[7,column.no] <- quantile(data$Flow_cms, 0.90);
      sum.stats[8,column.no] <- max(data$Flow_cms);               
      
      return(sum.stats);       #we return the dataframe. This gives us access to the data frame outside of the function
    }
    #call the function to run using the following parameters
    sum.stats <- gen_stats(neuse, 2)
    sum.stats$`p1930-2017` <- round(sum.stats$`p1930-2017`,3) #round the data to look pretty
    sum.stats #make sure numbers match excel
    ```

  * Now we can re-run the function for different subsets of the data. 

    * ```R
      #Subset data and rerun function
      neuse.pre1980 <- subset(neuse, Date<="1979-12-31");
      neuse.post1984 <- subset(neuse, Date>="1984-01-01");

      #call the function to calculate summary statistics
      sum.stats <- gen_stats(neuse.pre1980,3)
      sum.stats <- gen_stats(neuse.post1984,4)
      ```

      ​

- dplyr and pipes. Pipes create a chain of commands that build on the previous command. There are two libraries you need to do this: `dplyr` and `magrittr`. The symbol `%>%` is the pipe that connects a chain of commands together.

  - In this example we will create a new data frame, `sum.stats2` to hold the summary statistics. We will then perform a series of commands on the `neuse` data. Essentially we are saying to grab the neuse data and then calculate the following variables in the sum.stats2 frame.

    ```R
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

    #repeat for the other time periods. Use the 'filter' command:
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
    final.stats <- as.data.frame(t(round(sum.stats2,3))); #t transposes the matrix
      final.stats$Statistics <- row.names(final.stats);   # change rownames to column
    final.stats <- final.stats[,c(4,1,2,3)]; #reorder data frame
    colnames(final.stats) <- c("Statistics","p1930-2017","p1930-1980","p1984-2017")
      final.stats  
    ```

    ​

##### Is there seasonal variation in streamflow?

Here we will look at the seasonal variation in streamflow using two methods: pipes and the for loop. For loops are great when you need to repeat a process multiple times.

- dplyr and pipes. Here we will use the new command `group_by`. This command allows us to run our summary statistics based on particular groups of data, in this case by months.

  ```R
  #add year and month values
  neuse$Year <- year(neuse$Date);  neuse$Month <- month(neuse$Date)

  #run dplyr
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
  ```

  ​


- For loop example. Here we want to loop through each month and calculate the summary statistics. The format for the for loop is: 

  ```R
  for (j in 1:n){ do something ... }
  ```

  where j is a count variable. It will be 1 the first time the loop runs, 2 the second time, etc. n is the number of times you want to run the loop. The task to perform is in between the {}.

  ```R
  #set up data frame
  month.flow <- as.data.frame(matrix(nrow=0,ncol=4));                 
  colnames(month.flow) <- c("Month","p1930to2017","p1930to1980","p1984to2017")
  #unique() <- pulls out the unique values in a column.
  unique.month <- unique(neuse$Month)

  for (j in 1:length(unique.month)){      #you are telling the loop to run for as many unique variables as you have
    #subset data to month of interest
    zt <- subset(neuse, Month==unique.month[j])    #subset data for month 'j'
    #further subset data based on year
    zt.early <- subset(zt, Year<=1979);             zt.late <- subset(zt, Year>=1984)
    
    #fill in dataframe
    month.flow[j,1]<-unique.month[j];              # month                      
    month.flow[j,2] <- round(mean(zt$Flow_cms, na.rm=TRUE),3)    #period of record
    month.flow[j,3] <- round(mean(zt.early$Flow_cms, na.rm=TRUE),3);  #pre 1979 data
    month.flow[j,4] <- round(mean(zt.late$Flow_cms, na.rm=TRUE),3)    #post 1984 data
  }
  month.flow      #check your results
  ```

  - You will notice the months are ordered based on water year. Reorder the months and plot the results on a line chart.

    ```R
    #Reorder from water year to calendar year
    month.flow <- arrange(month.flow,Month) #automatically sorts ascending. If want to descend: arrange(month.flow,desc(Month))

    #Plot results
    par(mar = c(3,5,2,5)) #set plot margins
    plot(month.flow$Month, month.flow$p1930to2017, type='n', yaxt="n", xaxt="n", ylim=c(0,max(month.flow$p1930to2017)+10),
         ylab="Mean Streamflow (cms)", xlab = '', main=siteInfo$station_nm,
         yaxs="i", xaxs="i") #gets rid of spaces inside plot
      axis(2, las=2, cex.axis=0.9)  #adds the y-axis labels
      axis(1, at=seq(1,12,1), labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), cex.axis=0.9)      #add x-axis labels
    #plot monthly lines
      lines(month.flow$Month, month.flow$p1930to2017, col=rgb(0,0,0,0.5), lty=1, lwd=2)
      lines(month.flow$Month, month.flow$p1930to1980, col=rgb(0.8,0,0,1), lty=1, lwd=3)
      lines(month.flow$Month, month.flow$p1984to2017, col=rgb(0,0,0.8,1), lty=1, lwd=3)
    #add a legend
    legend("topright",c("Period of Record", "1930 to 1980", "1984 to 2017"), col=c(rgb(0,0,0,0.5), rgb(0.8,0,0,1), rgb(0,0,0.8,1)), lwd=c(2,3,3))
    ```



---

### Loading Sites on Leaflet

Let's say you want to know where all stream gauges are in North Carolina. You can use the USGS NWIS website or you can plot the sites in R. Here, we call on all site data in North Carolina.

```R
#load in all sites in 'NC' that have discharge data (pcode).
nc.sites <- readNWISdata(stateCd="NC", parameterCd = pcode, service = "site", seriesCatalogOutput=TRUE)
#how many sites are in NC?
length(unique(nc.sites$site_no))
```



Next we use the `leaflet` library in r to plot the sites.

```R
leaflet(data=nc.sites2) %>%                        #on this data
  addProviderTiles("CartoDB.Positron") %>%         #add the background map (can change)
  addCircleMarkers(~dec_long_va,~dec_lat_va,       #plot circles using these columns
                   color = "red", radius=3, stroke=FALSE,   
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm)             #when moused over provide station name
```



That's a lot of data. Let's look at discharge over time for all stations in the the Upper Neuse River basin upstream of Falls Lake. You know the HUC code is `03020201`

```R
#let's focus on the upper Neuse upstream of Falls Lake
upper.neuse <- subset(nc.sites2, huc_cd=="03020201")
unique.sites <- unique(upper.neuse$site_no); length(unique.sites)   

#let's plot all the site data on the same graph to compare.
par(mfrow=c(2,3))    #there are 6 sites so create a matrix with 2 rows and 3 columns
par(mar = c(2,2.5,2,2)) #set plot margins (bottom, left, top, right)
#set up the color for each plot
stream.col <- c(rgb(0,0,0,0.5),rgb(1,0,0,0.5),rgb(0,0,1,0.5),rgb(0,0.7,0,0.5),rgb(0.7,0.2,0,0.5), rgb(0.7,0,1,0.5))
#provide the name of each station
legend.names <- upper.neuse[1:6,]$station_nm

#set up a for loop to read in and plot streamflow over time
for (i in 1:length(unique.sites)){
  #read in the site data
  zt <- readNWISdv(siteNumbers = unique.sites[i], parameterCd = pcode, statCd = scode)
  	zt <- renameNWISColumns(zt);
  	zt$Flow_cms <- zt$Flow*0.028316847

  #plot the data
  plot(neuse$Date, neuse$Flow_cms, type='n', yaxt="n", xlim=c(as.Date("1920-01-01"),as.Date("2017-12-31")), ylim=c(0,300),
       ylab="Streamflow (cms)", xlab = '', main=legend.names[i])
  axis(2, las=2, cex.axis=0.9)
  lines(zt$Date,zt$Flow_cms,col=stream.col[i])  
  print(legend.names[i])
 } #end for loop
dev.off() #turns off the plot
```





