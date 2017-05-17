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
*
Question: Which ethnic groups increased their number of graduate students between 2014 to 2015?
Rationale:It is important to know that every ethnicity graduates at the same, consistent rate, so finding out an increase to one ethnic group would be crucial to know.
Note:
Methodology: 
Limitations: 
Followup Steps: 
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question:  What are the top five school district have the highest percentage of graduate students?
Rationale: Knowing which areas of California succeed the highest in education is a major factor to be looked at because it can determine where parents would want to send their children to school at.
Note:
Methodology: 
Limitations: 
Followup Steps: 
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which school had the highest increase number of graduate students between 2014 to 2015?
Rationale: Being the school with the highest graduate increase in in the state in terms of graduating is a remarkable achievement in any case, so that school deserves to be figured out and recognized.  
Note:
Methodology: 
Limitations: 
Followup Steps: 
