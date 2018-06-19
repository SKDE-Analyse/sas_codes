/*
Andel indikikator
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\&mappe";

proc sgplot data=&dsn_var noborder noautolegend sganno=anno pad=(Bottom=7%);
	hbarparm category=bohf response=andel / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde; 
	hbarparm category=bohf response=andel_no / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;	
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0)  datalabelattrs=(color=black size=7); 	
	  	scatter y=BoHf x=posisjon / datalabel=andel datalabelpos=left markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=black WEIGHT=BOLD size=7);
     	Yaxistable en_ant tot_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    	yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
  		xaxis label="Proportion"   labelattrs=(size=&fontst) offsetmin=0.02 valueattrs=(size=&fontst);
     Format andel percent8.0 en_ant tot_ant comma8.0 ;		
run;
ods listing close; ods graphics off;

