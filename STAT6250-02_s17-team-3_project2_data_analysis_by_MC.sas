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

%let inputDataset3URL =
https://github.com/stat6250/team-3_project2/blob/master/data/GradRates.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = GradRates_raw;

* load raw datasets over the wire, if they don't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)

* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
  
proc sort
        nodupkey
        data=Grads1314_raw
        dupout=Grads1314_raw_dups
        out=Grads1314_raw_sorted
    ;
    by
        CDS_CODE
    ;
run;

proc sort
        nodupkey
        data=Grads1415_raw
        dupout=Grads1415_raw_dups
        out=Grads1415_raw_sorted
    ;
    by
        CDS_CODE
    ;
run;

proc sort
        nodupkey
        data=GradRates_raw
        dupout=GradRates_raw_dups
        out=GradRates_raw_sorted
    ;
    by
        CDS_CODE
    ;
run;


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
;

footnote2
;
*



;

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

run;

