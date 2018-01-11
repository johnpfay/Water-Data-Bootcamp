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
  * notice the table is in an array. We want to put it into a data frame (similar to the nuese data) so we can manipulate the columns. The command `as.data.frame` puts the table into a format we can use.













##### Examine Summary Statistics of our Data

Summary statistics provide another quick way to examine our data for peculiarities. Here, we'll outline the process for computing min, max, mean, and percentiles from our data in Excel. We'll simplify this procedure by creating a name for the range of `Mean flow (cms)` data cell. 

* Assign `CMS` as the name of the range of `Mean flow (cms)` cells:
  * Select all the data cells under the `Mean flow (cms)` header
  * Type `ctrl`-`F3` to open the Name Manager and click `New` to add a new named range of cells.
  * Enter CMS as the Name. Note the range is set to what we highlighted as we open the Name Manger. Click `OK`.
  * Close the Name Manger. Now we can just type `CFS` in any formula and it will refer to that range of cells. We'll see below how this works. 
* Create a skeleton table with labels: `Min`, `P10`, `P25`, `P75`, `P90`, `Median`, `Average`, and `Max`
* Insert the appropriate formula for each, using the range of `Mean flow (cms)` cells for each. 
  * min: `=MIN(CMS)`
  * P10:  `=PERCENTILE.INC(CMS,0.1)`
    * `INC` means inclusive: where the percentile value must be between 0 and 1
    * Alternatively, `EXC` requires the percentile to be between 1/n and 1-1/n, where n is the number of elements 
    * Calculate P25, P75, P90 following the same format
  * median: `=MEDIAN(CMS)`
  * average: `=AVERAGE(CMS)`
  * max: `=MAX(CMS)`

Now that we know how to compute summary statistics, let's examine whether building Falls Lake had a noticeable impact on these values. We can do this by computing summary statistics for subsets of the discharge data, with one subset containing the discharge before 1980, when construction of the lake started, and after 1984, after the dam was completed. 

* Create named ranges for discharge data before 1980 and after 1984
  * A quick way to do this is search for 1980 and select 12/31/1979 and up with `shift`+`ctrl`+`↑`. With these records selected, assign a name as we did above. 
  * Then search for 1984 and select from 1/1/1984 and down (`shift`+`ctrl`+`↓`), and name that range. 
* Compute summary stats for these new ranges as you did above. (Tip: you can use `ctrl`+`H` to replace the named range `CMS` with the new names you created for easy update.)

What do you notice? Particularly with regards to min and max streamflow. Does that make sense given what you know about reservoirs?

##### Is there seasonal variation in streamflow?

To examine seasonal (or monthly) variation in streamflow, we need to extract the months from our date values. We'll also convert calendar years into water years, which run from October thru September. 

* Parse out the Date to include Year and Month
  * Insert three new columns in your EDA worksheet by right-clicking on Column C and selecting `Insert` three times.
  * Name these columns `year`, `month`, and `water year`
  * In the Year column, use the `=Year()` function to extract the year from the corresponding cell in the `datetime` column.
  * Repeat for the month column. 
  * Change the format of these cells from *General* to *Number* by highlighting the columns and selecting `Number` from the dropdown list in the `Number` panel in the `Home` menu. 
  * Extend these formulas to the cells below. 
* Water year runs from October to September. We adjust the year column to account for this information using `IF`
  * Create a new column for water year. 
  * Use the `IF` function to assign the value to the cell in the `year` column if the month value is `>= 10`, otherwise, set the value of the year column minus 1:  `=IF(D2>=10,C2,C2-1)`.
  * Change the format of the cell from General to Number, if necessary. 
  * Extend the formula to the cells below, examining to ensure the calculations are correct. 
* Create a table skeleton of average streamflow by month (1-12) over the different time periods (period of record, pre1980, and post1984).
* Use the `AVERAGEIF()` function to compute the average discharge of records where the month equals the specified month. Here, the *range* will be the range of cells in the month column, the criteria will be the month (e.g. '1'), and the average range will be the range of discharge values.

What do you observe? Would a plot of the results facilitate interpretation? 

### ♦ Exercise: Compute total streamflow by water year

Repeat the above using `SUMIF` for annual streamflow based on the water year.

---

## 

## Q1: Evaluating 100-year flood frequency

### Background: Calculating return intervals

Our team hydrologist suggested that one method for evaluating the impacts of dam construction is to monitor changes in flood return intervals. Falls Lake is a flood control reservoir, so it should decrease the amount of downstream flooding.

 ![image3](media/image3.png)

**Figure**: Reservoirs should moderate downstream flows. There is a flood control pool to hold flood waters that can be released slowly over time. There is also a conservation pool that holds water that can be released downstream during drier conditions to meet minimum streamflow requirements.



Flood insurance policy is built around the concept of the 100-year flood event. The housing industry has been working to explain what that risk actually means to homeowners with 30 year mortgages. Understanding the flood risk relative to mortage's is helpful for insurance companies to know. Has Falls Lake decreased the flood risk for downstream homes?

![image4](media/image4.png)

Reservoirs decrease the likelihood of downstream flooding, but that often means development occurs in areas that would have been frequently flooded prior to the reservoir. We’ve seen examples of this just his year with Hurricane Harvey.



### Framing and executing the analysis

We will use Leopold’s (1994) flood frequency curve and the Weibull equation to calculate the recurrence interval. Here the return interval is computed as $\frac{n+1}{m}$ where `n` is the number of years of data and `m` is the rank of the year from largest to smallest (see this [link](https://en.wikipedia.org/wiki/Return_period) for more info). 	

*\* NOTE: The accuracy of a return interval is highly impacted by the length of the time series.*

So, for us to do this analysis, we need to first compute maximum annual discharge, i.e., extract the largest discharge observed from each water year. The we sort and rank our data on max annual discharge and then compute a regression line from which we can determine the discharge of a 100 and 500 year flood. 

#### Compute maximum annual streamflow using <u>pivot tables</u>

Excel's pivot tables are one of it's more powerful features, allowing you to easily extract and cross tabulate various summaries from your data. We'll use to sift through discharge records on a per-year basis and identify the largest one. 

* Highlight your entire EDA table, headers and all.
* From the `Insert` menu, select `Pivot Table`, choosing to place the report in a `New Worksheet`.
* Rename this worksheet "Flood".
* In the new worksheet created, click on the Pivot Table if the `Pivot Table Fields` dialog is not shown. 
* In the Pivot Table Fields dialog:
  * Drag the `Water year` field into the `Rows` section
  * Drag the `Mean discharge (cms)` field into the `Values` section
  * Using the dropdown menu next to the `the Mean discharge (cms)` item now in the `Values` section, change the `Value Fields Settings` to summarize the field by the `Max` value.  

#### Rank & sort the pivot table data; compute return intervals 

We now have the data we want. Next we'll compute rankings and then sort the data. However, to do this we need to copy the data from the dynamic Pivot Table.

* Copy contents of your pivot table
* Paste *the values* of the contents `right click`+`s`+`v`.
* Delete the last row in the pasted values (the grand total).
* Sort the data from largest to smallest: 
  * Select both columns of data
  * From the Home menu, select Sort & Filter->Custom Sort 
  * Sort data by discharge values from largest to smallest. 
* Compute rankings in a new column named `rank`
  * Type in a few numbers, e.g., 1, 2, 3.

  * Select these numbers and double click the lower right hand corner of the selected range.

  * *Alternatively, you can use the* `RANK.EQ` *function*

    **Note: How do these methods differ for those years with the same maximum values (ties)?*
* Calculate return interval in a new column named `RI`
  * Determine how many years of data you have (e.g. count of year rows or max of rank).
  * Compute  $\frac{n+1}{m}$ where `n` is the number of years of data and `m` is the rank.
* Calculate the Annual Exceedance Probability in a new column named `Pe`
  * $Pe = 1/RI$
* Compute the the probability of the 100, 500, and 100 year flood occurring over the next 30 years as a binomial distribution: $Pe =1 - [1-(1/T)]^n$ where `T` is the return period (e.g. 100 years) and number of years of interest (30 years in our case).
  * Add three label cells: 100, 500, 1000 in a new location in your worksheet
  * Next to them add the formula `=1-(1-(1/XX))^30` where xx is the reference to your label cell. 

#### Plot the data and compute a regression equation

* Create a scatterplot of max discharge (y-axis) vs. recurrence interval (x-axis)
  * Note: Excel will default to setting the left most column in your table to the X-axis and the other as the Y-axis, meaning your scatterplot will default to setting the X-axis to Max Discharge and the Y-axis to Recurrence Interval. You'll have to manually switch this using the `Select Data` tool. 
    * In the Select Data Source dialog, Edit the `RI` category and swap the `Series X values` and `Series Y values`.
* Place the x-axis on a log scale and add minor tick marks
* Add a regression line to your plot
  * Select the points in your plot; right-click and select `Add Trendline`.
  * Try out different trendlines to see which has the best fit. In our case, logarithmic.
  * Check the box to display the equation on the chart and r2 values.

#### Apply the regression to compute 100, 500, and 1000-year flood discharges

* Using the regression equation you just calculated and added to your chart, estimate the discharge for the 100, 500, and 1000 year events, i.e., compute `y` for `x` = 100, 500, and 1000, respectively, somewhere in your Excel worksheet. *These are the estimated discharge at 100, 500, and 1000 year flood events.* 
* Add those estimated discharge values to your chart. 
  * `Select Data` > `Add` > *RI Year* goes to `X Values`, `Y Values` are the values computed from the regression.

### ♦ Exercise: Calculate the return interval from the pre-1980 data

Repeat the above analysis only using data prior to 1980 to calculate the return interval.

* How many fewer years of data are used?


* Plot the new dataset on top of the original plot.
  * `Design` > `Select Data` > `Add`
  * Add the estimated 100 and 500 year points for each plot based on the regression.
* How big is the difference between the 100 and 500 year estimates?
  * Percent is calculated relative to the smaller record (my choice)
* Calculate the discharge for different return periods and exceedance probabilities
* Plot annual discharge and calculate the number of times the 100 year flood was surpassed for both the POR and prior to 1980
  * Plot the estimates on the same chart. How much do they differ? Are you surprised by the results?

*Look at the first plot you did of streamflow on the EDA spreadsheet to look at the distribution of peak events. These events are all hurricanes. How does it change your understanding of why Falls Lake doesn’t seem to impact flood frequency?* 

*What happens to your answer if you remove those three points?*

### 

---

## Q2: Evaluating impact on minimum flows

#### Background & Framing the Analysis: 7Q10 

The passing of the Clean Water Act in 1972 and the Endangered Species Act in 1973 has resulted in many reservoirs having to meet downstream flow requirements for either water quality purposes or species protection. For example, at the Clayton gauge, minimum flow requirements have ranged from 184 to 404 cfs since 1983. *Here we want to see if Falls Lake has raised minimum flows.*

There are many ways to approach low flow to understand how minimum streamflow has changed since Falls Lake was constructed. We will look at a common metric known as 7Q10. <u>**7Q10** is the lowest average discharge over a one [week/month/year] period with a recurrence interval of 10 years.</u> This means there is only a 10% probability that there will be lower flows than the 7Q10 threshold in any given year. 

To get more practice with pivot tables and if statements, we will calculate this metric using the 7 month period. To do this we need to construct a rolling average of monthly discharges spanning 7 month, which we can do using a series of pivot tables. 

The first pivot table aggregates our daily discharge data into total monthly discharge values for each year. From this we table, we can compute a *7-month rolling average of minimum-flows* from the given month's total discharge and those from 6 months preceding it. 

Next, we construct a second Pivot Table from the above data. This one aggregates the monthly data by year, extracting the minimum of the 7-month average for each year. This will enable us to compute a regression similar the one we constructed for the flood return interval, but this regression is to reveal the recurrence interval of low flows so that we can determine the streamflow of a 10% low flow event. 

We then sort and rank these annual monthly-minimum values, similar to how we computed flood return intervals to compute *7 month minimum-flow (7Q) return interval* and then the *low flow probability of recurrence (POR)* of these flows, again using the same methods used for calculating flood return intervals and probabilities of recurrence. From this we can compute a regression between our yearly 7Q flows and POR, and use that regression equation to determine 7Q10, or the expected minimum flow across a span of 10 years. 

#### The analysis

* ##### Create a new Pivot Table to get the average daily discharge by year and month:

  * Rename the new worksheet "7Q10"
  * Set `year` and `month` as the Pivot Table *rows*. We use year instead of Water Year to ensure the data are being read in the correct order. If we use water year, the wrong September and Octobers are matched together.
  * In the field settings for both `year` and `month`, change the `Subtotals & Filters` to `None`
  * Set `Mean Flow (cms)` as your Pivot Table *value*. Keep as the sum of the monthly flows (since taking lowest 7 month average, small variability in the number of days in each month is ok.
  * Right click the top left `Row Labels` cell, and select PivotTable Options. 
    * On the `Totals & Filters` tab, un-check the two Grand Totals options. 
    * On the `Display` tab, check "Classify PivotTable layout..." This "flattens" your table to that year is shown in one column and month in another.

* ##### Create a static copy of the Pivot Table values

  * Copy the the entire Pivot Table data and paste - as *values* - into cell `F2`. (It can go anywhere, but this will make the subsequent steps easier to follow)

* ##### Fill all the blanks in the year column with the appropriate year. 

  * Select all the cells in the newly pasted Year column
  * Click `Home` > `Find & Select` > `Go To Special…`, and a `Go To Special` dialog box will appear.
  * Check the  `Blanks` option, and click `OK`. All of the blank cells have been selected. 
  * Then input the formula “=F2” into active cell F3 without changing the selection. 
  * Press `Ctrl` + `Enter`, Excel will copy the respective formula to all blank cells.
  * At this point, the filled contents are formulas, and we need to convert the formals to values. Now select the whole range, copy, and paste as values.

* ##### Calculate the 7-month minimum flow averages (i.e., "7Q")

  * Add a new column next to the records you just pasted. Give it the header `7Q`.
  * Go to the 7th cell down and set it to compute the average of the streamflow of that row and the preceding 6 rows.
  * Double-click the bottom corner to copy this formula down to the cells below. 

* ##### Create a new table listing the minimum flow for each year, using the above table as its source. 

  * Hint: Use your pivot table skills. But you may want to create the table in the same worksheet.

* ##### Compute the rank, return interval, and probability of recurrence of these minimum flows

  * Hint: Use the methods from the flood lesson, but remember to sort in the opposite direction!

* ##### Plot the 7Q flow (Y) against the Probability of Recurrence (X)

  * Try different regression types and stick with the one with the highest R2 (but avoid *quadratic* or *moving averages*).

* ##### Use the equation to estimate the 7Q10, i.e., the threshold where the 10% of the observed flows are smaller:

  * Set `x` in the regression equation to 0.10 and find `y`. This is your 7Q10. 
  * Add the 7Q10 point to the graph using `Select Data...` with your plot active. 

* ##### Apply your results: How many months in the monthly Pivot Table fell below the estimated 7Q10?

  Here we want to produce a plot that shows when and how frequently low flows have occurred. We do this by first created a new column of just the monthly discharges falling below our 7Q10 threshold, and then creating a plot where these are highlighted against all monthly discharge values. 

  * Insert a new column to the left of your copied and pasted monthly Pivot Table results. Label it `Below 7Q10`. 
  * Use the `IF` formula to set values in this column to the monthly discharge value if the monthly discharge was below your computed 7Q10, otherwise set to an empty string (`""`). 
  * Label the empty column to the right of this table (Column E) "Date" and set it cells to the 15th of the year and month of the record, using the formula `=Date(year,month,day)`
  * Plot the monthly discharge. Then add a new series to your plot of just the ones falling under the 7Q10 (column J).
  * Add labels and a legend.

* ##### Count the number of Q710 events per year:

  * Either use the `COUNTIF` function, or
  * Expand your Pivot table to include the `Below 7Q10` column and count the number of occurrences. (`PivotTableTools` > `Change Data Source...`).


#### Continued practice

* On your own - calculate the 7Q10 prior to Falls Lake and after Falls Lake

---

## 

## Q3: Exploring trends in streamflow over time

### Background

Water security is becoming increasingly important as population and water demand continue to grow. This is especially true with changing climate conditions that introduce new variability into our expectations of water supply. Briefly, we want to know whether the average annual streamflow has changed over time. 

### Set up

- Create a new spreadsheet and name it `Trends`.
- Create a table of `Year`, `Total Streamflow`, and `Count`.
  - Copy and Paste the entire Water Year column from the EDA tab in the `Year` column. 
    - Remove duplicate values: `Data menu`>`Data Tools`>`Remove Duplicates`
  - Use `SUMIF` and `COUNTIF` to calculate the number of observations per year and the annual streamflow
  - Remove those years with < 90% of data (i.e., fewer than 329 records in a year) , 
    - Use `IF` to calculate and flag rows.
- Plot streamflow over time and add a linear trend line
- Go to `File` > `Options` >`Add-ins` > `Analysis Toolpack`
  - `Data Menu` > `Data Analysis` > `Regression`
  - Run the regression analysis on the data
    - Turn on all the plots
    - Is the trend significant?
- Repeat for 1930-1980 and for 1984-2017
  - What to you observe? 
  - Are the trends obvious? 

### More Practice

If there are not annual trends, are there seasonal ones? What about February and August?

- ##### Grab all *February* values:

  - Go to the working spreadsheet and `filter` by month
  - `AVERAGEIF` the filtered data...

- ##### Repeat the above analysis

  - *What do you observe?*




# EXCEL Limitations

Excel is a wonderful tool; however, it also has several limitations.

1. Very limited analytical pack. Indeed, many of the statistical methods used for water resources rely are non-parametric, meaning they do not assume linear relationships between x and y variables. 

2. It is time consuming to repeat analyses over multiple sites. What if we wanted to look at all downstream gauges from Falls Lake?

3. It is difficult to replicate results in Excel. Sometimes data are copied and pasted as values rather than formulas. Sometimes errors are hand corrected and not marked. 

   ​

Statistical programs and coding are valuable tools that readily address these three limitations in excel: (1) diverse statistical packages, (2) batch capable, and (3) reproducible.