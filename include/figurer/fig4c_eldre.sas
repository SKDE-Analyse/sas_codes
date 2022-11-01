/*
Andel død
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off /*HEIGHT=10.0cm width=10.0cm*/ HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe"   ;

proc sgplot data=samlefig noborder noautolegend sganno=anno pad=(Bottom=4%);
hbarparm category=bohf response=andel30 / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
hbarparm category=bohf response=andel30_no / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;
/*	 scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;*/
    scatter x=posisjon y=bohf /datalabel=Andel30  datalabelpos=right markerattrs=(size=0) 
		datalabelattrs=(color=black WEIGHT=BOLD size=7);
    Yaxistable d30_&tema._ant d365_&tema._ant Andel365  /Label location=inside position=right labelpos=bottom  valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
	 xaxis label="Andel"   labelattrs=(size=&fontst) offsetmin=0.02 offsetmax=0.02 valueattrs=(size=&fontst);
    Format d30_&tema._ant d365_&tema._ant  nlnum8.0 andel: percent8.0 ;
run;
ods listing close; ods graphics off;

