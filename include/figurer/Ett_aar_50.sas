


/* 	Henter antall personer fra unik-datasett	*/



/* Setter sammen datasett	*/

data &varnavn._BOHF_aarsvar;
set &varnavn._BOHF;
run;

proc sort data=&varnavn._BOHF_aarsvar;
by bohf;
run;

data &varnavn._SAMLET;
set &varnavn._BOHF_aarsvar ;
by bohf;
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


%let fontst = 7;
%let mappe = rapport;
%let bildeformat = pdf;

%include "&filbane.\include\master\figurer\fig1c_yngre.sas";


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

%include "&filbane.\include\master\figurer\fig1c_yngre.sas";


%let fontst = 7;
%let mappe = png;
%let bildeformat = png;

%include "&filbane.\include\master\figurer\fig1c_yngre.sas";


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog"   ;
proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=7%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=Snittrate / nooutline outlineattrs=(color=darkgrey) fillattrs=(color=CXC3C3C3) ; 
				Highlow Y=BOHF low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
	scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;
    Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
	xaxis label=" Antall pr. 1 000 innbyggere (50 - 74 år)"   labelattrs=(color=black size=7 ) &xskala offsetmin=0.02 valueattrs=(size=8);
run;Title; ods listing close; ods graphics off;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
proc sgplot data=&varnavn._SAMLET noborder noautolegend sganno=anno pad=(Bottom=7%);
 hbarparm category=bohf response=rateSnitt / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=Snittrate / nooutline outlineattrs=(color=darkgrey) fillattrs=(color=CXC3C3C3) ; 
				Highlow Y=BOHF low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
	scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;
    Yaxistable &varnavn &kol_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
	xaxis label=" Antall pr. 1 000 innbyggere (50 - 74 år)"   labelattrs=(color=black size=7 ) &xskala offsetmin=0.02 valueattrs=(size=8);
run;Title; ods listing close; ods graphics off;

/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._AARSV_NO pers &varnavn._BOHF_aarsvar;
run;