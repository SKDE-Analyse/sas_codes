# Rateprogram-koden

Dette er for spesielt interesserte. [Ta meg tilbake.](./)

## Makroer i *rateberegninger.sas*

### utvalgx

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet



### `%macro omraadeNorge;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet


### `%macro omraade;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro lag_kart;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro omraadeHN;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Todeltalder;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Tredeltalder;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Firedeltalder;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Femdeltalder;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro valg_kategorier;`

#### Formål

#### Avhengig av følgende variabler

- `Alderskategorier`


#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- `Todeltalder`
- `Tredeltalder`
- `Firedeltalder`
- `Femdeltalder`

#### Annet

### `%macro tabell_1;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro tabell_1e;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Tabell_CV;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Tabell_CVe;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro tabell_3N;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro tabell_3Ne;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Tabell_3;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro Tabell_3e;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro lag_aarsvarbilde;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro lag_aarsvarfigur;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro KI_figur;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro KI_bilde;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro lagre_dataNorge;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro lagre_dataN;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro lagre_dataHN;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro aarsvar;`

#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet

### `%macro rateberegninger;`


#### Formål

#### Avhengig av følgende variabler

-

#### Kalles opp av følgende makroer

-

#### Bruker følgende makroer

- 

#### Annet



## Utvikling og stabile versjoner

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