%macro hyppigste_petter(Ant_i_liste=, VarName=, data_inn=, tillegg_tittel=, Where=);

/*!
Hva gjør denne annerledes enn `hyppigste`?

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

%mend hyppigste_petter;