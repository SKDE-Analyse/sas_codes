
# Dokumentasjon for filen *rateprogram/sas/utvalgx.sas*


## Makro `utvalgx;
`

#### Formål

- Lager datasettet `utvalgX`
   - Aggreregerer opp pasienter ut fra inkluderingskriteriene (hvilke år, alder, etc.)
   - Henter inn antall innbyggere
   - Definerer opp boområder

#### "Steg for steg"-beskrivelse

1. Definerer Periode, År1 etc.
2. Lager datasettet utvalgX av &Ratefil
   - RV = &RV_variabelnavn
   - keep RV ermann aar alder komnr bydel
   - alder mellom 106-115 defineres til 105
   - kjører aldjust (ermann = 1, hvis ikke tom)
3. Hvis vis_ekskludering = 1 -> lage tabeller over ekskluderte data i datasett
   - Dette burde flyttes ut i egen makro
4. Aggregerer RV (i `utvalgX`)
   - grupperer på `aar, KomNr, bydel, Alder, ErMann`. 
   - ekskluderer data hvis aar utenfor &periode, alder utenfor &aldersspenn, komnr > 2030, og ermann ikke i &kjonn
5. Lese inn innbyggerfil
   - aggregering av innbyggere, gruppert som over 
   - samme ekskludering som over
   - legger så innbyggere til `utvalgX`
6. Definere alderskategorier
   - kjør makro [valg_kategorier](#valg_kategorier)
   - kjører `proc means` 
7. Definerer boområder
8. Beregner andeler
   - Lager datasett `Andel`, som brukes i justering i omraade-makroen.

   
#### Avhengig av følgende variabler

- Ratefil (navnet på det aggregerte datasettet)
- RV_variabelnavn (variablen det skal beregnes rater på)
- vis_ekskludering (=1 hvis man vil ha ut antall pasienter som er ekskludert)
- innbyggerfil (navnet på innbyggerfila)
- boomraadeN (?)
- boomraade (?)

#### Definerer følgende variabler

Sjekk hvilke som brukes av andre makroer og hvilke som kun er interne.

- aarsvarfigur=1
- Periode=(&StartÅr:&SluttÅr)
- Antall_aar=%sysevalf(&SluttÅr-&StartÅr+2)
- År1 etc.


#### Kalles opp av følgende makroer

Ingen

#### Bruker følgende makroer

- [valg_kategorier](#valg_kategorier)
- Boomraader (fra makro-mappen)

#### Lager følgende datasett

- utvalgx (slettes)
- innb_aar (slettes)
- RV
- alderdef (slettes)
- Andel

#### Annet

Første makro som kjøres direkte i rateprogrammet

