


/*
Hva gjenstår å gjøre:

2. Ta hensyn til manglende avtspesdata (ved estimat basert på månedsdata)
NB! Kun relevant ved estimering på boområde.
Vurdering etter test 25 jan 2023: Forholdet mellom aktivitet på sykehus og hos avalespesialist
kan svinge mye fra måned til måned så korreksjon basert på f.eks. fjoråret eller 
første tertial inneværende år kan bli ganske feil. Kanskje bedre å bruke tertialdata?

6. teste på mer data
*/


%macro estimere(basis_data=, 
est_var=, 
est_data=,
sho=0, 
est_per=8, 
agg_level=bohf,
utdata=);

/*** HVA GJØR MAKROEN? ******************************************/
/*******************************************************************/
/*
Makroen lager et estimat for antall hendelser (eks. operasjoner) forventet ila et helt år
basert på data for deler av året, og data for ett eller flere hele forutgående år (basisperioden). 
Eks. Estimat for hele 2022 (estimatår) basert på data for 1 tertial 2022 + hele 2019-2021 (basisperiode).
Estimatet beregnes for et gitt aggregeringsnivå (eks pr behHF eller boHF).
Det beregnes ett estimat basert på snittet for basisperioden, samt et maksimums- og minimumsestimat.
Estimatet kan f.eks. benyttes til å beregne en ujustert rate for estimatåret.

Estimat bør være basert på minst 4 måneder med data - feilmelding dersom du forsøker deg på noe mindre...

NB! Skal du kun estimere basert på data fra sykehus kan du sende inn valgfritt antall måneder med 
data fra estimatåret, skal du estimere basert på data fra sykehus + avtalespesialist må du ha 
tertialdata (4 eller 8 måneder) fra estimatåret.
*/

/*** FORKLARING TIL INPUT ******************************************/
/*******************************************************************/

/*
basis_data=navn på datasett med hele årganger som danner grunnlag for estimat
Dersom du kun ønsker å basere estimat på f.eks. årene 2019 og 2022 sender du inn et datasett med
data fra bare disse to årene.

est_var=variabelen det skal estimeres for (indeksvariabel som indikerer en hendelse)

est_data=navn på datasett med noen måneder med data fra estimatår - året det estimeres for
est_per=8 antall måneder med data i est_data, 4 for 1 tertial, 8 for andre tertial
NB! Bruk minst ett tertial med data!

sho=1 hvis sykehusoppholdsmakro er brukt, 0 ellers
NB! sho-variabelen gjelder BÅDE basisperiode OG estimatår, 
sykehusoppholdsmakro må enten kjøres på begge datasett eller ingen av dem

agg_level=aggregeringsnivå for utdata OG nivå for estimering
(eks: hvis agg_level=bohf vil estimat beregnes separat for hvert bohf)
NB! agg_level kan ikke være finmasket - da blir estimatet dårlig (lav N i hver celle).
Bør være borhf/bohf/boshhn eller behrhf/behf/behsh - vurder ifht N!

utdata=navn på utdatasett;
*/

/*Feilmelding hvis antall måneder er for lite*/
%if &est_per lt 4 %then %do;
data _null_;
put 'ERROR: Antall måneder er for lite, bruk minst ett fullt tertial.';
run;
%end;

/*Plukker ut aktuelle måneder fra basisperioden*/
data basis;
set &basis_data;
if month(utdato) in (1:&est_per) then est_per=1;
run;

/*summere opp aktuell variabel for estimatperioden 
og for hele året og finne andel i estimatperioden pr år*/
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

 

/*Printe datasett for å vise oversikt over andel pr år*/
title "Andel av årlig aktivitet i estimatperioden (andel_estp), pr år";
proc print data=basis_andel;
var aar &agg_level andel_estp;
run;
title;


/*Finn antall år i basisperioden*/
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

/*Printe datasett for å vise oversikt over andel pr år*/
title "estp_snitt_andel";
proc print data=estp_snitt_andel;
var &agg_level snitt_andel_estp max_andel_estp min_andel_estp;
run;
title;

/*aggregere estimatdata på ønsket aggregeringsnivå (bo- eller behandler)*/

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

/*beregne estimert aktivitetsnivå vha 
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


