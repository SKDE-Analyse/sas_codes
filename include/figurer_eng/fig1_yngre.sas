/*
Årsvariasjonfigur 50-75 years old
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe"   ;

proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=4%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
 hbarparm category=bohf response=Snittrate / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde; 
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0)  datalabelattrs=(color=black size=7);
		scatter x=rate2013 y=BOHF / markerattrs=(symbol=circlefilled size=9 color=black); 
		scatter x=rate2014 y=BOHF / markerattrs=(symbol=Squarefilled size=9 color=black);
		scatter x=rate2015 y=BOHF / markerattrs=(symbol=Diamondfilled size=9 color=black);
	Highlow Y=BOHF low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
    Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
	xaxis label=" Number per 1,000 inhabitants (50 - 74 years old)"   labelattrs=(color=black size=&fontst) &xskala offsetmin=0.02 valueattrs=(size=&fontst);
     inset 
		(
	 	"(*ESC*){unicode'25cf'x}"="   2013"
	 	"(*ESC*){unicode'25a0'x}"="   2014"
	 	"(*ESC*){unicode'2666'x}"="   2015")/position=bottomright textattrs=(size=&fontst color=black);

run;
ods listing close; ods graphics off;

