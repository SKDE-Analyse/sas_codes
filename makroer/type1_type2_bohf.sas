%macro type1_type2_bohf(type1=, type2=);

/*!
### Beskrivelse

Lage datasett klart for ratefigurer ala offentlig/privat

```
%type1_type2_bohf(type1=, type2=);
```

### Parametre

1. `type1`: navn på datasett 1 fra ratestrøm for bohf (for eksempel off)
2. `type2`: navn på datasett 2 fra annen ratestrøm for bohf (for eksempel priv)

### Forfattere

Opprettet 11/5-16 av Arnfinn og Linda
*/

data &type1.;
set &type1._bohf;
ratesnitt_type1 = ratesnitt;
Norge_type1 = Norge;
type=1;
run;

data &type2.;
set &type2._bohf;
ratesnitt_type2 = ratesnitt;
Norge_type2 = Norge;
type=2;
run;

data &type1._&type2.;
set &type1. &type2.;
drop aar rate2012 rate2013 rate2014;
run;

proc sql;
   create table &type1._&type2. as 
   select *, SUM(ratesnitt) as Totalsnitt, SUM(Norge) as Norge_totalt
   from &type1._&type2.
   group by  BoHF;
quit;

data &type1._&type2.;
set &type1._&type2.;
Plassering_andel=100;
andel_type1 = (ratesnitt_type1/totalsnitt);
run; 


data &type1._priv;
set &type1._priv;
if type=1 then ratesnitt=ratesnitt_type1;
if type=2 then ratesnitt=ratesnitt_type2;
format ratesnitt_type1 ratesnitt_type2 Norge_totalt totalsnitt andel_type1 NLNUM8.0; /* Formatet gir åpenrom som tusenskilletegn og komma som desimaltegn */
/*format andel_offentlig NLNUM8.0;*/

run;

proc sort data=&type1._&type2.;
by descending totalsnitt;
run;

%mend type1_type2_bohf;

