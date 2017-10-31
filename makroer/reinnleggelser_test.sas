%macro reinnleggelser_test(branch=master);

/*!
Makro for å teste reinnleggelse-makro.

Kjører reinnleggelse-makroen på et test-datasett (npr_utva.ctrl_reinn).
Sammenligner dette datasettet med en referanse (skde_arn.ref_reinn1 og 2).
*/

data testset1;
set npr_utva.ctrl_reinn;
run;

data testset2;
set npr_utva.ctrl_reinn;
run;

%include "&filbane.makroer\&branch.\reinnleggelser.sas";

%reinnleggelser(dsn=testset1, eks_diag=1);

%reinnleggelser(dsn=testset2);

data testset1;
set testset1;
drop pid eoc_id doddato emigrertdato hdiag hdiag2;
run;

proc compare base=skde_arn.ref_reinn1 compare=testset1 BRIEF WARNING LISTVAR;

data testset2;
set testset2;
drop pid eoc_id doddato emigrertdato hdiag hdiag2;
run;

proc compare base=skde_arn.ref_reinn2 compare=testset2 BRIEF WARNING LISTVAR;

proc delete data = testset1 testset2;

%mend;
