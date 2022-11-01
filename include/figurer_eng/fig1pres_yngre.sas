/*
Årsvariasjonfigur 50-75 years old
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe"   ;

proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=4%);
* hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
* hbarparm category=bohf response=Snittrate / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde; 
 hbarparm category=bohf response=rateSnitt / fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
 hbarparm category=bohf response=Snittrate / fillattrs=(color=CXC3C3C3) barwidth=&soylebredde nooutline; 
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
	xaxis label=" Number per 1,000 inhabitants (50 - 74 years old)"   labelattrs=(color=black size=&fontst) &xskala offsetmin=0.02 valueattrs=(size=&fontst);

run;
ods listing close; ods graphics off;

