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
%let inputDataset1URL =
https://github.com/stat6250/team-3_project2/blob/master/data/Grads1314.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = Grads1314_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-3_project2/blob/master/data/Grads1415.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = Grads1415_raw;

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

* combine Grads1314 and Grads1415 data vertically and convert CDS_Code column to character;

data Grads1315_Vert;
    retain
        CDS_CODE
    ;
    length
        CDS_CODE $14.
    ;
    set
        Grads1314_raw_sorted(rename=(CDS_Code=CDS_Codenum))
        Grads1415_raw_sorted(rename=(CDS_Code=CDS_Codenum))
	;
	CDS_Code=put(CDS_Codenum, z14.)
	;
	drop CDS_Codenum
    ;
run;

* Sort Grads1315_Vert by CDS_Code;

proc sort
        nodupkey
        data=Grads1315_Vert
        dupout=Grads1315_vert_dups
        out=Grads1315_Vert_sorted
    ;
    by
        CDS_CODE
    ;
run;
* Convert CDS_Code column to character for Gradrates_raw_sorted;

data Gradrates_raw_sorted;
retain
        CDS_CODE
    ;
    length
        CDS_CODE $14.
    ;
    set
        Gradrates_raw_sorted(rename=(CDS_Code=CDS_Codenum))
	;
	CDS_Code=put(CDS_Codenum, z14.)
	;
	drop CDS_Codenum
    ;
run;
	
* build analytic dataset from raw datasets to address research questions in
corresponding data-analysis files;

data Graduates_analytic_file;
    retain
        CDS_CODE
        COUNTY
        DISTRICT
        SCHOOL
        HISPANIC
        AM_IND
        ASIAN
        PAC_ISLD
        FILIPINO
        AFRICAN_AM
        WHITE
        TWO_MORE_RACES
        NOT_REPORTED
        TOTAL
        D9
        D10
        D11
        D12
        GRADS
        GRADRATE
    ;
    keep
        CDS_CODE
        COUNTY
        DISTRICT
        SCHOOL
        HISPANIC
        AM_IND
        ASIAN
        PAC_ISLD
        FILIPINO
        AFRICAN_AM
        WHITE
        TWO_MORE_RACES
        NOT_REPORTED
        TOTAL
        D9
        D10
        D11
        D12
        GRADS
        GRADRATE
    ;
    merge
        Grads1315_Vert_sorted
        GradRates_raw_sorted
    ;
    by
        CDS_Code
    ;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How many graduates per school are there when sorted by ethnicity and how do they compare to the total number of students per school.'
;

title2
'Rationale:  Being that California is very diverse, it would interesting to see the proportion of graduates by their ethnicity .'
;

footnote1
'Hispanics had by far the highest average of graduates at 78.11 per school, nearly half as much as the total number of students.'
;

footnote2
'White is a distant second at 46.15, while Asians and African Americans are well below at 15.86 and 9.99 respectively.'
;
*
Note:  This experiment will test the columns "Hispanic", "Asian", "African
American", "White",  and "Total".

Methodology:  Use PROC MEANS to calculate the total number of graduates per
school by ethnicity along with total students.  Then, make comparisons and draw
conclusions from the results.

Limitations: The other ethnic groups have too few students in California to
make a valid conclusion compared to the four that are, so they would have to
be omitted for this purpose.  Also, certain schools have too few students as
well, so the actual number of graduates per school is skewed.

Followup Steps:  Perhaps analyzing the percentage of graduates among the ethnic
groups so that all ethnicities are fairly represented.
;

proc means data=Graduates_analytic_file;
	var Hispanic Asian African_Am White Total;
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

proc sort data=Graduates_analytic_file;
	by descending Gradrate;
run;

proc print data=Graduates_analytic_file(obs=4);
	var CDS_CODE District Gradrate;
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

proc sort data=Graduates_analytic_file;
	by descending Grads;
run;

proc print data=Graduates_analytic_file(obs=12);
	var County Grads Gradrate;
run;
