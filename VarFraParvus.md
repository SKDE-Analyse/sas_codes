
# Dokumentasjon for filen *makroer/VarFraParvus.sas*

### Beskrivelse

Hente variable fra Parvus til Magnus

```
%VarFraParvus(dsnMagnus=,var_som=,var_avtspes=,taar= );
```

### Parametre

- `dsnMagnus`: Datasettet du vil koble variable til. Kan vÃ¦re avdelingsoppholdsfil, sykehusoppholdsfil, avtalespesialistfil eller kombinasjoner av disse
- `var_som`: Variable som skal kobles fra avdelingsopphold- eller sykehusoppholdsfil
- `var_avtspes`: Variable som skal kobles fra avtalespesialistfil.
- `taar`: TilretteleggingsÃ¥r. 

### Eksempel

```
VarFraParvus(dsnMagnus=radiusfrakturer,var_som=cyto: komnrhjem2, var_avtspes=Fag_navn komnrhjem2)
```

De varible du har valgt hentes fra aktuelle filer, kobles med variabelen *KoblingsID* og legges til inndatasettet
Start gjerne med et ferdig utvalg om det er mulig, da vil makroen kjÃ¸re raskere og kreve mindre ressurser

### Endringsoversikt

- 5/10-16 Opprettet av Petter Otterdal
- juni 2017: Tilpasset versjon for tilrettelagte sett (Petter Otterdal)
- juli 2018: tilpasset t18 (Arnfinn)
- juli 2019: tilpasset t19; fjernet t17 (Arnfinn)

## Makro `koble_parvus`

