/* Makroen lager formater basert p� SAS-datasett lokalisert p� mappen HNREF */
/* SAS-datasettene p� HNREF er lagd ut fra CSV-filen 'boomr.csv', se: ../formater/bo_csv_fmtfil.sas. */
/* Sist endret: Janice 17.06.2021 */
proc format cntlin=hnref.fmtfil_boshhn; run;
proc format cntlin=hnref.fmtfil_bohf;   run;
proc format cntlin=hnref.fmtfil_bosh;   run;
proc format cntlin=hnref.fmtfil_borhf;  run;
proc format cntlin=hnref.fmtfil_bydel;  run;
proc format cntlin=hnref.fmtfil_komnr;  run;
