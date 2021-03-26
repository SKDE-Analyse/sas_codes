[![Dokumentasjon](https://img.shields.io/badge/Dokumentasjon--grey.svg)](https://skde-analyse.github.io/sas_codes)

# En kombinasjon av SAS-kode-repositoriene ved SKDE

- [Makroer](makroer)
- [Rateprogrammet](rateprogram)
- [Tilrettelegging](tilrettelegging)
- Se [denne siden](https://skde-analyse.github.io/sas_codes/monorepo) for en beskrivelse av hvordan alt ble samlet.

## Testing av koden

Ved å kjøre følgende kode vil alle testene i "branchen" `master` kjøres:

```
%let branch = master;
%let filbane=<...>\felleskoder\&branch;
%include "&filbane\tests\tests.sas";
%test(branch = &branch);
```

Endringer av kodene kan føre til at enkelte tester feiler. Det er da mulig å oppdatere referansene ved å kjøre `test` med `lag_ny_referanse = 1` slik:

```
%test(branch = &branch, lag_ny_referanse = 1);
```
