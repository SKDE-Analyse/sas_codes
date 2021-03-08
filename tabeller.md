
# Dokumentasjon for filen *rateprogram/sas/tabeller.sas*


## Makro `tabell_1;
`


Makro for å lage tabell over rater, kontakter og innbyggere i de ulike boområder, fordelt på år.


## Makro `Tabell_CV;
`


Makro for å lage tabell med
- variasjonskoeffisient
- systematisk variasjonskoeffisient
- OBV
- RCV


## Makro `Tabell_3;
`

Makro som lager en tabell med 
- innbyggere
- kontakter
- ujustert rate
- direkte justert rate
- indirekte juster rate
- Standardavvik
- Nedre og øvre konfidensinterval

Kjøres hvis 

```
%Let Vis_Tabeller=3;
```

## Makro `lag_tabeller;
`

