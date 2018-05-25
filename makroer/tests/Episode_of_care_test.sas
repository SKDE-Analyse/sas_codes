%macro Episode_of_care_test(branch=master, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste EoC-makro.

Kjører EoC-makroen på et test-datasett (skde_tst.pseudosens_avd_magnus) med ulike parametre.
Sammenligner datasettene som spyttes ut med referanse-sett (skde_tst.ref_eoc[n]).

## input

- `branch` (=master) Valg av mappe der makroen ligger.
- `debug` (=0) Ikke slette midlertidige datasett hvis ulik null.
- `lagNyRef` (=0) Lagre ny referanse på disk hvis ulik null.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\makroer\&branch.\episode_of_care.sas";


%if &lagNyStart ne 0 %then %do;
/*
Hente pseudosensitivt datasett
*/
data skde_tst.eoc_startsett;
set skde_tst.pseudosens_avd_magnus (drop = Bdiag: drg drg_type episodeFag Hdiag: ICD10Kap  InstitusjonId KoblingsID korrvekt ncmp: ncsp: ncrp: polUtforende_1);
run;
%end;

/*
Sjekk at det er trygt å kjøre EoC makroen flere ganger etter hverandre
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc1;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc1 compare=testset BRIEF WARNING LISTVAR;

/*
Sjekk forste_hastegrad = 0
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, forste_hastegrad = 0);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc2;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc2 compare=testset BRIEF WARNING LISTVAR;

/*
Sjekk at inntid og uttid er korrekt
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, behold_datotid = 1);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc3;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc3 compare=testset BRIEF WARNING LISTVAR;

/*
Teste det å nulle liggedøgn for dag og poliklinikk
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, nulle_liggedogn = 1);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc4;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc4 compare=testset BRIEF WARNING LISTVAR;


/*
Teste det å ikke aggregere poliklinikk i EoC (separer_ut_poli ne 0)
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, separer_ut_poli = 1);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc5;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc5 compare=testset BRIEF WARNING LISTVAR;


/*
Teste kols = 1
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, kols = 1);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc6;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc6 compare=testset BRIEF WARNING LISTVAR;


/*
Teste inndeling = 1 
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, inndeling = 1);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc7a;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc7a compare=testset BRIEF WARNING LISTVAR;


/*
Teste inndeling = 2
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, inndeling = 2);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc7b;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc7b compare=testset BRIEF WARNING LISTVAR;


/*
Teste inndeling = 3
*/

data testset;
set skde_tst.eoc_startsett;
run;

%episode_of_care(dsn=testset, inndeling = 3);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_eoc7c;
set testset;
run;
%end;

proc compare base=skde_tst.ref_eoc7c compare=testset BRIEF WARNING LISTVAR;


%if &debug eq 0 %then %do;
proc delete data = testset startsett;
%end;

%mend;
