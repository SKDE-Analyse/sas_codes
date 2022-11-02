%macro doubletab;
PROC TABULATE
DATA=&data;	
	CLASS aar &var3 &var4 /	ORDER=UNFORMATTED MISSING;
	TABLE 
	/* Row Dimension */
	(&var3*&var4) all,

	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar;
RUN;
%mend;