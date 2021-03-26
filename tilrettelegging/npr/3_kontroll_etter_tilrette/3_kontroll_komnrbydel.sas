/* check output new komnr is on the boomr list*/

%macro kontroll_komnrbydel(inndata= , aar=);  /*kontrollere om tilrettelagte data har gyldig komnr*/


data bo;
  infile "&filbane\data\boomr_2021.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $60.;
  format bohf 4.;
  format bohf_navn $60.;
  format boshhn 2.;
  format boshhn_navn $15.;
  format borhf 4.;
  format borhf_navn $60.;
  format kommentar $400.;
 
  input	
  komnr
  komnr_navn $
	bydel 
	bydel_navn $
	bohf
	bohf_navn $
  boshhn
	boshhn_navn $
  borhf
	borhf_navn $
	kommentar $
	;
  run;

/* ---------------------------------------------------------------- */
/*  1. Kun kommunenummer og bydeler fra boområader 2020 skal med    */
/* ---------------------------------------------------------------- */
/*csv-fil med gyldige komnr */
data gyldig_kom(keep=komnr);
set bo;
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_kom nodupkey out=liste_kom;
by komnr;
where komnr is not missing;
run;


/*csv-fil med gyldige bydeler*/
data gyldig_bydel(keep=bydel);
set bo;
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_bydel nodupkey out=liste_by;
by bydel;
where bydel is not missing;
run;



/* -------------------------------------------------------- */
/* 2. Hente ut variabel 'komnr' og 'bydel' fra mottatte data*/
/* -------------------------------------------------------- */
proc sql;
	create table mottatt_komnr as
	select distinct komnr, bydel
	from &inndata;
quit;

/*sortere og laga datasett til kontroll*/
proc sort data=mottatt_komnr(keep=komnr) out= mottatt_kom; 
by komnr; 
run;
proc sort data=mottatt_komnr(keep=bydel) out= mottatt_by; 
by bydel; 
where bydel is not missing;
run;


/* ---------------------------------------- */
/* 3. Sammenligne mottatte komnr med csv-fil*/
/* ---------------------------------------- */
/*Outputfiler 'error' inneholder komnr i mottatte data som ikke er i vår liste med godkjente komnr*/
/* output no_patient er tilfeller hvor komnr inngår i CSV-fil men ikke er i tilrettelagte data */
data godkjent_komnr_&aar error_komnr_&aar no_patient_&aar;
merge mottatt_kom (in=a) liste_kom (in=b);
by komnr;
if a and b then felles = 1;
if a and not b then feil = 1;
if b and not a then no_patient = 1;
if felles then output godkjent_komnr_&aar;
if feil then output error_komnr_&aar;
if no_patient then output no_patient_&aar;
run;

/*sammenligne bydel med csv-fil*/
/*Outputfiler 'error' inneholder bydel i mottatte data som ikke er i vår liste med godkjente bydeler*/
/* output no_patient er tilfeller hvor bydel inngår i CSV-fil men ikke er i tilrettelagte data */
data godkjent_bydel_&aar error_bydel_&aar no_patient_bydel_&aar;
merge mottatt_by (in=a) liste_by (in=b);
by bydel;
if a and b then felles = 1;
if a and not b then feil = 1;
if b and not a then no_patient_bydel = 1;
if felles then output godkjent_bydel_&aar;
if feil then output error_bydel_&aar;
if no_patient_bydel = 1 then output no_patient_bydel_&aar;
run;
%mend;


