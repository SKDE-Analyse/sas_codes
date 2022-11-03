
# Dokumentasjon for filen *tests/reinnleggelser_test.sas*

Makro for å teste reinnleggelse-makro.

Kjører reinnleggelse-makroen på et test-datasett (`test.reinn_start`).
Sammenligner dette datasettet med en referanse (`test.ref_reinn1` og `test.ref_reinn2`).

### Parametre

- `branch = main`: Bestemmer hvilken reinnleggelse-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset1` og `testset2`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.reinn_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_reinn1` og `test.ref_reinn2` på nytt.

