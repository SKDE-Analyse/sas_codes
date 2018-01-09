%macro reduser_lengde(innDataSett=, utDataSett=);

data &utDataSett;
set &innDataSett;

length ncmp: $7;
length ncsp: $7;
length cyto_: $7; 

length bohf borhf boshhn fylke 4;
length bydel 6;
length behhf behrhf behsh 4;
length hdiag hdiag2 $7;
length bdiag: $7;
length hdiag3tegn $3;
length aar hastegrad aktivitetskategori: 4;

length aggrshoppID 5;
length alderIDager 4;
length behandlingsstedKode: 6;
length debitor 3;

length drg $4;
length drg_type $1;
length DRGtypeHastegrad 3;
length ErMann 3;
length fodselsAar_ident 3;
length fodselsar 4;
length fodselsvekt 4;
length fodt_mnd g_omsorgsniva hastegrad hdg henvType ICD10Kap: 3;
length innmateHast inntilstand intern_kons isf_opphold kjonn kjonn_ident kontaktType liggetid 4;
length inndato utdato InnTid KomNr UtskrKlarDato 4;
length institusjonID institusjonID_original 6;
length NPRId_reg omsorgsniva oppholdstype pakkeforlop permisjonsdogn polIndir polIndirekteAktivitet polUtforende_1 polUtforende_2 RehabType stedAktivitet 4;
length tell_: 4;
length pid relatertKontaktID 6;
length trimpkt utforendeHelseperson utTilstand VertskommHN 4;
length versjon $7;
length UtTid 5;

format koblingsID 32.;

run;

%mend reduser_lengde;





