%macro Episode_of_care_test(branch=master);

/*
Makro for å teste EoC-makro.

Kjører EoC-makroen tre ganger etter hverandre på et test-datasett (npr_utva.ctrl_eoc).
Sammenligner dette datasettet med en referanse (skde_arn.ref_eoc).
*/

data testset;
set npr_utva.ctrl_eoc;
keep aar inndato utdato aktivitetskategori3 liggetid hastegrad uttid inntid pid;
run;

%include "&filbane.makroer\&branch.\episode_of_care.sas";

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

data testset;
set testset;
drop pid eoc_id;
run;

proc compare base=skde_arn.ref_eoc compare=testset BRIEF WARNING LISTVAR;

proc delete data = testset;

%mend;
