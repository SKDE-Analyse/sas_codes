/* formater til bo, beh og komnr og bydel */
%include "&filbane\formater\bo.sas";

/* formater til behandler og orgnr */
%include "&filbane\formater\beh.sas";

%include "&filbane\formater\NPR_AvtSpes.sas";
%include "&filbane\formater\NPR_somatikk.sas";
%include "&filbane\formater\SKDE_somatikk.sas";

/* ICD-10*/
%include "&filbane\formater\hdiag3tegn.sas";
%include "&filbane\formater\icd10.sas";

/*NCMP*/
%include "&filbane\formater\ncmp.sas";

/*NCSP*/
%include "&filbane\formater\ncsp.sas";

/*NCSP*/
%include "&filbane\formater\ncrp.sas";

/*DRG*/
%include "&filbane\formater\drg.sas";

/* HENVFRAINSTITUSJONID */
%include "&filbane\formater\NPR_henvFra_henvTil.sas";


