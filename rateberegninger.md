
# Dokumentasjon for filen *rateprogram/rateberegninger.sas*

Denne filen inneholder alle makroene til rateprogrammet, bortsett fra
`boomraader`-makroen.

## Makro `omraadeNorge;
`

Tom makro, for å unngå feilmeldinger i eldre rateprogram-beregninger.

## Makro `rateberegninger;
`

#### Formål

Makro som beregner rater og spytter ut tabeller og figurer.

#### "Steg for steg"-beskrivelse

1. Lager datasettet `Norgeaarsspenn` fra `RV` og henter ut variablene min_aar og max_aar
2. Legger variablen alder til `norge_agg_snitt`
   - `alder=(substr(alder_ny,1,((find(alder_ny,'-','i'))-1)))-0;`
3. Lager tabell over aldersstruktur, basert på datasett `norge_agg_snitt`
4. Definere variablene Periode, Antall_aar, År1 etc. (dette gjøres også i utvalgX-makroen)
5. Kaller opp [omraade](#omraade)-makroen, som beregner ratene etc. ut fra `Bo`. `Bo` kan være

|`Bo`        |variabel = 1        |makro       |
| ---------- | -----------        | ---------- |
| Norge      |                    | [omraade](#omraade)    |
| BoRHF      | &RHF=1             | [omraade](#omraade)    |
| BoHF       | &HF=1              | [omraade](#omraade)    | 
| BoShHN     | &sykehus_HN=1      | [omraadeHN](#omraadehn)|
| komnr      | &kommune=1         | [omraade](#omraade)    | 
| komnr      | &kommune_HN=1      | [omraadeHN](#omraadehn)|
| fylke      | &fylke=1           | [omraade](#omraade)    |
| VK         | &Vertskommune_HN=1 | [omraadeHN](#omraadehn)|
| bydel      | &oslo=1            | [omraade](#omraade)    |
   
6. Kaller opp tabell-rutiner, figur-rutiner etc. basert på valg gjort i rateprogrammet (se variabelliste under)

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
- Vertskommune_HN
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
- [tabell_1](#tabell_1) (hvis Vis_tabeller=1,2,3) Kjøres for Bo=Norge, Bo=BoRHF, , 
- [tabell_CV](#tabell_cv) (hvis Vis_tabeller=2)
- [tabell_3N](#tabell_3n) (hvis Vis_tabeller=3)
- [tabell_3](#tabell_3) (hvis Vis_tabeller=3)
- [lagre_dataNorge](#lagre_datanorge)
- [lag_kart](#lag_kart)
- [lag_aarsvarbilde](#lag_aarsvarbilde)
- [lag_aarsvarfigur](#lag_aarsvarfigur)
- [KI_bilde](#ki_bilde)
- [KI_figur](#ki_figur)
- [lagre_dataN](#lagre_datan)
- [omraadeHN](#omraadehn)

#### Annet

Kjøres som andre makro av rateprogrammet (etter [utvalgX](#utvalgX))

