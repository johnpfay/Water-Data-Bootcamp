---
Title: Analysis of Streamflow Data using Excel
Author: Lauren Patterson and John Fay
Date: Spring 2018
---

# Unit 1: Analysis of Streamflow Data using Excel

[TOC]

## ♦ Background: How has Falls Lake affected streamflow?

Prior to 1978, flooding of the Neuse River caused extensive damage to public and private properties including roadways, railroads, industrial sites, and farmlands. The Falls Lake Project was developed by the U.S. Army Corps of Engineers to control damaging floods and to supply a source of water for surrounding communities. Construction of the dam began in 1978 and was completed in 1981. In addition to recreation opportunities, Falls Lake now provides flood and water-quality control, water supply, and fish and wildlife conservation ([source](https://www.ncparks.gov/falls-lake-state-recreation-area/history)).

Now, some 3 dozen years after Falls Lake was constructed, we want to evaluate its impact on downstream streamflow, using this as an opportunity to examine some data analytic techniques, specifically ones using Microsoft Excel. These techniques will cover ways to get data into Excel and how to manage, wrangle, and analyze those data. 

This document begins with a review of the **analytical workflow** of most data projects. Then we apply this workflow to the question posed above. In doing so, we focus on using *Excel* to tackle the assignment, but companion documents will examine how *R* and *Python* can accomplish the same set of tasks in a scripting environment.

---

## ♦ Analytical workflow: A Preview

Data analysis projects follow a similar workflow, one that begins with a general question or objective that guides our process of turning data into actionable information. Let's begin by examining our workflow, depicted in the diagram below. 



![Data Analytics Process Streamflow](media/Data Analytics Process Streamflow.png)



### 1. Clarifying the central question

Data analysis has a workflow that often begins with clarifying the central question. For example, our initial question is *"How has Falls Lake affected streamflow?"* This question has some useful specifics: We know where we'll be working (Falls Lake) and what to core dataset will be (streamflow). However, the question is vague on how precisely we might evaluate effects of the dam on streamflow. As a data analyst your first job is often to <u>clarify a basic question into one that is *actionable*</u>, that is one that has a clear route to an answer or at least that allows you to present data to a way that facilitates effective decision making. 

This step usually requires some communication between the the client, project managers, experts in the field, and you, the data analyst. (And let's hope it goes better than this meeting: https://www.youtube.com/watch?v=BKorP55Aqvg .) For our Falls Lake example, however, we'll assume this meeting took place and narrowed on on the following questions:

* How has the 100-year flood frequency changed since building the lake?
* How have 7-month minimum flows changed since building the lake?
* Has has variability in streamflow changed since building the lake?

While these are still a touch vague, our expert hydrologists will provide more specific guidance on these analyses below. 



### 2. What data do I need to answer the question? Do those data exist?

With our objectives clarified, our next step is to <u>identify the data needed drive our analyses</u>. In our case, it's fairly obvious: we need long-term streamflow data at some point downstream (and not too far downstream) from the Falls Lake dam. In other cases, it may not be as obvious and may require another conference with the project team to figure out what that ideal dataset may be. 

When a target dataset is identified, the following question is <u>whether those data exist</u>? Knowing where to look or whom to ask whether a certain dataset exists comes with experience (though web-search skills can be quite useful too). In other words, it's not really something one can teach in a broad sense. However, if you've exhausted your search and still can't find the proper dataset for your analysis, your fallback is to look for **proxies**, or similar (existing) data that can be used in place of your [missing] data without making too crazy of assumption. In some cases, **models** can be used to derive suitable data to run your analysis. 

Again, we are fortunate in our case. The data we want are provided by the USGS' *National Water Information System* (NWIS). Instructions on how to grab the data we want are provided in this document.



### 3. Obtaining, exploring, and cleaning the data

Data come in a variety of forms and formats. Some datasets lend themselves to easy import and immediate analysis; others may not be digital-ready (e.g. hard-copies or PDFs) or have an inconsistent format rendering them essentially useless. As they saying goes, "your mileage may vary" with the dataset you find. While there are techniques, technologies, and some tricks in getting messy, seemingly irretrievable data into a workable format, we will not focus deeply on that. Rather, we'll cover some reliable techniques for <u>getting data into a workable, or **tidy** format</u> in Excel. Comparable, actually more powerful techniques exist for obtaining and cleaning data exist in *R* and *Python* scripting languages that we'll examine  a bit later.



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

As mentioned above, we've determined that we need streamflow data for some site below Falls Lake dam, and those data are provided via the USGS' National Water Information System. The following steps outline the process of finding the appropriate gaging site and then the data we need to run our analysis. 

#### <u>Finding the streamflow data</u>

1. Open the NWIS mapper in a browser: https://maps.waterdata.usgs.gov/mapper/index.html

2. Locate Falls Lake on the map. (Tip: Search for `Falls Lake, NC`)

3. On the map, visually follow the stream flowing out of Falls Lake dam until you find a gage site. Click on it, and it should reveal Site #: `02087500`, `NEUSE RIVER NEAR CLAYTON, NC`. This is the site we'll use for our analysis. 

   [img]

4. Click on the [Access Data](https://waterdata.usgs.gov/nwis/inventory?agency_code=USGS&site_no=02087500) link. This brings up the interface for selecting which data you want to grab. 

5. On this page, from the dropdown menu near the top, select `Time-series: Daily Data` and hit `GO`. This will open the form for selecting the current and historical stream flow data we want.

6. In this form:
   \- Check the box next to `00060 Discharge`;

   \- Select `Tab-separated data` and `Display in browser` as the output format;

   \- Set the From date to `1930-10-01` and the End date to `2017-09-30` (note: the "water year" goes from Oct. to Sept.);

   \- And finally hit `Go`. This will call up a page with all the data you just requested. 

   [img]

​     *\*  (If needed, this [LINK](https://waterdata.usgs.gov/nwis/dv?cb_00060=on&format=rdb&site_no=02087500&referred_module=sw&period=&begin_date=1930-10-01&end_date=2017-09-30) will take you directly to the data...)*

Pause and have a look at what's provided. The first several lines begin with a '#' and display the dataset's *metadata*, i.e. data about the data. Then, the first line without the '#' appears to be column headers, but the line after that looks different than the actual data values below that. (As it happens, this line indicates the data *length* and *type*: `5s` indicates a `s`tring that is `5` characters long. The other data types include `d` for *date*, and `n` for *numeric*.) 

#### <u>Getting the data into Excel</u>

\**Before embarking on our work with Excel, be sure you are clear what each of the following refers to with respect to Excel:* `workbook`, `worksheet`, `row`, `column`, `cell`.

Now that we have obtained the data in digital form, we need to get it into *Excel* so that each value is in its own cell. We'll discuss two, somewhat imperfect, methods to do this, each requiring a bit of manual editing. We also present a third, more automated method. However, while this third method may seem easier, it is less transparent to what is going on an also seems a bit unstable with the current release of *Excel*.   

##### Method 1 -

- Select the entire contents of the web page containing the discharge data. (Tip: use `ctrl`-`a` )
- Copy (`ctrl`-`c`) the contents from the browser and paste (`ctrl`-`v`) them into a new *Excel* worksheet. 
- *Notice that the contents are lumped into a single column, which prevents us from properly working with the data. To fix this, you can use the `Text to Columns` command.*
- To convert text to data, first select the cells containing text you want to convert into columns. For us, its the entire first column, which you can select by click the header of Column `A`.
- From the `Data` menu, click the `Text to Columns` command in the `Data Tools` panel. 
- In the wizard, specify that your data are `delimited` by a `space`, and then click `Finish`. 

*This works, but not perfectly. Notice the data (starting in row 34) are in columns now, but the column headers don’t match the data fields until 2004 when minimum and maximum discharge were collected. We, need to be careful for these types of errors using this method. Let's look at an alternative method and see whether it works better...*

##### Method 2 - 

- Clear the contents of your Excel spreadsheet and copy the contents of the NWIS data web page again, if necessary.
- In your blank worksheet, right-click cell A1 and select `Paste Special...` from the context menu.
- In the Paste Special wizard, select `text` and hit `OK`. Notice that the data are in the correct columns!
- Rename the worksheet "`Raw`" and save your workbook. 

##### Method 3 - 

*(Note, this method is somewhat buggy and may take a bit longer to run...)*

- From the `Data` menu, select `From Web`. 
- In the `New Web Query` window, copy and paste the NWIS data web page's [URL](https://waterdata.usgs.gov/nwis/dv?cb_00060=on&format=rdb&site_no=02087500&referred_module=sw&period=&begin_date=1930-10-01&end_date=2017-09-30) into the `Address:` box and click `Go`.
- You'll see the data appear in this window; Click the orange arrow to select the data to import.
- Click the `import` button. 

---

### • Exploring the data

While we now have our data in Excel, we should explore and inspect the data before we dive into our analysis. This may expose irregularities in the data, stemming either from our import process or in the dataset itself. **Plots** and **summary statistics** are a quick way to reveal any data gaps or outliers. 

#### Create a copy of the raw data and clean it up

We'll begin by creating a tidier version of the raw data, but keeping the raw worksheet intact in case we make a mistake and need to revert to it. And with this copy, we'll remove the metadata and other extraneous items so that we have a clean, efficient dataset, ready for quick analysis. 

- **Create a copy your `Raw` worksheet and rename it `EDA` (for exploratory data analysis):** 
  - Right click the `Raw` worksheet tab, and select `Move or Copy...`

  - Be sure, `create a copy` is checked and click `OK`. 

  - Right click on the `Raw (2)` worksheet tab and select `Rename`

  - Type in `EDA` as the new name

    ​		**---All further work will be done in this EDA worksheet ---**

- **Delete the metadata rows and the data type specification row (rows 1-31 and 33):**
  * Select the entire row by selecting the row number. Use `shift-click` to make continuous selections and `ctrl`-`click` to make disjunct selections.
  * Right-click and select `Delete`. 

- **As we are only interested in *mean* discharge, we can remove the other columns:** 

  * Delete all columns but `site_no`, `datetime`, and mean discharge, currently labeled `85235_00060_00003`. 
  * Rename the `85235_00060_00003` as `Mean flow (cfs)`
    *\*Note: It's always good to include the units in a field name!*


#### Plot streamflow data to look for gaps/outliers

* **Create a scatterplot of discharge over time**:

  * Choose the data you want to plot:

    * Highlight cells B1 and C1.
    * Press `ctrl`+`shift`+`↓` to select all data cells beneath your initial selection.

  * Create a scatter plot with straight lines from your selected data:

    * From the `Insert` menu, over in the `Charts` panel, select the scatterplot dropdown, and chose an appropriate chart type given the data. (Straight lines makes sense since our data are based on measurements.)

    *Notice that the X-axis contains an odd sampling of dates and lots of dead space on either side. Different plot types behave differently in Excel, and scatterplots are finicky with dates, so we need to either manually adjust the x axis or chose a different plot type. We'll examine both ways...* 

  * Format the X-axis to eliminate empty data space:

    * Double-click the x-axis to open the *Format Axis* menu.
    * In the *Format Axis* panel, click the *Axis Options* icon (looks like a bar chart). 
    * Notice that the axis bounds are currently set from 0 to 50,000. To set these to our data's minimum and maximum values, just type them in as dates, e.g., `1930-10-01` and `2017-09-30`. 

  * <u>Or</u>, you can convert your scatterplot to a 2-d line plot.

    * With the chart selected, and the `Design` tab active, select `Change Chart Type` to switch your scatterplot to a line plot. *Notice you can preview the design of a chart before committing to it.*
    * Notice that the date format is much tidier with a line plot...

* **Adjust the aesthetics of your plot**

  * Change the title to something meaningful, such as “Neuse Streamflow near Clayton, NC”

  * Add a y-axis label: `Design` -> `Add Chart Element` -> `Axis Titles` -> `Primary Vertical`

  * Change the y-axis bounds:

    * Set the maximum to 23,000; note the minimum drops to -2000. Change the minimum to 0

    * Set the display units to *Thousands*. 

    * Delete the gridlines

    * Play with the colors, font sizes, borders, etc. Try setting your plot to use narrower lines to show more detail. 

* **Save your workbook...**

*You remembered that scientists like the metric system and you need to convert the data from cubic feet per second to cubic meters per second. You'll need to create a new column with the discharge values in these units and re-create a new plot. Here are the steps:*

* **Add a header in column `D`: "Mean flow (cms)"**
* **Compute cms values from your cfs ones:**
  * In cell `D2`, enter the formula `=C2*0.028316847` (0.028316847 is the conversion rate from cfs to cms). 
  * To carry this formula down to all records, double click on the bottom right corner of the `D2` cell.
* **Check that the new values appear correct:**
  * First, lock the header row so it doesn't disappear when scrolling
    * Click `ctrl`-`home` to set the active cell as the top left cell `A1`.
    * Highlight Row 1
    * From the View menu, select `Freeze Top Row`
    * Scroll down and examine the Discharge (cms) data. Note the header row stays put!
* **Re-plot the data in cubic meters per second.** 
  * Select your existing plot and click on the data line. That will indicate the columns of data on which the plot was based. 
  * Click on the side of the blue rectangle and drag it so that it covers the column D, not C. 
  * Change the y-axis label and bounds. 
  * Reformat other aesthetics as needed...

---

### ►  Exercise - Plot data in mgal/day

Your project manager looks at the chart but she doesn’t like the metric system. Add a new column to convert discharge to millions of gallons per day. Make a new plot and show side by side to the CFS plot. (1 CFS = 0.53817 MGD)

---

### ♦ Summarize and plot data

<u>Know your data.</u> Whenever you get data, it’s good practice to look at and understand the raw data to make sure it looks reasonable and you understand something about its quality and content. One of the first things to assess in the metadata is how confident you are in the quality of the data being used in your analysis. Is the data fit for purpose?

##### How confident are we in the data?

Our data included data-value qualification codes, and indication of the confidence we can have in the values reported. Let's examine our data in terms of those codes. We deleted these data from the table, so we'll have to add them back in to the data in our EDA worksheet. 

* **Add a new column header to the table in the EDA worksheet; name it `Confidence`.**

  *We could copy and paste the data back into our table, as we haven't moved things around. However, it's useful to know how the vertical lookup, or* `VLOOKUP` *function works to join data from on table to another using a common joining field.*

* **Under the `Confidence` header you just created, enter the formula: `=VLOOKUP(B2,Raw!$C$34:$I$31810,7,FALSE)`**

*There's a lot going on in that VLOOKUP formula, so lets explain it.* 

*First, the VLOOKUP function looks up a value by matching a given value in one table to a given value in another table, specified by a range of cells. In our example, this matching value is in cell `B2`, i.e. the date `10/1/1930`. VLOOKUP searches the range of cells specified in the second argument, `Raw!$C$34:$I$31810` for that value, and returns the value in the `7`th column of that range.* 

*What still may be confusing is how the range of cells is defined by `Raw!$C$34:$I$31810`. Here, `Raw!` tells Excel that the range of values is in the worksheet named "Raw", not the current worksheet. The range of cells in the "Raw" worksheet is `C34` to `I31801`, but the `$` indicates that, as we copy this formula to other cells, this range should remain static. Otherwise, if we copied the formula to the cell below it the range would dynamical update  from `C34:I31810` to `C35:I31811`, but in our case, we want the lookup range to be locked in.* 

* **Double click the bottom corner to copy this function down to all records in our table.** Now we have re-added the confidence values back to our data table!

Now, let's add into our worksheet a table listing how many records are associated with each confidence value. A look at the metadata indicate three data-value qualification codes: *A*, *P*, and *e*. Let's first confirm what values are contained in our dataset. We can do this quickly by setting up a data filter:

* **Create a Filter for the `Confidence` column to reveal a list of unique values**
  * Select the entire Confidence column.
  * With the `Home` menu active, select `Sort & Filter`>`Filter` (from the `Editing` panel)

You'll now see that the header cell has a dropdown arrow. Click this arrow and it will list all the unique values, and you'll see that our data indeed has three values, but they are slightly different than what was listed in the metadata. They are: A, A:e, and P. 

Now to create the table listing how many records are associated with these three values. The `countif` tool is useful here.

* **Create a table listing the number of records associated with each Confidence code using COUNTIF** 
  * Somewhere in your EDA worksheet, create two header cells: `Confidence code` and `Count`.
  * Under the `Confidence Code` header cell, enter three label cells, one for each confidence code: `A`, `A:e`, and `P`,
  * To the left of each label cell, start typing the formula `=countif(` 
  * To specify the *range* portion of this formula, select the top data cell in the Confidence column (E2), and then press `shift`+ `ctrl`+`↓`. (It should result in `E2:E31778`)
  * To specify the *criteria* portion of the formula, select the label cell containing the confidence code you want to count. This should be immediately to the left of the cell into which you are typing the formula. The value for `A` should be `31601`.
  * Before copying this formula down, you need to add `$` to your range so that it remains locked in: Edit the range in your formula from  `E2:E31778` to  `E$2:E$31778`.
  * Now, double-click the lower right corner of the cell to copy the formula down for the other two confidence codes. 

With this table you can interpret the results. What proportion of the data is reliable? Would a plot be helpful?



##### Examine Summary Statistics of our Data

Summary statistics provide another quick way to examine our data for peculiarities. Here, we'll outline the process for computing min, max, mean, and percentiles from our data in Excel. We'll simplify this procedure by creating a name for the range of `Mean flow (cfs)` data cell. 

* Assign `CFS` as the name of the range of `Mean flow (cfs)` cells:
  * Select all the data cells under the `Mean flow (cfs)` header
  * Type `ctrl`-`F3` to open the Name Manager and click `New` to add a new named range of cells.
  * Enter CFS as the Name. Note the range is set to what we highlighted as we open the Name Manger. Click `OK`.
  * Close the Name Manger. Now we can just type `CFS` in any formula and it will refer to that range of cells. We'll see below how this works. 
* Create a skeleton table with labels: `Min`, `P10`, `P25`, `P75`, `P90`, `Median`, `Average`, and `Max`
* Insert the appropriate formula for each, using the range of `Mean flow (cms)` cells for each. 
  * min: `=MIN(CFS)`
  * P10:  `=PERCENTILE.INC(CFS,0.1)`
    * `INC` means inclusive: where the percentile value must be between 0 and 1
    * Alternatively, `EXC` requires the percentile to be between 1/n and 1-1/n, where n is the number of elements 
  * median: `=MEDIAN(CFS)`
  * average: `=AVERAGE(CFS)`
  * max: `=MAX(CFS)`

Now that we know how to compute summary statistics, let's examine whether building Falls lake had a noticeable impact on these values. We can do this by computing summary statistics for subsets of the discharge data, with one subset containing the discharge before 1980, when construction of the lake started, and after 1984, after the dam was completed. 

* Create named ranges for discharge data before 1980 and after 1984
  * A quick way to do this is search for 1980 and select 12/31/1979 and up with `shift`+`ctrl`+`↑`. With these records selected, assign a name as we did above. 
  * Then search for 1984 and select from 1/1/1984 and down (`shift`+`ctrl`+`↓`), and name that range. 
* Compute summary stats for these new ranges as you did above. (Tip: you can use `ctrl`+`H` to replace the named range `CFS` with the new names you created for easy update.)

What do you notice? Particularly with regards to min and max streamflow. Does that make sense given what you know about reservoirs?

##### Is there seasonal variation in streamflow?

To examine seasonal (or monthly) variation in streamflow, we need to extract the months from our date values. We'll also convert calendar years into water years, which run from October thru September. 

* Parse out the Date to include Year and Month
  * Insert three new columns in your EDA worksheet by right-clicking on Column C and selecting `Insert` three times.
  * Name these columns `year` and `month`
  * In the Year column, use the `=Year()` function to extract the year from the corresponding cell in the `datetime` column.
  * Repeat for the month column. 
  * Change the format of these cells from *General* to *Number* by highlighting the columns and selecting `Number` from the dropdown list in the `Number` panel in the `Home` menu. 
  * Extend these formulas to the cells below. 
* Water year runs from October to September. We adjust the year column to account for this information using `IF`
  * Create a new column for water year. 
  * Use the `IF` function to assign the value to the cell in the `year` column if the month value is `>= 10`, otherwise, set the value of the year column minus 1:  `=IF(D2>=10,C2,C2-1)`.
  * Change the format of the cell from General to Number, if necessary. 
  * Extend the formula to the cells below, examining to ensure the calculations are correct. 
* Create a table skeleton of average streamflow by month (1-12) over the different time periods (pre1980, post1984).
* Use the `AVERAGEIF()` function to compute the average discharge of records where the month equals the specified month. Here, the *range* will be the range of cells in the month column, the criteria will be the month (e.g. '1'), and the average range will be the range of discharge values.

What do you observe? Would a plot of the results facilitate interpretation? 

### ♦ Exercise: Compute total streamflow by water year

Repeat the above using `SUMIF` for annual streamflow based on the water year.

---

## 

## Q1: Evaluating 100-year flood frequency

### Background: Calculating return intervals

Our team hydrologist suggested that one method for evaluating the impacts of dam construction is to monitor changes in flood return intervals. 

 ![image3](media/image3.png)

**Figure**: Reservoirs should moderate downstream flows. There is a flood control pool to hold flood waters that can be released slowly over time. There is also a conservation pool that holds water that can be released downstream during drier conditions to meet minimum streamflow requirements.



Flood insurance policy is built around the concept of the 100-year flood event. The housing industry has been working to explain what that risk actually means to homeowners with 30 year mortgages.

![image4](media/image4.png)

Reservoirs decrease the likelihood of downstream flooding, but that often means development occurs in areas that would have been frequently flooded prior to the reservoir. We’ve seen examples of this just his year with Hurricane Harvey.



### Framing and executing the analysis

We will use Leopold’s (1994) flood frequency curve and the Weibull equation to calculate the recurrence interval. Here the return interval is computed as $\frac{n+1}{m}$ where `n` is the number of years of data and `m` is the rank of the year from largest to smallest (see this [link](https://en.wikipedia.org/wiki/Return_period) for more info). i.	*\*\*\*NOTE: The accuracy of a return interval is highly impacted by the length of the time series.*

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
  * Select the trendline; set to logarithmic.
  * Check the box to display the equation on the chart.

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

The passing of the Clean Water Act in 1972 and the Endangered Species Act in 1973 has resulted in many reservoirs having downstream flow requirements they need to meet for either water quality purposes or to protect downstream species. For example, at the Clayton gauge, minimum flow requirements have ranged from 184 to 404 cfs since 1983. *Here we want to see if Falls Lake has raised minimum flows.*

There are many ways to approach low flow to understand how minimum streamflow has changed since Falls Lake was constructed. We will look at a common metric known as 7Q10. <u>**7Q10** is the lowest average discharge over a one [week/month/year] period with a recurrence interval of 10 years.</u> This means there is only a 10% probability that there will be lower flows than the 7Q10 threshold in any given year. 

To get more practice with pivot tables and if statements, we will calculate this metric using the 7 month period. To do this we need to construct a rolling average of monthly discharges spanning 7 month, which we can do using a series of pivot tables. 

The first pivot table aggregates our daily discharge data into total monthly discharge values for each year. From this we table, we can compute a *7-month rolling average of minimum-flows* from the given month's total discharge and those from 6 months preceding it. 

Next, we construct a second Pivot Table from the above data. This one aggregates the monthly data by year, extracting the minimum of the 7-month average for each year. This will enable us to compute a regression similar the one we constructed for the flood return interval, but this regression is to reveal recurrence interval of low flows so that we can determine the stream flow of a 10% low flow event. 

We then sort and rank these annual monthly-minimum values, similar to how we computed flood return intervals to compute *7 month minimum-flow (7Q) return interval* and then the *low flow probability of recurrence (POR)* of these flows, again using the same methods used for calculating flood return intervals and probabilities of recurrence. From this we can compute a regression between our yearly 7Q flows and POR, and use that regression equation to determine 7Q10, or the expected minimum flow across a span of 10 years. 

#### The analysis

* ##### Create a new Pivot Table to get the average daily discharge by year and month:

  * Rename the new worksheet "7Q10"
  * Set `year` and `month` as the Pivot Table *rows*. We use year instead of Water Year to ensure the data are being read in the correct order. If we use water year, the wrong September and Octobers are matched together.
  * In the field settings for both `year` and `month`, change the `Subtotals & Filters` to `None`
  * Set `Mean Flow (cfs)` as your Pivot Table *value*. Keep as the sum of the monthly flows (since taking lowest 7 month average, small variability in the number of days in each month is ok.
  * Right click the top left `Row Labels` cell, and select PivotTable Options. 
    * On the `Totals & Filters` tab, un-check the two Grand Totals options. 
    * On the `Display` tab, check "Classif PivotTable layout..." This "flattens" your table to that year is shown in one column and month in another.

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

