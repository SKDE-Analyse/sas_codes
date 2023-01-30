


/*
Hva gjenst�r � gj�re:

2. Ta hensyn til manglende avtspesdata (ved estimat basert p� m�nedsdata)
NB! Kun relevant ved estimering p� boomr�de.
Vurdering etter test 25 jan 2023: Forholdet mellom aktivitet p� sykehus og hos avalespesialist
kan svinge mye fra m�ned til m�ned s� korreksjon basert p� f.eks. fjor�ret eller 
f�rste tertial innev�rende �r kan bli ganske feil. Kanskje bedre � bruke tertialdata?

6. teste p� mer data
*/


%macro estimere(basis_data=, 
est_var=, 
est_data=,
sho=0, 
est_per=8, 
agg_level=bohf,
utdata=);

/*** HVA GJ�R MAKROEN? ******************************************/
/*******************************************************************/
/*
Makroen lager et estimat for antall hendelser (eks. operasjoner) forventet ila et helt �r
basert p� data for deler av �ret, og data for ett eller flere hele forutg�ende �r (basisperioden). 
Eks. Estimat for hele 2022 (estimat�r) basert p� data for 1 tertial 2022 + hele 2019-2021 (basisperiode).
Estimatet beregnes for et gitt aggregeringsniv� (eks pr behHF eller boHF).
Det beregnes ett estimat basert p� snittet for basisperioden, samt et maksimums- og minimumsestimat.
Estimatet kan f.eks. benyttes til � beregne en ujustert rate for estimat�ret.

Estimat b�r v�re basert p� minst 4 m�neder med data - feilmelding dersom du fors�ker deg p� noe mindre...

NB! Skal du kun estimere basert p� data fra sykehus kan du sende inn valgfritt antall m�neder med 
data fra estimat�ret, skal du estimere basert p� data fra sykehus + avtalespesialist m� du ha 
tertialdata (4 eller 8 m�neder) fra estimat�ret.
*/

/*** FORKLARING TIL INPUT ******************************************/
/*******************************************************************/

/*
basis_data=navn p� datasett med hele �rganger som danner grunnlag for estimat
Dersom du kun �nsker � basere estimat p� f.eks. �rene 2019 og 2022 sender du inn et datasett med
data fra bare disse to �rene.

est_var=variabelen det skal estimeres for (indeksvariabel som indikerer en hendelse)

est_data=navn p� datasett med noen m�neder med data fra estimat�r - �ret det estimeres for
est_per=8 antall m�neder med data i est_data, 4 for 1 tertial, 8 for andre tertial
NB! Bruk minst ett tertial med data!

sho=1 hvis sykehusoppholdsmakro er brukt, 0 ellers
NB! sho-variabelen gjelder B�DE basisperiode OG estimat�r, 
sykehusoppholdsmakro m� enten kj�res p� begge datasett eller ingen av dem

agg_level=aggregeringsniv� for utdata OG niv� for estimering
(eks: hvis agg_level=bohf vil estimat beregnes separat for hvert bohf)
NB! agg_level kan ikke v�re finmasket - da blir estimatet d�rlig (lav N i hver celle).
B�r v�re borhf/bohf/boshhn eller behrhf/behf/behsh - vurder ifht N!

utdata=navn p� utdatasett;
*/

/*Feilmelding hvis antall m�neder er for lite*/
%if &est_per lt 4 %then %do;
data _null_;
put 'ERROR: Antall m�neder er for lite, bruk minst ett fullt tertial.';
run;
%end;

/*Plukker ut aktuelle m�neder fra basisperioden*/
data basis;
set &basis_data;
if month(utdato) in (1:&est_per) then est_per=1;
run;

/*summere opp aktuell variabel for estimatperioden 
og for hele �ret og finne andel i estimatperioden pr �r*/
%if &sho=1 %then %do;
proc sql;
create table basis_andel as
select sho_aar as aar, &agg_level, 
count(distinct case when &est_var=1 then sho_id end) as tot_&est_var, 
count(distinct case when (&est_var=1 and est_per=1) then sho_id end) as estp_&est_var,
calculated estp_&est_var/calculated tot_&est_var as andel_estp
from basis
group by sho_aar, &agg_level;
quit;
%end;
%else %if &sho ne 1 %then %do;
proc sql;
create table basis_andel as
select aar, &agg_level, sum(&est_var) as tot_&est_var, 
count(case when (&est_var=1 and est_per=1) then 1 end) as estp_&est_var,
calculated estp_&est_var/calculated tot_&est_var as andel_estp
from basis
group by aar, &agg_level;
quit;
%end;

 

/*Printe datasett for � vise oversikt over andel pr �r*/
title "Andel av �rlig aktivitet i estimatperioden (andel_estp), pr �r";
proc print data=basis_andel;
var aar &agg_level andel_estp;
run;
title;


/*Finn antall �r i basisperioden*/
proc sql;
create table basis_aar as
select distinct aar
from &basis_data;
quit;

data _null_;
set basis_aar;
nobs+1;
call symputx("n_aar",nobs);
run;

%put &=n_aar;

/*Beregne gjennomsnittlig andel i estimatperioden, for basisperioden*/
proc sql;
create table estp_snitt_andel as
select distinct &agg_level, 
sum(andel_estp)/&n_aar as snitt_andel_estp,
max(andel_estp) as max_andel_estp,
min(andel_estp) as min_andel_estp
from basis_andel
group by &agg_level;
quit;

/*Printe datasett for � vise oversikt over andel pr �r*/
title "estp_snitt_andel";
proc print data=estp_snitt_andel;
var &agg_level snitt_andel_estp max_andel_estp min_andel_estp;
run;
title;

/*aggregere estimatdata p� �nsket aggregeringsniv� (bo- eller behandler)*/

%if &sho=1 %then %do;
proc sql;
   create table est_agg as 
   select distinct &agg_level,
	count(distinct case when &est_var=1 then sho_id end) as &est_var._data
   from &est_data 
   group by &agg_level;
quit;
%end;
%else %if &sho ne 1 %then %do;
proc sql;
   create table est_agg as 
   select distinct &agg_level, 
	count(case when &est_var=1 then 1 end) as &est_var._data
   from &est_data 
   group by &agg_level;
quit;
%end;


/*Sette sammen estimatdata og snittandel*/
proc sql;
create table est_agg_andel as
select a.*, b.snitt_andel_estp, b.max_andel_estp, b.min_andel_estp
from est_agg as a
	left join estp_snitt_andel as b on a.&agg_level=b.&agg_level;
quit;

/*beregne estimert aktivitetsniv� vha 
gjennomsnittlig andel i estimatperioden*/
data &utdata;
set est_agg_andel;
&est_var._est=round(&est_var._data/snitt_andel_estp);
&est_var._min=round(&est_var._data/max_andel_estp);
&est_var._max=round(&est_var._data/min_andel_estp);
run;

/*proc datasets nolist;*/
/*delete est: basis:;*/
/*quit;*/

%mend estimere;


