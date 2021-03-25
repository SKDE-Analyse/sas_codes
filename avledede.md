
# Dokumentasjon for filen *tilrettelegging/npr/avledede.sas*


MACRO FOR AVLEDEDE VARIABLE

### Innhold i macroen:
1. Retting av ugyldig fødselsår og avleding av aldersgrupper
2. Definisjon av Alder, Ald_gr og Ald_gr5
3. Omkoding av KJONN til ErMann
5. DRGTypeHastegrad


### Steg for steg

- Retting av ugyldig fødselsår
/*

/*
I datasettet er det registrert 27 personer over 110 år, som er høyeste oppnådde alder for bosatte i Norge i denne perioden, jfr.
Wikipedias kronologiske liste over eldste levende personer i Norge siden 1964 (http:
//no.wikipedia.org/wiki/Liste_over_Norges_eldste_personer#Kronologisk_liste_over_eldste_levende_personer_i_Norge_siden_01.01.1964).
Høyeste alder i datasetett er 141 år. Feilaktig høy alder kan påvirke gjennomsnittsalder i små strata. Velger derfor å definere
alder som ugyldig når oppgitt alder er høyere enn eldste person registret i Norge på dette tidspunktet.

Satte opprinnelig et krav om at personene måtte være bosatt i Norge, ettersom det er her vi har tall for eldste nålevende personer.
Dette innebærer imidlertid at mange opphold for personer bosatt i utlandet med alder over 110 år, og en særlig opphopning rundt
årstallet 1899 (som muligens er feilkoding av 1999 eller missing-verdi).Velger derfor også å nullstille alder for utenlandske borgere etter
samme regel som for norske.
- Definerer Alder basert på Fodselsår
- Omkoding av KJONN til ErMann
- Definere `hastegrad` og `DRGtypeHastegrad` (kun for somatikk). 
Definerer `hastegrad = 4` (planlagt) for avtalespesialistkonsultasjoner.
- Lager ny harmonisert variabel fra FAG og Fag_navn (gjelder kun avtalespesialister). 
