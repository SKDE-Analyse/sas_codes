%macro reduser_lengde(innDataSett=, utDataSett=);

/*!

Makro for å redusere størrelsen på variabler i datasettet.

Opprinnelig har alle variablene en størrelse på 8 byte. 
De fleste variablene trenger ikke okkupere så mye plass.

*/

data &utDataSett;


length ncmp: $7;
length ncsp: $7;
length cyto_: $7; 

length bohf borhf boshhn fylke 4;
length bydel 6;
%if &somatikk ne 0 %then %do;
length behhf behrhf behsh 4;
%end;
length hdiag3tegn $3;
length aar 4;
length ErMann 3;
length fodselsar 4;
length ICD10Kap: 3;
length innmateHast kjonn kontaktType 4;
length inndato utdato KomNr 4;
length institusjonID  6;
length NPRId_reg stedAktivitet 4;
length tell_: 4;
length pid 6;

%if &somatikk ne 0 %then %do;
length hastegrad aktivitetskategori: 4;

length aggrshoppID 5;
length alderIDager 4;
length behandlingsstedKode: 6;
length debitor 3;

length drg $4;
length DRGtypeHastegrad 3;
length fodselsAar_ident 3;
length fodselsvekt 4;
length fodt_mnd g_omsorgsniva hastegrad hdg henvType 3;
length inntilstand intern_kons isf_opphold liggetid 4;
length InnTid UtskrKlarDato 4;
length institusjonID_original 6;
length omsorgsniva pakkeforlop permisjonsdogn polIndir polIndirekteAktivitet polUtforende_1 polUtforende_2 RehabType 4;
length relatertKontaktID 6;
length trimpkt utforendeHelseperson utTilstand VertskommHN 4;
length UtTid 5;
%end;
%if &avtspes ne 0 %then %do;
length ald_gr: 3;
%end;

set &innDataSett;
format koblingsID 32.;

run;

%mend reduser_lengde;





