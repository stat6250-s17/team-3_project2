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
'Research Question: How do the top 30 school areas of California in total graduate students compare to their dropout student numbers.'
;

title2
'Rationale:  It would be intriguing to see if the areas with the highest number of graduates would also be among the highest number of dropouts.'
;

footnote1
'Though it is not entirely clear, each county or school district total has about a 20-30% dropout rate when compared to total graduates.'
;

footnote2
'The county/school district with the highest number of graduates, Los Angeles county, has about a 30% dropout rate.'
;

*
Note:  This experiment will test the columns "D9", "D10", "D11", and "D12" and
will be compared to "GRADS" (only School Districts and Counties will be
compared).

Methodology:  Use PROC SORT on the "GRADS" column, then use PROC PRINT to
compare the number of graduates of the top 30 school districts/counties to
their number of dropouts.

Limitations: Due to School Districts and Counties having more students than an
individual school, we can't really answer this question when comparing schools
unless we delete the district and county rows.

Followup Steps:  Maybe use the total number of dropout students per school and
compare to the total number graduated.
;

proc print data=Graduates_analytic_file_MC1(obs=31);
	var County District School D9 D10 D11 D12 Grads;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question:  What are the top four school districts that have the highest percentage of graduate students?'
;

title2
'Rationale: Knowing which areas of California succeed the highest in education is a major factor to be looked at because it can determine what school district parents would want to send their children to school at.  Though each school within a district is different, indicating the school district that has the hihest graduataion rate is what will be looked at by parents as well as the California department of education.'
;

footnote1
'Palos Verdes Peninsula Unified and Poway Unified had the highest gradrate of all school districts in California at 99.8%.'
;

footnote2
'Acalanes and Capistrano are the other school districts among the top four highest gradrates.'
;
*
Note:  This will be looking at the "GRADRATES" column from the data set.

Methodology:  Use PROC SORT on the "GRADRATES" column, then use PROC PRINT to
examine the four school districts with the highest graduation rate percentage.

Limitations: Since the total school district data is combined with the
individual schools, it may be difficult to properly read the different
percentages from the districts.

Followup Steps: Separate the school district rows from the individual schools
so that the new data can be properly read.
;

proc print data=Graduates_analytic_file_MC2(obs=4);
		var District Gradrate;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'How do the top 10 counties with the highest number of graduates compare to their graduation rate percentage and how does it compare to the overall graduation percentage in California.'
;

title2
'Rationale: It should be interesting to see whether the schools with the highest number of graduates are at the top of list because of their graduation rate, or if it is just because they have a much larger number of students.'
;

footnote1
'Orange county has the highest gradrate among the top 10 schools in terms of graduates at 87.5%.  Fresno county has the lowest at 70.4%.'
;

footnote2
'It appears as though all of the gradrates for the top counties have a relatviely similar percentage to the state percentage of 80.5%.'
;

footnote3
'Observation 4, Los Angeles, represents the district data and not the county data.'
;

*
Note:  We will use the "GRADS" and "GRADRATE" columns in the dataset and
compare to the "COUNTY" column.

Methodology: Use PROC SORT on the "GRADS" column, then use PROC PRINT to
compare the counties with the top graduate students to their grad rate.

Limitations: Since we can not easily separate the other rows from the county
rows, there may be a school district or two on the list, which would have to be
ignored for this question.

Followup Steps: Perhaps using this method on the top individual schools instead
of the counties to get a more specific analysis.
;

proc print data=Graduates_analytic_file_MC3(obs=12);
		var County Grads Gradrate;
run;

title;
footnote;
