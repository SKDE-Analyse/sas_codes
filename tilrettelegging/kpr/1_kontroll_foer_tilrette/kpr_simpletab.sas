﻿%macro simpletab;
PROC TABULATE
DATA=&data;	
	CLASS aar &var /	ORDER=UNFORMATTED MISSING;
	TABLE 
	/* Row Dimension */
	&var all, 
	/* Column Dimension */
	(N*f=nlnum10. colpctn*f=8.) * aar ;				
RUN;
%mend;