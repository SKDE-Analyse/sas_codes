
# Dokumentasjon for filen *tests/boomraader_test.sas*

Makro for Ã¥ teste boomraader-makro.

KjÃ¸rer boomraader-makroen pÃ¥ et test-datasett (`test.boomr_start`).
Sammenligner dette datasettet med en referanse (`test.ref_boomr_&navn`).

### Parametre

- `branch = main`: Bestemmer hvilken boomraader-makro som kjÃ¸res (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.boomr_start` pÃ¥ nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_boomr_&navn` pÃ¥ nytt.

