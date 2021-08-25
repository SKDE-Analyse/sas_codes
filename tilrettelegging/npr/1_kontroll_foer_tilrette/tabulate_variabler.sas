/* create frequency table for a variable */
%macro simpletab(dsn=, var=);
options locale=NB_no;

PROC TABULATE
DATA=&dsn;	
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var /	ORDER=UNFORMATTED MISSING;

	TABLE 
	/* Row Dimension */
	&var all, 
	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar ;				
RUN;
%mend;


/* create frequency table for 2 variables, for example komnr/bydel */
%macro doubletab(dsn=, var1=, var2=);
ods excel options(sheet_name="&var1. - &var2.");
PROC TABULATE
DATA=&dsn;	
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var1 &var2 /	ORDER=UNFORMATTED MISSING;
	TABLE 
	/* Row Dimension */
	(&var1*&var2) all,

	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar;
RUN;
%mend;