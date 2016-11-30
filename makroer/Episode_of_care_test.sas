%macro Episode_of_care_test(branch=master);

data testset;
set npr_utva.eoc_kontroll;
keep inndato utdato aktivitetskategori3 liggetid hastegrad uttid inntid pid;
run;

%include "&filbane.makroer\&branch.\episode_of_care.sas";

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

data testset;
set testset;
drop pid eoc_id;
run;

proc compare base=skde_arn.eoc_ref compare=testset BRIEF WARNING LISTVAR;

proc delete data = testset;

%mend;
