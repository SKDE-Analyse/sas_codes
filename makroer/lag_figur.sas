%macro lag_figur(dsn = , fignavn = , mappe ="\\hn.helsenord.no\RHF\SKDE\Analyse\Data\SAS\Bildefiler",  
rate1 = off, ratenavn1a = , ratenavn1b =, 
rate2 = priv, ratenavn2a =, ratenavn2b =,
rate3 = , ratenavn3a =, ratenavn3b =,
bildeformat = pdf, fontst = 9, xskala =, xlabel=);

/*!
### Beskrivelse

Makro for å lage ratefigur. Makroen bruker rateprogrammet for å lage rater.

### Parametre

- `dsn`: datasettet med (aggregerte) date. Må inneholde følgende variabler: alder, ermann, komnr, bydel, "rate1", "rate2", der
navnene på "rate1" og "rate2" sendes inn som egne argumenter.
- `fignavn` (=&dsn._&rate1._&rate2, hvis ikke oppgitt): figurnavn 
- `mappe` (= "\\hn.helsenord.no\RHF\SKDE\Analyse\Data\SAS\Bildefiler"): mappen der figur skal lagres

*/

%macro samle_datasett(fil_en = , fil_to =, fil_tre =, label_en =, label_to =, label_tre =);

Proc format;
value type
1="&label_en"
2="&label_to"
%if %length(&verdi) ne 0 %then %do;
3="&label_tre"
%end;
;
run;

/*Hente inn type en rater*/
data en;
set &fil_en;
ant_opphold = Konsultasjoner;
en_rate = ratesnitt;
type = 1;
en_ant = ant_opphold;
run;


/*Hente inn type to rater*/
data to;
set &fil_to;
ant_opphold = Konsultasjoner;
to_rate = ratesnitt;
type = 2;
to_ant = ant_opphold;
run;


/*Slå sammen en og to*/
data smelt;
set en to;
format type type.;
Run;

proc sql;
   create table smelt as 
   select *, SUM(ratesnitt) as tot_ratesnitt, sum(ant_opphold) as AntOpph, sum (en_rate) AS rate_en, sum (to_rate) as rate_to
   from smelt
   group by  Bohf ;
quit;

data smelt;
Set smelt;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
/*     Ant_opphold=.;*/
     Innbyggere=.;
end;

Andel=en_rate/tot_ratesnitt;
label Innbyggere="Innb." to_ant="&label_to." en_ant="&label_en."; 
rate_original=ratesnitt;
Length Mistext $ 10;
if antopph lt 30 then do;
	rate_en = .;
    Mistext = "N<30";
    Plassering = tot_ratesnitt/100;
	tot_ratesnitt = .;
	Andel = .;
end; 
format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
keep Bohf en_rate rate_en Mistext type Plassering ratesnitt Innbyggere Andel AntOpph en_ant to_ant to_rate rate_to tot_ratesnitt labelpos sortering;
run;

proc sql;
   create table smelt   as 
   select *, max(tot_ratesnitt) as maks, min(tot_ratesnitt) as minimum
   from smelt;
quit;

data smelt; 
set smelt;
FT2=round((maks/minimum),0.1);
run;

/*
Data _null_;
set smelt;
call symput('FT2', trim(left(put(FT2,8.1))));
run;
*/

data smelt;
set smelt;
if bohf = 8888 then do;
ratesnitt_no = tot_ratesnitt;
rate_en_no = rate_en;
rate_en =.;
end;
label en_ant="&label_en" to_ant="&label_to";
plass = maks/1000;
drop maks minimum ratesnitt ;
run;

proc sort data=smelt;
by descending tot_ratesnitt;
run;

%mend;


%macro splittet_figur(dsn =, figurnavn =, bildeformat =, mappe = , label_en =, label_to =, label_tre =, fontst =, xskala =);

/* 
Splittet søyle-figur 
*/

%let soylebredde = 0.8;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat border=off ;
ODS Listing Image_dpi=300 GPATH=&mappe;

proc sgplot data=&dsn  noborder noautolegend sganno=Anno pad=(bottom=4%);
hbarparm category=bohf response=tot_RateSnitt / outlineattrs=(color=CX00509E) fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_to" barwidth=&soylebredde; 
hbarparm category=bohf response=Ratesnitt_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CXC3C3C3) barwidth=&soylebredde;
hbarparm category=bohf response=rate_en / outlineattrs=(color=CX00509E) fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_en" barwidth=&soylebredde; 
hbarparm category=bohf response=rate_en_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX4C4C4C) barwidth=&soylebredde;
     scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) datalabelattrs=(color=black size=7) ;
     scatter x=plass y=bohf /datalabel=Andel  datalabelpos=right markerattrs=(size=0) datalabelattrs=(color=white WEIGHT=BOLD size=7);
xaxis label="&xlabel" labelattrs=(color=black size=&fontst) offsetmin=0.02 OFFSETMAX=0.02  &xskala valuesformat=nlnum8.0   valueattrs=(size=&fontst);
Keylegend "hp2" "hp1"/ noborder location=inside position=bottomright down=2;
Yaxistable en_ant to_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=&fontst) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=&fontst) ;

Format andel percent8. en_ant to_ant  ratesnitt_no rate_en_no nlnum8.0 ;
run;
ods graphics off;

%mend;

/* Definere figurnavn, hvis ikke gitt */
%if %sysevalf(%superq(fignavn)=,boolean) %then %let fignavn = &dsn._&rate1._&rate2;


/*
Makro for å definere navn over kolonner
*/
/*
Definere hva som skrives over kolonnene 1, 2 og 3
*/

%if not %sysevalf(%superq(rate1)=,boolean) %then %do;
    %if %sysevalf(%superq(ratenavn1a)=,boolean) %then %do;
        %if &rate1 = off %then %let ratenavn1a = Offentlig;
        %else %if &rate1 = priv %then %let ratenavn1a = Privat;
        %else %if &rate1 = akutt %then %let ratenavn1a = Akutt;
        %else %if &rate1 = planlagt %then %let ratenavn1a = Planlagt;
        %else %let ratenavn1a = &rate1;
    %end;
    %if %sysevalf(%superq(ratenavn1b)=,boolean) %then %let ratenavn1b = &ratenavn1a;
%end;

%if not %sysevalf(%superq(rate2)=,boolean) %then %do;
    %if %sysevalf(%superq(ratenavn2a)=,boolean) %then %do;
        %if &rate2 = off %then %let ratenavn2a = Offentlig;
        %else %if &rate2 = priv %then %let ratenavn2a = Privat;
        %else %if &rate2 = akutt %then %let ratenavn2a = Akutt;
        %else %if &rate2 = planlagt %then %let ratenavn2a = Planlagt;
        %else %let ratenavn2a = &rate2;
    %end;
    %if %sysevalf(%superq(ratenavn2b)=,boolean) %then %let ratenavn2b = &ratenavn2a;
%end;

%if not %sysevalf(%superq(rate3)=,boolean) %then %do;
    %if %sysevalf(%superq(ratenavn3a)=,boolean) %then %do;
        %if &rate3 = off %then %let ratenavn3a = Offentlig;
        %else %if &rate3 = priv %then %let ratenavn3a = Privat;
        %else %if &rate3 = akutt %then %let ratenavn3a = Akutt;
        %else %if &rate3 = planlagt %then %let ratenavn3a = Planlagt;
        %else %let ratenavn3a = &rate3;
    %end;
    %if %sysevalf(%superq(ratenavn3b)=,boolean) %then %let ratenavn3b = &ratenavn3a;
%end;



/* Ikke rør originalt datasett */

data tmp_figur;
set &dsn;
keep aar alder ermann komnr bydel &rate1 &rate2;
run;

/*
Rateberegninger
*/

%include "&filbane\rateprogram\rateberegninger.sas";
%include "&filbane\rateprogram\sas\definerVariabler.sas";
%include "&filbane\Stiler\stil_figur.sas";
%include "&filbane\Stiler\Anno_logo_kilde_NPR_SSB.sas";

%let ratefil = tmp_figur;


%definerVariabler;

%let RV_variabelnavn = &rate1;
%utvalgx;
%rateberegninger;

data &rate1;
set konsultasjoner_bohf;
run;


%let RV_variabelnavn = &rate2;
%utvalgx;
%rateberegninger;

data &rate2;
set konsultasjoner_bohf;
run;

%if not %sysevalf(%superq(rate3)=,boolean) %then %do;
    %let RV_variabelnavn = &rate3;
    %utvalgx;
    %rateberegninger;

    data &rate3;
    set konsultasjoner_bohf;
    run;
%end;

%samle_datasett(fil_en = &rate1, fil_to = &rate2, fil_tre = &rate3, label_en = &ratenavn1a, label_to = &ratenavn2a, label_tre =);

%splittet_figur(dsn = smelt, figurnavn = &fignavn, bildeformat = &bildeformat, mappe = &mappe, label_en = &ratenavn1a, label_to = &ratenavn2a, label_tre =, fontst = &fontst, xskala = &xskala);

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd;
run;

%mend;