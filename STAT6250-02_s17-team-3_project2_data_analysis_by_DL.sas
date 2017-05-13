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
Question: 
Rationale:
Note: This compares the column "Percent (%) Eligible Free (K-12)" from frpm1415
to the column of the same name from frpm1516.
Methodology: When combining frpm1415 with frpm1516 during data preparation,
take the difference of values of "Percent (%) Eligible Free (K-12)" for each
school and create a new variable called frpm_rate_change_2014_to_2015. Here,
use proc sort to create a temporary sorted table in descending by
frpm_rate_change_2014_to_2015 and then proc print to display the first five
rows of the sorted dataset.
Limitations: 
Followup Steps: 
;

proc sort
        data=cde_2014_analytic_file
        out=cde_2014_analytic_file_sorted
    ;
    by descending frpm_rate_change_2014_to_2015;
run;

proc print data=cde_2014_analytic_file_sorted(obs=5);
    id School_Name;
    var frpm_rate_change_2014_to_2015;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: 
Rationale: 
Note: This compares the column "Percent (%) Eligible Free (K-12)" from frpm1415
to the column PCTGE1500 from sat15.
Methodology: Use proc means to compute 5-number summaries of "Percent (%)
Eligible Free (K-12)" and PCTGE1500. Then use proc format to create formats
that bin both columns with respect to the proc means output. Then use proc freq
to create a cross-tab of the two variables with respect to the created formats.
Limitations:
Followup Steps:
;

proc means min q1 median q3 max data=cde_2014_analytic_file;
    var
        Percent_Eligible_FRPM_K12
        PCTGE1500
    ;
run;
proc format;
    value Percent_Eligible_FRPM_K12_bins
        low-<.39="Q1 FRPM"
        .39-<.69="Q2 FRPM"
        .69-<.86="Q3 FRPM"
        .86-high="Q4 FRPM"
    ;
    value PCTGE1500_bins
        low-20="Q1 SAT_Scores_GE_1500"
        20-<37="Q2 SAT_Scores_GE_1500"
        37-<56.3="Q3 SAT_Scores_GE_1500"
        56.3-high="Q4 SAT_Scores_GE_1500"
    ;
run;
proc freq data=cde_2014_analytic_file;
    table
             Percent_Eligible_FRPM_K12
            *PCTGE1500
            / missing norow nocol nopercent
    ;
        where not(missing(PCTGE1500))
    ;
    format
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
        PCTGE1500 PCTGE1500_bins.
    ;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: 
Rationale: 
Note: This compares the column NUMTSTTAKR from sat15 to the column TOTAL from
gradaf15.
Methodology: When combining sat15 and gradaf15 during data preparation, take
the difference between NUMTSTTAKR in sat15 and TOTAL in gradaf15 for each
school and create a new variable called excess_sat_takers. Here, use proc sort
to create a temporary sorted table in descending by excess_sat_takers and then
proc print to display the first 10 rows of the sorted dataset.
Limitations: 
Followup Steps: 
;

proc sort
        data=cde_2014_analytic_file
        out=cde_2014_analytic_file_sorted
    ;
    by descending excess_sat_takers;
run;

proc print data=cde_2014_analytic_file_sorted(obs=10);
    id School_Name;
    var excess_sat_takers;
run;
