
# Dokumentasjon for filen *tests/aggreger_test.sas*

Makro for å teste aggreger-makro.

Kjører aggreger-makroen på et test-datasett (`test.agg_start`).
Sammenligner dette datasettet med en referanse (`tests/data/agg_&navn.csv`).

### Parametre

- `branch = main`: Bestemmer hvilken aggreger-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0` Hvis ulik null, lage referansedatasettene `tests/data/agg_&navn.csv` på nytt.
- `lagNyStart = 0`: Hvis ulik null, lage startdatasettet `test.agg_start` på nytt.

