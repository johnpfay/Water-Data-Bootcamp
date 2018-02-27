---
Title: Visualizing Data in Tableau
Author: Lauren Patterson and John Fay
Date: Spring 2018
---

# Unit 3: Part 1 - Visualizing Data in `Tableau`

## Background & Introduction

### Conceptual Introduction to Visualization

Data visualizations are the modern equivalent of visual communication with the goal of better communicating numerical information to an audience. Interactive visualizations allow the audience to explore and engage with the data that is of particular interest to them. Effective visualizations make complex data more accessible, understandable, and usable.

Visualizations take many shapes and forms, and like any form of communication, a great deal of artful creativity accompanies whatever scientific method in devising the best visualizations. That said, however, a few key principles go a long way in thinking about visualizing data. 

First, visualization is all about patterns, about categorizing or aggregating data in meaningful ways, and then revealing these patterns in ways that require the least amount of brain power. And so, when looking at our raw data, we need to identify which fields might serve as categories or <u>dimensions</u>, and which fields might serve as <u>numeric values</u> and how those numeric values might be <u>aggregated</u> in meaningful ways. 

Second, visualization is about communicating a <u>message</u> to an <u>audience</u>. Visualization software allow us an enormous variety of visualization options to choose from. However, in some cases one simple number may be the most effective means to communicate a results. What decides this is knowing what exactly it is you want to communicate with your product, i.e. your message, and to whom you are communicating, i.e., your audience. 

Finally, <u>experience</u> is key to getting better at constructing visualizations. Again, like writing or other forms of communication, you get better the more you do. Take a moment to reflect on what you like or don't like about other  visualizations you see. Also, seek other's opinion about ones you create. Develop your own common sense about what makes a good visualization!



### Visualization tools

There are a plethora of tools to help researchers display their data to a broader audience. Some of these tools are:

- **Shiny R**: https://shiny.rstudio.com/

  - Shiny is an R package that enables users to build interactive web apps within R by accessing html and javascript libraries.

- **Python**: many libraries (such as Bokeh and pandas) can be used to create interactive data visualizations. Python also has tools such as:

  - **Dash** - https://medium.com/@plotlygraphs/introducing-dash-5ecf7191b503

- **Tethys Platform**: http://www.tethysplatform.org/

  - Uses Python to create interactive data visualizations specifically around water resources

- **Tableau**: https://www.tableau.com/

  * Uses spreadsheets (such as Excel) to create data visualizations and storyboards. 

In the interest of time, we are going to explore **Tableau**. Unlike **R** or **Python** based visualization tools, Tableau is proprietary software. As a student, you can string along as many free 1-year licenses as you want (as long as you remain a student), but if you want to continue using Tableau beyond academia, you'll need to pay for it. However, Tableau's learning curve is much shorter, allowing us to dive deeper into aspects of data visualization.  



### Downloading and installing Tableau

Tableau is <u>not</u> installed on NSOE machines. Instead, you'll need to install your own copy. You can either apply for a 1-year license of the full desktop edition or download the free public version here: https://public.tableau.com/s/download/public/pc64 . The key difference between the two is that the public version does not allow you to save your Tableau workbooks... 



---

## I. Exploring Water Use Data

### USGS Water Use Overview

The USGS collects and reports water use on 5-year intervals. The latest data released was from 2010. Go to the USGS Water Use website (https://water.usgs.gov/watuse/). Notice they provide some overviews of the data. Click on the different overviews. What do you notice? Is this information helpful? Would this information be more engaging if we could explore different state water use?



### Obtaining the data & spreadsheet etiquette

From the USGS website, download the state data for 2010](https://water.usgs.gov/watuse/data/2010/index.html).

 * Download and examine the [Formatted tables, Excel .xlsx format](https://water.usgs.gov/watuse/data/2010/USGSCircular1405-tables1-14.xlsx). <font color=red>*Based on what we have learned in previous sessions, is this type of spreadsheet particularly usable? Why or why not?*</font>

This is a frequent problem with water data. You might be able to discover the data, but the data are not in a format that is immediately usable. How would you reorganize the data to be more usable?

* Download and examine the unformatted version [Excel format](https://water.usgs.gov/watuse/data/2010/usco2010.xlsx). <font color=red>How does this format compare to the previous one? Better? Worse?</font>

While this latter format is better suited for data analysis, we have further modified it to provide a good working example for learning Tableau. This is saves as the file called `State_Data_Formatted.xlsx`, which can be downloaded [here](https://github.com/ENV872/Water-Data-Bootcamp/blob/master/3_WaterQuality/data/State_Data_Formatted.xlsx?raw=true). 

* Download a local copy of the  `State_Data_Formatted.xlsx` workbook, and examine its contents. 


---

## II. Tableau

We'll start exploring Tableau's analysis environment by making a simple plot with our water use data. Specifically, we'll construct a simple stacked bar plot of water withdrawals by category, limiting our data to fresh water withdrawals only. In doing so, we'll cover some basics such as: reading data in, joining tables, setting up plots, and manipulating plots. 

Then we'll see if we can mimic some of the USGS exploratory products. 



### Loading data into Tableau

Tableau accepts several data formats, including Excel spreadsheets. You can also connect to remotely served data such as [Google Sheets](https://www.google.com/sheets/about/). However, to keep it simple, we'll just load in our local Excel spreadsheet. 

- Select `Microsoft Excel` under the `Connect` menu. Navigate to where the data are held.


- On the left-hand side we see that we are connected to the `State_Data_Formatted.xlsx` spreadsheet. Underneath the connection you see both `worksheets`. Drag the `WaterUse` sheet into the top right panel.

- Make sure the data loaded into Tableau correctly:

  - Data Column Headers

  - Data Types

    - Geographic types are pre-loaded into Tableau


### Joining tables

We want to connect data in our `WaterUse` worksheet with the data in the `Population` worksheet. We do this by joining the two tables.

- Drag the population sheet into the top right region of the workspace.
- Types of joins...
- Select the fields to link too: `State`
  - Linking population and water use data together will allow us to calculate the per-capita water use later on.

![Data Source](tableau/Tableau_DataSource.png)



### Navigating Tableau

The bottom row of the Tableau workspace contains tabs for the different objects you've created as well as links to create new objects.  

- `Data Source` - the raw data we load into Tableau
- `Worksheet` - spreadsheets where we create visualizations to explore the data
- `Dashboard` - organize visualizations onto a page. Can set up connectivity and interaction of different charts.
- `New Story` - organize dashboard(s) in an order to walk users through the analysis

### Working with worksheets

![TableauWorkspace](tableau/TableauWorkspace.PNG)Worksheets

##### The Data pane:

- *Dimensions* are discrete data. These set the level of detail in your visualization.
- *Measures* are continuous data. These values will be aggregated for each level in your selected dimension(s), and you specify how they are aggregated (mean, max, count, etc.).
- Italicized variables are calculated by Tableau on the fly.
- You can change how data are categorized, i.e. dimension or measures by dragging or by right clicking the variable and selecting the operation you want to perform.

##### Constructing a visualization:

- Drag `Withdrawal MGD` into the main area of the sheet. <font color="blue">What do you see?</font> Tableau will always summarize information. You can then ask it to break out that information into <u>categories</u>.


- Drag `Source` into the `Columns` "shelf". You can think of columns as your **x-axis** and rows as your **y-axis** in terms of how the data will be displayed.

  ![MGDbySource](tableau/MGDbySource.PNG)

*How else can we summarize the data?*

- Add `Type` as a column header.

  ![MGDbySourceType](tableau/MGDbySourceType.PNG)

*Notice that as you drag information over, new data summaries begin to come up. These are different options that Tableau recommends for displaying the information.*

- Drag `Category` into the `Rows` tab.

  ![MGDbySourceTypebyCategory](tableau/MGDbySourceTypebyCategory.PNG)

- Create a `stacked bar` chart by clicking the appropriate icon on the right hand side. 

  - *How did Tableau organize the information?*
  - *How did Tableau order the data in the bar chart?*

![StackedBarPlot1](tableau/StackedBarPlot1.PNG)

*It's a little hard to see - what if we flipped the orientation...*

*  Use `Ctrl`-`W` or  the `Swap Rows and Columns` tool to transpose the data. The stacked bar plot will update...

![StackedBarPlot1](tableau/StackedBarPlot2.PNG)

*Notice that `Total` is making the `Withdrawal` axis very long. Remove the `Total` column.*
- Right-Click on `Total` and click `exclude`


- Let's focus only on freshwater. Can you exclude `Saline`?


- Can you sort the column <u>data</u> from descending to ascending?


- Name your worksheet something meaningful; it will update the name of your table.

![Bar Chart](tableau/BarChart1.png)



##### Create a new worksheet and this time let's plot *per capita* water withdrawals.

- `Duplicate` the worksheet you just created and rename it "Per Capita Withdrawals"
- Under `Measures`, click on `Withdrawal MGD`. Click `Create`, `calculated field`
  - Name this calculated field `Per Capita (MGD/person)`
  - Calculate the per-capita water use (mgd/person) as `[Withdrawal MGD]/[Population]` (You can type or drag fields into the box...)
- Drag `Per Capita (MGD/person)` field into the columns chart and remove  `SUM(Withdrawal MGD)`. 

![Bar Chart](tableau/BarChart2.png)



### Recreate the charts shown on the USGS website

#### 1. Bar chart: https://water.usgs.gov/watuse/wuto.html 

Let's explore more of Tableau by attempting to recreate the USGS figure shown here:

![USGS Fig 1](https://water.usgs.gov/watuse/images/category-pages/2010/totalwateruse-map-2010.png)



- In Tableau, create a new worksheet and title it `Total Water Use, 2010`
  - Drag `State` into the worksheet. Voila! A map!

  - Let's create a color map based on `Withdrawal MGD` by dragging the field over the `color` icon.
    - You can click on colors to edit.
    - The USGS used `Stepped` color, meaning the colors are broken into discrete categories. Tableau naturally uses a `continous` color range. <font color="red">What are the pros / cons of using each. </font>Look at the USGS map for comparison. 

    > There's not a right or wrong answer. Pick the one you want to use.

  ![Map](tableau/TotalWaterUse1.png)

► Let's only look at <u>freshwater</u> totals. 

- Use the `filters` box to exclude `Saline`.

►How does the fresh water map change if you look at per capita withdrawals?

![Map](tableau/TotalWaterUse2.png)

#### 2. Pie Chart: https://water.usgs.gov/watuse/wuto.html . 

Next, we'll tackle the pie chart shown here:

![Pie](https://water.usgs.gov/watuse/images/category-pages/2010/total-category-pie-2010.png)

- Create a new worksheet and rename it "Pie Chart"
- Add the `Withdrawal MGD` data to the workspace.
- Set `Category` to be the rows.
  - Exclude the `Total` category
- Convert your result to be a Pie chart
  - Optional: reorder your fields and color them to match the USGS figure..

![pie](tableau/piechart.png)

Some modifications:

- Filter it to only look at `freshwater` 

- Set `Source` to be a column

  ![Pie](tableau/PieChart2.png)

What other charts might convey this information better than a pie chart?

#### 3. Bar chart  by state and category.

Finally, we'll tackle this one: https://water.usgs.gov/watuse/east-west-2010.html

![USGS Bar chart](https://water.usgs.gov/watuse/images/category-pages/2010/east-west-categories-2010.png)

- Create a new worksheet, rename it `State Water Use`
- Drag `Category` into the columns along with `Withdrawal MGD`
  - Filter for `Fresh`

  - Sort by `Total Withdrawals` 

  - Show only the top 10 states

    - Add `State` as a Row feature

    - Right-click the state and create a filter. In this filter, select `Top` and set to sort by the Top 10 states ranked by sum of Withdrawal...

      ![StateFilter](tableau/StateFilter.PNG)

*Can you think of how you might sort the display of `categories` from most used to least used?*

![State Bar](tableau/StateBar.png)

* To mimic the USGS chart (first duplicate the above sheet):

  * Remove the Top 10 State filter

  * Transpose the rows and columns

  * Sort on -- *well, if we had a longitude column we could do it...*

    ​

### Dashboards

- Now that we've created the data visualizations, we can organize the visualizations onto a dashboard.

- Add a `Dashboard` sheet

  - Notice that instead of seeing your data on the left-hand side, you now see the data visualizations you have created. 

- Add your `Total Water Use, 2000` map to the dashboard by dragging it over. 

- Add in the `Pie Chart` and the `State Water Use` charts.

  - Notice you can undock and delete some of the legends.
  - You can also change legends from full lists to drop down menus.

- Rearrange these three plots however you would like.

- Notice that the Map and the State Water Use bar charts could be <u>linked together by state.</u>
  - Click on the state map. Click on the bottom arrow and click `use as filter`.
    - Click on a state. What happens to the bar chart and the pie chart?
      - Why does the bar chart not seem to work correctly?
        - Go to the `State Bar` worksheet and turn off the `Top 10 filter`. 
      - Now try selecting multiple states.
- Save the workbook


  - Sometimes you will get an error saying it failed to saved the workbook. Click `open from Tableau Public`. This will let you sign in and you will see an older version of your workbook. Close that and then try to save your workbook again.

![Dashboard](tableau/WaterUse_Dashboard.png)



### Storyboards

A storyboard allows you to merge together multiple dashboards or charts to progressively lead a reader through a process of understanding their data.

Storyboard is similar to the dashboard, except you can also include dashboards. Each caption box at the top represents an html page. Arrange your plots and captions, add text, and tell a story about the data. Here's one example:



![Story board](tableau/Storyboard.png)



------





# Bringing it all together

## ♦ Water Quality Data

### Question

In North Carolina, both Falls Lake and Jordan Lake have experienced high nutrient concentrations. A series of rules have been passed with the goal of reducing nutrient loads by setting annual loads on the amount of Nitrogen (and Phosphorus) that are allowed to enter the lake annually. We want to know how successful these rules have been at reducing Nitrogen loads into Jordan Lake. The rules set for Jordan Lake set two different targets based on the arm of the lake.

- **Upper New Hope**: 641,021 pounds of Nitrogen per year
- **Haw River**: 2,567,000 pounds of Nitrogen per year.

![Jordan Lake](tableau/JordanLake.jpg)

Finding data on nutrient levels and thresholds can be challenging. I found the following sources. You may find many more.

- <https://www.epa.gov/nutrient-policy-data/progress-towards-adopting-total-nitrogen-and-total-phosphorus-numeric-water>
- <https://www.epa.gov/sites/production/files/2014-12/documents/nc-classifications-wqs.pdf>
- <https://deq.nc.gov/nc-stdstable-09222017>
- <http://www.orangecountync.gov/document_center/PlanningInspections/Fallsrulesfactsheet.pdf>



### Obtaining the data

To answer this question, you need to find water quality information. The National Water Quality Monitoring Council has a Water Quality Portal (WQP) that uses Water Quality Exchange (WQX) standards to integrate publicly available water quality data from USGS NWIS, EPA STORET, and the USDS STEWARDS databases. Other data are included from state, federal, tribal, and local agencies. It's a great starting point for water quality data.

![Water Quality Portal](tableau/WQP national results.png)



- Go to the national water quality data portal: https://www.waterqualitydata.us/portal/

  - Notice that you can search for data based on location, parameters, characteristics, etc. This can be overwhelming if you aren't a water quality expert. The best way to start is by filtering. We know we want the nitrogen loads entering Jordan Lake so lets filter by location and select those sites upstream of Jordan Lake. To do this we need to know the basin code (HUC).

    - There is a beta version being tested that allows you to click a point on the map and it will trace upstream (or downstream) and grab all the data upstream (can also filter in the above drop-down boxes). To learn more about this, search `Network Linked Data Index, NLDI`.

      ![Water Quality Portal](tableau/NLDI_Beta.png)

      - It's good to know how to find your basin though so we will search the old-fashioned way.

        ​

  - Take a moment to see if you can figure out what HUC8 Jordan Lake belongs to. What are some of the sources you looked at?

    - One spot that I looked for was the NC Department of Natural Resources website. They have put together an arcgis platform to facilitate data sharing.

      - http://data-ncdenr.opendata.arcgis.com/

      - From this website, I found Jordan Lake belonged to the Haw sub-basin: `03030002`

        ![Haw](tableau/HawHUC.png)



#### Download the Data

- We know we want to download nitrogen data and that nitrogen is a nutrient. How would you narrow down the number of sites?

  - State: `North Carolina`
  - Site Type: `Lake, Reservoir, Impoundment and Stream`
  - HUC: `03030002`
  - Sample Media: `Water`
  - Characteristic Group: `Nutrient`
  - Date Range: `01-01-1970`, `12-31-2017`
  - Minimum results per site: `500`

- **Make sure to keep notes of your download selections for replication purposes**

- Click `Show sites on map`

  - When I ran this in January I found 91 sites

    Download the sites data as a comma separated file

- Download the Sample Results (physical/chemical metadata) as a csv

  - We download this as a CSV because we need to do some cleaning first and with large data files it is easier to do that in a scripting environment (such as R or Python).

------



## Exploratory Data Analysis in R

Go to the `TotalNitrogen.Rmd` file to follow along with how we are going to clean the data and prepare it for visualization. Data exploration can also help us better understand the underlying data and the story we wish to tell with the data.

##### Data Cleaning

Some of the things you might want to do to clean the data include:

- Load in the site data and plot a map to see where water quality data were present from this portal.
- Load in the results data and do some cleaning:
  - We want to make sure we are using routine samples and not extreme event sampling (biased for specific occasions and not for estimating annual average load).
  - Determine what type of Nitrogen we want to use. From the literature we found that regulations for Nitrogen include: nitrate, nitrite, ammonia and organic forms. Doing some reading about the WQX standards, you learn that `Nitrogen, mixed froms` incorporates all of the above forms of nitrogen. Filter the data to only include those results.
- We also want to make sure we are looking at total Nitrogen, so make sure the Results Sample Fraction Text only includes those with `Total`.
- Detection Limits and Measurement Units
  - You may have noticed that many sample sites state “not detected”. This is important data that are not currently being represented. Create a new column and set the value equal to the results, unless it is below the detection limit – in which case set it equal to ½ of the detection limit.
  - You may also have noted that the total nitrogen was sometimes reported as `mg/l` or `mg/l NO3`. We want `mg/l`. Convert `mg/l NO3` `to mg/l`
    - The atomic weight of nitrogen is 14.0067 and the molar mass of the nitrate anion(NO3) is 62.0049 g/mole. Therefore to convert Nitrate-NO3 to Nitrate-N:
      - `Nitrate-N(mg/L) = (14.0067/62.0049)*Nitrate-NO3 (mg/l)`



##### Data Exploration

Refer to the `TotalNitrogen.Rmd` for ways that we chose to explore the data. Feel free to create your own exploratory analysis.



##### Calculating Annual Load to Compare with Thresholds

Now let’s look at how the Haw River and New HopeRiver thresholds are doing. The water quality data reports Nitrogen as mg/l. Inorder to convert to an annual load (lbs/yr), we need to know the volume ofwater flowing through each site. Go to the NWIS Mapper to find which USGSgauges are closest to:

* USGS-0209699999 (Haw River Arm)
* USGS-0209768310 (New Hope Arm)

![NWIS data](tableau/NWISDownloads.png)

**Figure: **NWIS mapper USGS gauges near water quality monitoring sites. The red circle is the
gauge of interest for the Haw River Branch. The blue circles are the gauges of interest for New Hope Creek.



For specific details, refer to `TotalNitrogen.Rmd`

- Use `readNWISdv` to download the daily discharge for the Haw River.
- Plot the USGS site and the water quality site together to see how close they are and if any major tributaries intersect between them.
- Convert flow to MGD and calculate the total annual flow.
- Calculate the average annual nitrate (mg/l).
- Merge the annual discharge and nitrate load together. Calculate the pounds of nitrate per year based on the flow (rough estimate).
  - Pounds = Annual Flow * Average N * lbspergal (water is 8.34 pounds per gallon)



- Repeat this process for the Upper New Hope Creek. 
  - Take the sum of the flow for all three sites over a year.
  -  Notice that the lbs are far below the threshold.Why might that be?
    - The drainage area for Jordan lake is 1689 mi2
    - The Haw River site accounted for 1,275 mi2
    - The three sites on for New Hope Creek accounted for 76.9, 21.2, and 41 mi2
  - The downstream site on the right accounts for 12mi2
  - This leaves 402 mi2 unaccounted for
- Let’s assume that 75% of this is being missed and should be included in the analysis. Adjust the pounds accordingly and plot both on the graph.



Write files out in csv to be loaded into RShiny, Python, Javascript, or Tableau….

------



## Visualize Data in Tableau

Now that you know a little about how Tableau works - create a story board for water quality data in the Jordan Lake. Be as creative as you'd like. Below is one possibility:

[Nitrogen Flowing into Jordan Lake](https://public.tableau.com/profile/lauren3839#!/vizhome/Unit3-Nitrogen/Story1?publish=yes)

