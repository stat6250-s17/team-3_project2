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
Question: Did the total number of Hispanic graduates increase from AY2013-2014 to AY2014-2015?

Rationale:Hispanic graduates forms a large proportion of the total number of graduates. Therefore, it’s necessary to compare Hispanic student’s changing graduation rate. 

Note:

Methodology: 

Limitations: 

Followup Steps: 


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which race/ethnic students has the most graduates in AY2014-2015?

Rationale: This would help identify recent year’s highest graduation rate by ethnicity.

Note:

Methodology: 

Limitations: 

Followup Steps: 


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top ten districts have the most graduates？

Rationale: This would help identify which district is more welcome or which district has higher education level.  

Note:

Methodology: 

Limitations: 

Followup Steps: 


