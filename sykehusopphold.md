
# Dokumentasjon for filen *makroer/sykehusopphold.sas*


## Makro `sykehusopphold`


 ### Beskrivelse
Makro for å markere opphold som regnes som en sykehusepisode. 
Inndatasettet må inneholde pid, inndato, utdato, inntid, uttid, aar, alder, aggrshoppid_lnr, aktivitetskategori3, hastegrad, uttilstand, behsh

```
%sykehusopphold(dsn=, overforing_tid=28800, forste_hastegrad=1, behold_datotid=0, nulle_liggedogn=0, minaar=0);
```
### Parametre

### Input
- `dsn`: datasett man utfører analysen på 
- `overforing_tid` (=28800): tidskrav i sekunder (default 8 timer) for opphold med tidsdifferanse - må være et tall
- `forste_hastegrad` (=1): Hastegrad for første kontakt hvis ulik 0. Hvis 0: hastegrad for første døgnopphold
- `behold_datotid` (=0): Hvis ulik 0, så beholdes disse 
- `nulle_liggedogn` (=0): Hvis forskjellig fra null, så settes antall SHO_liggedogn til null hvis opphold er <8 timer
- `minaar` (=0): dersom man ønsker å bruke første opphold for å definere SHO_Aar
  
Episode of care omfatter da:
- Dersom inndatotid på nytt opphold er før utdatotid på forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid på forrige opphold


 
### Output
Makroen lager 12 (eventuelt 14) nye variabler:
1.  `SHO_nr_pid`: Nummererte SHO-opphold pr pid, dersom SHO består av flere opphold har disse samme nummer
2.  `SHO_id`: Unik ID per sykehusopphold (pid+SHO_nr_pid)
3.  `SHO_Intern_nr`: Nummerer oppholdene innenfor hver SHO for hver pid
4.  `SHO_Antall_i_SHO`: Antall opphold i SHO
5.  `SHO_inndato`: inndato på første opphold i SHO
6.  `SHO_utdato`: utdato på siste opphold i SHO
7.  [eventuelt] `SHO_inndatotid`: inntid (dato og tidspunkt) på første opphold i SHO (hvis behold_datotid ulik 0))
8.  [eventuelt] `SHO_utdatotid`: uttid (dato og tidspunkt) på siste opphold i SHO (hvis behold_datotid ulik 0))
9.  `SHO_aar`: år ved utskriving - alternativt minaar=1 (år ved første opphold)
10. `SHO_liggetid`: tidsdifferanse mellom inndatotid på det første oppholdet og utdatotid på det siste oppholdet i SHO
11. `SHO_aktivitetskategori3`: 1 hvis ett av oppholdene er døgn, eller 2 hvis ett av oppholdene er dag (og ingen døgn), eller 3 hvis oppholdene er kun poli
12. `SHO_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `SHO_forste_hastegrad`: Hastegrad for første avdelingsopphold. 1 for akutt, 4 for elektiv
14. `SHO_uttilstand`: max(uttilstand) for oppholdene i en SHO ("som død" hvis ett av oppholdene er "som død")


### Endringslogg
- 07.09.2021 Opprettet av Janice Shu
