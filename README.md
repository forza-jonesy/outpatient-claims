
![RibbonLarge](Documentation/RibbonLarge.png)

# OUTPATIENT CLAIMS BENEFICIARIES CMS PUBLIC DATA

### **Introduction**
Demo data analysis and Tableau Dashboard for CMS public data.
Using SQL, Alteryx, Tableau, CSS. <br/>
CMS Data Manual
https://www.cms.gov/data-research/statistics-trends-and-reports/medicare-claims-synthetic-public-use-files



## **DATA**
1. Datasource 1: Out Patient Claim Sample
2. Datasource 2: Beneficiary Summary File
Locations of datasources at Documentation/Technical Skills Interview Task.xlsx


## **STEPS**

### **1. Outpatient Claims**
 * Ingested using alteryx, visually inspected column names and data missingness. Removed cols that are completely null, white spaces. 
 * Removed blank providersChanged yyyymmdd to date in sql for the one OPC i ingested into MSSQL Server. 
 * Used CTEs and partitions to find countd member per provider/disease combination (PPDC), sum paid amt PPDC, sum paid amt for amt for a provider this can be used to speed up tableau workbook where aggregation is not needed. eg boxplot.
 * Inner joined to Benefit summary to get disease combination concatenated along with race, age etc. 3 dupes only so there is no multiplication of data. ignored the 3 dupes.
 * Excluded Provider blanks

### **2. Beneficiary Summary**
* Ingested using alteryx, visually inspected column names and data missingness. Removed cols that are completely null, white spaces etc. 
* recoded 1 yes to 1 and 2 no to 0
* Joined to OPC
* Created unpivot of Benefit table to get list of members and their diseases. didnt do anything further with it
* Excluded Provider blanks

### **3. Tableau**
* Used inner joined table to make Outpatient_BS_Reporting and used this for tableau reporting
* used company website to copy colours and fonts and downloaded similar fonts where couldnt find them using webpage inspect html, used https://coolors.co/generate to create a palette for tableau
* added palette to My Tableau Repository, and shapes with palette
* assumed race codes w/o reading the manual in too much detail

### **4. Alteryx**
* Simple ingestion of 2 csv files into mssql server database

### **5. Documentation**
* Contains ppt document with notes
* Contains all images and gifs used
* Contains some basic notes in excel

## Examples
Item | Description | 
------------ | ------------- | 
![sampledash](Documentation/sampledash.png)|Here is an example of a dashboard using the Demo colour palette|
![tableaudash](Documentation/tableaudash.PNG)|Tableau public dashbord example of multiple chronic diseases with fonts and colour palette and parameter to change date breakdown|
![tableaudash1](Documentation/tableaudash1.gif)|Info button and functionality|
![fulldashboard](Documentation/FullDashboard.PNG)| Screenshot of full dashboard|


### **6. More Analysis in future**

* Correlation type matrix for paired disease combinations
* Add variance from avg NPI + Disease Combination to single NPI cost PM
* Investigate blank data better
* Investigate gender, state, age wrt cost PM
* Are providers skewed to certain demographics? appy a weighting factor to avg cost per NPI (Q8), similar to what stors do for skewed plans.
