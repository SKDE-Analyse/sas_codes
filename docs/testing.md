# Testing av SAS-koder

## Kjøre testene

Ved å kjøre følgende kode vil alle testene i "branchen" `master` kjøres:

```sas
%let branch = master;
%let filbane=<...>\felleskoder\&branch;
%include "&filbane\tests\tests.sas";
%test(branch = &branch);
```

Endringer av kodene kan føre til at enkelte tester feiler. Det er da mulig å oppdatere referansene ved å kjøre `test` med `lag_ny_referanse = 1` slik:

```sas
%test(branch = &branch, lag_ny_referanse = 1);
```

## Hvordan lage test

Se hvordan det er gjort tidligere (i mappen `tests/`) og spør eventuelt Arnfinn.

Vanligvis bruker man et input-datasett, som man kjører koden på, og sammenligner data man får ut med et referansesett. I filen `tests/tests.sas` ligger makroen `sammenlignData`. Denne kan brukes til å sammenligne to datasett, der referansedatasettet ligger i mappen `&filbane\tests\data\`. Referansedatasettet lages ved å kjøre samme makro med argumentet `lagReferanse = 1` slik:

```sas
%sammenlignData(fil = <filnavn>, lagReferanse = 1);
```

## Prosedyrer for testing av rateprogrammet

**Mulig denne dokumentasjonen er utdatert**

For å forhindre at man introduserer feil i rateprogrammet skal man teste koden etter at man har gjort endringer. Datasett som tidligere er produsert sjekkes mot datasett produsert av ny kode. Følgende datasett sjekkes:

- Etter `Stiler\Anno_logo_kilde_NPR_SSB.sas`:
  - anno
- Etter utvalgx-makro:
  - rv
  - andel
- Etter omraadeNorge-makro:
  - norge_agg
  - norge_agg_snitt
- Etter rateberegninger-makro, de &bo = Norge BoRHF bohf BoShHN komnr komnrHN fylke bydel:
  - &Bo._AGG_CV
  - &Bo._Agg_rate

### Kjøring av test

Test av rateprogrammet kan kjøres slik:

    %let versjon = <mappe>;
    %include "&filbane\rateprogram\tests\tests.sas";
    %test1(branch = &versjon);
Her kjøres testen i rateprogrammet i mappen &lt;mappe&gt;, siden utviklingen ikke skal gjøres direkte i `master`-mappen. Bytt ut &lt;mappe&gt; med `master` for å teste master-versjonen.

Testen vil sammenligne flere datasett, og for hver sammenligning spyttes noe ala dette ut:

                                   The COMPARE Procedure
                      Comparison of SKDE_ARN.REF_RATE_RV with WORK.RV
                                       (Method=EXACT)

    NOTE: No unequal values were found. All values compared are exactly equal.

Hvis man får ut noe annet enn dette så har testen feilet.

### Oppdatering av datasett

Endringer i rateprogrammet kan påvirke datasettene man får ut. Hvis dette er endringer som er ønsket, og ikke er endringer som er forårsaket av nye feil i koden, må de datasettene man tester mot oppdateres. Dette gjøres ved å kjøre koden under *tests/lagFasit.sas* på nytt. Denne koden lagrer så de nødvendige datasett på *skde_arn*.

### Annet som burde testes

Det er umulig å dekke alle mulige scenarier, men her er en liste over hva man burde teste:

- Forskjellig alderskategorier (kjører kun med Alderskategorier = 30 foreløpig)
- Kun aldersjustering (aldjust=Ermann=1)
- Velge ut noen boområder (f.eks Mine_boomraader = komnr in (1900:1930))
- Kun ett kjønn (f.eks kjonn=(0))
- Annen nevner (f.eks rate_pr=100000)
- Unit-testing
  - Teste hver enkelt makro uavhengig av resten av programmet.
   

## Muligheter for å teste SAS-kode på nett?

Vi ønsker å kjøre SAS-tester i en *Pull Request*, før de legges inn i `master`. Til det trengs en server som kjører SAS og som kan kommunisere med github. Mulige løsninger: bruke [saspy](https://github.com/sassoftware/saspy) for å kunne bruke python til å kjøre tester (med github actions).
