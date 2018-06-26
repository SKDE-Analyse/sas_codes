/*!*********************************************************************
***********************************************************************
	6.	Fordele de tilrettelagte variablene i to datasett
***********************************************************************
**********************************************************************/

%Macro Merge_persondata (innDataSett=, utDataSett=);
/*!
 Kobler først på variablene emigrert og dodDato fra egen fil 
 */

/* Merge med sql */


proc sql;
create table &utDataSett as
%if &avtspes ne 0 %then %do;
select &innDataSett..*, emigrertDato, dodDato, fodselsAar_ident19062018, fodt_mnd_ident19062018, kjonn_ident19062018
%end;
%if &somatikk ne 0 %then %do;
select &innDataSett..*, emigrertDato, dodDato
%end;
from &innDataSett left join NPR18.T18_persondata
on &innDataSett..pid=T18_persondata.pid;
quit; 

data &utDataSett;
set &innDataSett;
label emigrertDato='Emigrert dato - per 19062018 (NPR)';
label dodDato='Dødedato - per 19062018 (NPR)';
%if &avtspes ne 0 %then %do;
label fodselsAar_ident19062018='Fødselsår fra f.nr. ved siste kontakt med spes.helsetjenesten';
label fodt_mnd_ident19062018='Fødselsmåned fra f.nr. ved siste kontakt med spes.helsetjenesten';
label kjonn_ident19062018='Kjønn fra f.nr. ved siste kontakt med spes.helsetjenesten';
%end;
length dodDato emigrertDato 4;
run;

%Mend Merge_persondata;

%Macro Splitte (innDataSett=, utDataSettEN=,utDataSettTO=);

/*!**
1. Datasett med de mest sentrale tilrettelagte variable
***/
Data &UtdatasettEN;
%if &avtspes ne 0 %then %do;
retain aar pid inndato utdato ErMann alder koblingsID komnr bydel bohf borhf borhf boshhn hdiag hdiag2 hdiag3tegn bdiag1-bdiag9 ncmp1-ncmp10 ncsp1-ncsp10 ; 
%end;
%if &somatikk ne 0 %then %do;
retain aar pid inndato utdato aktivitetskategori3 ErMann alder koblingsID HDG komnr bydel bohf borhf boshhn behsh behhf behrhf hdiag hdiag2 hdiag3tegn bdiag1-bdiag19 ncmp1-ncmp19 ncsp1-ncsp19 ;
%end;
set &Inndatasett;
keep 
aar
%if &somatikk ne 0 %then %do;
Aktivitetskategori3
%end;
Alder
%if &avtspes ne 0 %then %do;
AvtSpes
%end;
Bdiag:
%if &somatikk ne 0 %then %do;
behandlingsstedKode2
BehHF
BehRHF
behSh
%end;
BoHF
BoRHF
BoShHN
Bydel
DodDato
%if &somatikk ne 0 %then %do;
drg
drg_type
%end;
Episodefag
ErMann
fodselsar
Fylke
%if &somatikk ne 0 %then %do;
hastegrad
hdg
%end;
Hdiag:
ICD10Kap
Inndato
%if &somatikk ne 0 %then %do;
InnTid
%end;
InstitusjonId
KoblingsID
KomNr
%if &somatikk ne 0 %then %do;
korrvekt
liggetid
%end;
ncmp:
ncsp:
%if &somatikk ne 0 %then %do;
ncrp:
%end;
NPRId_reg
%if &somatikk ne 0 %then %do;
opphold_id
%end;
%if &avtspes ne 0 %then %do;
Normaltariff:
%end;
PID
%if &somatikk ne 0 %then %do;
polUtforende_1
%end;
%if &avtspes ne 0 %then %do;
SpesialistKomHN
Tdiag:
%end;
Utdato
%if &somatikk ne 0 %then %do;
UtTid
utTilstand
versjon
%end;
%if &avtspes ne 0 %then %do;
fag_skde
Komplett
AvtaleRHF
%end;
;
format koblingsID 32.;
run;


Data &UtdatasettTO;
retain aar koblingsId;
set &Inndatasett;
keep
KoblingsID
aar
%if &somatikk ne 0 %then %do;
aggrshoppID
Aktivitetskategori
Aktivitetskategori2
Aktivitetskategori4
alderIDager
avdOpp_id
behandlingsstedKode
behandlingsstedLokal
behandlingsstedReshID
bydel_DSF
cyto:
dag_kir
DRGtypeHastegrad
fagenhetKode
fagenhetLokal
fagenhetReshID
fagomrade
fodselsAar_ident
fodselsvekt
fodt_mnd
g_omsorgsniva
henvType
inntilstand
institusjonID_original
isf_opphold
kjonn_ident
komNrHjem_DSF
bydel_DSF
komp_drg
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
%end;
ATC:
EmigrertDato
ICD10KatBlokk
bydel2
innmateHast
kjonn
komnrHjem2
kontaktType
stedAktivitet
TilSted
debitor
%if &avtspes ne 0 %then %do;
Fag
fagLogg
hjemmelstr
kontakt
tell:
AvtSpesKomHN
fodselsAar_ident09052017
fodt_mnd_ident09052017
kjonn_ident09052017
ulikt_kjonn
%end;
;
format koblingsID 32.;
run;

%Mend Splitte;

