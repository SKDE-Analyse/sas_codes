%macro ekskluderingstabeller(datasett = );

/*!
Makro for � lage tabeller over antall kontakter i det originale datasettet som blir ekskludert
i rateprogrammet.

F�lgende ekskluderinger vises:
- `komnr=. or komnr not in (0:2031, 5000:5100)`
- `alder not &aldersspenn`
- `ermann not in &kjonn`
- `aar not in (&start�r:&slutt�r)`

F�lgende variabler, som er definert tidligere, brukes:
- `&aldersspenn`
- `&kjonn`
- `&start�r`
- `&slutt�r`

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
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} ,
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
where komnr=. or komnr not in (0:2031, 5000:5100) or alder not &aldersspenn or ermann not in &kjonn or aar not in (&start�r:&slutt�r); 
QUIT;

PROC TABULATE DATA=ikke_med_tot FORMAT=&talltabformat..0;	
VAR RV;
CLASS aar ErMann/	ORDER=UNFORMATTED MISSING;
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} ,
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Totalt ekskludert" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;


/* Kun se p� de dataene "bruker" har valgt � se p� */
data qwerty_data;
set &datasett;
where aar in (&start�r:&slutt�r) and alder &aldersspenn and ermann in &kjonn;
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
/ BOX={LABEL="Kommunenummer utenfor definert omr�de" STYLE={JUST=LEFT VJUST=BOTTOM}};
run;

PROC TABULATE DATA=ikke_kom FORMAT=&talltabformat..0;	
VAR RV;
CLASS alder aar ErMann /	ORDER=UNFORMATTED MISSING;
TABLE 
alder={LABEL=""} ALL={LABEL="Total alder"} 
ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} 
aar={LABEL=""} ALL={LABEL="Total �r"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Kommunenummer utenfor definert omr�de" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

/*
Ekskludering pga alder ikke i definert aldersspenn
*/

/* Kun se p� de dataene "bruker" har valgt � se p� */
data qwerty_data;
set &datasett;
where aar in (&start�r:&slutt�r) and ermann in &kjonn;
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
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"} aar={LABEL=""} ALL={LABEL="Total �r"} 
komnr={LABEL=""} ALL={LABEL="Total komnr"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga alder not &aldersspenn" STYLE={JUST=LEFT VJUST=BOTTOM}};
RUN;

/*
Ekskludert pga ermann ikke i definert kjonn
*/

/* Kun se p� de dataene "bruker" har valgt � se p� */
data qwerty_data;
set &datasett;
where aar in (&start�r:&slutt�r) and alder &aldersspenn;
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
TABLE ErMann={LABEL=""} ALL={LABEL="Total kj�nn"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga missing kj�nn eller komnr" STYLE={JUST=LEFT VJUST=BOTTOM}};
run;

PROC TABULATE DATA=ikke_kjonn FORMAT=&talltabformat..0;	
VAR RV;
CLASS alder aar komnr/	ORDER=UNFORMATTED MISSING;
TABLE aar={LABEL=""} ALL={LABEL="Total �r"} 
komnr={LABEL=""} ALL={LABEL="Total komnr"} alder={LABEL=""} ALL={LABEL="Total alder"},
RV={LABEL=""}*Sum={LABEL="Antall"}
/ BOX={LABEL="Eksluderte pga missing kj�nn eller komnr" STYLE={JUST=LEFT VJUST=BOTTOM}};

RUN;

proc datasets nolist;
delete ikke: qwerty_data;
run;

%mend;