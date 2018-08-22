%macro ekskluderingstabeller(datasett = );

/*!
Makro for å lage tabeller over antall kontakter i det originale datasettet som blir ekskludert
i rateprogrammet.

Følgende ekskluderinger vises:
- `komnr=. or komnr not in (0:2031, 5000:5100)`
- `alder not &aldersspenn`
- `ermann not in &kjonn`
- `aar not in (&startår:&sluttår)`

Følgende variabler, som er definert tidligere, brukes:
- `&aldersspenn`
- `&kjonn`
- `&startår`
- `&sluttår`

*/

Title "EKSKLUDERING";
PROC TABULATE DATA=&datasett FORMAT=NLnum12.0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Fra utvalgsdatasettet" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN; Title;

PROC SQL;
CREATE TABLE ikke_med_tot AS
SELECT * FROM &datasett
where komnr=. or komnr not in (0:2031, 5000:5100) or alder not &aldersspenn or ermann not in &kjonn or aar not in (&startår:&sluttår); 
QUIT;

PROC TABULATE DATA=ikke_med_tot FORMAT=NLnum12.0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Totalt ekskludert" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

PROC SQL;
CREATE TABLE ikke_kom AS
SELECT * FROM &datasett
where komnr not in (0:2031, 5000:5100); 
QUIT;

PROC TABULATE DATA=ikke_kom FORMAT=NLnum12.0;	
VAR RV;
CLASS alder aar ErMann komnr/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} komnr={LABEL=""} ALL={LABEL="Total komnr"}
/*alder={LABEL=""} ALL={LABEL="Total alder"}*/,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Kommunenummer utenfor definert område" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

PROC SQL;
CREATE TABLE ikke_med AS
SELECT * FROM &datasett
where (komnr=. or komnr in (0:2031, 5000:5100)) and (alder not &aldersspenn or ermann not in &kjonn or aar not in (&startår:&sluttår)); 
QUIT;

PROC TABULATE DATA=ikke_med FORMAT=NLnum12.0;	
VAR RV;
CLASS alder aar ErMann komnr/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} 
komnr={LABEL=""} ALL={LABEL="Total komnr"} alder={LABEL=""} ALL={LABEL="Total alder"}
/*alder={LABEL=""} ALL={LABEL="Total alder"}*/,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga missing alder, kjønn eller komnr" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

proc datasets nolist;
delete ikke:;
run;

%mend;