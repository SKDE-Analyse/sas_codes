
%macro csv_filer;  /*hente inn CSV-filer med komnr og bydeler*/

	%macro read_csv;
		%let datamappe = \\tos-sas-skde-01\SKDE_SAS\felleskoder\boomr\data;  /*boomr må endres til master når branchen tas inn i  master*/
		proc import datafile = "&datamappe.\&datafil"
		DBMS = csv OUT = &utdata replace;
		getnames=YES;
		run;
	%mend;

%let datafil=forny_komnr.csv; 
%let sheetnavn=ark1;
%let utdata = komnr; /*Gir eldre komnr nytt og gyldig komnr pr 1.1.20202*/
%read_csv
%let datafil=forny_bydel.csv; 
%let sheetnavn=ark1;
%let utdata = bydel; /*Gir eldre bydelsnr nytt og gyldig bydelsnr pr 1.1.2020*/
%read_csv
%let datafil=boomr_2020.csv; 
%let sheetnavn=ark1;
%let utdata = boomr; /*Opptaksområder pr 1.1.2020*/
%read_csv


/*csv-fil med gyldige komnr - slår sammen filene 'komnr' og 'boomr' for å få fullstendig liste med alle komnr */
data gyldig_komnr(keep=komnr2);
set komnr(rename=(gml_komnr=g_komnr)) boomr(rename=(komnr=g_komnr)); /*Gi variabel komnr likt navn*/
komnr2=input(g_komnr,best4.); /*fikse til numerisk*/
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_komnr nodupkey out=liste_komnr;
by komnr2;
run;

/*csv-fil med gyldige bydeler - slår sammen filene 'bydel' og 'boomr' for å få fullstendig liste med alle bydeler*/
data gyldig_bydel(keep=bydel2);
set bydel(rename=(fra_bydel=g_bydel)) boomr(rename=(bydel=g_bydel)); /*Gi variabel bydel likt navn*/
bydel2=input(g_bydel,best6.); /*fikse til numerisk*/
run;

/*fjerne duplikate linjer*/
proc sort data=gyldig_bydel nodupkey out=liste_bydel;
by bydel2;
run;

/* Fjerne linje med bydel missing */
data liste_bydel;
set liste_bydel;
if bydel2 = . then delete;
run;
%mend;

%csv_filer;



%macro kontroll_komnr(inndata=, komnr=, bydel=, aar=);  /*kontrollere om mottatte data har gyldig komnr og bydel*/

/*hente ut variabel 'komnrhjem2' og 'bydel2' fra mottatte data*/
proc sql;
	create table mottatt_komnr as
	select distinct &komnr, &bydel 
	from &inndata;
quit;

/*lage bydel-variabel med seks siffer*/
data mottatt_bydel;
set mottatt_komnr;
if &bydel in (1:9) then bydel = cats(&komnr,'0',&bydel);
else if &bydel in (10:99) then bydel = cats(&komnr, &bydel);
else if &bydel eq . then bydel = .;
run;

/*sortere og laga datasett til kontroll*/
proc sort data=mottatt_komnr(keep=&komnr); by &komnr; run;
proc sort data=mottatt_bydel; by bydel; run;

/*fjerne linje med bydel2 = 0*/
data mottatt_bydel;
set mottatt_bydel;
if &bydel = 0 then delete;
run;

/*sammenligne komnr med csv-fil ved bruk av merge*/
/* Output-fil 'error' vil inneholde ugyldige komnr i mottatte data */
data godkjent_komnr_&aar error_komnr_&aar;
merge mottatt_komnr (in=a) liste_komnr (in=b);
if a and b then felles = 1;
if a and not b then feil = 1;
if felles then output godkjent_komnr_&aar;
if feil then output error_komnr_&aar;
run;

/*sammenligne bydel med csv-fil ved bruk av merge*/
/* Output-fil 'error' vil inneholde ugyldige bydelsnr i mottatte data */
data godkjent_bydel_&aar(drop=&bydel) error_bydel_&aar;
merge mottatt_bydel (in=a) liste_bydel (in=b);
if a and b then felles = 1;
if a and not b then feil = 1;
if felles then output godkjent_bydel_&aar;
if feil then output error_bydel_&aar;
run;
%mend;


/*input til makro er mottatt datasett og navn på komnr og bydel i datasettet*/
%kontroll_komnr(inndata=hnmot.m20_avd_2016, komnr=komnrhjem2, bydel=bydel2, aar=avd2016);
%kontroll_komnr(inndata=hnmot.m20_avd_2017, komnr=komnrhjem2, bydel=bydel2, aar=avd2017);
%kontroll_komnr(inndata=hnmot.m20_avd_2018, komnr=komnrhjem2, bydel=bydel2, aar=avd2018);
%kontroll_komnr(inndata=hnmot.m20_avd_2019, komnr=komnrhjem2, bydel=bydel2, aar=avd2019);
%kontroll_komnr(inndata=hnmot.m20_avd_2020_nov, komnr=komnrhjem2, bydel=bydel2, aar=avd2020);

/*Denne kontrollerer at mottatte data inneholder gyldige komrn og bydel*/
/*Den sier ikke noe om det er løpenr ifeks Oslo 0301 som mangler bydel*/