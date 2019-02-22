%macro Episode_of_care_test(branch=null, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste EoC-makro.

Kjører EoC-makroen på et test-datasett (test.pseudosens_avd_magnus) med ulike parametre.
Sammenligner datasettene som spyttes ut med referanse-sett (test.ref_eoc[n]).

## input

- `branch` (=master) Valg av mappe der makroen ligger.
- `debug` (=0) Ikke slette midlertidige datasett hvis ulik null.
- `lagNyRef` (=0) Lagre ny referanse på disk hvis ulik null.

*/

/* Definere filbane */
%let filbane = %definer_filbane(branch = &branch);

%include "&filbane\makroer\episode_of_care.sas";

%if &lagNyStart ne 0 %then %do;
/*
Hente pseudosensitivt datasett
*/
data test.eoc_startsett;
set test.pseudosens_avd_magnus (drop = Bdiag: drg drg_type episodeFag Hdiag: ICD10Kap  InstitusjonId KoblingsID korrvekt ncmp: ncsp: ncrp: polUtforende_1);
run;
%end;

/*
Sjekk at det er trygt å kjøre EoC makroen flere ganger etter hverandre
*/

data eoc1;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc1);

%sammenlignData(fil = eoc1, lagReferanse = &lagNyRef);

%episode_of_care(dsn=eoc1);

%sammenlignData(fil = eoc1, lagReferanse = 0);

%episode_of_care(dsn=eoc1);

%sammenlignData(fil = eoc1, lagReferanse = 0);

/*
Sjekk forste_hastegrad = 0
*/

data eoc2;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc2, forste_hastegrad = 0);

%sammenlignData(fil = eoc2, lagReferanse = &lagNyRef);

/*
Sjekk at inntid og uttid er korrekt
*/

data eoc3;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc3, behold_datotid = 1);

%sammenlignData(fil = eoc3, lagReferanse = &lagNyRef);

/*
Teste det å nulle liggedøgn for dag og poliklinikk
*/

data eoc4;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc4, nulle_liggedogn = 1);

%sammenlignData(fil = eoc4, lagReferanse = &lagNyRef);

/*
Teste det å ikke aggregere poliklinikk i EoC (separer_ut_poli ne 0)
*/

data eoc5;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc5, separer_ut_poli = 1);

%sammenlignData(fil = eoc5, lagReferanse = &lagNyRef);


/*
Test av bug i "separer_ut_poli = 1". Vil ikke fungere før issue #52 (https://github.com/SKDE-Analyse/sas_codes/issues/52) er fikset.
*/

data eoc6;
set test.eoc_poli;
run;

%episode_of_care(dsn=eoc6, separer_ut_poli = 1);

%sammenlignData(fil = eoc6, lagReferanse = &lagNyRef);

/*
Teste inndeling = 1 
*/

data eoc7a;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc7a, inndeling = 1);

%sammenlignData(fil = eoc7a, lagReferanse = &lagNyRef);

/*
Teste inndeling = 2
*/

data eoc7b;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc7b, inndeling = 2);

%sammenlignData(fil = eoc7b, lagReferanse = &lagNyRef);

/*
Teste inndeling = 3
*/

data eoc7c;
set test.eoc_startsett;
run;

%episode_of_care(dsn=eoc7c, inndeling = 3);

%sammenlignData(fil = eoc7c, lagReferanse = &lagNyRef);

%if &debug eq 0 %then %do;
proc delete data = eoc1 eoc2 eoc3 eoc4 eoc5 eoc6 eoc7a eoc7b eoc7c;
%end;

%mend;
