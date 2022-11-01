/* 
Splittet søyle-figur 
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\Helseatlas\Eldre\&katalog.\&mappe";

proc sgplot data=smelt  noborder noautolegend sganno=Anno pad=(bottom=4%);
hbarparm category=bohf response=tot_RateSnitt / outlineattrs=(color=CX00509E) fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_to" barwidth=&soylebredde; 
hbarparm category=bohf response=Ratesnitt_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;
hbarparm category=bohf response=rate_en / outlineattrs=(color=CX00509E) fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_en" barwidth=&soylebredde; 
hbarparm category=bohf response=rate_en_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX4C4C4C) barwidth=&soylebredde;
     scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) datalabelattrs=(color=black size=7) ;
     scatter x=plass y=bohf /datalabel=Andel  datalabelpos=right markerattrs=(size=0) datalabelattrs=(color=white WEIGHT=BOLD size=7);
xaxis label=" Number per 1,000 inhabitants ((*ESC*){unicode'2265'x}75 years old)" labelattrs=(color=black size=&fontst) offsetmin=0.02 OFFSETMAX=0.02  &xskala valuesformat=comma8.0   valueattrs=(size=&fontst);
Keylegend "hp2" "hp1"/ noborder location=inside position=bottomright down=2;
Yaxistable en_ant to_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=&fontst) ;

Format andel percent8. en_ant to_ant  ratesnitt_no rate_en_no comma8.0 ;
run;
ods graphics off;