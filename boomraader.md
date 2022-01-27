
# Dokumentasjon for filen *makroer/boomraader.sas*


## Makro `boomraader`

### Beskrivelse

Makro for Ã¥ lage bo-variablene: boshhn, bohf, borhf og fylke.
Bo-variablene defineres ved Ã¥ bruke 'komnr' og 'bydel' fra inndata.

```
%boomraader(inndata=, indreOslo = 0, bydel = 1);
```

### Input 
- inndata: Datasett som skal fÃ¥ koblet pÃ¥ bo-variablene.
- indreOslo = 1: SlÃ¥r sammen Diakonhjemmet og Lovisenberg, NB: mÃ¥ ogsÃ¥ ha argument 'bydel = 1', default er 'indreOslo=0'.
- bydel = 0: Uten bydel fÃ¥r hele kommune 301 Oslo bohf=30 (Oslo), ved bruk av 'bydel=1' deles kommune 301 Oslo til bohf: 15 (akershus), 17 (lovisenberg), 18 (diakonhjemmet) og 15 (ahus), default er 'bydel=1'. 

### Output 
- bo-variablene: boshhn, bohf, borhf og fylke.

### Endringslogg:
- 2020 Opprettet av Tove og Janice
- september 2021, Tove, fjernet argument 'utdata='
- januar 2022, Tove, fjerne argument 'barn=' og 'haraldsplass='
