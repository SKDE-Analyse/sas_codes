%macro henteKorrvekt(avdfil =, shofil =, taar = 19);

/*!
### Beskrivelse

Hente variablen korrvekt fra sykehusoppholdsfil og legge til 
avdelingsoppholdsfil der disse mangler.

```
%macro henteKorrvekt(avdfil =, shofil = );
```

### Bakgrunn

Fra og med 2016 ligger ikke korrvekt inne i avdelingsoppholdfilen for opphold 
som blir aggregert i sykehusoppholdsfilen. Disse må derfor hentes inn manuelt 
fra sykehusoppholdsfilen. Aggregerte opphold har en variabel (`aggrshoppid_LNr`) 
som kan brukes til identifisere hvilke avdelingsopphold som er utgangspunktet 
for et sykehusopphold.

### Bivirkninger

- Variablen `korrvekt` legges til datasettet `&avdfil` på linjer med unike `aggrshoppid_LNr ne .`
- Datasettet `&avdfil` sorteres slik at de linjene med `aggrshoppid_LNr ne .` legges sist.
- Henter `aggrshoppid_LNr` fra *parvus* og dropper den til slutt. Det vil si at denne 
  vil fjernes fra datasettet selv om den eventuelt finnes fra før. Gjelder `&avdfil`
- Datasett i *work* som begynner på `qwerty` slettes.
- Makroen `VarFraParvus` kjøres på `&avdfil`, så bivirkninger fra den makroen arves.

### Forfatter

Opprettet 1/12-17 av Arnfinn

*/

/* Ikke rør &shofil */
data tmp_sho;
set &shofil;
run;

/* Hente aggrshoppid_LNr fra parvus */

%VarFraParvus(dsnMagnus=&avdfil, var_som=aggrshoppid_LNr, taar = &taar);
%VarFraParvus(dsnMagnus=tmp_sho, var_som=aggrshoppid_LNr, taar = &taar);

/* Kun beholde linjer fra sho som inneholder aggrshoppid_LNr */
data tmp_sho;
set tmp_sho;
where aggrshoppid_LNr ne .;
qwerty_drg = drg;
run;

/* Kun beholde linjer fra avd som inneholder aggrshoppid_LNr */
data qwerty_avd1;
set &avdfil;
where aggrshoppid_LNr ne .;
drop korrvekt;
run;

/* 
Kun beholde linjer fra avd som IKKE inneholder aggrshoppid_LNr.
Denne skal slås sammen med qwerty_avd1 til slutt.
*/
data qwerty_avd2;
set &avdfil;
where aggrshoppid_LNr = .;
run;

/* Koble korrvekt på linjer i &avdfil som har aggrshoppid_LNr*/
proc sql;
create table qwerty_avd1 as
select *
from qwerty_avd1, tmp_sho(keep = aggrshoppid_LNr korrvekt qwerty_drg)
where qwerty_avd1.aggrshoppid_LNr = tmp_sho.aggrshoppid_LNr;
quit;

/*
Fjerne korrvekt hvis drg for avdelingsopphold er ulik drg for sykehusopphold
*/

data qwerty_avd1;
set qwerty_avd1;
if drg ne qwerty_drg then korrvekt = .;
run;

/*
Fjerne korrvekt hvis den finnes på flere linjer
*/

proc sort data=qwerty_avd1;
by pid aggrshoppid_LNr korrvekt;
run;

data qwerty_avd1;
set qwerty_avd1;
by pid aggrshoppid_LNr;
if last.aggrshoppid_LNr ne 1 then korrvekt =. ;
run;

/* Overskrive &avdfil */
data &avdfil;
set qwerty_avd2 qwerty_avd1;
drop aggrshoppid_LNr qwerty_drg;
run;

/* Slette midlertidige datasett */
proc datasets nolist;
delete qwerty:;

%mend;