%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);

/*%include "&filbane.Formater\Standardformater_2015\Format_2015_SKDE.sas";*/
/*%include "&filbane.Formater\Standardformater_2015\Format_Bo_2015.sas";*/
/*%include "&filbane.Formater\Standardformater_2015\Formatkomnr2015.sas";*/
/*%include "&filbane.Formater\Standardformater_2015\Format_2015_behSh_behandlingsstedKode2.sas";*/
/*%include "&filbane.Formater\Standardformater_2015\Format_SOM_2015.sas";*/

%include "&filbane.Formater\master\Bo.sas";
%include "&filbane.Formater\master\Beh.sas";
%include "&filbane.Formater\master\KomNr.sas";
%include "&filbane.Formater\master\NPR_somatikk.sas";
%include "&filbane.Formater\master\SKDE_somatikk.sas";

/* ICD-10*/

%include "&filbane.Formater\master\ICD10\icd10_2015.sas";
%include "&filbane.Formater\master\ICD10\icd10_2014.sas";
%include "&filbane.Formater\master\ICD10\icd10_2013.sas";
%include "&filbane.Formater\master\ICD10\icd10_2012.sas";

/*NCMP*/
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2015.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2014.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2013.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2012.sas";

/*NCSP*/
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2015.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2014.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2013.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2012.sas";

/*DRG*/
%include "&filbane.Formater\master\DRG\DRG_2016.sas";
%include "&filbane.Formater\master\DRG\DRG_2015.sas";
%include "&filbane.Formater\master\DRG\DRG_2014.sas";
%include "&filbane.Formater\master\DRG\DRG_2013.sas";
%include "&filbane.Formater\master\DRG\DRG_2012.sas";
