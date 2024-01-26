
# Dokumentasjon for filen *rateprogram/standard_rate.sas*


Dette er en makro for å beregne standardiserte rater.

Justeringen gjøres basert på følgende formel (Adaptert fra forklaringen i [Eldrehelseatlaset fra 2017](https://www.skde.no/helseatlas/files/eldrehelseatlas_rapport.pdf#page=25)):

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

