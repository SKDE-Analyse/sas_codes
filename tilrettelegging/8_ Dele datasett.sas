/**********************************************************************
***********************************************************************
	6.	Fordele de tilrettelagte variablene i to datasett
***********************************************************************
**********************************************************************/

/* Kobler først på variablene emigrert og dodDato fra egen fil */

/* Merge med sql */

%Macro Merge_dod_emigrert (innDataSett=, utDataSett=);

proc sql;
create table &utDataSett as
select &innDataSett..*, emigrertDato, dodDato
from &innDataSett left join NPR_SKDE.T17_doed_NyEmigrert_kjonn_faar
on &innDataSett..pid=T17_doed_NyEmigrert_kjonn_faar.pid;
quit; 

data &utDataSett;
set &innDataSett;
label emigrertDato='Emigrert dato - per 20170425 (NPR)';
label dodDato='Dødedato - per 20170425 (NPR)';
length DodDato emigrertdato 4;
run;

%Mend Merge_dod_emigrert;

%Macro Splitte (innDataSett=, utDataSettEN=,utDataSettTO=);

/***
1. Datasett med de mest sentrale tilrettelagte variable
***/
Data &UtdatasettEN;
retain aar pid inndato utdato aktivitetskategori3 ErMann alder koblingsID HDG komnr bydel bohf borhf boshhn behsh behhf behrhf hdiag hdiag2 hdiag3tegn bdiag1-bdiag19 ncmp1-ncmp19 ncsp1-ncsp19 ;
set &Inndatasett;
keep 
aar
Aktivitetskategori3
Alder
Bdiag:
behandlingsstedKode2
BehHF
BehRHF
behSh
BoHF
BoRHF
BoShHN
Bydel
DodDato
drg
drg_type
episodeFag
ErMann
fodselsar
Fylke
hastegrad
hdg
Hdiag:
ICD10Kap
Inndato
InnTid
InstitusjonId
intern_kons
KoblingsID
KomNr
korrvekt
liggetid
ncmp:
ncsp:
ncrp:
NPRId_reg
opphold_id
PID
polUtforende_1
UtDato
UtTid
utTilstand
versjon
;
format koblingsID 32.;
run;




/***
2. Datasett med andre tilrettelagte variable
***/
Data &UtdatasettTO;
retain aar koblingsId;
set &Inndatasett;
keep	
aar
aggrshoppID
Aktivitetskategori
Aktivitetskategori2
Aktivitetskategori4
alderIDager
ATC:
avdOpp_id
behandlingsstedKode
behandlingsstedLokal
behandlingsstedReshID
bydel2
bydel_DSF
cyto:
dag_kir
debitor

DRGtypeHastegrad
emigrertDato
fagenhetKode
fagenhetLokal
fagenhetReshID
fagomrade
fodselsAar_ident
fodselsvekt
fodt_mnd
g_omsorgsniva
henvType
ICD10KatBlokk
innmateHast

inntilstand
institusjonID_original
isf_opphold
kjonn
kjonn_ident
KoblingsID
komNrHjem2
komNrHjem_DSF
bydel_DSF
komp_drg
kontaktType
niva
omsorgsniva

oppholdstype
pakkeforlop
permisjonsdogn
polIndir
polIndirekteAktivitet
polUtforende_2
polUtforende_3
RehabType
relatertKontaktID
spes_drg
stedAktivitet
tell_ATC
tell_cyto
tell_ICD10
tell_NCMP
tell_NCSP
tell_NCRP
tjenesteenhetKode
tjenesteenhetLokal
tjenesteenhetReshID
trimpkt
utforendeHelseperson

vekt

VertskommHN
UtskrKlarDato
tidspunkt_1
tidspunkt_2
tidspunkt_3
tidspunkt_4
tidspunkt_5
typeTidspunkt_1
typeTidspunkt_2
typeTidspunkt_3
typeTidspunkt_4
typeTidspunkt_5
ant_Tidspunkt


henvFraTjeneste
henvFraInstitusjonID
frittSykehusvalg
secondOpinion
fraSted
tilSted
/* delytelse */ /*Kun registrert på 2760 kontakter i 2017*/
;
format koblingsID 32.;
run;

%Mend Splitte;