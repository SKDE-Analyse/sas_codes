*Selecting all the variables from a dataset and run tabulate on the vars;

/* This is copied to the sas project as one of the programs, rather than used as a macro */

/* create a dataset with variables names */
proc contents data=&avd1 noprint out=varlist(where=(type=1) keep=name type); run;

proc sql;
  create table varlist as
  select name
  from varlist;
quit;

/* remove variables that we don't want to tabulate on */
data varlist;
  set varlist;
    if upcase(name) in ('I', '_TYPE_','_FREQ_',
                        'LOPENR','AAR') 
    then delete;
    label name=' ';
run;

 
/* create a global macro variable (called vars) with the list of variable names */
proc sql noprint;
    select name into :vars separated by ' '
    from varlist;
quit;

%put &vars;


%macro looptab;
*initialize the pointer for the variable list;
%let i=1;
%let tabvar=%scan(&vars, &i);
%put &tabvar;

*loop through the variables to create tabulate;
%do %until(&tabvar.=);

%if &i > 1 %then %do;
proc datasets library=work;
  delete tabdata;
run;
%end;

/* combine all years into the same table so that we can tabulate by year and see the changes over time */
data tabdata;
  set &avd1 (keep=aar &tabvar)
      &avd2 (keep=aar &tabvar)
      &avd3 (keep=aar &tabvar)
      &avd4 (keep=aar &tabvar)
      &avd5 (keep=aar &tabvar);
run;

/* run the tabulate macro */
  %simpletab(dsn=tabdata, var=&tabvar);

/* increase counter by one and reassign tabvar to the next variable on the list */
  %let i = %eval(&i+1);
  %let tabvar=%scan(&vars, &i);

%end;
%mend;

%looptab;

