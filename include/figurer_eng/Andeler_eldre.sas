

Proc format;
value type
1="&label_en"
2="&label_to";
run;
/*Hente inn en rater*/
data en;
set &ratenavn_en._bohf;
ant_opphold = &ratenavn_en;
en_rate = ratesnitt;
type = 1;
en_ant = ant_opphold;
if bohf = 1 then no_snitt = norge;
run;

data test;
set &ratenavn_en._norge;
where aar = 9999;
bohf = 25;
en_rate = RV_just_rate;
ratesnitt = RV_just_rate;
en_ant = ant_opphold;
innbyggere = ant_innbyggere;
keep en_rate bohf innbyggere en_ant ratesnitt tot_ratesnitt type ant_opphold;
type = 1;
run;

data en;
set en test;
run;


/*Hente inn to rater*/
data to;
set &ratenavn_to._bohf;
ant_opphold = &ratenavn_to;
to_rate = ratesnitt;
type = 2;
to_ant = ant_opphold;
if bohf = 1 then no_snitt = norge;
run;


data test;
set &ratenavn_to._norge;
where aar = 9999;
bohf = 25;
to_rate = RV_just_rate;
ratesnitt = RV_just_rate;
to_ant = ant_opphold;
innbyggere = ant_innbyggere;
keep to_rate bohf innbyggere to_ant ratesnitt tot_ratesnitt type ant_opphold;
type = 2;
run;

data to;
set to test;
run;


/*Slå sammen en og to*/
data andeler;
set en to;
format type type.;
Run;

proc sql;
   create table andeler as 
   select *, SUM(ratesnitt) as tot_ratesnitt, sum(to_ant) as AntOpph, sum (en_rate) AS en_rate, sum (to_ant) as tre_ant
   from andeler
   group by  Bohf ;
quit;


proc sql;
   create table andeler as 
   select *, sum(no_snitt) as norge_snitt
   from andeler
quit;

data andeler;
Set andeler;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
     Ant_opphold=.;
     Innbyggere=.;
end;

Andel=en_ant/tre_ant;
label Innbyggere="Inhab." antopph="&label_to." en_ant="&label_en.";                     
format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
keep Bohf en_rate type Plassering ratesnitt Innbyggere Andel AntOpph en_ant tre_rate to_ant to_rate tot_ratesnitt labelpos No_snitt norge_snitt;
run;

data andeler;
set andeler;
where andel ne .;
if type = 1 then do;
if bohf = 25 then andel_no = andel;
posisjon = andel - 0.005;
end;
run;


proc sort data=andeler;
by descending andel en_ant;
run;


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog\&mappe"   ;
/*Title font=arial height=8pt "&arbtittel, gj. snitt 2013-2015                 ";*/
proc sgplot data=andeler noborder noautolegend sganno=anno pad=(Bottom=4%);
hbarparm category=bohf response=andel / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=andel_no / nooutline fillattrs=(color=CXC3C3C3);		
	  scatter y=BoHf x=posisjon / datalabel=andel datalabelpos=left markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=black);
     Yaxistable en_ant antopph /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=&fontst ) type=discrete discreteorder=data valueattrs=(size=&fontst);
  xaxis label="Percentage"   labelattrs=(size=&fontst) offsetmin=0.02 valueattrs=(size=&fontst);
     Format andel percent8.1 en_ant antopph comma8.0 ;
		
run;Title; ods listing close; ods graphics off;



ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
/*Title font=arial height=8pt "&arbtittel, gj. snitt 2013-2015                 ";*/
proc sgplot data=andeler noborder noautolegend sganno=anno pad=(Bottom=7%);
hbarparm category=bohf response=andel / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=andel_no / nooutline fillattrs=(color=CXC3C3C3);		
	  scatter y=BoHf x=posisjon / datalabel=andel datalabelpos=left markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=black);
     Yaxistable en_ant antopph /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=7 ) type=discrete discreteorder=data valueattrs=(size=7);
  xaxis label="Percentage"   labelattrs=(size=7) offsetmin=0.02 valueattrs=(size=7);
     Format andel percent8.1 en_ant antopph comma8.0 ;
		
run;Title; ods listing close; ods graphics off;


Proc datasets nolist;
delete en to test;
run;

