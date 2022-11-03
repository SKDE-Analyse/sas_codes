
# Dokumentasjon for filen *tilrettelegging/ssb/lesSSBdata.sas*

Makro for å lese Excel-fil med innbyggertall fra SSB

Følgende må gjøres før denne makroen kjøres
1. Last ned data fra SSB som *Semikolonseparert med overskrift (csv)*.
Velg: Tabell - Visining 1 og lagre fil som Semikolonseparert med overskrift (CSV)
	a. Kommune: tabell 07459: Alders- og kjønnsfordeling i kommuner, fylker og hele landets befolkning (K) 1986 - 2019
	b. Bydel: tabell 10826: Alders- og kjønnsfordeling for befolkningen i de 4 største byene (B) 2001 - 2019
2. Åpne csv-fil i Excel
  - Fjern i to øverste radene
  - Erstatt `kjønn` med `kjonn` og `Personer ÅÅÅÅ` med `Personer`
  - Sjekk at fanen heter `Personer`
  - Lagre som `xlxs`-fil med navnet `Innb20XX_bydel` eller `Innb20XX_kommune` i mappen `Analyse\Data\SAS\Tilrettelegging\Innbyggere`.

Makroen gjør følgende:
- Leser fanen `Personer` fra filen `Innb&aar._bydel` (hvis `bydel ne 0`) eller `Innb&aar._kommune` (hvis `bydel = 0`).
- Konverterer variablene fra *character* til *numeric*. 
- Lagrer et sas-datasett med navnet `&utdata`.
