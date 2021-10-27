/* Makroen lager formater basert p� SAS-datasett lokalisert p� mappen HNREF */
/* SAS-datasettene p� HNREF er lagd ut fra CSV-filen 'behandler.csv', se: ../formater/beh_csv_fmtfil.sas. */
/* Sist endret: Janice 17.06.2021 */
proc format cntlin=hnref.fmtfil_behsh; run;
proc format cntlin=hnref.fmtfil_behhf; run;
proc format cntlin=hnref.fmtfil_behhfkort; run;
proc format cntlin=hnref.fmtfil_behrhf; run;
proc format cntlin=hnref.fmtfil_rhfkort; run;
proc format cntlin=hnref.fmtfil_rhfkortest; run;
proc format cntlin=hnref.fmtfil_orgnr; run;