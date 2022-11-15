
%macro antall_pasienter_rader(inndata=);
title color=darkblue height=5 '1: antall pasienter og rader: sjekk mot utleveringsinfo';
proc sql;  
select 	count(distinct lopenr)  	as pasienter, 
		count(*) 					as rader
from &inndata;
quit;
%mend antall_pasienter_rader;

