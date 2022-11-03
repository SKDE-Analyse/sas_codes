
# Dokumentasjon for filen *makroer/sykehusopphold.sas*


## Makro `sykehusopphold`


 ### Beskrivelse
Makro for Ã¥ markere opphold som regnes som en sykehusepisode. 
Inndatasettet mÃ¥ inneholde pid, inndato, utdato, inntid, uttid, aar, alder, aggrshoppid_lnr, aktivitetskategori3, hastegrad, uttilstand, behsh

```
%sykehusopphold(dsn=, overforing_tid=28800, forste_hastegrad=1, behold_datotid=0, nulle_liggedogn=0, minaar=0);
```
### Parametre

### Input
- `dsn`: datasett man utfÃ¸rer analysen pÃ¥ 
- `overforing_tid` (=28800): tidskrav i sekunder (default 8 timer) for opphold med tidsdifferanse - mÃ¥ vÃ¦re et tall
- `forste_hastegrad` (=1): Hastegrad for fÃ¸rste kontakt hvis ulik 0. Hvis 0: hastegrad for fÃ¸rste dÃ¸gnopphold
- `behold_datotid` (=0): Hvis ulik 0, sÃ¥ beholdes disse 
- `nulle_liggedogn` (=0): Hvis forskjellig fra null, sÃ¥ settes antall SHO_liggedogn til null hvis opphold er <8 timer
- `minaar` (=0): dersom man Ã¸nsker Ã¥ bruke fÃ¸rste opphold for Ã¥ definere SHO_Aar
  
Episode of care omfatter da:
- Dersom inndatotid pÃ¥ nytt opphold er fÃ¸r utdatotid pÃ¥ forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid pÃ¥ forrige opphold


 
### Output
Makroen lager 12 (eventuelt 14) nye variabler:
1.  `SHO_nr_pid`: Nummererte SHO-opphold pr pid, dersom SHO bestÃ¥r av flere opphold har disse samme nummer
2.  `SHO_id`: Unik ID per sykehusopphold (pid+SHO_nr_pid)
3.  `SHO_Intern_nr`: Nummerer oppholdene innenfor hver SHO for hver pid
4.  `SHO_Antall_i_SHO`: Antall opphold i SHO
5.  `SHO_inndato`: inndato pÃ¥ fÃ¸rste opphold i SHO
6.  `SHO_utdato`: utdato pÃ¥ siste opphold i SHO
7.  [eventuelt] `SHO_inndatotid`: inntid (dato og tidspunkt) pÃ¥ fÃ¸rste opphold i SHO (hvis behold_datotid ulik 0))
8.  [eventuelt] `SHO_utdatotid`: uttid (dato og tidspunkt) pÃ¥ siste opphold i SHO (hvis behold_datotid ulik 0))
9.  `SHO_aar`: Ã¥r ved utskriving - alternativt minaar=1 (Ã¥r ved fÃ¸rste opphold)
10. `SHO_liggetid`: tidsdifferanse mellom inndatotid pÃ¥ det fÃ¸rste oppholdet og utdatotid pÃ¥ det siste oppholdet i SHO
11. `SHO_aktivitetskategori3`: 1 hvis ett av oppholdene er dÃ¸gn, eller 2 hvis ett av oppholdene er dag (og ingen dÃ¸gn), eller 3 hvis oppholdene er kun poli
12. `SHO_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `SHO_forste_hastegrad`: Hastegrad for fÃ¸rste avdelingsopphold. 1 for akutt, 4 for elektiv
14. `SHO_uttilstand`: max(uttilstand) for oppholdene i en SHO ("som dÃ¸d" hvis ett av oppholdene er "som dÃ¸d")


### Endringslogg
- 07.09.2021 Opprettet av Janice Shu
- juni 2022, fikset bug som ga duplikate sho_id (den slo sammen rader som ikke hÃ¸rte sammen, og ga dermed feil i sho-variablene)
