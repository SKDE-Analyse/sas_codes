


options locale=NB_no;

/* 	Henter antall konsultasjoner 	*/

data kons;
set &varnavn_to._bohf;
run;

proc sql;
create table kons AS 
select bohf, &varnavn_to AS kons, sum(&varnavn_to) AS Sum_kons
from kons;
run;

 

/* Setter sammen datasett	*/

data &varnavn._BOHF_aarsvar;
set &varnavn._BOHF;
run;

proc sort data=kons;
by bohf;
run;

proc sort data=&varnavn._BOHF_aarsvar;
by bohf;
run;

data &varnavn._SAMLET;
merge &varnavn._BOHF_aarsvar kons;
by bohf;
drop aar norge;
Kons_per_pas = kons/&varnavn;
if bohf = 8888 then snittrate = ratesnitt;
label &varnavn="&label_en" &kol_to="&label_to";
format &kol_to NLnum8.1;
run;


proc sort data=&varnavn._SAMLET;
by descending &sortering;
run;

/*	Lager figur	*/

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog"   ;
proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=7%);
hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6); ; 
hbarparm category=bohf response=Snittrate / nooutline fillattrs=(color=CXC3C3C3) ; 		
     Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
 xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)"   labelattrs=(color=black size=7) &xskala offsetmin=0.02 valueattrs=(size=8); 	
run;Title; ods listing close; ods graphics off;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=7%);
hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6); ; 
hbarparm category=bohf response=Snittrate / nooutline fillattrs=(color=CXC3C3C3) ; 		
     Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
 xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)"   labelattrs=(color=black size=7) &xskala offsetmin=0.02 valueattrs=(size=8); 	
run;Title; ods listing close; ods graphics off;


/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._AARSV_NO  pers &varnavn._BOHF_aarsvar kons;
run;