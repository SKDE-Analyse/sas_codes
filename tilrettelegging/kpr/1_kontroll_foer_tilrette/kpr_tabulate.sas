%macro simpletab;
PROC TABULATE
DATA=&data;	
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var /	ORDER=UNFORMATTED MISSING;

	TABLE 
	/* Row Dimension */
	&var all, 
	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar ;				
RUN;
%mend;

%macro missing_string;
proc tabulate
data=&data(where=(&var eq " "));
CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var1 /	ORDER=UNFORMATTED MISSING;
	TABLE 
	/* Row Dimension */
	&var1 all, 
	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar ;				
RUN;
%mend;

%macro doubletab;
PROC TABULATE
DATA=&data;	
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	CLASS &var3 &var4 /	ORDER=UNFORMATTED MISSING;
	TABLE 
	/* Row Dimension */
	(&var3*&var4) all,

	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar;
RUN;
%mend;