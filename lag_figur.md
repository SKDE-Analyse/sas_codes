
# Dokumentasjon for filen *makroer/lag_figur.sas*

### Beskrivelse

Makro for Ã¥ lage ratefigur. Makroen bruker rateprogrammet for Ã¥ lage rater.

### Parametre

- `dsn`: datasettet med (aggregerte) date. MÃ¥ inneholde fÃ¸lgende variabler: alder, ermann, komnr, bydel, "rate1", "rate2", der
navnene pÃ¥ "rate1" og "rate2" sendes inn som egne argumenter.
- `fignavn` (=&dsn._&rate1._&rate2, hvis ikke oppgitt): figurnavn 
- `mappe` (= "\\hn.helsenord.no\RHF\SKDE\Analyse\Data\SAS\Bildefiler"): mappen der figur skal lagres


## Makro `samle_datasett`


## Makro `splittet_figur`

