/* create frequency table for a variable */
%macro simpletab(dsn=, var=);
PROC TABULATE
DATA=&dsn;	
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
&var*N 
ALL={LABEL="Total (ALL)"}*N

&var*colpctn*f=8.
ALL={LABEL="Total (ALL)"}* colpctn*f=8.,
/* Column Dimension */
aar;
RUN;
%mend;


/* create frequency table for 2 variables, for example komnr/bydel */
%macro doubletab(dsn=, var1=, var2=);
PROC TABULATE
DATA=&dsn;	
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var1 &var2 /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
(&var1*&var2) *N,
/* Column Dimension */
aar;
RUN;
%mend;