/*Kontrollerer at mottatte data inneholder gyldige komrn og bydel*/
/*Den sier ikke noe om det er løpenr ifeks Oslo 0301 som mangler bydel*/
/* Output-filer med navn 'error' gir oversikt over ugyldige komnr eller bydeler i mottatt data */

%macro kontroll_komnr_bydel(inndata= ,komnr=komnrhjem2, bydel=bydel2, aar=);  /*kontrollere om mottatte data har gyldig komnr*/


/* laste inn tre datafiler */
data komnr;
  infile "&filbane\data\forny_komnr.csv"
  delimiter=';'
  missover firstobs=3 DSD;

  format aar 4.;
  format gml_komnr 4.;
  format gml_navn $30.;
  format ny_komnr 4.;
  format ny_navn $30.;
  format kommentar $400.;
  format kommentar2 $400.;

  input	
  	aar
  	gml_komnr
	  gml_navn $ 
	  ny_komnr
	  ny_navn $
	  kommentar $
	  kommentar2 $
	  ;
  run;

data bydel;
  infile "&filbane\data\forny_bydel.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format aar 4.;
  format fra_bydel 6.;
  format fra_navn $30.;
  format til_bydel 6.;
  format til_navn $30.;
  format kommentar $400.;
 
  input	
  	aar
  	fra_bydel
	  fra_navn $ 
	  til_bydel
	  til_navn $
	  kommentar $
	  ;
run;

data boomr;
  infile "&filbane\data\boomr.csv"
  delimiter=';'
  missover firstobs=3 DSD;

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

/* -------------------------------------------- */
/*  1.Alle kommunenummer og bydeler skal med    */
/* -------------------------------------------- */
/*csv-fil med gyldige komnr */
data gyldig_komnr(keep=komnr2);
set komnr(rename=(gml_komnr=komnr2)) boomr(rename=(komnr=komnr2));
run;
/*fjerne duplikate linjer*/
proc sort data=gyldig_komnr nodupkey out=liste_komnr;
by komnr2;
run;


/*csv-fil med gyldige bydeler*/
data gyldig_bydel(keep=bydel);
set bydel(rename=(fra_bydel=bydel)) boomr;
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



/* -------------------------------------------------------- */
/* 2. Hente ut variabel 'komnr' og 'bydel' fra mottatte data*/
/* -------------------------------------------------------- */
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


/* -------------------------------------------- */
/* 3. Sammenligne mottatte data mot CSV-filer   */
/* -------------------------------------------- */

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


