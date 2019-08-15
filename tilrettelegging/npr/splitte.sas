/*!

Fordele de tilrettelagte variablene i to datasett
*/

%Macro Splitte (innDataSett=, utDataSettEN=,utDataSettTO=);

/*!
Splitte datasett i to

*/

/*!
- Definere hvilke variabler som skal legges i *magnus*
*/

/* Magnus-variabler som finnes i b�de sykehus-fil og avtspes-fil */
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
behandlingssted2
BehHF
BehRHF
behSh
drg
drg_type
HDG
korrvekt /* Ikke f�tt data for 2018 */
liggetid
opphold_id
polUtforende_1
utTilstand /* Fikk ikke i f�rste utlevering, juni 2018 */
intern_kons
niva
versjon
;

/* Magnus-variabler som kun finnes i avtspes-fil */
%let magnusvar_avtspes = 
bdiag1-bdiag9
ncmp1-ncmp10
ncsp1-ncsp10
fag_skde
Normaltariff1-Normaltariff15
Tdiag1-Tdiag5 /* Vil mangle for alle �r, bortsett fra 2014. */
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

Data &UtdatasettEN;
retain aar pid &magnusvar koblingsID;
set &Inndatasett;
keep aar pid &magnusvar koblingsID;
format koblingsID 32.;
run;

/*!
- Datasett med de andre variablene
*/

Data &UtdatasettTO;
set &Inndatasett;
drop &magnusvar;
format koblingsID 32.;
run;

%mend;
