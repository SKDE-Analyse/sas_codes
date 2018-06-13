%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);

%include "&filbane.Formater\master\Bo.sas";
%include "&filbane.Formater\master\Beh.sas";
%include "&filbane.Formater\master\KomNr.sas";
%include "&filbane.Formater\master\NPR_AvtSpes.sas";
%include "&filbane.Formater\master\NPR_somatikk.sas";
%include "&filbane.Formater\master\SKDE_somatikk.sas";

/* ICD-10*/
%include "&filbane.Formater\master\icd10.sas";
%include "&filbane.Formater\master\hdiag3tegn.sas";

/*NCMP*/
%include "&filbane.Formater\master\ncmp.sas";

/*NCSP*/
%include "&filbane.Formater\master\ncsp.sas";

/*NCSP*/
%include "&filbane.Formater\master\ncrp.sas";

/*DRG*/
%include "&filbane.Formater\master\drg.sas";
