*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding graduation numbers and rates for various California High
Schools
Dataset Name: Graduates_analytic_file created in external file
STAT6250-02_s17-team-3_project2_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset cde_2014_analytic_file;
%include '.\STAT6250-02_s17-team-3_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which ethnic group had the highest increase in their number of graduate students between 2014 to 2015?'
;

title2
'Rationale:It is important to know that every ethnicity graduates at the same, consistent rate, so finding out an increase to one ethnic group would be crucial to know.'
;

footnote1
'Hispanics had by far the highest increase in graduate students from the two years measured in California.'
;

footnote2
'White and African Americans had a slight increase in graduates, while Asians actually had a decrease.'
;
*
Note:  This experiment will test the columns "Hispanic", "Asian", "African
American", and "White" from Grad13-14 and Grad 14-15.

Methodology:  Use PROC PRINT for both datasets while using the SUM statement to
calculate the totals of each column.  Then combine the GradRates14 and
GradRates 15 files, and then take the difference of the alike columns from the
two datsets before drawing conclusions.

Limitations: The other ethnic groups have too few students in California to
make a valid conclusion compared to the four that are, so they would have to
be omitted for this purpose.

Followup Steps:  Perhaps analyzing the percentage of graduate increase among
the ethnic groups so that all ethnicities are fairly represented.
;

proc print data=Grads1314_raw;
var CDS_CODE Hispanic Asian African_American White;
sum Hispanic Asian African_American White;
run;

proc print data=Grads1415_raw;
var CDS_CODE Hispanic Asian African_American White;
sum Hispanic Asian African_American White;
run;

proc sort data=Total_Graduates_analytic_file;
by difference;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question:  What are the top five school districts that have the highest percentage of graduate students?'
;

title2
'Rationale: Knowing which areas of California succeed the highest in education is a major factor to be looked at because it can determine where parents would want to send their children to school at.'
;

footnote1
'Palos Verdes Peninsula Unified and Poway Unified had the highest gradrate of all school districts in California at 99.8%.'
;

footnote2
'Acalanes, Capistrano, and San Ramon Valley are the other school districts among the top five highest gradrates.'
;
*
Note:  This will be looking at the "GRADRATES" column from the GradRates data
file.

Methodology:  Use PROC SORT on the "GRADRATES" column, then examine the five
school districts with the highest graduation rate percentage.

Limitations: Since the total school district data is combined with the
individual schools, it may be difficult to properly read the percentages from
the districts.

Followup Steps: Separate the school district rows from the individual schools
so that the new data can be properly read.
;

proc sort data=Graduates_analytic_file;
by descending Gradrates;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which school had the highest increase number of graduate students between 2014 to 2015?'
;

title2
'Rationale: Being the school with the highest graduate increase in in the state in terms of graduating is a remarkable achievement in any case, so that school deserves to be figured out and recognized.'
; 

footnote1
'Paramount High had the highest increase at over 1000 students, about 200 more than the next highest increase.'
;

footnote2
'Interesting to note that Paramount had just 3 graduates in 13-14 as opposed to 1053 the following year.'
;
*
Note:  We will use the "TOTAL" column for the Grads13-14 and Grads14-15.

Methodology: Combine the GradRates14 and GradRates 15 files, then take the
difference from the "TOTAL" columns in the two datasets and place them in a new
variable.  Then, use PROC SORT to arrange the differences in order and then use
PROC PRINT to display the results before drawing conclusions.

Limitations: As with question 1, smaller schools have a less likely chance of
being recognized for their increase in graduates even if their number
doubles from the previous year.

Followup Steps: Create a column for percentage increase per school.  Then, draw
comparisons from both the "percentage" and "total" columns to have a more accurate analysis.
;

proc sort data=Total_Graduates_analytic_file;
by difference;
run;

proc print data=Total_Graduates_analytic_file;
run;
