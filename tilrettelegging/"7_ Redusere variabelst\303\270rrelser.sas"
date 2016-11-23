%macro reduser_lengde(innDataSett=, utDataSett=);

data &utDataSett;
set &innDataSett;

length ncmp: $6;
length ncsp: $6;
length cyto_: $6; 

length bohf borhf boshhn fylke 3;
length bydel 6;
length behhf behrhf behsh 3;
length hdiag hdiag2 $6;
length bdiag: $5;
length hdiag3tegn $3;
length aar hastegrad aktivitetskategori: 3;

length aggrshoppID 5;
length ald_gr: 3;
length alderIDager 3;
length behandlingsstedKode: 6;
length debitor 3;
length DodDato emigrertdato 4;
length drg $4;
length drg_type $1;
length DRGtypeHastegrad 3;
length ErMann 3;
length fodselsar_ident 3;
length fodselsar 4;
length fodselsvekt 4;
length fodt_mnd_ident g_omsorgsniva hastegrad hdg henvType ICD10Kap: 3;
length innmateHast inntilstand intern_kons isf_opphold kjonn kjonn_ident kontaktType liggetid 3;
length inndato utdato InnTid KomNr 4;
length institusjonID InstitusjonId_omkodet institusjonID_original 6;
length NPRId_reg omsorgsniva oppholdstype pakkeforlop permisjonsdogn polIndir polIndirekteAktivitet polUtforende_1 polUtforende_2 RehabType stedAktivitet 3;
length tell_: 3;
length pid relatertKontaktID 5;
length trimpkt utforendeHelseperson utTilstand VertskommHN 3;
length versjon $6;
length UtTid 4;

run;

%mend reduser_lengde;





