# Prosedyrer for testing av rateprogrammet

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


## Kjøring av test

Test av rateprogrammet kan kjøres slik:
```
%let versjon = develop;
%include "\\tos-sas-skde-01\SKDE_SAS\rateprogram\&versjon\tests\tests.sas";
%test1(branch = &versjon);
```
Her kjøres testen på develop-branchen, siden det er her utviklingen skal foregå. Bytt ut `develop` med `master` for å teste master-versjonen.

Testen vil sammenligne flere datasett, og for hver sammenligning spyttes noe ala dette ut:
```
                                                       The COMPARE Procedure                                                        
                                          Comparison of SKDE_ARN.REF_RATE_RV with WORK.RV                                           
                                                           (Method=EXACT)                                                           
                                                                                                                                    
NOTE: No unequal values were found. All values compared are exactly equal.                                                          
```
Hvis man får ut noe annet enn dette så har testen feilet.


## Oppdatering av datasett

Endringer i rateprogrammet kan påvirke datasettene man får ut. Hvis dette er endringer som er ønsket, og ikke er endringer som er forårsaket av nye feil i koden, må de datasettene man tester mot oppdateres. Dette gjøres ved å kjøre koden under *tests/lagFasit.sas* på nytt. Denne koden lagrer så de nødvendige datasett på *skde_arn*.

## Annet som burde testes

Det er umulig å dekke alle mulige scenarier, men her er en liste over hva man burde teste:
   - Forskjellig alderskategorier (kjører kun med Alderskategorier = 30 foreløpig)
   - Kun aldersjustering (aldjust=Ermann=1)
   - Verstkommune_HN = 1 (fungerer foreløpig ikke)
   - Velge ut noen boområder (f.eks Mine_boomraader = komnr in (1900:1930))
   - Kun ett kjønn (f.eks kjonn=(0))
   - Annen nevner (f.eks rate_pr=100000)
- Unit-testing
   - Teste hver enkelt makro uavhengig av resten av programmet.
   


