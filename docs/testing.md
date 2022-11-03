# Testing av SAS-koder

## Kjøre testene

Ved å kjøre følgende kode vil alle testene i "branchen" `main` kjøres:

```sas
%let branch = main;
%let filbane=/sas_smb/skde_analyse/Data/SAS/&branch;
%include "&filbane/tests/tests.sas";
%test(branch = &branch);
```

Endringer av kodene kan føre til at enkelte tester feiler. Det er da mulig å oppdatere referansene ved å kjøre `test` med `lag_ny_referanse = 1` slik:

```sas
%test(branch = &branch, lag_ny_referanse = 1);
```

## Hvordan lage test

Se hvordan det er gjort tidligere (i mappen `tests/`) og spør eventuelt Arnfinn.

Vanligvis bruker man et input-datasett, som man kjører koden på, og sammenligner data man får ut med et referansesett. I filen `tests/tests.sas` ligger makroen `sammenlignData`. Denne kan brukes til å sammenligne to datasett, der referansedatasettet ligger i mappen `&filbane/tests/data/`. Referansedatasettet lages ved å kjøre samme makro med argumentet `lagReferanse = 1` slik:

```sas
%sammenlignData(fil = <filnavn>, lagReferanse = 1);
```

## Muligheter for å teste SAS-kode på nett?

Vi ønsker å kjøre SAS-tester i en *Pull Request*, før de legges inn i `main`. Til det trengs en server som kjører SAS og som kan kommunisere med github. Mulige løsninger: bruke [saspy](https://github.com/sassoftware/saspy) for å kunne bruke python til å kjøre tester (med github actions).
