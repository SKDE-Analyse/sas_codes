
# Dokumentasjon for filen *makroer/henteKorrvekt.sas*

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

