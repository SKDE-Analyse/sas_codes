/*
Alderssammensetning 
*/

%let soylebredde = 0.8;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\&mappe";

proc sgplot data=smelt  noborder noautolegend sganno=Anno pad=(bottom=3%);
styleattrs datacolors=(CX00509E CX95BDE6) DATACONTRASTCOLORS=(CX00509E);
hbarparm category=BOHF response=&variabel / group=type grouporder=ascending groupdisplay=stack barwidth=&soylebredde NAME='h1';
hbarparm category=BOHF response=&variabel._no / group=type grouporder=ascending groupdisplay=stack barwidth=&soylebredde NAME='h1';
scatter x=plassering y=bohf /datalabel=Andel datalabelpos=left markerattrs=(size=0) 
        datalabelattrs=(color=white weight=bold size=&fontst);
Keylegend 'h1' / noborder location=inside position=bottomright across=1;
Yaxistable en_ant  to_ant andel/Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);


yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=&fontst) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=&fontst) ;
xaxis offsetmin=0.02 OFFSETMAX=0.02  values=(0.0 to 0.10 by 0.01) valuesformat=percent8.0 
         valueattrs=(size=7) /*Display=(Nolabel)*/ label='Andel av totalbefolkningen' labelattrs=(size=&fontst);
*          inset ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"="Norge") /position=bottomright textattrs=(size=7 color=black);
Format andel percent8. en_ant to_ant nlnum8.0 ;
run;
ods listing close; 
ods graphics off;

