
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
%let utdata = komnr;
%read_csv
%let datafil=forny_bydel.csv;
%let sheetnavn=ark1;
%let utdata = bydel;
%read_csv
%let datafil=boomr_2020.csv;
%let sheetnavn=ark1;
%let utdata = boomr;
%read_csv


/*csv-fil med gyldige komnr */
data gyldig_komnr(keep=komnr2);
set komnr(rename=(gml_komnr=g_komnr)) boomr(rename=(komnr=g_komnr));
komnr2=input(g_komnr,best4.);
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_komnr nodupkey out=liste_komnr;
by komnr2;
run;

/*csv-fil med gyldige bydeler*/
data gyldig_bydel(keep=bydel);
set bydel(rename=(fra_bydel=g_bydel)) boomr(rename=(bydel=g_bydel));
bydel=input(g_bydel,best6.); /*endre ti lnumerisk*/
run;

/*fjerne duplikate linjer*/
proc sort data=gyldig_bydel nodupkey out=liste_bydel;
by bydel;
run;

/*fjerne linje med missing bydel*/
data liste_bydel;
set liste_bydel;
if bydel = . then delete;
run;
%mend;

%csv_filer;



%macro kontroll_komnr(inndata=, komnr=, bydel=, aar=);  /*kontrollere om mottatte data har gyldig komnr*/

/*hente ut komnrhjem2 fra mottatte data*/
proc sql;
	create table mottatt_komnr as
	select distinct &komnr, &bydel
	from &inndata;
quit;

/*lage bydel-variabel*/
data mottatt_bydel(keep=&komnr bydel);
set mottatt_komnr;
if &bydel in (1:9) then bydel_fix = cats(&komnr,'0', &bydel);
else if &bydel in (10:99) then bydel_fix = cats(&komnr, &bydel);
else if &bydel eq . then bydel_fix = .;
bydel = input(bydel_fix, best6.); /*endre til numerisk*/
run;

/*sortere og laga datasett til kontroll*/
proc sort data=mottatt_komnr(rename=(&komnr=komnr2) keep=&komnr); by komnr2; run;
proc sort data=mottatt_bydel(keep=bydel); by bydel; run;

/*fjerne linje med bydel2 = 0*/
data mottatt_bydel;
set mottatt_bydel;
if bydel = . then delete;
run;

/*sammenligne mottatte komnr med csv-fil*/
/*Outputfiler 'error' inneholder komnr i mottatte data som ikke er i vår liste med godkjente komnr*/
data godkjent_komnr_&aar error_komnr_&aar;
merge mottatt_komnr (in=a) liste_komnr (in=b);
by komnr2;
if a and b then felles = 1;
if a and not b then feil = 1;
if felles then output godkjent_komnr_&aar;
if feil then output error_komnr_&aar;
run;

/*sammenligne bydel med csv-fil*/
/*Outputfiler 'error' inneholder bydel i mottatte data som ikke er i vår liste med godkjente bydeler*/
data godkjent_bydel_&aar error_bydel_&aar;
merge mottatt_bydel (in=a) liste_bydel (in=b);
by bydel;
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