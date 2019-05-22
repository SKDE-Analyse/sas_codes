/*
Alderssammensetning 
*/

%let soylebredde = 0.8;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\&mappe";

proc sgplot data=smelt  noborder noautolegend sganno=Anno pad=(bottom=3%);

hbarparm category=bohf response=tot_andel_inn / outlineattrs=(color=CX00509E) fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_to" barwidth=&soylebredde; 
hbarparm category=bohf response=tot_andel_inn_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;
hbarparm category=bohf response=andel_inn / outlineattrs=(color=CX00509E) fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_en" barwidth=&soylebredde; 
hbarparm category=bohf response=andel_inn_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX4C4C4C) barwidth=&soylebredde;

scatter x=plassering y=bohf /datalabel=Andel datalabelpos=left markerattrs=(size=0) 
        datalabelattrs=(color=white size=7);
Keylegend 'h1' / noborder location=inside position=bottomright across=1;
Yaxistable en_ant  to_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);


yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=&fontst) ;
xaxis offsetmin=0.02 OFFSETMAX=0.02  values=(0.0 to 0.10 by 0.01) valuesformat=percent8.0 
         valueattrs=(size=&fontst) /*Display=(Nolabel)*/ label='Andel av totalbefolkningen' labelattrs=(size=&fontst);
*          inset ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"="Norge") /position=bottomright textattrs=(size=7 color=black);
Format andel percent8. en_ant to_ant comma8.0 ;
run;
ods listing close; 
ods graphics off;

