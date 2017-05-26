


/* 	Henter antall personer fra unik-datasett	*/

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
merge &varnavn._BOHF_aarsvar kons ;
by bohf;
Kons_per_pas = kons/&varnavn;
if bohf = 8888 then snittrate = ratesnitt;
label &varnavn="&label_en" &kol_to="&label_to";
rate_original=ratesnitt;
Length Mistext $ 10;
if &varnavn lt 30 then do;
     ratesnitt=.;
	 rate2013=.; rate2014=.; rate2015=.; min=.; max=.;
     Mistext="N<30";
     Plassering=Norge/100;
end;
run;

proc sql;
   create table &varnavn._SAMLET as 
   select *, max(ratesnitt) as maks, min(ratesnitt) as minimum
   from &varnavn._SAMLET;
   quit;

data &varnavn._SAMLET; 
set &varnavn._SAMLET;
FT2=round((maks/minimum),0.1);
drop maks minimum;
run;

Data _null_;
set &varnavn._SAMLET;
call symput('FT2', trim(left(put(FT2,8.1))));
run;

proc sort data=&varnavn._SAMLET;
by descending &sortering;
run;




/*	Lager figur	*/

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog"   ;
proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=7%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=Snittrate /  nooutline fillattrs=(color=CXC3C3C3) ; 
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;
		scatter x=rate2013 y=BOHF / markerattrs=(symbol=circlefilled color=black); 
		scatter x=rate2014 y=BOHF / markerattrs=(symbol=trianglefilled color=black);
		scatter x=rate2015 y=BOHF / markerattrs=(symbol=Diamondfilled color=black);
	Highlow Y=BOHF low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
    Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
	xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)"   labelattrs=(color=black size=7 ) &xskala offsetmin=0.02 valueattrs=(size=8);
     inset 
		(
	 	"(*ESC*){unicode'25cf'x}"="   2013"
	 	"(*ESC*){unicode'25b2'x}"="   2014"
	 	"(*ESC*){unicode'2666'x}"="   2015")/position=bottomright textattrs=(size=7 color=black);
	/*inset "FT=&FT2" / position=right border textattrs=(size=10);*/
	Format &varnavn nlnum8.0 &kol_to nlnum8.1 ;
run;Title; ods listing close; ods graphics off;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=7%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=Snittrate /  nooutline fillattrs=(color=CXC3C3C3) ; 
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;
		scatter x=rate2013 y=BOHF / markerattrs=(symbol=circlefilled color=black); 
		scatter x=rate2014 y=BOHF / markerattrs=(symbol=trianglefilled color=black);
		scatter x=rate2015 y=BOHF / markerattrs=(symbol=Diamondfilled color=black);
	Highlow Y=BOHF low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
    Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
	xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)"   labelattrs=(color=black size=7 ) &xskala offsetmin=0.02 valueattrs=(size=8);
     inset 
		(
	 	"(*ESC*){unicode'25cf'x}"="   2013"
	 	"(*ESC*){unicode'25b2'x}"="   2014"
	 	"(*ESC*){unicode'2666'x}"="   2015")/position=bottomright textattrs=(size=7 color=black);
	/*inset "FT=&FT2" / position=right border textattrs=(size=10);*/
	Format &varnavn nlnum8.0 &kol_to nlnum8.1 ;
run;Title; ods listing close; ods graphics off;

/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._AARSV_NO pers kons &varnavn._BOHF_aarsvar;
run;