%let filbane=\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Data\SAS\;
options sasautos=("&filbane.Makroer\SASAUTOS" SASAUTOS);
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
%include "&filbane.Formater\master\ICD10\icd10_2011.sas";

/*NCMP*/
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2015.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2014.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2013.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2012.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCMP_2011.sas";

/*NCSP*/
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2015.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2014.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2013.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2012.sas";
%include "&filbane.Formater\master\Prosedyrekoder\NCSP_2011.sas";

/*DRG*/
%include "&filbane.Formater\master\DRG\DRG_2015.sas";
%include "&filbane.Formater\master\DRG\DRG_2014.sas";
%include "&filbane.Formater\master\DRG\DRG_2013.sas";
%include "&filbane.Formater\master\DRG\DRG_2012.sas";
%include "&filbane.Formater\master\DRG\DRG_2011.sas";