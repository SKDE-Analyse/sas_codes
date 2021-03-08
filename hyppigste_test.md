
# Dokumentasjon for filen *tests/hyppigste_test.sas*


## Makro `hyppigste_test`

Makro for å teste hyppigste-makro.

Kjører hyppigste-makroen på et test-datasett (`test.hyppigste_start`).
Sammenligner dette datasettet med en referanse (`test.ref_hyppigste_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken hyppigste-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.hyppigste_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_hyppigste_&navn` på nytt.

### Tester

#### Test default

Kjører med `%hyppigste(VarName=hdiag, data_inn=test.hyppigste_start, test = hyppigste_&navn);`

#### Test Ant_i_liste

Kjører med `Ant_i_liste = 20`

#### Test VarName

Kjører med `VarName=behsh`

#### Test where

Kjører med `Where=Where Behrhf=1`

