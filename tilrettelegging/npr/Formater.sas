%let filbane=\\tos-sas-skde-01\SKDE_SAS\saskoder\master\;
options sasautos=("&filbane.makroer" SASAUTOS);

%include "&filbane.Formater\Bo.sas";
%include "&filbane.Formater\Beh.sas";
%include "&filbane.Formater\KomNr.sas";
%include "&filbane.Formater\NPR_AvtSpes.sas";
%include "&filbane.Formater\NPR_somatikk.sas";
%include "&filbane.Formater\SKDE_somatikk.sas";

/* ICD-10*/
%include "&filbane.Formater\icd10.sas";
%include "&filbane.Formater\hdiag3tegn.sas";

/*NCMP*/
%include "&filbane.Formater\ncmp.sas";

/*NCSP*/
%include "&filbane.Formater\ncsp.sas";

/*NCSP*/
%include "&filbane.Formater\ncrp.sas";

/*DRG*/
%include "&filbane.Formater\drg.sas";
