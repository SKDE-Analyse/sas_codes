/*
Årsvariasjonfigur
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\&mappe"   ;

proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=4%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
 hbarparm category=bohf response=Snittrate / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde; 
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0)  datalabelattrs=(color=black size=7);
		scatter x=rate2013 y=BOHF / markerattrs=(symbol=circlefilled size=9 color=black); 
		scatter x=rate2014 y=BOHF / markerattrs=(symbol=Squarefilled size=9 color=black);
		scatter x=rate2015 y=BOHF / markerattrs=(symbol=Diamondfilled size=9 color=black);
	Highlow Y=BOHF low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
    Yaxistable &varnavn pasienter kons_pr_pas /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
	xaxis label="Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)" labelattrs=(color=black size=&fontst ) offsetmin=0.02 valueattrs=(size=&fontst);
     inset 
		(
	 	"(*ESC*){unicode'25cf'x}"="   2013"
	 	"(*ESC*){unicode'25a0'x}"="   2014"
	 	"(*ESC*){unicode'2666'x}"="   2015")/position=bottomright textattrs=(size=8 color=black);
	Format  en_ant pasienter kons_pr_pas nlnum8.0 kons_pr_pas nlnum8.1;

run;
ods listing close; ods graphics off;
