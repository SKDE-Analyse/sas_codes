

Proc format;
value type
1="&label_en"
2="&label_to";
run;
/*Hente inn en rater*/
data en;
set &navn_en._bohf;
ant_opphold = &navn_en;
en_rate = ratesnitt;
type = 1;
en_ant = ant_opphold;
run;


/*Hente inn to rater*/
data to;
set &navn_to._bohf;
ant_opphold = &navn_to;
to_rate = ratesnitt;
type = 2;
to_ant = ant_opphold;
run;

data tot;
set &navn_tot._bohf;
tot_ratesnitt = ratesnitt;
keep bohf tot_ratesnitt;
run;





/*Slå sammen en og to*/
data &navn_en._andeler;
set en to tot;
format type type.;
Run;

proc sql;
   create table &navn_en._andeler as 
   select *, max (tot_ratesnitt) as tot_rate, sum(to_ant) as antall_to, sum (en_rate) AS rate_en, sum (to_rate) as rate_to, sum(ant_opphold) as tot_ant
   from &navn_en._andeler
   group by  Bohf ;
quit;


data &navn_en._andeler;
Set &navn_en._andeler;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
     Ant_opphold=.;
     Innbyggere=.;
end;
if bohf = 8888 then snittrate = ratesnitt;
	Andel=rate_en/tot_rate;
	Length Mistext $ 10;
	if tot_ant lt 30 then do;
		andel=.;
		Mistext="N<30";
		Plassering=0.01;
	end;
	rate_original=ratesnitt;
	format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
	label en_ant="&label_en" antall_to="&label_to";
	keep Bohf  type Plassering ratesnitt antall_to en_rate Innbyggere Andel en_ant tot_rate rate_en to_rate  labelpos No_snitt norge_snitt Mistext;
run;


data &navn_en._andeler;
set &navn_en._andeler;
where en_rate ne .;
if type = 1 then do;
if bohf = 8888 then andel_no = andel;
posisjon =  0.005;
end;
run;


proc sort data=&navn_en._andeler;
by descending andel en_ant;
run;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog"   ;
/*Title font=arial height=8pt "&arbtittel, gj. snitt 2013-2015           ";*/
proc sgplot data=&navn_en._andeler noborder noautolegend sganno=anno pad=(Bottom=7%);
hbarparm category=bohf response=andel / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=andel_no / nooutline fillattrs=(color=CXC3C3C3);	
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ; 
		scatter y=BoHf x=posisjon / datalabel=andel datalabelpos=right markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=black weight=bold size=8);
     Yaxistable en_ant antall_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
  xaxis label="Andel"   labelattrs=(size=7 ) offsetmin=0.02 offsetmax=0.02 valueattrs=(size=7);
     Format andel percent8.0 en_ant antall_to nlnum8.0 ;	
run;Title; ods listing close; ods graphics off;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off /*HEIGHT=10.0cm width=10.0cm*/;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
/*Title font=arial height=8pt "&arbtittel, gj. snitt 2013-2015           ";*/
proc sgplot data=&navn_en._andeler noborder noautolegend sganno=anno pad=(Bottom=7%);
hbarparm category=bohf response=andel / nooutline fillattrs=(color=CX95BDE6); 
 hbarparm category=bohf response=andel_no / nooutline fillattrs=(color=CXC3C3C3);	
		scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ; 
		scatter y=BoHf x=posisjon / datalabel=andel datalabelpos=right markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=black weight=bold size=8);
     Yaxistable en_ant antall_to /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
  xaxis label="Andel"   labelattrs=(size=7 ) offsetmin=0.02 offsetmax=0.02 valueattrs=(size=7);
     Format andel percent8.0 en_ant antall_to nlnum8.0 ;	
run;Title; ods listing close; ods graphics off;


Proc datasets nolist;
delete en to tot;
run;

