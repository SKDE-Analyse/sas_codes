
# Dokumentasjon for filen *tilrettelegging/npr/bobehandler.sas*

MACRO FOR BOSTED OG BEHANDLER

### Innhold i syntaxen:
Bområder og behandlingssteder
1. Numerisk kommunenummer og bydel (for Oslo)
2. BoShHN - Opptaksområder for lokalsykehusene i Helse Nord
3. BoHF - Opptaksområder for helseforetakene
4. BoRHF - Opptaksområder for RHF'ene
5. Fylke
6. Vertskommuner i Helse Nord
7. Behandlingssteder
8. BehSh - Behandlende sykehus
9. BehHF - Behandlende helseforetak
10. BehRHF - Behandlende regionalt helseforetak
11. SpesialistKomHN og vertskommuner (Vertskommuner Helse Nord)
12. Spesialistenes avtale-RHF

### Logg

- Opprettet av: Linda Leivseth
- Opprettet dato: 06. juni 2015
- Modifisert 04.10.2016 av Linda Leivseth og Petter Otterdal
- Modifisert 05.01.2017 av Linda Leivseth (lagt til missigverdi 99 for manglende info om bydel2)
- Modifisert 16.05.2018 av Arnfinn: Lagt inn avtspes.-kode
- Modifisert 03.07.2017 av Arnfinn, for tilrettelegging 2018:
  - Flyttet ut kode for definering av behandlende sykehus etc. (sykehus)
  - Flyttet ut kode for definering av avtaleRHF etc. (avtalespes.)
  - Kjører nå `forny_komnr`-makroen

### Steg for steg
- Skille Glittre og Feiring i behandlingssted2  da dette ikke er gjort fra NPR. Begge rapporterer på org.nr til Feiring (973144383) fra og med 2015.
- Numerisk kommunenummer og bydel (for Oslo, Stavanger, Bergen og Trondheim)
- Definere `komNr` til siste år (pr. 1. januar 2018) ved å kjøre makroen
`forny_komnr`
- Kjøre makroen `boomraader` for å definere opptaksområder
- Kjøre behandler-makroen for å definere behandlende sykehus, HF og RHF
- Kjøre AvtaleRHF_spesialistkomHN-makroen for å definere `AvtaleRHF` og
`spesialistkomHN` for avtalespesialister.
