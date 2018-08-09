%macro test_rateprogram(branch = );

/*!
Makro for å teste rateprogrammet.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch\rateprogram\tests\tests.sas";

%test1(branch = &branch);

%test2(branch = &branch);

%mend;


