
# Dokumentasjon for filen *rateprogram/standard_rate.sas*


# Makro for kjønns- og/eller aldersstandardisering.

## Argumenter til %standard_rate()
- _første argument_ = `<simple dataspecifier>`. En simplifisert dataspecifier med formen `<dataset>/<variables>`. `<variables>` er her en SAS Variable List, og %standard_rate vil kalkulere en standardisert rate for alle variablene.
- **region** = `[bohf, borhf, boshhn]`. Denne variabelen styrer på hvilket regionalt nivå standardiseringen skal gjøres. Default: bohf.
- **min_age** = `[<number>, auto]`. Laveste alder man skal ha med i standardiseringen. Default: auto.
- **max_age** = `[<number>, auto]`. Høyeste alder man skal ha med i standardiseringen. Default: auto.
- **out** = `<text>`. Navn på utdatasett.
- **out_vars** = `<list>`. Liste over hvilke type variabler som skal med i ut-datasettet. Mulige verdier er rate (justert rate), crude (ujustert rate), ant (sum av variabelen), avg (justert gjennomsnittlig verdi av variabelen), cravg (ujustert gjennomsnitt). Default: rate ant.
- **age_group_size** = `<number>`. Størrelsen på algersgruppene brukt i standariseringen. Default: 5.
- **ratemult** = `<number>`. Ratemultiplikator, dvs. rate pr. Default: 1000.
- **std_year** = `<number>`. Standardiseringsår. Default: auto. (auto betyr at std_year = max_year).
- **min_year** = `<number>`. Første år man skal ha med i standardiseringen. Default: auto.
- **max_year** = `<number>`. Siste år man skal ha med i standardiseringen. Default: auto.
- **standardize_by** = `[ka, a, k]`. Denne variabelen bestemmer hvilken type standardisering som skal utføres. `ka` betyr kjønns- og aldersstandardisering; `a` betyr aldersstandardisering (uten kjønnsjustering); og `k` betyr kjønnsjustering (uten aldersjustering). Default: ka.
- **kjonn** = `[begge, kvinner, menn]`. Denne variabelen avgjør om raten er på kvinnepopulasjonen, mannspopulasjonen, eller begge. Hvis kjonn=kvinner vil menn bli filtrert ut av både datafilen og populasjonsfilen, og den endelige raten vil bli "pr 1 000 kvinner", for eksempel. Default: begge.
- **yearly** = `[no, rate, crude, cravg, avg, ant]`. Hvis denne er satt til noe annet enn `no` vil det lages et transponert datasett (med navnet &out._yearly) hvor kolonnene er opptaksområder, og hver rad viser tall for et år. Dette gjør det lett å lage en tidstrend med %graf(). Default: rate.
- **population_data** = `<text>`. Datasett med informasjon om befolkningstall brukt i standardiseringen. Default: innbygg.INNB_SKDE_BYDEL.

# Introduksjon

Dette er en makro for å beregne standardiserte rater for en eller flere variabler i input-datasettet. Disse variablene blir summert for hver kjønns og/eller aldersgruppe i hvert boområde (noe som betyr at man kan sende inn aggregerte data),
og så justeres verdiene slik at summen av hver av variablene for hvert boområde blir slik de ville vært om demografien (altså kjønnsratioen og alderspyramiden) for boområdet hadde vært identisk med norgespopulasjonen i standardiseringsåret
(std_year=).

For at makroen skal fungere må input-datasettet ha variablene `aar`, `alder`, `ermann`, og en av disse: (`bohf`, `borhf`, `boshhn`).

Utdatasettet er strukturert slik at det er kompatibelt med [`%graf()`](./graf), slik at det er enkelt å representere resultatet visuelt.

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

![img](/sas_codes/bilder/std_rate.png)

I formelen ovenfor refererer b til et geografisk område; b står for boområde. g står for en spesifikk kjønn og/eller aldersgruppe, og G er antall grupper.
sum(V<sub>gb</sub>) er summen av variabelen vi vil finne raten for i gruppen g i boområdet b; b<sub>g</sub> refererer til antall innbyggere
i gruppen g i boområdet b. Med andre ord, sum(V<sub>gb</sub>)/b<sub>g</sub> er en rate som sier noe om hvor mange hendelser det er per person i boområdet b, i
gruppen g. Hvis vi med hendelser mener konsultasjoner, og det er omtrent like mange konsultasjoner som det er innbyggere, vil denne raten bli rundt 1. A<sub>g</sub>
refererer til hvor mange prosent gruppen g utgjør av den nasjonale populasjonen.

En ting som er verdt å notere seg er at A<sub>g</sub> refererer til populasjonen i standardiseringsåret (std_year=); b<sub>g</sub> på sin side refererer til
populasjonen i boområdet i det året hendelsene skjedde. Intensjonen med å gjøre det slikt er at man skal kunne sammenligne over tid.

# KA-justert gjennomsnitt (inklusive KA-justerte andeler)

For å lage en KA-justert andel, og mer generelt en KA-justert gjennomsnittlig verdi, brukes ikke populasjonen i boområdene, men heller fordelingen av observasjonene
på de forskjellige KA-gruppene i input-datasettet (i standardiseringsåret) som basis for standardiseringen. Formelen ser slik ut:

![img](/sas_codes/bilder/std_avg.png)

avg(V<sub>gb</sub>) er den gjennomsnittlige verdien av variabelen for hver KA-gruppe. A<sub>gN</sub> er hvor stor andel av alle observasjonene i input-datasettet som tilhører KA-gruppen g.

KA-justert gjennomsnitt er normalt ikke inkludert i utdatasettet til %standard_rate. For å få den med må man legge til avg i variabelen &out_vars, slik som dette

```
%standard_rate(datasett/prosedyre,
               region=bohf,
               out_vars=rate ant avg cravg,
               out=prosedyrer
)
```

Ovenfor har vi også lagt til cravg, som er det ujusterte gjennomsnittet. Ved å sammenligne avg med cravg kan man se effekten av KA-justeringen, for eksempel slik som dette:

```
%graf(bars=prosedyrer/prosedyre_avgsnitt,
      variation=prosedyrer/prosedyre_avgsnitt prosedyre_cravgsnitt, variation_colors=gray red,
      category=bohf
)
```


## Makro `parse_simple_dataspecifier`


## Makro `join_on`

