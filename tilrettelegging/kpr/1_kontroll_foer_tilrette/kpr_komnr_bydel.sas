%macro kpr_komnr_bydel(inndata= ,komnr=komnrhjem2, bydel=bydel2, aar=);  /*kontrollere om mottatte data har gyldig komnr*/

/* Import komnr CSV */
proc import datafile="&filbane/formater/forny_komnr.csv"
    out=komnr
    dbms=csv
    replace;
    delimiter=';';
    getnames=yes;      /* Use first row as variable names */
    datarow=3;         /* Data starts on line 3 */
    guessingrows=1000;
run;

/* Import bydel CSV */
proc import datafile="&filbane/formater/forny_bydel.csv"
    out=bydel
    dbms=csv
    replace;
delimiter=';';
    getnames=yes;      
    datarow=2;         
    guessingrows=1000;
run;

/* Import boomr CSV */
proc import datafile="&filbane/formater/boomr.csv"
    out=boomr
    dbms=csv
    replace;
delimiter=';';
    getnames=yes;    
    datarow=3;         
    guessingrows=1000;
run;

/* ------------------------------------ */
/*  1. Gyldige kommunenummer og bydeler */
/* ------------------------------------ */
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
	select distinct &komnr as komnr, &bydel
	from &inndata;
quit;

/*lage bydel-variabel*/
data mottatt_bydel(keep=komnr bydel);
length bydel_num 6 bydel 6; /*sette lengde lik 6*/
  set mottatt_komnr;

  if komnr in (301,4601,1201,5001,1601,1103) then do; 
    /* make bydel numeric and create new variable that combines komnr and bydel */
    bydel_num=&bydel;
    bydel=komnr*100+bydel_num;
    output;
  format bydel best6.;
  end;
  run;

/*sortere og laga datasett til kontroll*/
proc sort data=mottatt_komnr(rename=(komnr=komnr2) keep=komnr); by komnr2; run;
proc sort data=mottatt_bydel (keep=bydel); by bydel; run;

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
%if &nobs ne 0 %then %do;
    /* Count number of rows in original data with invalid komnr */
    proc sql noprint;
        select count(*) into :n_invalid_komnr
        from &inndata
        where &komnr in (select komnr2 from error_komnr_&aar);
    quit;

    title color=red height=5 
        "6a: det er &n_invalid_komnr rader med ugyldige verdier for komnr i &aar.-filen";
    proc sql;
        select &komnr, count(*) as antall_rader
        from &inndata
        where &komnr in (select komnr2 from error_komnr_&aar)
        group by &komnr;
    quit;
    title;

proc sql;
	create table ukjent_bosted_&aar. as
	select kpr_lnr, kommuneNr, enkeltregning_lnr
	from &inndata 
	where kommuneNr in (select komnr2 from error_komnr_&aar.);
quit;
title color=red height=5 "Antall pasienter og regninger med ukjent komnr i &aar";
proc sql;
select	&aar as aar, 
			count(distinct kpr_lnr) as unik_pas,
			count(distinct enkeltregning_lnr) as unik_regning,
			sum(missing(kpr_lnr)) as uten_kpr_lnr
from ukjent_bosted_&aar.;
quit;
%end;

/* hvis error-fil er tom, print All is good! */
%if &nobs eq 0 %then %do;
title color= darkblue height=5  "6a: alle mottatte kommunenummer er gyldige";
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
    /* Count number of rows in original data with invalid bydel */
    data inndata_with_bydel;
    set &inndata(keep=&komnr &bydel);
    if &komnr in (301,4601,1201,5001,1601,1103) then bydel_combined = &komnr*100 + &bydel;
    else bydel_combined = .;
run;
    proc sql noprint;
    select count(*) into :n_invalid_bydel
    from inndata_with_bydel
    where bydel_combined in (select bydel from error_bydel_&aar);
quit;

title color=red height=5 "6b: det er &n_invalid_bydel rader med ugyldig verdi for bydel i &aar.-filen - tilretteleggingen gir de bydel = 99";
proc sql;
    select &komnr, &bydel, bydel_combined, count(*) as ant_rader
    from inndata_with_bydel
    where bydel_combined in (select bydel from error_bydel_&aar)
    group by &komnr, &bydel, bydel_combined;
quit;
%end;

proc datasets nolist;
delete komnr bydel boomr gyldig_komnr liste_komnr 
      gyldig_bydel liste_bydel mottatt_komnr mottatt_bydel
      godkjent_komnr_&aar godkjent_bydel_&aar;
run;
%mend kpr_komnr_bydel;
