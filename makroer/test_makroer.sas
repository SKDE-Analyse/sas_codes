%macro test_makroer(branch=main, lagNyRef = 0, lagNyStart = 0);
/*!
Makro som skal teste de andre makroene.

Tester for øyeblikket makroene
- `Episode_of_care`
- `reinnleggelser`
- `boomraader`
- `aggreger`
- `unik_pasient`
- `hyppigste`

*/

%include "&filbane/makroer/tests/episode_of_care_test.sas";
%episode_of_care_test(branch=&branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);

%include "&filbane/makroer/tests/reinnleggelser_test.sas";
%reinnleggelser_test(branch=&branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);

%include "&filbane/makroer/tests/boomraader_test.sas";
%boomraader_test(branch=&branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);

%include "&filbane/makroer/tests/aggreger_test.sas";
%aggreger_test(branch=&branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);

%include "&filbane/makroer/tests/unik_pasient_test.sas";
%unik_pasient_test(branch = &branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);

%include "&filbane/makroer/tests/hyppigste_test.sas";
%hyppigste_test(branch = &branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);

%mend;