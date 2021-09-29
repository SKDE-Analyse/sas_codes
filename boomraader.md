
# Dokumentasjon for filen *makroer/boomraader.sas*


## Makro `boomraader`

### Beskrivelse

Makro for å lage bo-variablene: boshhn, bohf, borhf og fylke.
Bo-variablene defineres ved å bruke 'komnr' og 'bydel' fra inndata.

```
%boomraader(inndata=, haraldsplass = 0, indreOslo = 0, bydel = 1, barn=0);
```

### Input 
- inndata: Datasett som skal få koblet på bo-variablene.
- haraldsplass = 1: Splitter ut Haraldsplass fra Bergen, NB: må også ha argument 'bydel = 1', default er 'haraldsplass=0'.
- indreOslo = 1: Slår sammen Diakonhjemmet og Lovisenberg, NB: må også ha argument 'bydel = 1', default er 'indreOslo=0'.
- bydel = 0: Uten bydel får hele kommune 301 Oslo bohf=30 (Oslo), ved bruk av 'bydel=1' deles kommune 301 Oslo til bohf: 15 (akershus), 17 (lovisenberg), 18 (diakonhjemmet) og 15 (ahus), default er 'bydel=1'. 
- barn = 1: Helgeland (Rana, Mosjøen og Sandnessjøen) legges under bohf=3 (Nordland) hvis vi ser på barn, og Lovisenberg og Diakonhjemmet skal til OUS, NB: må også ha argument 'bydel = 1', default er 'barn=0'.

### Output 
- bo-variablene: boshhn, bohf, borhf og fylke.

### Endringslogg:
- 2020 Opprettet av Tove og Janice
- september 2021, Tove, fjernet argument 'utdata='
