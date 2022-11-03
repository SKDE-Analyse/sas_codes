
# Dokumentasjon for filen *tests/Episode_of_care_test.sas*

Makro for Ã¥ teste EoC-makro.

KjÃ¸rer EoC-makroen pÃ¥ et test-datasett (test.pseudosens_avd_magnus) med ulike parametre.
Sammenligner datasettene som spyttes ut med referanse-sett (test.ref_eoc[n]).

## input

- `branch` (=main) Valg av mappe der makroen ligger.
- `debug` (=0) Ikke slette midlertidige datasett hvis ulik null.
- `lagNyRef` (=0) Lagre ny referanse pÃ¥ disk hvis ulik null.

