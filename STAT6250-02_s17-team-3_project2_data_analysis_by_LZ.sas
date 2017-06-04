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
title1
'Research Question: Did the total number of Hispanic graduates increase from AY2013-2014 to AY2014-2015?'
;

title2
'Rationale: Hispanic graduates forms a large proportion of the total number of graduates. Therefore, it’s necessary to compare Hispanic student’s changing graduation rate.'
;

footnote1
‘Academic year 2014-2015 have more Hispanic graduates than academic year 2013-2014.’
;

footnote2
‘The amount of Hispanic graduate is increasing year by year.’
;

Note: This compares the column "HISPANIC" from Grads1314 to the column of the same name from Grads1415.

Methodology: Merge two datasets and use RENAME= option to rename the column “HISPANIC” from dataset Grads1415 as HISPANIC1415. After that, use proc means to get the sum for the columns "HISPANIC" and “HISPANIC1415”. Then compare numbers. 

Limitations: None

Followup Steps: Possibly use other methods instead of using RENAME= option.
;

data Grads1314Grads1415; 
        merge Grads1314 Grads1415(rename=(HISPANIC=HISPANIC1415))
    ;
    id
        CDS_CODE
    ;
run;

proc means 
        data=Graduates_analytic_file
        sum
    ;
    id
        CDS_CODE
    ;
    var
        HISPANIC HISPANIC1415
    ;
run;

title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
title1
'Research Question: Which race/ethnic students has the most graduates in AY2014-2015?'
;

title2
'Rationale: This would help identify recent year’s highest graduation rate by ethnicity.'
;

footnote1
‘Hispanic has the most graduates in academic year 2013-2014.’
;

footnote2
‘White students ranked second.’
;

footnote3
‘Pacific island has the least graduates in academic year 2014-2015.’
;

Note: This compares the column "HISPANIC", “AM_IND”, “ASIAN”, PAC_ISLD”, FILIPINO”, “AFRICAN_AM”, and” WHITE” from Grads1415.

Methodology: Use proc means to get the sum for the columns "HISPANIC", “AM_IND”, “ASIAN”, PAC_ISLD”, FILIPINO”, “AFRICAN_AM”, and” WHITE”. Then compare which one has the most graduates.

Limitations: None

Followup Steps: Compare the number with AY2013-2014.
;

proc means 
        data=Graduates_analytic_file
        sum
    ;
    id
        CDS_CODE
    ;
    var
        HISPANIC AM_IND ASIAN PAC_ISLD FILIPINO AFRICAN_AM WHITE
    ;
run;

title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
title1
'Research Question: What are the top three districts have the most graduates？'
;

title2
'Rationale: This would help identify which district is more welcome or which district has higher education level.'
;

footnote1
‘Los Angeles Unified, San Diego Unified, and Kern Union High are the top three districts have the most graduates.’
;

footnote2
‘Los Angeles Unified has more than 30,000 graduates which is significantly higher than other districts.’
;

footnote3
‘Both San Diego Unified and Kern Union High have more than 7,500 graduates.’
;

Note: This compare each dictrict's total graduates from GradRates.

Methodology: Use proc sort by descending to get districts with most graduates. After that, use proc print to display first three rows for the GRADS column. Then compare the numbers. 

Limitations: None

Followup Steps: Possibly get the sum of graduates for each district then compare. 
;

proc print 
        data=Graduates_analytic_file(obs=3)
    ;
    id 
        CDS_CODE
    ;
    var 
        DISTRICT GRADS;
    ;
run;

title;
footnote;



