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

### Obtaining the data

As mentioned above, we've determined that we need streamflow data for some site below Falls Lake dam, and those data are provided via the USGS' National Water Information System. The following steps outline the process of finding the appropriate gaging site and then the data we need to run our analysis. 

#### <u>Finding the streamflow data</u>

1. Open the NWIS mapper in a browser: https://maps.waterdata.usgs.gov/mapper/index.html

2. Locate Falls Lake on the map. (Tip: Search for `Falls Lake, NC`)

3. On the map, visually follow the stream flowing out of Falls Lake dam until you find a gage site. Click on it, and it should reveal Site #: `02087500`, `NEUSE RIVER NEAR CLAYTON, NC`. This is the site we'll use for our analysis. 

   [img]

4. Click on the [Access Data](https://waterdata.usgs.gov/nwis/inventory?agency_code=USGS&site_no=02087500) link. This brings up the interface for selecting which data you want to grab. 

   [img]

5. Click on the [Current/Historical Observations](https://waterdata.usgs.gov/nwis/uv?site_no=02087500) link to access the form for selecting the current and historical stream flow data we want.

6. In this form:
   \- Check the box next to `00060 Discharge`;

   \- Select `Tab-separated data` and `Display in browser` as the output format;

   \- Set the From date to `1930-10-01` and the End date to `2017-09-30` (note: the "water year" goes from Oct. to Sept.);

   \- And finally hit `Go`. This will call up a page with all the data you just requested. 

   [img]

​     *\*  (If needed, this [LINK](https://nwis.waterdata.usgs.gov/usa/nwis/uv/?cb_00060=on&format=rdb&site_no=02087500&period=&begin_date=1930-10-01&end_date=2017-09-300) will take you directly to the data...)*

Pause and have a look at what's provided. The first several lines begin with a '#' and display the dataset's *metadata*, i.e. data about the data. Then, the first line without the '#' appears to be column headers, but the line after that looks different than the actual data values below that. (As it happens, this line indicates the data *length* and *type*: `5s` indicates a `s`tring that is `5` characters long. The other data types include `d` for *date*, and `n` for *numeric*.) 

#### <u>Getting the data into Excel</u>

Now that we have the data in digital form, we need to get it into Excel so that each value is in its own cell. There are two, somewhat imperfect, methods to do this, each requiring a bit of manual editing. 

###### Method 1:

1. Select the entire contents of the web page with the discharge data. (Tip: use `ctrl`-`a` )

2. Copy the contents and paste them into a new Excel worksheet. 

3. Notice that the contents are lumped into a single column, which is a problem. To fix this, you can use the `Text to Columns` command.

  1. Select the row of text you want to convert into columns (Click the header of Row `A`)
  2. From the `Data` menu, click the `Text to Columns` command.
  3. In the wizard, specify that your data are `delimited` by a `space`, and then click `Finish`. 


   This works, but not perfectly. The actual data, in rows 

### Exploring the data

- #### Plot streamflow data to look for gaps/outliers

- #### Summarize and plot data

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

## Q2: Evaluating impact on minimum flows

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