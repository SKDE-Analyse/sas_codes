/* check output new komnr is on the boomr list*/

%macro kontroll_komnrbydel(inndata= , aar=);  /*kontrollere om tilrettelagte data har gyldig komnr*/


data bo;
  infile "&databane\boomr_2020.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $60.;
  format bohf 2.;
  format bohf_navn $60.;
  format boshhn 2.;
  format boshhn_navn $15.;
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
	kommentar $
	;
  run;

/* ---------------------------------------------- */
/* alle=1: alle kommunenummer og bydeler skal med */
/* ---------------------------------------------- */
/*csv-fil med gyldige komnr */
data gyldig_kom(keep=komnr);
set bo;
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_kom nodupkey out=liste_kom;
by komnr;
run;


/*csv-fil med gyldige bydeler*/
data gyldig_bydel(keep=bydel);
set bo;
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_bydel nodupkey out=liste_by;
by bydel;
run;
/*fjerne linje med missing bydel*/
data liste_by;
set liste_by;
if bydel = . then delete;
run;



/* ---------------------------------------------------- */
/*hente ut variabel 'komnr' og 'bydel' fra mottatte data*/
/* ---------------------------------------------------- */
proc sql;
	create table mottatt_komnr as
	select distinct komnr, bydel
	from &inndata;
quit;

/*sortere og laga datasett til kontroll*/
proc sort data=mottatt_komnr(keep=komnr) out= mottatt_kom; by komnr; run;
proc sort data=mottatt_komnr(keep=bydel) out= mottatt_by; by bydel; run;

/*fjerne linje med bydel2 = 0*/
data mottatt_by;
set mottatt_by;
if bydel = . then delete;
run;

/* ------------------------------------ */
/*sammenligne mottatte komnr med csv-fil*/
/* ------------------------------------ */
/*Outputfiler 'error' inneholder komnr i mottatte data som ikke er i vår liste med godkjente komnr*/
data godkjent_komnr_&aar error_komnr_&aar;
merge mottatt_kom (in=a) liste_kom (in=b);
by komnr;
if a and b then felles = 1;
if a and not b then feil = 1;
if felles then output godkjent_komnr_&aar;
if feil then output error_komnr_&aar;
run;

/*sammenligne bydel med csv-fil*/
/*Outputfiler 'error' inneholder bydel i mottatte data som ikke er i vår liste med godkjente bydeler*/
data godkjent_bydel_&aar error_bydel_&aar;
merge mottatt_by (in=a) liste_by (in=b);
by bydel;
if a and b then felles = 1;
if a and not b then feil = 1;
if felles then output godkjent_bydel_&aar;
if feil then output error_bydel_&aar;
run;
%mend;


