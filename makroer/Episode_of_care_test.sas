%macro Episode_of_care_test(branch=master, debug = 0);

/*
Makro for å teste EoC-makro.

Kjører EoC-makroen tre ganger etter hverandre på et test-datasett (npr_utva.ctrl_eoc).
Sammenligner dette datasettet med en referanse (skde_arn.ref_eoc).
*/

%include "&filbane.makroer\&branch.\episode_of_care.sas";

data testset;
set npr_utva.ctrl_eoc;
run;

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

%episode_of_care(dsn=testset);

data testset;
set testset;
drop pid eoc_id;
run;

proc compare base=skde_arn.ref_eoc compare=testset BRIEF WARNING LISTVAR;

data testset;
set npr_utva.ctrl_eoc;
run;

%episode_of_care(dsn=testset, forste_hastegrad = 0);

data testset;
set testset;
drop pid eoc_id;
run;

proc compare base=skde_arn.ref_eoc2 compare=testset BRIEF WARNING LISTVAR;

data testset;
set npr_utva.ctrl_eoc;
run;

%episode_of_care(dsn=testset, behold_datotid = 1);

data testset;
set testset;
drop pid eoc_id;
run;

proc compare base=skde_arn.ref_eoc3 compare=testset BRIEF WARNING LISTVAR;

data testset;
set npr_utva.ctrl_eoc;
run;

%episode_of_care(dsn=testset, nulle_liggedogn = 1);

data testset;
set testset;
drop pid eoc_id;
run;

proc compare base=skde_arn.ref_eoc4 compare=testset BRIEF WARNING LISTVAR;


%if &debug eq 0 %then %do;
proc delete data = testset;
%end;

%mend;
