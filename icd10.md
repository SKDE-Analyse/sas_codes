
# Dokumentasjon for filen *tilrettelegging/npr/2_tilrettelegging/icd10.sas*


MACRO FOR ICD-KAPITTEL, KATEGORIBLOKK OG HOVEDDIAGNOSE PÅ TRE TEGN

### Innhold
1. ICD10KAP
2. ICD10KATBLOKK
3. hdiag3TEGN


### Steg for steg
- Definerer hoveddiagnosekap for ICD10 (1 tegn) ut fra oppgitt hoveddiagnose (4 tegn). Disse kodene er ikke oppdatert siden 2014 - vi må finne/be e-helsedir om lister for hvert år 
- Definerer ICD10 kategoriblokker
- Definerer hoveddiagnose på 3-tegnsnivå