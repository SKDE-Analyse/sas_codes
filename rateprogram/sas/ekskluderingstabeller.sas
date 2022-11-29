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

/* NLnum eller Excel-format i tabeller */
%definere_format;

ods text=" ";
ods text=" ";
ods escapechar='^';
ods text='^{style[font_size=14pt font_weight=bold font_style=italic]
					Antall RV i input data}';

PROC TABULATE DATA=&datasett FORMAT=&talltabformat..0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Fra utvalgsdatasettet" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN; title;

/*
Alle ekskluderte
*/

ods text='^{style[font_size=14pt font_weight=bold font_style=italic]
					Ekskludert pga komnr=. or komnr not in (0:2031, 5000:5100) or alder not &aldersspenn or ermann not in &kjonn}';
ods text=" ";
ods text='^{style[font_size=12pt font_weight=bold]
					Utvalgskriterier:}';
ods text="Aldersspenn = &aldersspenn";
ods text="kjonn = &kjonn";

PROC SQL;
CREATE TABLE ikke_med_tot AS
SELECT * FROM &datasett
where komnr=. or komnr not in (0:2031, 5000:5100) or alder not &aldersspenn or ermann not in &kjonn or aar not in (&startår:&sluttår); 
QUIT;

PROC TABULATE DATA=ikke_med_tot FORMAT=&talltabformat..0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Totalt ekskludert" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;


/* Kun se på de dataene "bruker" har valgt å se på */
data qwerty_data;
set &datasett;
where aar in (&startår:&sluttår) and alder &aldersspenn and ermann in &kjonn;
run;

/*
Ekskludering pga komnr utenfor (0:2031, 5000:5100)
*/
ods text='^{style[font_size=14pt font_weight=bold font_style=italic]
					Ekskludert pga komnr not in (0:2031, 5000:5100)
                    }';
ods text=" ";

PROC SQL;
CREATE TABLE ikke_kom AS
SELECT * FROM qwerty_data
where komnr not in (0:2031, 5000:5100);
QUIT;

PROC TABULATE DATA=ikke_kom FORMAT=&talltabformat..0;	
VAR RV;
CLASS komnr/	ORDER=UNFORMATTED MISSING;
TABLE komnr={LABEL=""} ALL={LABEL="Total komnr"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Kommunenummer utenfor definert område" STYLE={JUST=LEFT VJUST=BOTTOM}};
run;

PROC TABULATE DATA=ikke_kom FORMAT=&talltabformat..0;	
VAR RV;
CLASS alder aar ErMann /	ORDER=UNFORMATTED MISSING;
TABLE 
alder={LABEL=""} ALL={LABEL="Total alder"} 
ErMann={LABEL=""} ALL={LABEL="Total kjønn"} 
aar={LABEL=""} ALL={LABEL="Total år"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Kommunenummer utenfor definert område" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

/*
Ekskludering pga alder ikke i definert aldersspenn
*/

/* Kun se på de dataene "bruker" har valgt å se på */
data qwerty_data;
set &datasett;
where aar in (&startår:&sluttår) and ermann in &kjonn;
run;

ods text='^{style[font_size=14pt font_weight=bold font_style=italic]
					Ekskludert pga alder not &aldersspenn}';
ods text=" ";

PROC SQL;
CREATE TABLE ikke_alder AS
SELECT * FROM qwerty_data
where (alder not &aldersspenn); 
QUIT;

PROC TABULATE DATA=ikke_alder FORMAT=&talltabformat..0;	
VAR RV;
CLASS alder /	ORDER=UNFORMATTED MISSING;
TABLE alder={LABEL=""} ALL={LABEL="Total alder"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga alder not &aldersspenn" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

PROC TABULATE DATA=ikke_alder FORMAT=&talltabformat..0;	
VAR RV;
CLASS alder aar ErMann komnr/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"} aar={LABEL=""} ALL={LABEL="Total år"} 
komnr={LABEL=""} ALL={LABEL="Total komnr"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga alder not &aldersspenn" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

/*
Ekskludert pga ermann ikke i definert kjonn
*/

/* Kun se på de dataene "bruker" har valgt å se på */
data qwerty_data;
set &datasett;
where aar in (&startår:&sluttår) and alder &aldersspenn;
run;

ods text='^{style[font_size=14pt font_weight=bold font_style=italic]
					Ekskludert pga ermann not in &kjonn}';
ods text=" ";

PROC SQL;
CREATE TABLE ikke_kjonn AS
SELECT * FROM qwerty_data
where ermann not in &kjonn;
QUIT;

PROC TABULATE DATA=ikke_kjonn FORMAT=&talltabformat..0;	
VAR RV;
CLASS ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kjønn"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga missing kjønn eller komnr" STYLE={JUST=LEFT VJUST=BOTTOM}};
run;

PROC TABULATE DATA=ikke_kjonn FORMAT=&talltabformat..0;	
VAR RV;
CLASS alder aar komnr/	ORDER=UNFORMATTED MISSING;
TABLE aar={LABEL=""} ALL={LABEL="Total år"} 
komnr={LABEL=""} ALL={LABEL="Total komnr"} alder={LABEL=""} ALL={LABEL="Total alder"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga missing kjønn eller komnr" STYLE={JUST=LEFT VJUST=BOTTOM}};

RUN;

proc datasets nolist;
delete ikke: qwerty_data;
run;

%mend;