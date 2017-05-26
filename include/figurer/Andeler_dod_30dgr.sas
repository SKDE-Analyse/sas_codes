
proc sort data=d30_&tema._&RV_variabelnavn._bohf out=dod_30;
by bohf;
run;

proc sort data=d365_&tema._&RV_variabelnavn._bohf out=dod_365;
by bohf;
run;

proc sort data=&tema._&RV_variabelnavn._bohf out=dod_tot;
by bohf;
run;

data samlefig;
merge dod_30 dod_365 dod_tot; 
by bohf;
Andel30 = d30_&tema._rate/&tema._rate;
Andel365 = d365_&tema._rate/&tema._rate;
if bohf = 8888 then do;
	andel30_no = andel30;
	andel365_no = andel365;	
end;
posisjon = 0.005;

label d30_&tema._ant='30 dgr.' d365_&tema._ant='365 dgr.' Andel365='Andel 365dgr.';
run;


proc sql;
create table samlefig as 
select *, max (andel365) as maks, min (andel365) as mini
from samlefig;
quit;


data samlefig;
set samlefig;
FT=round((maks/mini),0.1);
run;

Data _null_;
set samlefig;
call symput('FT', trim(left(put(FT,8.1))));
run;

proc sort data=samlefig;
by descending andel30;
run;

proc datasets nolist;
delete dod:;
run;

/*	Lager figur	*/

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog"   ;
/*Title font=arial height=8pt "&arbtittel, kjÃ¸nns- og aldersjusterte rater pr. 1000 innbyggere, gj. snitt 2013 - 2015             ";*/
proc sgplot data=samlefig noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=bohf response=andel30 / nooutline fillattrs=(color=CX95BDE6) ; 
hbarparm category=bohf response=andel30_no / nooutline fillattrs=(color=CXC3C3C3) ;
/*	 scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;*/
    scatter x=posisjon y=bohf /datalabel=Andel30  datalabelpos=right markerattrs=(size=0) 
		datalabelattrs=(color=black weight=bold size=8);
    Yaxistable d30_&tema._ant d365_&tema._ant Andel365  /Label location=inside position=right labelpos=bottom  valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
	 xaxis label="Andel"   labelattrs=(size=7) offsetmin=0.02 offsetmax=0.02 valueattrs=(size=7);
	/*inset "FT=&FT" / position=right border textattrs=(size=10);*/
	Format d30_&tema._ant d365_&tema._ant  nlnum8.0 andel: percent8.0 ;
run;Title; ods listing close; ods graphics off;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png  border=off HEIGHT=12.0cm ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\helseatlas\eldre\&katalog.\png"   ;
/*Title font=arial height=8pt "&arbtittel, kjÃ¸nns- og aldersjusterte rater pr. 1000 innbyggere, gj. snitt 2013 - 2015             ";*/
proc sgplot data=samlefig noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=bohf response=andel30 / nooutline fillattrs=(color=CX95BDE6) ; 
hbarparm category=bohf response=andel30_no / nooutline fillattrs=(color=CXC3C3C3) ;
/*	 scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;*/
    scatter x=posisjon y=bohf /datalabel=Andel30  datalabelpos=right markerattrs=(size=0) 
		datalabelattrs=(color=black weight=bold size=8);
    Yaxistable d30_&tema._ant d365_&tema._ant Andel365  /Label location=inside position=right labelpos=bottom  valueattrs=(size=7 family=arial) labelattrs=(size=7);
    yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) type=discrete discreteorder=data valueattrs=(size=7);
	 xaxis label="Andel"   labelattrs=(size=7) offsetmin=0.02 offsetmax=0.02 valueattrs=(size=7);
	/*inset "FT=&FT" / position=right border textattrs=(size=10);*/
	Format d30_&tema._ant d365_&tema._ant  nlnum8.0 andel: percent8.0 ;
run;Title; ods listing close; ods graphics off;


