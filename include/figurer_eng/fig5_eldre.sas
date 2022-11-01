

/*
Tredelt figur
*/

%let soylebredde = 0.8;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\Helseatlas\Eldre\&katalog.\&mappe";

proc sgplot data=smelt_tre  noborder noautolegend sganno=Anno pad=(bottom=4%);
hbarparm category=bohf response= tot_ratesnitt/ outlineattrs=(color=CX00509E) fillattrs=(color=CX95BDE6) name='h3' legendlabel="Blood clots"  barwidth=&soylebredde; 
hbarparm category=bohf response=tot_ratesnitt_no /outlineattrs=(color=CX4C4C4C) fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;
hbarparm category=bohf response=minus_tre_tot /outlineattrs=(color=CX00509E) fillattrs=(color=CX568BBF) name='h2' legendlabel="Diabetes" barwidth=&soylebredde; 
hbarparm category=bohf response=minus_tre_tot_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX969696) barwidth=&soylebredde;
hbarparm category=bohf response=en_rate / outlineattrs=(color=CX00509E) fillattrs=(color=CX00509E) name='h1' legendlabel="AMD" barwidth=&soylebredde; 
hbarparm category=bohf response=en_rate_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX4C4C4C) barwidth=&soylebredde;
scatter x=plass y=bohf /datalabel=Andel datalabelpos=right markerattrs=(size=0) 
     datalabelattrs=(color=white  size=7);
Keylegend 'h1' 'h2' 'h3'/ noborder location=inside position=bottomright down=3;
Yaxistable en_ant to_ant tre_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=&fontst) ;
xaxis label=" Number per 1,000 inhabitants ((*ESC*){unicode'2265'x}75 years old)" labelattrs=(color=black size=&fontst) offsetmin=0.02 OFFSETMAX=0.02  
	&xskala valuesformat=comma8.0   valueattrs=(size=&fontst);  
Format andel percent8. en_ant to_ant tre_ant comma8.0 ;
run;
ods graphics off;

