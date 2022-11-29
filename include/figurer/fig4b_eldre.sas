/*
Andel reinnleggelser
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe"   ;

proc sgplot data=&navn_en._andeler noborder noautolegend sganno=anno pad=(Bottom=4%);
hbarparm category=bohf response=andel / nooutline fillattrs=(color=CX95BDE6) barwidth=&soylebredde;
hbarparm category=bohf response=andel_no / nooutline fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;
		scatter y=BoHf x=posisjon / datalabel=andel datalabelpos=right markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=black WEIGHT=BOLD size=7);
     Yaxistable en_ant tot_ant gj_liggetid/Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=&fontst) type=discrete discreteorder=data valueattrs=(size=&fontst);
  xaxis label="Andel"   labelattrs=(size=&fontst) offsetmin=0.02 offsetmax=0.02 valueattrs=(size=&fontst);
     Format andel percent8.0 en_ant antall_to tot_ant nlnum8.0 gj_liggetid nlnum8.1 ;
run;
ods listing close; ods graphics off;
