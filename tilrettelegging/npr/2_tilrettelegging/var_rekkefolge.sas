/*!

Fordele de tilrettelagte variablene i to datasett
*/

%Macro var_rekkefolge (innDataSett=, utDataSett=);

/*!
Splitte datasett i to

*/

/*!
- Definere hvilke variabler som skal legges i *magnus*
*/

/* Magnus-variabler som finnes i både sykehus-fil og avtspes-fil */
%let magnusvar_felles = 
inndato
utdato
ErMann
alder
komnr
bydel
bohf
borhf
boshhn
Fylke
NPRId_reg
fodselsar
dodDato
institusjonId
debitor
Episodefag
hastegrad
ICD10Kap
hdiag
hdiag2
hdiag3tegn
hf
;

/* Magnus-variabler som kun finnes i sykehus-fil */
%let magnusvar_sykehus = 
bdiag1-bdiag19
ncmp1-ncmp20
ncsp1-ncsp20
ncrp1-ncrp20
InnTid
UtTid
aktivitetskategori3
behandlingsstedkode2
BehHF
BehRHF
behSh
drg
drg_type
HDG
/*korrvekt*/ /* Ikke fått data for 2018 */
liggetid
/* opphold_id */
polUtforende_1
utTilstand /* Fikk ikke i første utlevering, juni 2018 */
/*intern_kons*/
niva
/* versjon */
;

/* Magnus-variabler som kun finnes i avtspes-fil */
%let magnusvar_avtspes = 
bdiag1-bdiag9
ncmp1-ncmp10
ncsp1-ncsp10
fag_skde
Normaltariff1-Normaltariff15
Tdiag1-Tdiag5 /* Vil mangle for alle år, bortsett fra 2014. */
AvtaleRHF
SpesialistKomHN
Komplett
AvtSpes
;

%if &somatikk ne 0 %then %do;
%let magnusvar = &magnusvar_felles &magnusvar_sykehus;
%end;
%if &avtspes ne 0 %then %do;
%let magnusvar = &magnusvar_felles &magnusvar_avtspes;
%end;


/*!
- Datasett med de mest sentrale tilrettelagte variable
*/

Data &Utdatasett;
retain aar pid &magnusvar ;
set &Inndatasett;
run;


%mend;

