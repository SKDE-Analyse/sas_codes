%macro VarFraParvus(dsnMagnus=, dsnParvus= , var=);

/*!
### Beskrivelse

Hente variabler fra Parvus til Magnus.
OBS: Kan kun koble en filtype(avd, sho eller avtspes) for ett �r!! 
Hvis du �nsker � koble for flere �r og/eller fra ulike datasett (sho, avd, avtspes) m� makroen kj�res flere ganger.

```
%VarFraParvus(dsnMagnus=, dsnParvus= , var= );
```

### Parametre

- `dsnMagnus`: Datasettet du vil koble variable til. Kan v�re avdelingsoppholdsfil, sykehusoppholdsfil eller avtalespesialistfil.
- `dsnParvus`: Datasettet du skal hente variabel fra. Velg Parvus-fil som 'tilh�rer' dsnMagnus.
- `var`: Variable som skal kobles fra dsnParvus


### Eksempel hvor datasettene er basert p� RHF-data. Trenger data fra 2019 og 2020, kj�rer derfor makro to ganger. 

```
data utvalg19;
set hnana.t20t2_magnus_avd_2019;
run;

%varfraparvus(dsnMagnus=utvalg19, dsnParvus=hnana.t20t2_parvus_avd_2019, var=koblingsID innmnd utmnd komnrhjem2);


data utvalg20;
set hnana.t20t3_magnus_avd_2020;
run;

%varfraparvus(dsnMagnus=utvalg20, dsnParvus=hnana.t20t3_parvus_avd_2020, var=koblingsID innmnd utmnd komnrhjem2);

```

*/


proc sql;
create table &dsnMagnus as
select *
from &dsnMagnus a left join &dsnParvus(keep=koblingsID &var) b 
on a.koblingsID = b.koblingsID;
quit;

%mend; 
 
