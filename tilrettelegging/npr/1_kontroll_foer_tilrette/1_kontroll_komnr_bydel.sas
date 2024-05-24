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
    - juli 2023, Tove
          - angi antall rader som har feil med utlevert bydel, og endre melding som gis når det er feil    
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
  format bodps 4.;
  format bodps_navn $60.;
 
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
    bodps 
    bodps_navn $
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

/* sjekk om kommune error-fil har innhold */
%let dsid=%sysfunc(open(error_komnr_&aar));
%let nobs=%sysfunc(attrn(&dsid,any));
%let dsid=%sysfunc(close(&dsid)); 

/* printes hvis det er innhold i error-fil */
title color=red height=5 "5a: det er ugyldige verdier for komnr i &aar.-filen";
proc print data=error_komnr_&aar; run;

/* hvis error-fil er tom, print gyldige obs fra mottatt */
%if &nobs eq 0 %then %do;
title color= darkblue height=5  "5a: alle mottatte kommunenummer er gyldige";
proc sql;
   create table m
       (note char(12));
   insert into m
      values('All is good!');
   select * from m;
quit;
%end;

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

/* sjekk om bydel error-fil har innhold */
%let dsid2=%sysfunc(open(error_bydel_&aar));
%let nobs2=%sysfunc(attrn(&dsid2,any));
%let dsid2=%sysfunc(close(&dsid2)); 

%if &nobs2 ne 0 %then %do;
title color=purple height=5 "5b: Antall rader med ugyldig verdi for bydel i &aar.-filen - tilretteleggingen gir de bydel = 99";
/* proc sql;
	select  ((&komnr.+0)*100+(&bydel.+0)) as bydel,  count(*) as ant_rader
	from &inndata.
	where ((&komnr.+0)*100+(&bydel.+0)) in (select bydel from error_bydel_&aar)
	group by bydel;
quit; */
proc sql;
	select &komnr., &bydel.,  count(*) as ant_rader
	from &inndata.
	where &bydel. in (select bydel from error_bydel_&aar.)
	group by &komnr., &bydel.;
quit;
title;
%end;

/* hvis error-fil er tom, print gyldige obs fra mottatte */
%if &nobs2 eq 0 %then %do;
title color= darkblue height=5  "5b: alle mottatte bydeler er gyldige";
proc freq data=mottatt_bydel;
tables bydel /  missing nopercent; ; run;
%end;

proc datasets nolist;
delete komnr bydel boomr gyldig_komnr liste_komnr 
      gyldig_bydel liste_bydel mottatt_komnr mottatt_bydel
      godkjent_komnr_&aar godkjent_bydel_&aar;
run;
%mend kontroll_komnr_bydel;


