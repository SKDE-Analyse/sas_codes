/*
Årsvariasjonfigur, ett år
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\&mappe";

proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=4%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
 hbarparm category=bohf response=Snittrate / nooutline outlineattrs=(color=darkgrey) fillattrs=(color=CXC3C3C3) barwidth=&soylebredde; 
				
	scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0)  datalabelattrs=(color=black size=7);
    Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
	xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)"   labelattrs=(color=black size=&fontst ) &xskala offsetmin=0.02 valueattrs=(size=&fontst);
run;
ods listing close; ods graphics off;

