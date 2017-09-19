%macro hyppigste(Ant_i_liste=, VarName=, data_inn=, tillegg_tittel=, Where=);
/*!

### Beskrivelse

```
%hyppigste(Ant_i_liste=, VarName=, data_inn=, Tillegg_tittel=, Where=);
```

### Parametre

1. `Ant_i_liste`: De *X* hyppigste - sett inn tall for *X*
2. `VarName`: Variabelen man analyserer
3. `data_inn`: datasett man utfører analysen på
4. `Tillegg_tittel`: Dersom man ønsker tilleggsinfo i tittel
  - settes i hermetegn dersom mellomrom eller komma brukes
5. `Where` 
  - dersom man trenger et where-statement:
  - Må skrives slik: `Where=Where Borhf=1`

### Forfatter
  
Opprettet 30/11-15 av Frank Olsen

Endret 4/1-16 av Frank Olsen
*/


data dsn;
set &data_inn;
&where;
run;

PROC SQL;
   CREATE TABLE dsn AS 
   SELECT DISTINCT &VarName,(COUNT(&VarName)) AS antall
      FROM dsn 
      GROUP BY &VarName;
QUIT;

proc rank data=dsn out=dsn descending ties=low;
   var antall; ranks Rang;
run;

proc sql noprint;
select sum(antall) into :totalt
from dsn; quit;

proc sql noprint;
select sum(antall) into :totaltrang
from dsn where rang le &Ant_i_liste; quit;

data dsn;
set dsn;
where rang le &Ant_i_liste;
PCT_tot=antall/&totalt;
PCT_rang_tot=100*(&totaltrang/&totalt);
call symput ('rang_av_total',round(PCT_rang_tot));
rest=(&totalt-&totaltrang);
call symput ('Ovrige',rest);
PCT_rang=antall/&totaltrang;
run;

%let rang_av_total=&rang_av_total;
%let totalt=&totalt;
%let totaltrang=&totaltrang;
%let Ovrige=&Ovrige;

Title "Rangering, &Ant_i_liste hyppigste &VarName, &rang_av_total.% av totalt, med &totaltrang av &totalt observasjoner totalt. &tillegg_tittel";
PROC TABULATE
DATA=dsn;
	WHERE( Rang <= &Ant_i_liste);	
	VAR antall PCT_tot PCT_rang;
	CLASS Rang &varName/	ORDER=FORMATTED MISSING;
	TABLE Rang={LABEL=""}*&varName={LABEL="" STYLE(CLASSLEV)={NOBREAKSPACE=ON}} ALL={LABEL="Totalt &Ant_i_liste hyppigste, Øvrige=&Ovrige "},
	antall={LABEL="Antall"}*F=12.0*Sum={LABEL=""} 
	PCT_tot={LABEL="Andel av total"}*F=PERCENT8.1*Sum={LABEL=""} 
	PCT_rang={LABEL="Andel &Ant_i_liste hyppigste"}*F=PERCENT8.1*Sum={LABEL=""}
	/ BOX={LABEL="&Ant_i_liste hyppigste &VarName , &tillegg_tittel " STYLE={JUST=LEFT VJUST=TOP}};
RUN; title;

proc datasets nolist;
delete dsn;
run;

%mend hyppigste;