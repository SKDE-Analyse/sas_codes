
# Dokumentasjon for filen *makroer/boomraader.sas*

### Beskrivelse

Makro for å lage bo-variablene: boshhn, bohf, borhf og fylke.
Bo-variablene defineres ved å bruke 'komnr' og 'bydel' fra inndata.

```
%boomraader(inndata=, indreOslo = 0, bydel = 1);
```

### Input 
- inndata: Datasett som skal få koblet på bo-variablene.
- indreOslo = 1: Slår sammen Diakonhjemmet og Lovisenberg, NB: må også ha argument 'bydel = 1', default er 'indreOslo=0'.
- bydel = 0: Uten bydel får hele kommune 301 Oslo bohf=30 (Oslo), ved bruk av 'bydel=1' deles kommune 301 Oslo til bohf: 15 (akershus), 17 (lovisenberg), 18 (diakonhjemmet) og 15 (ahus), default er 'bydel=1'. 

### Output 
- bo-variablene: boshhn, bohf, borhf og fylke.

### Endringslogg:
- 2020 Opprettet av Tove og Janice
- september 2021, Tove, fjernet argument 'utdata='
- januar 2022, Tove, fjerne argument 'barn=' og 'haraldsplass='
- februar 2022, Tove, ta ut radene som kun brukes til formater
