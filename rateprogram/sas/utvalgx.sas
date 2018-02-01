
%macro utvalgx;

/*!
#### Form�l

- Lager datasettet `utvalgX`
   - Aggreregerer opp pasienter ut fra inkluderingskriteriene (hvilke �r, alder, etc.)
   - Henter inn antall innbyggere
   - Definerer opp boomr�der

#### "Steg for steg"-beskrivelse

1. Definerer Periode, �r1 etc.
2. Lager datasettet utvalgX av &Ratefil
   - RV = &RV_variabelnavn
   - keep RV ermann aar alder komnr bydel
   - alder mellom 106-115 defineres til 105
   - kj�rer aldjust (ermann = 1, hvis ikke tom)
3. Hvis vis_ekskludering = 1 -> lage tabeller over ekskluderte data i datasett
   - Dette burde flyttes ut i egen makro
4. Aggregerer RV (i `utvalgX`)
   - grupperer p� `aar, KomNr, bydel, Alder, ErMann`. 
   - ekskluderer data hvis aar utenfor &periode, alder utenfor &aldersspenn, komnr > 2030, og ermann ikke i &kjonn
5. Lese inn innbyggerfil
   - aggregering av innbyggere, gruppert som over 
   - samme ekskludering som over
   - legger s� innbyggere til `utvalgX`
6. Definere alderskategorier
   - kj�r makro [valg_kategorier](#valg_kategorier)
   - kj�rer `proc means` 
7. Definerer boomr�der
8. Beregner andeler
   - Er denne n�dvendig? Kan ikke se at den "virker".
   - Lager datasett `Andel`

   
#### Avhengig av f�lgende variabler

- Ratefil (navnet p� det aggregerte datasettet)
- RV_variabelnavn (variablen det skal beregnes rater p�)
- vis_ekskludering (=1 hvis man vil ha ut antall pasienter som er ekskludert)
- innbyggerfil (navnet p� innbyggerfila)
- boomraadeN (?)
- boomraade (?)

#### Definerer f�lgende variabler

Sjekk hvilke som brukes av andre makroer og hvilke som kun er interne.

- aarsvarfigur=1
- Periode=(&Start�r:&Slutt�r)
- Antall_aar=%sysevalf(&Slutt�r-&Start�r+2)
- �r1 etc.


#### Kalles opp av f�lgende makroer

Ingen

#### Bruker f�lgende makroer

- [valg_kategorier](#valg_kategorier)
- Boomraader (fra makro-mappen)

#### Lager f�lgende datasett

- utvalgx (slettes)
- innb_aar (slettes)
- RV
- alderdef (slettes)
- Andel

#### Annet

F�rste makro som kj�res direkte i rateprogrammet

*/

%if %sysevalf(%superq(aarsvarfigur)=,boolean) %then %let aarsvarfigur = 1;

%definere_aar;

%if &Antall_aar=2 %then %do;
	proc format; Value aar
	&�r1="&�r1" 9999='Snitt';	run;
%end;
%if &Antall_aar=3 %then %do;
	proc format; Value aar
	&�r1="&�r1" &�r2="&�r2" 9999='Snitt';	run;
%end;
%if &Antall_aar=4 %then %do;
	proc format; Value aar
	&�r1="&�r1"	&�r2="&�r2" &�r3="&�r3" 9999='Snitt';	run;
%end;
%if &Antall_aar=5 %then %do;
	proc format; Value aar
	&�r1="&�r1"	&�r2="&�r2" &�r3="&�r3"	&�r4="&�r4" 9999='Snitt';	run;
%end;
%if &Antall_aar=6 %then %do;
	proc format; Value aar
	&�r1="&�r1"	&�r2="&�r2" &�r3="&�r3" &�r4="&�r4" &�r5="&�r5"	9999='Snitt';	run;
%end;
%if &Antall_aar=7 %then %do;
	proc format; Value aar
	&�r1="&�r1"	&�r2="&�r2" &�r3="&�r3"	&�r4="&�r4" &�r5="&�r5"	&�r6="&�r6" 9999='Snitt';	run;
%end;
%if &Antall_aar=8 %then %do;
	proc format; Value aar
	&�r1="&�r1"	&�r2="&�r2" &�r3="&�r3"	&�r4="&�r4" &�r5="&�r5"	&�r6="&�r6" &�r7="&�r7" 9999='Snitt';	run;
%end;

options locale=NB_NO;

	data tmp1utvalgX;
	set &Ratefil; /*HER M� DET AGGREGERTE RATEGRUNNLAGSSETTET SETTES INN */
		RV=&RV_variabelnavn; /* Definerer RV som ratevariabel */
	keep RV ermann aar alder komnr bydel;
	/*endring 11/5-17 Frank Olsen - alder>105-->105*/
	if alder in (106:115) then alder=105;
	&aldjust;
	run;
	
/*Nytt pr 11/5-17 - Frank Olsen - tabeller for eksludering*/
%if &vis_ekskludering=1 %then %do;
Title "EKSKLUDERING";
PROC TABULATE DATA=tmp1utvalgx FORMAT=NLnum12.0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Fra utvalgsdatasettet" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN; Title;

PROC SQL;
CREATE TABLE ikke_med_tot AS
SELECT * FROM tmp1UTVALGX
where komnr=. or komnr not in (0:2031) or alder not &aldersspenn or ermann not in &kjonn or aar not in (&start�r:&slutt�r); 
QUIT;

PROC TABULATE DATA=ikke_med_tot FORMAT=NLnum12.0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Totalt ekskludert" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

PROC SQL;
CREATE TABLE ikke_kom AS
SELECT * FROM tmp1UTVALGX
where komnr not in (0:2031); 
QUIT;

PROC TABULATE DATA=ikke_kom FORMAT=NLnum12.0;	
VAR RV;
CLASS alder aar ErMann komnr/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} komnr={LABEL=""} ALL={LABEL="Total komnr"}
/*alder={LABEL=""} ALL={LABEL="Total alder"}*/,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Kommunenummer utenfor definert omr�de" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

PROC SQL;
CREATE TABLE ikke_med AS
SELECT * FROM tmp1UTVALGX
where (komnr=. or komnr in (0:2031)) and (alder not &aldersspenn or ermann not in &kjonn or aar not in (&start�r:&slutt�r)); 
QUIT;

PROC TABULATE DATA=ikke_med FORMAT=NLnum12.0;	
VAR RV;
CLASS alder aar ErMann komnr/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} 
komnr={LABEL=""} ALL={LABEL="Total komnr"} alder={LABEL=""} ALL={LABEL="Total alder"}
/*alder={LABEL=""} ALL={LABEL="Total alder"}*/,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga missing alder, kj�nn eller komnr" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

proc datasets nolist;
delete ikke:;
run;
%end;

	/*----------------------------*/

	PROC SQL;
	   CREATE TABLE tmp2utvalgx AS
	   SELECT DISTINCT aar,KomNr,bydel,Alder,ErMann,(SUM(RV)) AS RV
	      FROM tmp1UTVALGX
		  where aar in &Periode and Ermann in &kjonn and Alder &aldersspenn and 0<komnr<2031
	      GROUP BY aar, KomNr, bydel, Alder, ErMann;	  
	QUIT;

	data tmp1innb_aar;
	set &innbyggerfil;
	keep aar komnr bydel Ermann Alder innbyggere;
	where aar in &Periode and Ermann in &kjonn and Alder &aldersspenn and 0<komnr<2031;
	&aldjust; 
	run;

	PROC SQL;
	   CREATE TABLE innb_aar AS 
	   SELECT DISTINCT aar,KomNr, bydel, Alder,ErMann,(SUM(Innbyggere)) AS Innbyggere
	      FROM tmp1innb_aar
	      GROUP BY aar, KomNr, Alder, bydel, ErMann;
	QUIT;

	PROC SQL;
	 CREATE TABLE utvalgx AS
	 SELECT a.aar, a.KomNr, a.bydel, a.Alder, a.ErMann, b.RV, a.Innbyggere
	 FROM innb_aar a left join tmp2utvalgx b
	 ON b.komnr=a.komnr and b.bydel=a.bydel and b.aar=a.aar 
		and b.ermann=a.ermann and b.alder=a.alder;
	QUIT; 

	proc datasets nolist;
	delete tmp1innb_aar innb_aar tmp1utvalgx tmp2utvalgx;
	run;

	/* Definere alderskategorier */

	%valg_kategorier;	

	data tmpRV;
	set Utvalgx;
	where alder_ny ne .; 
	if RV=. then RV=0;
	run;

	Proc means data=tmpRV min max noprint;
	var alder;
	class alder_ny;
	where alder_ny ne .;
	Output out=alderdef Min=Min Max=Max / AUTONAME AUTOLABEL INHERIT;
	Run;

	data alderdef;
	set alderdef;
	aldernytall=catx('-',put(min,3.),put(max,3.));
	ar='�r';
	alderny=catx(' ',aldernytall,ar);
	run;

	PROC SQL;
	 CREATE TABLE RV AS
	 SELECT tmpRV.*, alderdef.aldernytall, alderdef.alderny
	 FROM tmpRV left join alderdef 
	 ON tmpRV.alder_ny=alderdef.alder_ny;
	QUIT;

	data RV;
	set RV;
	keep aar alder ermann Innbyggere KomNr bydel rv alderny;
	format aar aar.;
	run;

	proc delete data=alderdef utvalgx tmpRV;
	run;

   /*
   Definere macro-variabler for boomraade-makroen,
   hvis de ikke er definert tidligere
   */
   %if %sysevalf(%superq(haraldsplass)=,boolean) %then %let haraldsplass = 0;
   %if %sysevalf(%superq(indreOslo)=,boolean) %then %let indreOslo = 0;
   %if %sysevalf(%superq(bydel)=,boolean) %then %let bydel = 1;
   %if %sysevalf(%superq(barn)=,boolean) %then %let barn = 0;
   
	data RV;
	set RV;
	%Boomraader(haraldsplass = &haraldsplass, indreOslo = &indreOslo, bydel = &bydel, barn = &barn);
	if BOHF in (24,99) then BoRHF=.; /*kaster ut Utlandet og Svalbard*/
	if BoRHF in (1:4) then Norge=1;
format borhf borhf_kort. bohf bohf_kort. boshhn boshhn_kort. fylke fylke. komnr komnr. bydel bydel. ermann ermann.;
	run;

	/* beregne andeler */
	proc sql;
	    create table tmpAndel as
	    select distinct aar, alderny, ErMann, sum(innbyggere) as innbyggere 
	    from RV
		where aar=&aar and &boomraadeN /*test 13/6-16*/
	    group by aar, alderny, ErMann;
	quit;

	proc sql;
	    create table Andel as
	    select distinct aar, alderny, ErMann, innbyggere, sum(innbyggere) as N_innbygg, innbyggere/sum(innbyggere) as andel  
	    from tmpAndel;
	quit;

    proc delete data=tmpAndel;
	run;
    
	/* legg p� boomr�der */
	/*%include "\\tos-sastest-07\SKDE\rateprogram\Rateprogram_Boomraader.sas";
	%include "\\tos-sastest-07\SKDE\rateprogram\Rateprogram_BoFormat.sas";*/
	data RV;
	set RV;
/*	%Boomraader; test 13/6-16*/
	where &boomraade;
	rename alderny=alder_ny;
	run;
%mend utvalgx;
