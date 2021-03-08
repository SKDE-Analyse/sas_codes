
# Dokumentasjon for filen *rateprogram/sas/valg_kategorier.sas*


## Makro `valg_kategorier;
`

## **valg_kategorier**

#### Formål
{: .no_toc}

Dele alder inn i kategorier, basert på verdi av `Alderskategorier`

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. Kjører en av alderinndeling-makroene, basert på verdien av Alderskategorier
   - Der defineres `Startgr1`, `SluttGr1` etc.
2. Definerer `alder_ny` til 1, 2 etc. ut fra `Startgr1`, `SluttGr1` etc.

#### Avhengig av følgende datasett
{: .no_toc}

- utvalgx

#### Lager følgende datasett
{: .no_toc}

Ingen (legger til variablen `alder_ny` til datasettet utvalgx)


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

- [Todeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- [Tredeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- [Firedeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- [Femdeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- `Alderkat` (hvis Alderskategorier = 99; makroen defineres i selve rateprogrammet)

#### Annet
{: .no_toc}

