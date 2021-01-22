/* haraldsplass = 0  --> Haraldsplass settes til Bergen */
/* indreoslo = 0 -->  diakonhjemmet og lovisenberg settes til indreoslo */


%macro boomrade(dsn= , haraldsplass=1, indreoslo=1);


/* importere CSV-fil med mapping av boområder */
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

/*
*********************************************
2. BoHF - Opptaksområder for helseforetakene
*********************************************
*/
/* Merge datasett til boomr-mapping for å hente BoHF og BoshHN ( Opptaksområder for lokalsykehusene i Helse Nord) */

proc sql;
  create table &dsn as
  select a.*, b.bohf, b.boshhn, b.borhf
  from &dsn a left join bo b
  on a.komnr=b.komnr
  and a.bydel=b.bydel;
quit;

/*
***********************
0. Nulle ut variabler
***********************
*/

data &dsn;
  set &dsn;

VertskommHN=.;
BoRHF=.;
Fylke=.;

/* JS Aug2020 - if do not wish to split out Haraldsplass, then assign all Haraldsplass to Bergen */
%if &haraldsplass = 0 %then %do;
  if bohf=9 then bohf=11;
%end;

/* Slå sammen Lovisenberg og Diakonhjemmet */
%if &indreoslo = 0 %then %do;
  if bohf in (17,18) then bohf=31;
%end;


/*
******************************************************
4. Fylke
******************************************************
*/

if bohf=24 then Fylke=24 ;/*24='Boomr utlandet/Svalbard' */
else if bohf=99 then Fylke=99; /*99='Ukjent/ugyldig kommunenr'*/
else Fylke=floor(komnr/100); /*Remove the last 2 digits from kommunenummer.  The remaining leading digits are fylke*/


/*
*****************************************************
5. VertskommHN (Vertskommuner Helse Nord)
*****************************************************
*/
if BoRHF = 1 /*Helse Nord*/ then do;
    if KomNr in (1804 /*Bodø*/,
                       1805 /*Narvik (-2019)*/,
                 1806 /*Narvik (2020)*/,
    		     1820 /*Alstahaug*/ ,
    			 1824 /*Vefsn*/ ,
    			 1833 /*Rana*/ ,
    			 1860 /*Vestvågøy*/ ,
    			 1866 /*Hadsel*/ ,
                       1901 /*Harstad(-2012)*/,
    			       1903 /*Harstad(-2019)*/,
                 5402 /*Harstad(2020)*/,
    			       1902 /*Tromsø(-2019)*/,
                 5401 /*Tromsø(2020)*/,
    			       2004 /*Hammerfest(-2019)*/,
                 5406 /*Hammerfest(2020)*/ ,
    			       2030 /*Sør-Varanger(-2019)*/,
                 5444 /*Sør-Varanger(2020)*/)              
    then VertskommHN=1;
    else VertskommHN=0;
end;

run;

%mend;

