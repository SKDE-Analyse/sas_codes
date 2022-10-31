%macro UnikeVariableAvdOpphold(variabler=, dsn=, prefix=, extrawhere=);

/*!
### Beskrivelse
For å finne unike prosedyrer/diagnoser o.l. pr pasient pr sykehusopphold i avdelingsoppholdsfila
```
%UnikeVariableAvdOpphold(variabler=, dsn=, prefix=, extrawhere=);
```

### Parametre

1. `variabler`: variablene man utfører analysen på, feks nc: eller ncsp: eller hdiag:
2. `dsn`: datasettnavn - datasettet man utfører analysen på
3. `prefix`: Prefix på variablene som telles/lages
4. `extrawhere`: dersom man ønsker noe mer i where-statement, feks `alder in (50:60)`, extrawhere må starte med `and`

### Eksempel

```
%UnikeVariableAvdOpphold(variabler=ncsp:, dsn=tarzan2014_avd, prefix=ncsp_pros, extrawhere=and alder in (10:15));
```

Det lages et nytt datasett med *pid*, *AgrshoppId*, de nye variablene og en antallsvariabel som teller antall pr avdelingsopphold
Dette datasettet kan merges med sykehusoppholdsfila

### Forfatter

Opprettet 24/2-16 av Frank Olsen

*/

data &dsn._trp;
set &dsn;
where niva='F' and aggrshoppID_LNr ne . &extrawhere;
keep pid aggrshoppID_LNr &variabler;
run;

proc sort data=&dsn._trp;
by pid aggrshoppID_LNr &variabler; run;

proc transpose data=&dsn._trp out=&dsn._trp1 prefix=&prefix;
by pid aggrshoppID_LNr &variabler;
var &variabler;
run;

data &dsn._trp1;
set &dsn._trp1;
   group = missing(&prefix.1);
run;

proc sort data=&dsn._trp1 nodupkey;
by pid aggrshoppID_LNr group &prefix.1;
run;

proc transpose data=&dsn._trp1 out=&dsn._&prefix (drop=_:) prefix=&prefix;
by pid aggrshoppID_LNr;
var &prefix.1;
run;

data &dsn._&prefix;
set &dsn._&prefix;
ant_&prefix = 0;      
array tp[*] &prefix:; 
        do i= 1 to dim(tp); 
           if tp(i) ^= ' ' then  ant_&prefix=ant_&prefix+1; 
        end; 
 drop i;
run;

proc transpose data=&dsn._&prefix out=temp; 
var _ALL_;
run;
%symdel dropvars;
data _NULL_;
set temp end=eof;
    array cols {*} COL: ;
do i = 1 to dim(cols);
    cols[i]=ifn((strip(cols[i])=" " or strip(cols[i])="."),0,1);
end;
if sum(of COL:)=0 then 
call symput("dropvars", catx(" ",symget("dropvars"),_NAME_));
run;

data &dsn._&prefix; set &dsn._&prefix (drop=&dropvars); run;
PROC TABULATE DATA=&dsn._&prefix;	
	CLASS ant_&prefix /	ORDER=UNFORMATTED MISSING;
	TABLE ant_&prefix={LABEL="" STYLE(CLASSLEV)={JUST=RIGHT}},
	N={LABEL="Frekvens"} ColPctN={LABEL="Prosent"}
/ BOX={LABEL="Unike &prefix i fleravdelingsopphold" STYLE={FONT_WEIGHT=BOLD FONT_STYLE=ROMAN JUST=LEFT VJUST=BOTTOM}};
RUN;

proc datasets nolist;
delete &dsn._trp: temp;
%mend Unikevariableavdopphold;