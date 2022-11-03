%macro min_maks_dato(inndata=);
title color=darkblue height=5 '2: min og maks: år, inn- og utdato';
proc sql;  
select 	min(aar) 					as minaar, 
		max(aar) 					as maxaar, 
		min(inndato) 				as mininn format yymmdd10., 
		max(inndato) 				as maxinn format yymmdd10.,
		min(utdato) 				as minut  format yymmdd10., 
		max(utdato) 				as maxut  format yymmdd10.
from &inndata;
quit;

%mend min_maks_dato;

