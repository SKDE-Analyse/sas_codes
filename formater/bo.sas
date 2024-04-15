/* Makroen lager formater basert på SAS-datasett lokalisert på mappen HNREF */
/* SAS-datasettene på HNREF er lagd ut fra CSV-filen 'boomr.csv', se: ../formater/bo_csv_fmtfil.sas. */
/* Sist endret: Janice 17.06.2021 */
proc format cntlin=hnref.fmtfil_boshhn; run;
proc format cntlin=hnref.fmtfil_bohf;   run;
proc format cntlin=hnref.fmtfil_borhf;  run;
proc format cntlin=hnref.fmtfil_bydel;  run;
proc format cntlin=hnref.fmtfil_komnr;  run;
proc format cntlin=hnref.fmtfil_bodps;  run;