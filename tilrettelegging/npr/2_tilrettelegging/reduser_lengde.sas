%macro reduser_lengde(innDataSett=, utDataSett=);

/*!

Makro for å redusere størrelsen på variabler i datasettet.

Opprinnelig har alle variablene en størrelse på 8 byte. 
De fleste variablene trenger ikke okkupere så mye plass.

*/

data &utDataSett;

length ncmp: $7;
length ncsp: $7;
*length cyto_: $7; 
length debitor 3;
length bohf borhf boshhn fylke 4;
length bydel 6;
length hdiag3tegn $3;
length hdiag $6;
length aar 4;
length ErMann 3;
length fodselsar 4;
length ICD10Kap: 3;
length innmateHast kjonn kontaktType 4;
length inndato: utdato: doddato /*emigrertDato*/ epikrisedato  /*utskrklardato utskrklardato2*/ KomNr 4;
length institusjonID  6;
length NPRId_reg stedAktivitet 4;
*length tell_: 4;
length pid 6;
*length dodDato_DSF emigrertDato_DSF 4;
length polIndir omsorgsniva liggetid 4;
length InnTid  4;
length UtTid 5;

%if &somatikk ne 0 %then %do;
length behhf behrhf behsh 4;
length individuellplandato mottaksdato sluttdato tildeltdato ventetidsluttdato ventetidsluttkode vurddato  4;
length atc_5 $8;
length takst_5 $5;
length alderIDager UtskrKlarDato liggetid_org 4;
length behandlingsstedKode: 6;
length tjenesteenhetlokal $102;
length drg $4;
length DRGtypeHastegrad hastegrad 3;
/* length fodselsAar_ident 3; */
length fodselsvekt 4;
length /*fodt_mnd*/ g_omsorgsniva hdg henvType 3;
length inntilstand /*intern_kons isf_opphold*/  4;
/* length institusjonID_original 6; */
length  /*pakkeforlop*/ permisjonsdogn aktivitetskategori /*polIndirekteAktivitet*/ polUtforende_1 /*polUtforende_2*/ RehabType 4;
/* length relatertKontaktID 6; */
length trimpkt /*utforendeHelseperson*/ utTilstand /* VertskommHN*/ 4;
length takst_11 takst_12 takst_13 takst_14 takst_15 $4.;
%end;

%if &sektor = REHAB %then %do;
length behhf behrhf behsh 4;
length liggetid permisjonsdogn 4;
%end;

set &innDataSett;
*format koblingsID 32.;
run;

%mend reduser_lengde;





