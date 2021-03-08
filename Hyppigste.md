
# Dokumentasjon for filen *makroer/Hyppigste.sas*


## Makro `hyppigste`


### Beskrivelse

```
%hyppigste(Ant_i_liste=, VarName=, data_inn=, Tillegg_tittel=, Where=);
```

### Parametre

1. `Ant_i_liste`: De *X* hyppigste - sett inn tall for *X* (default = 10)
2. `VarName`: Variabelen man analyserer
3. `data_inn`: datasett man utfører analysen på
4. `Tillegg_tittel`: Dersom man ønsker tilleggsinfo i tittel
  - settes i hermetegn dersom mellomrom eller komma brukes
5. `Where` 
  - dersom man trenger et where-statement:
  - Må skrives slik: `Where=Where Borhf=1`
6. `test`:  Hvis ulik null lagres et datasett &test istedenfor tabell.

7.`by` : create the list for subgroups:
   - Må skrives slik: 'by=bohf'
   
### Forfatter
  
Opprettet 30/11-15 av Frank Olsen

Endret 4/1-16 av Frank Olsen

Ebdret 25/10-19 av Janice Shu : new argument 'by'
