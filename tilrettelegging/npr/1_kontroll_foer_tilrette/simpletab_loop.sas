/* Selecting all the variables from a dataset and run tabulate on the vars; */

/* code in a sas project to create a list of variables before running the macro */

/*************************************

* create a dataset with variables names ;
proc contents data=&avd1 noprint out=varlist(where=(type=1) keep=name type); run;

proc sql;
  create table varlist as
  select name
  from varlist;
quit;

* remove variables that we don't want to tabulate on ;
data varlist;
  set varlist;
    if upcase(name) in ('I', '_TYPE_','_FREQ_',
                        'LOPENR','AAR') 
    then delete;
    label name=' ';
run;

 
* create a global macro variable (called vars) with the list of variable names ;
proc sql noprint;
    select name into :vars separated by ' '
    from varlist;
quit;

%put &vars;

* combine all years into the same table so that we can tabulate by year and see the changes over time ;
data tabdata;
  set &avd1 (keep=aar &vars)
      &avd2 (keep=aar &vars)
      &avd3 (keep=aar &vars)
      &avd4 (keep=aar &vars)
      &avd5 (keep=aar &vars);
run;

%let tabdata=tabdata;
*******************************************/

%macro simpletab_loop(utxls=);

*initialize the pointer for the variable list;
%let i=1;
%let tabvar=%scan(&vars, &i);
ods excel file="&utbane\&utxls..xlsx"  options(sheet_name="&tabvar");

*loop through the NUMERIC variables to create tabulate;
%do %until(&tabvar.=);

  ods excel  options(sheet_name="&tabvar");
  /* run the tabulate macro */
    %simpletab(dsn=&tabdata, var=&tabvar);

  /* increase counter by one and reassign tabvar to the next variable on the list */
    %let i = %eval(&i+1);
    %let tabvar=%scan(&vars, &i);

%end;

*proc freq on the STRING variables;
ods excel options(sheet_name="string");
proc freq data=&tabdata;
  tables episodefag fagomrade / missing;
run;

ods excel close;

%mend;


