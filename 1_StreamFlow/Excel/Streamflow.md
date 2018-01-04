---
Title: Analysis of Streamflow Data using Excel
Author: Lauren Patterson and John Fay
Date: Spring 2018
---

# Unit 1: Analysis of Streamflow Data using Excel

[TOC]

## Background: How has Falls Lake affected streamflow?

Prior to 1978, flooding of the Neuse River caused extensive damage to public and private properties including roadways, railroads, industrial sites and farmlands. The Falls Lake Project was developed by the US Army Corps of Engineers to control damaging floods and to supply a source of water for surrounding communities. Construction of the dam began in 1978 and was completed in 1981. In addition to recreation opportunities, Falls Lake now provides flood and water-quality control, water supply, and fish and wildlife conservation ([source](https://www.ncparks.gov/falls-lake-state-recreation-area/history)).

Now, some 3 dozen years after the Falls Lake was completed, we want to evaluate its impact on streamflow downstream of its dam. And we'll use this opportunity to examine some data analytic techniques, specifically ones using Microsoft Excel. These techniques will cover ways to get data into Excel and how to organize it. 

This document begins with a review of the analytical workflow of most data projects. Then we apply this workflow to the question posed above. Here, we focus on using Excel to tackle the assignment, but companion documents will examine how R and Python can accomplish the same set of tasks

---

## Analytical workflow - a preview

#### 1. Clarifying the central question

Data analysis has a workflow that often begins with clarifying the central question. For example, our initial question is *"How has Falls Lake affected streamflow?"* This question has some useful specifics: We know where we'll be working (Falls Lake) and what to core dataset will be (streamflow). However, it's vague on how we might evaluate effects of the dam on streamflow. As a data analyst your first job is often to clarify the central question into one that has a definitive answer, or at least one that allows you to present data to a way that facilitates others in making a more informed decision.

This step usually requires some communication between the the client, project managers, experts in the field, and you, the data analyst. (And let's hope it goes better than this meeting: https://www.youtube.com/watch?v=BKorP55Aqvg .) For our example, however, we'll narrow the question down to the following objectives:

* How has the 100-year flood frequency changed since building the lake?
* How have 7-month minimum flows changed since building the lake?
* Has has variability in streamflow changed since building the lake?

Expert hydrologists on our team have provided more specific guidance on these analyses below. 

#### 2. What data do I need to answer the question? Do those data exist?

With our objectives clarified, our next step is to identify the data needed drive our analyses. In our case, it's fairly obvious: we need long-term streamflow data at some point downstream (and not too far downstream) from the Falls Lake dam. In other cases, it may not be as obvious and may require another conference with the project team to figure out what that ideal dataset may be. 

When a target dataset is identified, the following question is whether those data exist? Knowing where to look or whom to ask whether a certain dataset exists comes with experience, though web-search skills can be quite useful too. In other words, it's not really something you can teach in a broad sense. However, if you've exhausted your search and still can't find the proper dataset for your analysis, your fallback is to look for **proxies**, or similar (existing) data that can be used in place of your [missing] data without making too crazy of assumption. In some cases, **models** can be used to derive suitable data to run your analysis. 

Again, we are fortunate in our case. The data we want are provided by the USGS' National Water Information System (NWIS). Instructions on how to grab the data we want will be provided below. 

#### 3. Obtaining, exploring, and cleaning the data

Data come in a variety of forms and formats. Some datasets lend themselves to easy import and immediate analysis; others may not be digital-ready (e.g. hard-copies or PDFs) or have an inconsistent format rendering them essentially useless. As they saying goes, "your mileage may vary" with the dataset you find. While there are techniques, technologies, and some tricks in getting messy, seemingly irretrievable data into a workable format, we will not focus deeply on that. Rather, we'll cover some reliable techniques for getting fairly standard data into a workable, or **tidy** format in Excel. Comparable, actually more powerful techniques exist for obtaining and cleaning data exist in R and Python scripting languages. 

#### 4. Conducting the analysis and communicating the results

With the proper data in your analytical environment (e.g. Excel, R, Python), the remaining steps in the data analysis workflow involve answering your question(s). How this goes depends entirely on your particular needs, but in this exercise we will examine a few basic strategies for workign with data. These include:

* Selecting and subsetting specific observations (rows) and variables (columns) of data.
* Reshaping or changing the layout of your data, e.g. pivoting or transforming rows and columns
* Grouping and summarizing data
* Combining datasets
* Graphing, charting, and plotting data

#### 5. Post-mortem: evaluation and documentation

Often overlooked by the data analyst is the step of reviewing your analysis and documenting your work. When you've completed your analysis, you'll often reconvene with the team and assess whether you answered your central question effectively. If not, you'll need to tweak things until you do and perhaps cycle through the workflow again. This is where **documentation** can be hugely helpful. Documentation includes notes to yourself and to others covering in enough detail as to facilitate repeating the entire process. Documentation should include any non-obvious assumption or decision made in doing your analysis. This can be a bit cumbersome with Excel, but is done quite easily through comments in R or Python scripts. 

---

## Applying the Analytical Workflow

### ♦ Obtaining the data

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

Now that we have the data in digital form, we need to get it into Excel so that each value is in its own cell. There are two, somewhat imperfect, methods to do this, each requiring a bit of manual editing. 

###### Method 1:

1. Select the entire contents of the web page with the discharge data. (Tip: use `ctrl`-`a` )

2. `Copy` the contents and `paste` them into a new Excel worksheet. 

3. Notice that the contents are lumped into a single column, which is a problem. To fix this, you can use the

   `Text to Columns` command.

  4. Select the row of text you want to convert into columns (Click the header of Row `A`)
  5. From the `Data` menu, click the `Text to Columns` command.
  6. In the wizard, specify that your data are `delimited` by a `space`, and then click `Finish`. 

This works, but not perfectly. Notice the data (starting in row 34) are in columns now, but the column headers don’t match the data fields until 2004 when minimum and maximum discharge were collected. We, need to be careful for these types of errors using this method. Let's look at an alternative method and see whether it works better...

###### Method 2: 

1. Clear the contents of your Excel spreadsheet and copy the contents of the NWIS data web page, if necessary.
2. In your blank worksheet, right-click cell A1 and select `Paste Special...` from the context menu.
3. In the Paste Special wizard, select `text` and hit `OK`. Notice that the data are in the correct columns!
4. Rename the worksheet "`Raw`" and save your workbook. 

###### Method 3: 

*(Note, this method is somewhat buggy and may take a bit longer to complete...)*

1. From the `Data` menu, select `From Web`. 
2. In the `New Web Query` window, copy and paste the NWIS data web page's [URL](https://waterdata.usgs.gov/nwis/dv?cb_00060=on&format=rdb&site_no=02087500&referred_module=sw&period=&begin_date=1930-10-01&end_date=2017-09-30) into the `Address:` box and click `Go`.
3. You'll see the data appear in this window; Click the orange arrow to select the data to import.
4. Click the `import` button. 

---

### ♦ Exploring the data

While we now have our data in Excel, we should explore and inspect the data before we dive into our analysis. This serves to identify any irregularities in the data, stemming either from our import process or in the dataset itself. Plots and summary statistics are a quick way to identify any data gaps or outliers. 

#### Create a copy of the raw data and clean it up

We'll begin by creating a tidier version of the raw data, but keeping the raw worksheet intact in case we make a mistake and need to revert to it. And with this copy, we'll remove the metadata and other extraneous items so that we have a clean, efficient dataset, ready for quick analysis. 

- Create a copy your `Raw` worksheet and rename it `EDA` (for exploratory data analysis). 
  - Right click the `Raw` worksheet tab, and select `Move or Copy...`

  - Be sure, `create a copy` is checked and click `OK`. 

  - Right click on the `Raw (2)` worksheet tab and select `Rename`

  - Type in `EDA` as the new name

    ​		**---All further work will be done in this EDA worksheet ---**

- Delete the metadata rows and the data type specification row (rows 1-31 and 33).
  * Select the entire row by selecting the row number. Use `shift-click` to make continuous selections and `ctrl`-`click` to make disjunct selections.
  * Right-click and select `Delete`. 

- As we are only interested in *mean* discharge, we can remove the other columns. 

  * Delete all columns but `site_no`, `datetime`, and mean discharge, currently labeled `85235_00060_00003`. 
  * Rename the `85235_00060_00003` as `Mean flow (cfs)`
    **\*Note: It's always good to include the units in a field name!**

- Name the range of cells comprising your EDA dataset

  - Select the entire range of cells containing data (including headers). You can do this selecting cell A1, and then while holding down the`shift` & `ctrl` keys, click the down arrow and then the right arrow on your keyboard. 
  - Click `ctrl`-`F3` to bring up the Name Manager
  - In the Name Manager, click `New...` and give your range a name, e.g. `flowdata`. 

#### Plot streamflow data to look for gaps/outliers

* Create a scatterplot of discharge over time

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

* Adjust the aesthetics of your plot

  * Change the title to something meaningful, such as “Neuse Streamflow near Clayton, NC”

  * Add a y-axis label: `Design` -> `Add Chart Element` -> `Axis Titles` -> `Primary Vertical`

  * Change the y-axis bounds:

    * Set the maximum to 23,000; note the minimum drops to -2000. Change the minimum to 0

    * Set the display units to Thousands. 

    * Delete the gridlines

    * Play with the colors, font sizes, borders, etc. Try setting your plot to use narrower lines to show more detail. 

      ​

* Save your workbook...

You remembered that scientists like the metric system and you need to convert the data from cubic feet per second to cubic meters per second. You'll need to create a new column with the discharge values in these units and re-create a new plot. Here are the steps:

* Add a header in column `D`: "Mean flow (cms)"
* Compute cms values from your cfs ones:
  * In cell `D2`, enter the formula `=C2*0.028316847` (0.028316847 is the conversion rate from cfs to cms). 
  * To carry this formula down to all records, double click on the bottom right corner of the `D2` cell.
* Check that the new values appear correct:
  * First, lock the header row so it doesn't disappear when scrolling
    * Click `ctrl`-`home` to set the active cell as the top left cell `A1`.
    * Highlight Row 1
    * From the View menu, select `Freeze Top Row`
    * Scroll down and examine the Discharge (cms) data. Note the header row stays put!
* Re-plot the data in cubic meters per second. 
  * Select your existing plot and click on the data line. That will indicate the columns of data on which the plot was based. 
  * Click on the side of the blue rectangle and drag it so that it covers the column D, not C. 
  * Change the y-axis label and bounds. 
  * Reformat other aesthetics as needed...

##### ♦♦Exercise

Your general manager looks at the chart but he doesn’t like the metric system. Add a new column to convert discharge to millions of gallons per day. Make a new plot and show side by side. (1 CFS = 0.53817 MGD)

#### Summarize and plot data

---

## Q1: Evaluating 100-year flood frequency

- #### Background: Calculating return intervals

- #### Framing the analysis

- #### Computing maximum annual streamflow using <u>pivot tables</u>

- #### Sorting and ranking data

- #### Calculating recurrence intervals

- #### Calculating annual exceedance probability

- #### Plotting recurrence intervals

- #### Adding a regression line

- #### Computing 100 & 500 floods from the regression

#### ♦ Exercises:

 * ##### Compute return interval from all records

 * ##### Compute return intervals from records before 1980

 * ##### Compute return intervals from records after 1984

### Q2: Evaluating impact on minimum flows

- #### Background: 7Q10 

- #### Framing the analysis

- #### Computing average daily discharge  by year and month w/Pivot tables

- #### Computing 7-month averages

- #### Extracting 7-month minimum averages

- #### Rank

## Q3: Exploring trends in streamflow over time

- #### Background

- #### Framing the analysis

- #### Removing duplicates

- #### Conditional sums and counts

- #### Plotting trends

- #### Computing regressions