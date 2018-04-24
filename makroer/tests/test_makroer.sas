%macro test_makroer(branch=master);
/*!
Makro som skal teste de andre makroene.

Tester for øyeblikket kun makroene
- `Episode_of_care`
- `reinnleggelser`
*/


%let filbane=\\tos-sas-skde-01\SKDE_SAS\;

%include "&filbane.makroer\&branch.\tests\episode_of_care_test.sas";
%episode_of_care_test(branch=&branch);

%include "&filbane.makroer\&branch.\tests\reinnleggelser_test.sas";
%reinnleggelser_test(branch=&branch);


%mend;