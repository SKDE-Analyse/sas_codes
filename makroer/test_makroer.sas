%macro test_makroer(branch=master);

%let filbane=\\tos-sas-skde-01\SKDE_SAS\;

%include "&filbane.Formater\master\SKDE_somatikk.sas";
%include "&filbane.Formater\master\NPR_somatikk.sas";
%include "&filbane.Formater\master\bo.sas";
%include "&filbane.Formater\master\beh.sas";


%include "&filbane.makroer\&branch.\episode_of_care_test.sas";
%episode_of_care_test(branch=&branch);

%include "&filbane.makroer\&branch.\reinnleggelser_test.sas";
%reinnleggelser_test(branch=&branch);


%mend;