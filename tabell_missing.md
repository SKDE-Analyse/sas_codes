
# Dokumentasjon for filen *makroer/tabell_missing.sas*

Macro som beregner antall missing-verdier for alle variabler i et datasett.

## INPUT:
- ds: navn på datasett
- where: where statement på formen where=where ermann=0;

## OUTPUT:

1. En tabell-rapport med antall datarader og antall missing for alle variabler
2. Ett datasett (&ds._f) hvor alle variabler i det opprinnelige datasettet er omgjort til 
	numeriske variabler og alle verdier i det opprinnelige datasettet er 
	erstattet med enten 1 (hvis missing) eller 0 (hvis ikke missing).


## Makro `tabell_missing`

