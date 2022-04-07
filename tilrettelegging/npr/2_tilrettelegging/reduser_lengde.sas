%macro reduser_lengde(innDataSett=, utDataSett=);

/*!

Makro for � redusere st�rrelsen p� variabler i datasettet.

Opprinnelig har alle variablene en st�rrelse p� 8 byte. 
De fleste variablene trenger ikke okkupere s� mye plass.

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
length inndato: utdato: doddato /*emigrertDato*/ epikrisedato /*individuellplandato mottaksdato*/ sluttdato /*tildeltdato utskrklardato utskrklardato2*/ /*ventetidsluttdato ventetidsluttkode vurddato*/ KomNr 4;
length institusjonID  6;
length NPRId_reg stedAktivitet 4;
*length tell_: 4;
length pid 6;
*length dodDato_DSF emigrertDato_DSF 4;
length /*hastegrad polIndir*/ omsorgsniva  liggetid: 4;
length InnTid  4;
length UtTid 5;

%if &somatikk ne 0 %then %do;
length behhf behrhf behsh 4;


length alderIDager UtskrKlarDato 4;
length behandlingsstedKode: 6;
length tjenesteenhetlokal $102;
length drg $4;
length DRGtypeHastegrad 3;
/* length fodselsAar_ident 3; */
length fodselsvekt 4;
length /*fodt_mnd*/ g_omsorgsniva hastegrad hdg henvType 3;
length inntilstand /*intern_kons isf_opphold*/  4;
/* length institusjonID_original 6; */
length  /*pakkeforlop*/ permisjonsdogn aktivitetskategori /*polIndirekteAktivitet*/ polUtforende_1 /*polUtforende_2*/ RehabType 4;
/* length relatertKontaktID 6; */
length trimpkt /*utforendeHelseperson*/ utTilstand /* VertskommHN*/ 4;

%end;

%if &avtspes ne 0 %then %do;
length ald_gr: 3;
%end;

%if &sektor = REHAB %then %do;
length behhf behrhf behsh 4;
length liggetid permisjonsdogn 4;

%end;

set &innDataSett;
format koblingsID 32.;

run;

%mend reduser_lengde;





