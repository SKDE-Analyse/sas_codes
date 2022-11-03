
# Dokumentasjon for filen *tests/hyppigste_test.sas*

Makro for Ã¥ teste hyppigste-makro.

KjÃ¸rer hyppigste-makroen pÃ¥ et test-datasett (`test.hyppigste_start`).
Sammenligner dette datasettet med en referanse (`test.ref_hyppigste_&navn`).

### Parametre

- `branch = main`: Bestemmer hvilken hyppigste-makro som kjÃ¸res (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.hyppigste_start` pÃ¥ nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_hyppigste_&navn` pÃ¥ nytt.

### Tester

#### Test default

KjÃ¸rer med `%hyppigste(VarName=hdiag, data_inn=test.hyppigste_start, test = hyppigste_&navn);`

#### Test Ant_i_liste

KjÃ¸rer med `Ant_i_liste = 20`

#### Test VarName

KjÃ¸rer med `VarName=behsh`

#### Test where

KjÃ¸rer med `Where=Where Behrhf=1`

