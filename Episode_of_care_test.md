
# Dokumentasjon for filen *tests/Episode_of_care_test.sas*


## Makro `Episode_of_care_test`

Makro for å teste EoC-makro.

Kjører EoC-makroen på et test-datasett (test.pseudosens_avd_magnus) med ulike parametre.
Sammenligner datasettene som spyttes ut med referanse-sett (test.ref_eoc[n]).

## input

- `branch` (=master) Valg av mappe der makroen ligger.
- `debug` (=0) Ikke slette midlertidige datasett hvis ulik null.
- `lagNyRef` (=0) Lagre ny referanse på disk hvis ulik null.

