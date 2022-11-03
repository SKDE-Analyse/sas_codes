
# Dokumentasjon for filen *makroer/VarFraParvus1.sas*

### Beskrivelse

Hente variabler fra Parvus til Magnus.
OBS: Kan kun koble en filtype(avd, sho eller avtspes) for ett år!! 
Hvis du ønsker å koble for flere år og/eller fra ulike datasett (sho, avd, avtspes) må makroen kjøres flere ganger.

```
%VarFraParvus(dsnMagnus=, dsnParvus= , var= );
```

### Parametre

- `dsnMagnus`: Datasettet du vil koble variable til. Kan være avdelingsoppholdsfil, sykehusoppholdsfil eller avtalespesialistfil.
- `dsnParvus`: Datasettet du skal hente variabel fra. Velg Parvus-fil som 'tilhører' dsnMagnus.
- `var`: Variable som skal kobles fra dsnParvus


### Eksempel hvor datasettene er basert på RHF-data. Trenger data fra 2019 og 2020, kjører derfor makro to ganger. 

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

