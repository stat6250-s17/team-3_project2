*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] Grads1314

[Dataset Description] A dataset containing information for California high 
school graduates by racial/ethnic group and school for the school year 2013 – 
2014.

[Experimental Unit Description] High Schools within California

[Number of Observations] 2495

[Number of Features] 15

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=2013-14&cCat=GradEth&cPage=filesgrad.asp
I followed the link for the California Department of Education datasets and 
found this one for California high school graduate information. After 
downloading the text file, the information was copied and pasted into Excel 
for visualization.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsgrad09.asp

[Unique ID Schema] CDS_CODE, a 14-digit primary key that is a unique ID for a 
school within California

--

[Dataset 2 Name] Grads1415

[Dataset Description] A dataset containing information for California high 
school graduates by racial/ethnic group and school for the school year 2014 – 
2015.

[Experimental Unit Description] High Schools within California

[Number of Observations] 2490

[Number of Features] 15

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=2014-15&cCat=GradEth&cPage=filesgrad.asp
I followed the link for the California Department of Education datasets and 
found this one for California high school graduate information. After 
downloading the text file, the information was copied and pasted into Excel 
for visualization.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsgrad09.asp

[Unique ID Schema] CDS_CODE, a 14-digit primary key that is a unique ID for 
a school within California

--

[Dataset 3 Name] GradRates

[Dataset Description] A dataset containing information for graduate rates 
for high schools in California. This dataset also contains dropout 
information.

[Experimental Unit Description] High Schools within California

[Number of Observations] 7543

[Number of Features] 11

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=All&cYear=0910&cCat=NcesRate&cPage=filesncesrate
I followed the link for the California Department of Education datasets and 
found this one for California high school graduate rates. After 
downloading the text file, the information was copied and pasted into Excel 
for visualization.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsncesrate.asp

[Unique ID Schema] CDS_CODE, a 14-digit primary key that is a unique ID for a school within California

--

;

* setup environmental parameters;
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

*
Use PROC SORT to create a temporary sorted table in descending order by
Total and output the results to a temporary 
dataset which will be used as part of data analysis by DL.
;
 
proc sort
        data=Graduates_analytic_file
        out=Graduates_analytic_file_Total
    ;
    by 
        descending TOTAL;
run;

*
Use PROC SORT to create a temporary sorted table in descending order by
GRADRATE and output the results to a temporary dataset which will be 
used as part of data analysis by DL.
;
 
proc sort
        data=Graduates_analytic_file
        out=Graduates_analytic_file_GradRate
    ;
    by 
        descending GRADRATE;
run;
*
Use proc sort to create a temporary sorted table in descending GRADS which will be used as part of data analysis by LZ.
;

proc sort
        data=Graduates_analytic_file
		out=Graduates_analytic_file_GRADS
    ;
    by 
        descending GRADS;
run;

*
Methodology:  Use PROC SORT on the "GRADS" column, then use PROC PRINT to
compare the number of graduates of the top 30 school districts/counties to
their number of dropouts.
;

proc sort data=Graduates_analytic_file
				out=Graduates_analytic_file_MC1;
					by descending Grads;
run;

*
Methodology:  Use PROC SORT on the "GRADRATES" column, then use PROC PRINT to
examine the four school districts with the highest graduation rate percentage,
which will be done as part of data analysis by MC.
;

proc sort data=Graduates_analytic_file
			out=Graduates_analytic_file_MC2;
				by descending Gradrate;
run;

*
Methodology: Use PROC SORT on the "GRADS" column, then use PROC PRINT to
compare the counties with the top graduate students to their grad rate, which
will be done as part of data analysis by MC.
;

proc sort data=Graduates_analytic_file
			out=Graduates_analytic_file_MC3;
				by descending Grads;
run;
