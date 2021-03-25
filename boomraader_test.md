
# Dokumentasjon for filen *tests/boomraader_test.sas*


## Makro `boomraader_test`

Makro for å teste boomraader-makro.

Kjører boomraader-makroen på et test-datasett (`test.boomr_start`).
Sammenligner dette datasettet med en referanse (`test.ref_boomr_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken boomraader-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.boomr_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_boomr_&navn` på nytt.

