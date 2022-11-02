/*
Årsvariasjonfigur
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe";

proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=4%);
* hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
* hbarparm category=bohf response=Snittrate / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde; 
 hbarparm category=bohf response=rateSnitt / fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
 hbarparm category=bohf response=Snittrate / fillattrs=(color=CXC3C3C3) barwidth=&soylebredde nooutline; 
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
	xaxis label=" Number per 1,000 inhabitants ((*ESC*){unicode'2265'x}75 years old)"   labelattrs=(color=black size=&fontst) &xskala offsetmin=0.02 valueattrs=(size=&fontst);
/* 
 inset 
		(
	 	"(*ESC*){unicode'25cf'x}"="   2013"
	 	"(*ESC*){unicode'25a0'x}"="   2014"
	 	"(*ESC*){unicode'2666'x}"="   2015")/position=bottomright textattrs=(size=&fontst color=black);
      */
	Format rateSnitt &varnavn comma8.0 &kol_to comma8.0;

run;
ods listing close; ods graphics off;

