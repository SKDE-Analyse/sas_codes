
# Dokumentasjon for filen *rateprogram/standard_rate.sas*


# %standard_rate; makro for kjønns- og/eller aldersstandardisering.

## Argumenter til %standard_rate()
- _første argument_ = `<simple dataspecifier>`. En simplifisert dataspecifier med formen `<dataset>/<variables>`. `<variables>` er her en SAS Variable List, og %standard_rate vil kalkulere en standardisert rate for alle variablene.
- **region** = `[bohf, borhf, boshhn]`. Denne variabelen styrer på hvilket regionalt nivå standardiseringen skal gjøres. Default: bohf.
- **min_age** = `[<number>, auto]`. Laveste alder man skal ha med i standardiseringen. Default: auto.
- **max_age** = `[<number>, auto]`. Høyeste alder man skal ha med i standardiseringen. Default: auto.
- **out** = `<text>`. Navn på utdatasett.
- **age_group_size** = `<number>`. Størrelsen på algersgruppene brukt i standariseringen. Default: 5.
- **ratemult** = `<number>`. Ratemultiplikator, dvs. rate pr. Default: 1000.
- **std_year** = `<number>`. Standardiseringsår. Default: auto. (auto betyr at std_year = max_year).
- **min_year** = `<number>`. Første år man skal ha med i standardiseringen. Default: auto.
- **max_year** = `<number>`. Siste år man skal ha med i standardiseringen. Default: auto.
- **standardize_by** = `[ka, a, k]`, Denne variabelen bestemmer hvilken type standardisering som skal utføres. `ka` betyr kjønns- og aldersstandardisering; `a` betyr aldersstandardisering (uten kjønnsjustering); og `k` betyr kjønnsjustering (uten aldersjustering). Default: ka.
- **population_data** = `<text>`. Datasett med informasjon om befolkningstall brukt i standardiseringen. Default: innbygg.INNB_SKDE_BYDEL.

# Introduksjon

Dette er en makro for å beregne standardiserte rater for en eller flere variabler i input-datasettet. Disse variablene blir summert for hver kjønns og/eller aldersgruppe i hvert boområde (noe som betyr at man kan sende inn aggregerte data),
og så justeres verdiene slik at summen av hver av variablene for hvert boområde blir slik de ville vært om demografien (altså kjønnsratioen og alderspyramiden) for boområdet hadde vært identisk med norgespopulasjonen i standardiseringsåret
(std_year=).

For at makroen skal fungere må input-datasettet ha variablene `aar`, `alder`, `ermann`, og en av disse: (`bohf`, `borhf`, `boshhn`).

# Eksempel

La oss si at vi har et datasett (med navnet `datasett`) som inneholder en rad for hver konsultasjon i spesialisthelsetjenesten, og at dette datasettet
har et par variabler (`prosedyre_1` og `prosedyre_2`) som er satt til `1` hvis denne prosedyren er blitt utført. Hvis vi er interessert i å vite
hvor populær denne prosedyren er i de forskjellige opptaksområdene kan man bruke %standard_rate() til å regne ut kjønns- og aldersjusterte rater slik som dette:

```
%standard_rate(datasett/prosedyre_1 prosedyre_2,
               region=bohf,
               out=prosedyrer
)
```

Resultat vil da bli lagret i datasettet `prosedyrer`, som vil ha rundt 20 rader (en rad for hvert helseforetak, pluss en rad for norge). `prosedyrer` vil inneholder variabler slik som `prosedyre_1_ratesnitt` (kjønns- og aldersjusterte
rate for alle årene), `prosedyre_1_rate2019` (kjønns- og aldersjustert rate for 2019), `prosedyre_1_ant2019` (antall i 2019, uten noen standardisering) og `prosedyre_1_crudesnitt` (ujustert rate for alle årene). Den andre variabelen,
`prosedyre_2`, vil ha ekvivalente variabler i `prosedyrer`.

Utdatasettet `prosedyrer` vil også inneholde variabler slik som `popsnitt`, som sier hvor mange personer som bor i opptaksområdene som er i samme aldersgruppe som utvalget. Med andre ord, hvis datasettet bare inneholder data
for personer fra 75 til 105 år, vil variabelen `pop2022` være antallet i denne aldersgruppen som bor i et opptaksområde i 2022.

%standard_rate() finner automatisk ut av hvilken aldersgruppe som er med i utvalget, og hvilke år som er med. Standard-året blir automatisk satt til det siste året. Alt dette kan overstyres med å bruke variablene `min_age`, `max_age`, `min_year`, `max_year`,
og `std_year`. Det å finne ut hvilke år og hvilken aldersgruppe som er med i datasettet er tidskrevende, og man kan derfor få %standard_rate til å kjøre nesten dobbelt så raskt ved å spesifisere alle disse variablene.

# Kjønns- og/eller aldersstandardisering

Justeringen gjøres basert på følgende formel (adaptert fra forklaringen i [Eldrehelseatlaset fra 2017](https://www.skde.no/helseatlas/files/eldrehelseatlas_rapport.pdf#page=25)):

![img](/sas_codes/bilder/standard_rate_formel.png)

I formelen ovenfor refererer b til et geografisk område; b står for boområde. g står for en spesifikk kjønn og/eller aldersgruppe, og G er antall grupper.
b<sub>hg</sub> referer til anntall hendelser i gruppen g i boområde b (h for hendelser); b<sub>pg</sub> refererer til antall innbyggere (p for populasjon)
i gruppen g i boområdet b. Med andre ord, b<sub>hg</sub>/b<sub>pg</sub> er en rate som sier noe om hvor mange hendelser det er per person i boområdet b, i
gruppen g. Hvis vi med hendelser mener konsultasjoner, og det er omtrent like mange konsultasjoner som det er innbyggere, vil denne raten bli rundt 1. a<sub>g</sub>
refererer til hvor mange prosent gruppen g utgjør av den nasjonale populasjonen.

En ting som er verdt å notere seg er at a<sub>g</sub> refererer til populasjonen i standardiseringsåret (std_year=); b<sub>pg</sub> på sin side refererer til
populasjonen i boområdet i det året hendelsene skjedde. Intensjonen med å gjøre det slikt er at man skal kunne sammenligne over tid.


## Makro `parse_simple_dataspecifier`


## Makro `join_on`

