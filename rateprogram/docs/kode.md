Dette er for spesielt interesserte. [Ta meg tilbake.](./)

# Oversikt over makroene i *rateberegninger.sas*

## **utvalgx**

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
   - Er denne nødvendig? Kan ikke se at den "virker".
   - Lager datasett `Andel`

   
#### Avhengig av følgende variabler

- Ratefil (navnet på det aggregerte datasettet)
- RV_variabelnavn (variablen det skal beregnes rater på)
- vis_ekskludering (=1 hvis man vil ha ut antall pasienter som er ekskludert)
- innbyggerfil (navnet på innbyggerfila)
- boomraadeN (?)
- boomraade (?)

#### Definerer følgende variabler

(sjekk hvilke som brukes av andre makroer og hvilke som kun er interne)

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




## **omraadeNorge**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet

Andre makro som kjøres direkte i rateprogrammet




## **omraade**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet




## **lag_kart**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet




## **omraadeHN**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet





## **Todeltalder Tredeltalder Firedeltalder Femdeltalder**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet





## **valg_kategorier**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

- `Alderskategorier`

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- `Todeltalder`
- `Tredeltalder`
- `Firedeltalder`
- `Femdeltalder`

#### Annet




## **tabell_1**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **tabell_1e**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **Tabell_CV**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **Tabell_CVe**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **tabell_3N**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **tabell_3Ne**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **Tabell_3**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **Tabell_3e**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **lag_aarsvarbilde**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **lag_aarsvarfigur**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **KI_figur**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **KI_bilde**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **lagre_dataNorge**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **lagre_dataN**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **lagre_dataHN**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet


## **aarsvar**

#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet





## **rateberegninger**


#### Formål

#### "Steg for steg"-beskrivelse

1. 

#### Avhengig av følgende datasett

-

#### Lager følgende datasett

-

#### Avhengig av følgende variabler

-

#### Definerer følgende variabler


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

-

#### Annet






# Utvikling og stabile versjoner

- Branchen (mappen) 'master' er vår stabile versjon.
- For hver ny oppdatering i master oppdateres versjonnummeret.
  - Versionnummer følger, så godt det lar seg gjøre, [Semantic Versioning](semver.org) -- 1.0.0 ... 1.0.1 osv.
  - I korte trekk betyr det
    - så lenge første tall er likt, skal programmet være mulig å kjøre på samme måte som tidligere
    - hvis en endring fører til at rateprogrammet ikke kan kjøres på samme måte som tidligere, økes første tall
    - midterste tall økes hvis nye egenskaper legges inn i programmet
    - siste tall økes ved små endringer
  - Ny versjon får en tag, og eventuelt en egen mappe. Da får man kontroll på hvilke versjoner av rateprogrammet som er brukt til ulike prosjekter.
- All ny-utvikling skal skje i branchen (mappen) 'develop' eller i egen branch (mappe).
  - Kun når denne utviklingen er trygg/stabil og kvalitetssikret kan den legges i 'master'.
  - Hver branch får sin egen mappe
- All versjon-kontroll og opprettelse av nye versjoner gjøres foreløpig kun av Arnfinn.