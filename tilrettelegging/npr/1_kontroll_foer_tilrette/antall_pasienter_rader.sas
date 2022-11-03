
%macro antall_pasienter_rader(inndata=, pasid =);
title color=darkblue height=5 '1: antall pasienter og rader: sjekk mot utleveringsinfo';
proc sql;  
select 	count(distinct &pasid.)  	as pasienter, 
		count(*) 					as rader
from &inndata;
quit;
%mend antall_pasienter_rader;

