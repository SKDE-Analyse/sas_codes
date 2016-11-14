%include "\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Data\SAS\Stiler\Anno_logo_kilde_NPR_SSB.sas";


Proc format;
value type
1="&dsn_en"
2="&dsn_to";
run;
/*Hente inn en rater*/
data en;
set &ratenavn._&dsn_en._bohf;
ant_opphold = &ratenavn._&dsn_en;
en_rate = ratesnitt;
type = 1;
en_ant = ant_opphold;
if bohf = 1 then no_snitt = norge;
run;


/*Hente inn to rater*/
data to;
set &ratenavn._&dsn_to._bohf;
ant_opphold = &ratenavn._&dsn_to;
to_rate = ratesnitt;
type = 2;
to_ant = ant_opphold;
if bohf = 1 then no_snitt = norge;

run;

/*Slå sammen en og to*/
data smelt;
set en to;
format type type.;
Run;

proc sql;
   create table smelt as 
   select *, SUM(ratesnitt) as tot_ratesnitt, sum(ant_opphold) as AntOpph, sum (en_rate) AS en_rate, sum (to_rate) as to_rate
   from smelt
   group by  Bohf ;
quit;


proc sql;
   create table smelt as 
   select *, sum(no_snitt) as norge_snitt
   from smelt
quit;

data smelt;
Set smelt;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
     Ant_opphold=.;
     Innbyggere=.;
end;

Andel=en_rate/tot_ratesnitt;
label Innbyggere="Innb." to_ant="&dsn_to." en_ant="&dsn_en.";                     
format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
keep Bohf en_rate type Plassering ratesnitt Innbyggere Andel AntOpph en_ant to_ant to_rate tot_ratesnitt labelpos No_snitt norge_snitt;
run;

data smelt;
set smelt;
if type = 1 then do;
Plassering=ratesnitt-0.1; 
end;
run;


proc sort data=smelt;
by descending &sortering;
run;


ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\Helseatlas\Eldre\Figurer"   ;
Title font=arial height=7pt "&navn, kjønns- og aldersjusterte rater pr. 1000 innbyggere                   ";
proc sgplot data=smelt  noborder noautolegend sganno=Anno pad=(bottom=3%);
styleattrs datacolors=(CX00509E CX95BDE6) DATACONTRASTCOLORS=(CX00509E);
hbarparm category=BOHF response=ratesnitt / group=type grouporder=ascending groupdisplay=stack barwidth=0.7 NAME='h1';
scatter x=plassering y=bohf /datalabel=Andel datalabelpos=left markerattrs=(size=0) 
        datalabelattrs=(color=white weight=bold size=8);
refline norge_snitt / label='Norge'  labelpos=min labelloc=outside labelattrs=(color=black)
          axis=x lineattrs=(pattern=2 color=black);
Keylegend 'h1' / noborder position=bottom;
Yaxistable en_ant to_ant Innbyggere /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Boområde/opptaksområde' labelattrs=(size=8 weight=bold) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=7) ;
xaxis offsetmin=0.02 OFFSETMAX=0.02  /*values=(0 to 2200 by 200)*/ valuesformat=nlnum8.0 
         valueattrs=(size=7) Display=(Nolabel);
          inset ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"="Norge") /position=bottomright textattrs=(size=7 color=black);
Format andel percent8. en_ant to_ant nlnum8.0 ;
run;
ods graphics off;