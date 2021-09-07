
# Dokumentasjon for filen *tilrettelegging/npr/2_tilrettelegging/avledede.sas*


MACRO FOR AVLEDEDE VARIABLE

### Innhold i macroen:
1. Retting av ugyldig fødselsår og avleding av aldersgrupper
2. Definisjon av Alder, Ald_gr og Ald_gr5
3. Omkoding av KJONN til ErMann
5. DRGTypeHastegrad




### Steg for steg

- Retting av ugyldig fødselsår
- Definerer Alder basert på Fodselsår
- Omkoding av KJONN til ErMann
- Definere `hastegrad` og `DRGtypeHastegrad` (kun for somatikk). 
Definerer `hastegrad = 4` (planlagt) for avtalespesialistkonsultasjoner.
    - Sett alle hos avtalespesialister til planlagt (hastegrad 4), poliklinikk (omsorgsniva 3, utdato=inndato)
    - Omdefinere aar fra utdato
    - Lager ny harmonisert variabel fra FAG og Fag_navn (gjelder kun avtalespesialister). 
