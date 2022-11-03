
# Dokumentasjon for filen *tests/reinnleggelser_test.sas*

Makro for Ã¥ teste reinnleggelse-makro.

KjÃ¸rer reinnleggelse-makroen pÃ¥ et test-datasett (`test.reinn_start`).
Sammenligner dette datasettet med en referanse (`test.ref_reinn1` og `test.ref_reinn2`).

### Parametre

- `branch = main`: Bestemmer hvilken reinnleggelse-makro som kjÃ¸res (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset1` og `testset2`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.reinn_start` pÃ¥ nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_reinn1` og `test.ref_reinn2` pÃ¥ nytt.

