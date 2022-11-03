
# Dokumentasjon for filen *tilrettelegging/ssb/lesSSBdata.sas*

Makro for Ã¥ lese Excel-fil med innbyggertall fra SSB

FÃ¸lgende mÃ¥ gjÃ¸res fÃ¸r denne makroen kjÃ¸res
1. Last ned data fra SSB som *Semikolonseparert med overskrift (csv)*.
Velg: Tabell - Visining 1 og lagre fil som Semikolonseparert med overskrift (CSV)
	a. Kommune: tabell 07459: Alders- og kjÃ¸nnsfordeling i kommuner, fylker og hele landets befolkning (K) 1986 - 2019
	b. Bydel: tabell 10826: Alders- og kjÃ¸nnsfordeling for befolkningen i de 4 stÃ¸rste byene (B) 2001 - 2019
2. Ãpne csv-fil i Excel
  - Fjern i to Ã¸verste radene
  - Erstatt `kjÃ¸nn` med `kjonn` og `Personer ÃÃÃÃ` med `Personer`
  - Sjekk at fanen heter `Personer`
  - Lagre som `xlxs`-fil med navnet `Innb20XX_bydel` eller `Innb20XX_kommune` i mappen `Analyse\Data\SAS\Tilrettelegging\Innbyggere`.

Makroen gjÃ¸r fÃ¸lgende:
- Leser fanen `Personer` fra filen `Innb&aar._bydel` (hvis `bydel ne 0`) eller `Innb&aar._kommune` (hvis `bydel = 0`).
- Konverterer variablene fra *character* til *numeric*. 
- Lagrer et sas-datasett med navnet `&utdata`.
