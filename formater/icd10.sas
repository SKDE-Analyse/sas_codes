/* Makroen lager formater basert p� SAS-datasett lokalisert p� mappen HNREF */
/* SAS-datasett p� HNREF er lagd ut fra CSV-filen 'ICD10.csv', se: ../formater/icd10_csv_fmtfil.sas. */
/* Sist endret: Tove 21.06.2021 */
proc format cntlin=hnref.fmtfil_icd10; run;