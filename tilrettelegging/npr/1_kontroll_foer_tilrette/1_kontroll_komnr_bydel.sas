%macro kontroll_komnr_bydel(inndata= ,komnr=komnrhjem2, bydel=bydel2, aar=);  /*kontrollere om mottatte data har gyldig komnr*/

/*! 
### Beskrivelse

Makro for å kontrollere at mottatte data inneholder gyldige komnr og bydel
Den sier ikke noe om det er løpenr ifeks Oslo 0301 som mangler bydel

```
%kontroll_komnr_bydel(inndata= ,komnr=komnrhjem2, bydel=bydel2, aar=)
```

### Input 
      - Inndata: 
      - kommune_nr:  Kommunenummer som skal sjekkes, default er 'KomNrHjem2' - variabel utlevert fra NPR 
      - bydel     :  Bydelnummer som skal sjekkes, default er 'bydel2' - variabel utlevert fra NPR 

### Output 
      - Godkjent lister som SAS datasett
      - Error lister gir oversikt over ugyldige komnr eller bydeler i mottatt data.  De lages som SAS, og printes ut til results vinduet hvis det er noe.

### Endringslogg:
    - Opprettet før 2020
    - september 2021, Janice
          - dokumentasjon markdown
          - bydel til numerisk før kombineres med komnr
          - error lister printes ut
    - november 2021, Tove
          - inkluderer tidligere bydelskommuner 1201 og 4601 i steg 2 hvor bydel kontrolleres 
          - fjerne rad med missing komnr i steg 1 slik at rader med manglende komnr i kontrollert data kommer i output error-liste
 */

/* laste inn tre datafiler */
data komnr;
  infile "&filbane/formater/forny_komnr.csv"
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
  infile "&filbane/formater/forny_bydel.csv"
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
  infile "&filbane/formater/boomr.csv"
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
where komnr2 is not missing;
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

data mottatt_komnr;
  set mottatt_komnr;
  komnr = &komnr + 0;
run;

/*lage bydel-variabel*/
data mottatt_bydel(keep=komnr bydel);
length bydel_num 6 bydel 6; /*sette lengde lik 6*/
  set mottatt_komnr;

  if komnr in (301,4601,1201,5001,1601,1103) then do; 
    /* make bydel numeric and create new variable that combines komnr and bydel */
    bydel_num=&bydel+0;
    bydel=komnr*100+bydel_num;
  format bydel best6.;
  end;
  run;
run;

/*sortere og laga datasett til kontroll*/
proc sort data=mottatt_komnr(rename=(komnr=komnr2) keep=komnr); by komnr2; run;
proc sort data=mottatt_bydel (keep=bydel); by bydel; run;

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

title "error komnr i &aar. filen";
proc print data=error_komnr_&aar; run;

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

title "error bydel i &aar. filen";
proc print data=error_bydel_&aar; run;
title;

%mend;


