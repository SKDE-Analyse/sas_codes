/* Makroen lager formater basert på SAS-datasett lokalisert på mappen HNREF */
/* SAS-datasett på HNREF er lagd ut fra CSV-filen 'ICD10.csv', se: ../formater/icd10_csv_fmtfil.sas. */
/* Sist endret: Tove 21.06.2021 */
proc format cntlin=hnref.fmtfil_icd10; run;