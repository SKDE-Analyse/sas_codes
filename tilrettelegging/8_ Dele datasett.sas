/**********************************************************************
***********************************************************************
	6.	Fordele de tilrettelagte variablene i to datasett
***********************************************************************
**********************************************************************/


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
InstitusjonId
intern_kons
KoblingsID
KomNr
korrvekt
liggetid
ncmp:
ncsp:
NPRId_reg
PID
UtDato
utTilstand
;
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
ald_gr
Ald_gr5
alderIDager
ATC:
avdOpp_id
behandlingsstedKode
behandlingsstedLokal
behandlingsstedReshID
/*bydel_alle*/
bydel_Bergen
bydel_Oslo
bydel_Stavanger
bydel_Trondheim
bydel2
cyto:
dag_kir
debitor
DodDato
DRGtypeHastegrad
EmigrertDato
fagenhetKode
fagenhetLokal
fagenhetReshID
fagomrade
fodselsar_ident
fodselsvekt
fodt_mnd_ident
g_omsorgsniva
henvType
ICD10KatBlokk
innmateHast
InnTid
inntilstand
institusjonID_omkodet
institusjonID_original
isf_opphold
kjonn
kjonn_ident
KoblingsID
komNrHjem2
komp_drg
kontaktType
niva
omsorgsniva
opphold_id
oppholdstype
pakkeforlop
permisjonsdogn
polIndir
polIndirekteAktivitet
polUtforende_1
polUtforende_2
RehabType
relatertKontaktID
spes_drg
stedAktivitet
tell_ATC
tell_cyto
tell_ICD10
tell_NCMP
tell_NCSP
tjenesteenhetKode
tjenesteenhetLokal
tjenesteenhetReshID
trimpkt
utforendeHelseperson
UtTid
vekt
versjon
VertskommHN
;
run;

%Mend Splitte;