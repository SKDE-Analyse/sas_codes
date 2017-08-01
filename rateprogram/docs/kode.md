Dette er for spesielt interesserte. [Ta meg tilbake.](./)

# Innholdsfortegnelse
{: .no_toc}

* auto-gen TOC:
{:toc}

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



## **omraadeNorge**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

- NORGE_AGG
- NORGE_AGG_SNITT

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}
Andre makro som kjøres direkte i rateprogrammet




## **rateberegninger**


#### Formål

Makro som beregner rater og spytter ut tabeller og figurer.

#### "Steg for steg"-beskrivelse

1. Lager datasettet `Norgeaarsspenn` fra `RV` og henter ut variablene min_aar og max_aar
2. Legger variablen alder til `norge_agg_snitt`
   - `alder=(substr(alder_ny,1,((find(alder_ny,'-','i'))-1)))-0;`
3. Lager tabell over aldersstruktur, basert på datasett `norge_agg_snitt`
4. Definere variablene Periode, Antall_aar, År1 etc. (dette gjøres også i utvalgX-makroen)
5. Kaller opp tabell-rutiner, figur-rutiner etc. basert på valg gjort i rateprogrammet (se variabelliste under)

#### Avhengig av følgende datasett

- `RV`
- `norge_agg_snitt`

#### Lager følgende datasett

- Norgeaarsspenn (kun for å finne min_aar og max_aar?)


#### Avhengig av følgende variabler

- tallformat
- ratevariabel
- forbruksmal
- boomraadeN
- boomraade
- Vis_tabeller
- RHF
- kart
- aarsvarfigur
- Fig_AA_RHF
- KIfigur
- Fig_KI_RHF
- HF
- Fig_AA_HF
- Fig_KI_HF
- sykehus_HN
- Fig_AA_ShHN
- Fig_KI_ShHN
- kommune
- Fig_AA_kom
- Fig_KI_kom
- kommune_HN
- Fig_AA_komHN
- Fig_KI_komHN
- fylke
- Fig_AA_fylke
- Fig_KI_fylke
- Verstkommune_HN
- oslo
- Fig_AA_Oslo
- Fig_KI_Oslo


#### Definerer følgende variabler

Sjekk hvilke som brukes av andre makroer og hvilke som kun er interne.

- aarsvarfigur (defineres også i [utvalgX](#utvalgx))
- Periode (defineres også i [utvalgX](#utvalgx))
- Antall_aar (defineres også i [utvalgX](#utvalgx))
- År1 etc. (defineres også i [utvalgX](#utvalgx))
- Bo (brukes i tabell-rutiner og figur-rutiner som kalles opp)


#### Kalles opp av følgende makroer

Ingen

#### Bruker følgende makroer

- [omraade](#omraade) (selve rateberegningene)
- [tabell_1](#tabell_1) (hvis Vis_tabeller=1,2,3 og tallformat=NLnum) Kjøres for Bo=Norge, Bo=BoRHF, , 
- [tabell_1e](#tabell_1e) (hvis Vis_tabeller=1,2,3 og tallformat=Excel)
- [tabell_3N](#tabell_3n) (hvis Vis_tabeller=3 og tallformat=NLnum)
- [tabell_3Ne](#tabell_3ne) (hvis Vis_tabeller=3 og tallformat=Excel)
- [lagre_dataNorge](#lagre_datanorge)
- [tabell_CV](#tabell_cv)
- [tabell_CVe](#tabell_cve)
- [tabell_3](#tabell_3)
- [tabell_3e](#tabell_3e)
- [lag_kart](#lag_kart)
- [lag_aarsvarbilde](#lag_aarsvarbilde)
- [lag_aarsvarfigur](#lag_aarsvarfigur)
- [KI_bilde](#ki_bilde)
- [KI_figur](#ki_figur)
- [lagre_dataN](#lagre_datan)
- [omraadeHN](#omraadehn)

#### Annet

Kjøres som tredje makro av rateprogrammet (etter [utvalgX](#utvalgX) og [omraadeNorge](#omraadeNorge))



## **valg_kategorier**

#### Formål
{: .no_toc}

Dele alder inn i kategorier, basert på verdi av `Alderskategorier`

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

- utvalgx

#### Lager følgende datasett
{: .no_toc}

Ingen (oppdaterer utvalgx)

#### Avhengig av følgende variabler
{: .no_toc}

- `Alderskategorier`

#### Definerer følgende variabler
{: .no_toc}

Ingen

#### Kalles opp av følgende makroer
{: .no_toc}

- [utvalgX](#utvalgx)

#### Bruker følgende makroer
{: .no_toc}

- `Todeltalder`
- `Tredeltalder`
- `Firedeltalder`
- `Femdeltalder`
- `Alderkat` (hvis Alderskategorier = 99; makroen defineres i selve rateprogrammet)

#### Annet
{: .no_toc}




## **omraade**

#### Formål

Selve rateberegningene. Ratene beregnes basert på &bo 

#### "Steg for steg"-beskrivelse

Kommer senere...

#### Avhengig av følgende datasett

- RV
- andel
- NORGE_AGG_RATE
   - Lages ved å kjøre makro med bo=Norge først. Burde den heller lages i [omraadeNorge](#omraadenorge)-makroen?

#### Lager følgende datasett

- RV&Bo
- &Bo._Agg
- &Bo._Agg_Snitt
- alder
- &Bo._Agg_rate
- &Bo._AGG_CV
- NORGE_AGG_RATE2
- NORGE_AGG_RATE3
- NORGE_AGG_RATE4
- NORGE_AGG_RATE5

#### Avhengig av følgende variabler

- SluttÅr
- StartÅr
- Bo
- aar
- forbruksmal

#### Definerer følgende variabler

- Antall_aar

#### Kalles opp av følgende makroer

- [rateberegninger](#rateberegninger)

#### Bruker følgende makroer

Ingen

#### Annet




## **lag_kart**

#### Formål
{: .no_toc}
#### "Steg for steg"-beskrivelse
{: .no_toc}
1. 

#### Avhengig av følgende datasett
{: .no_toc}
-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}




## **omraadeHN**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}





## **Todeltalder Tredeltalder Firedeltalder Femdeltalder**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}








## **tabell_1**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **tabell_1e**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **Tabell_CV**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **Tabell_CVe**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **tabell_3N**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **tabell_3Ne**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **Tabell_3**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **Tabell_3e**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **lag_aarsvarbilde**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **lag_aarsvarfigur**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **KI_figur**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **KI_bilde**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **lagre_dataNorge**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **lagre_dataN**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **lagre_dataHN**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}


## **aarsvar**

#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}




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