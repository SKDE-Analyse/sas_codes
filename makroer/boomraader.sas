%macro Boomraader(dsn=, haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 0, boaar=2015);

/*!
### Beskrivelse

Definerer boområder ut fra komnr og bydel


Makroen kjører med følgende verdier, hvis ikke annet er gitt:
```
%Boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 0, boaar=2015);
```

### Parametre

- Hvis `haraldsplass ne 0`: del Bergen i Haraldsplass og Bergen
- Hvis `indreOslo ne 0`: Slå sammen Diakonhjemmet og Lovisenberg
- Hvis `bydel = 0`: Vi mangler bydel og må bruke gammel boomr.-struktur (bydel 030110, 030111, 030112 går ikke til Ahus men til Oslo)
- Hvis `barn ne 0`: Lager boområder som i det første barnehelseatlaset
- `boaar = ?`: Opptaksområdene kan endres over år. `boaar` velger hvilket år vi tar utgangspunkt i. Foreløpig kun Sagene, som ble flyttet fra Lovisenberg til OUS i 2015. Kjør med `boaar=2014` eller mindre hvis man vil ha Sagene til Lovisenberg.

### Annet

Følgende variabler nulles ut i begynnelsen av makroen, og lages av makroen:
```
BoShHN
VertskommHN
BoHF
BoRHF
Fylke
```

### Endringer

#### Endring Arnfinn 18. juni 2018:
- Lagt til nye kommunenummer for Trøndelag

#### Endring Arnfinn 7. aug. 2017:
- Årsbetinget definisjon av opptaksområde (kun 2015 foreløpig, siden Samdata kun har lagt ut til og med 2015) 

#### Endring Arnfinn 27. feb. 2017:
- Hvis haraldsplass ne 0: del Bergen i Haraldsplass og Bergen
- Hvis indreOslo ne 0: Slå sammen Diakonhjemmet og Lovisenberg
- Hvis bydel = 0: Vi mangler bydel og må bruke gammel boomr.-struktur (bydel 030110, 030111, 030112 går ikke til Ahus men til Oslo)
- Hvis opptaksområder med barneavdeling (slå sammen til OUS og Nordland)
- Standardverdier: kjører som før
*/

/*!
-Importere kommuner bydel mapping from csv fil
*/

data komm_bydel;
  infile "&filbane\data\kommuner_bydel_2020.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $30.;
  format bohf 2.;
  format bohf_navn $25.;
  format boshhn 2.;
  format boshhn_navn $15.;

  input	
  	komnr
	komnr_navn $
	bydel
	bydel_navn $
	bohf
	bohf_navn $
    boshhn
	boshhn_navn $
	;
*if bydel=. then bydel=0;
run;

/*
*********************************************************
2. BoHF - Opptaksområder for helseforetakene
*********************************************************
*/

/*!
- Merge datasett til komm_bydel mapping for å hente BoHF og BoshHN ( Opptaksområder for lokalsykehusene i Helse Nord)
*/


proc sql;
  create table &dsn as
  select *
  from &dsn a left join komm_bydel b
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

/*
*****************************************************
3. BoRHF - Opptaksområder for RHF'ene
*****************************************************
*/

If BoHF in (1:4) then BoRHF=1;
else If BoHF in (6:8) then BoRHF=2;
else If BoHF in (9:13) then BoRHF=3;
else If BoHF in (14:23) then BoRHF=4;
else if BOHF in (24) then BoRHF=24;
else If BoHF in (30) then BoRHF=4;
else If BoHF in (31) then BoRHF=4;
else if BoHF in (99) then BoRHF=99;

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

%mend Boomraader;
