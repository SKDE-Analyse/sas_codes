[Ta meg tilbake.](./)

# Episode_of_care

### Beskrivelse

Inndatasettet må inneholde inndato utdato inntid og uttid
inntid og uttid må (foreløpig) hentes fra parvus

```
%Episode_of_care(dsn=, Eoc_tid=28800, forste_hastegrad=1, behold_datotid=0, debug=0, nulle_liggedogn=0);
```

### Parametre

1. `dsn`: datasett man utfører analysen på
2. `Eoc_tid` (=28800): tidskrav i sekunder (default 28800 er 8 timer) for opphold med tidsdifferanse - må være et tall
3. `forste_hastegrad` (=1): Hastegrad for første kontakt hvis ulik 0. Hvis 0: hastegrad for første døgnopphold
4. `behold_datotid` (=0): Hvis ulik 0, så beholdes disse 
5. `debug` (=0): Spytter ut midlertidige datasett hvis forskjellig fra null
6. `nulle_liggedogn` (=0): Hvis forskjellig fra null, så settes antall EoC_liggedogn til null hvis opphold er <8 timer

Episode of care omfatter da:
- Dersom inndatotid på nytt opphold er før utdatotid på forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid på forrige opphold

### Variabler

Makroen lager 12 (eventuelt 14) nye variabler:
1.  `EoC_nr_pid`: Nummererte EoC-opphold pr pid, dersom EoC består av flere opphold har disse samme nummer
2.  `EoC_id`: Unik ID for hver EoC (pid+EoC_nr_pid)
3.  `EoC_Intern_nr`: Nummerer oppholdene innenfor hver EoC for hver pid
4.  `EoC_Antall_i_EoC`: Antall opphold i EoC
5.  `EoC_inndato`: inndato på første opphold i EoC
6.  `EoC_utdato`: utdato på siste opphold i EoC
7.  [eventuelt] `EoC_inndatotid`: inntid (dato og tidspunkt) på første opphold i EoC (hvis behold_datotid ulik 0))
8.  [eventuelt] `EoC_utdatotid`: uttid (dato og tidspunkt) på siste opphold i EoC (hvis behold_datotid ulik 0))
9.  `EoC_aar`: år ved utskriving
10. `EoC_liggetid`: tidsdifferanse mellom inndatotid på det første oppholdet og utdatotid på det siste oppholdet i EoC
11. `EoC_aktivitetskategori3`: 1 hvis ett av oppholdene er døgn, eller 2 hvis ett av oppholdene er dag (og ingen døgn), eller 3 hvis oppholdene er kun poli
12. `EoC_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `EoC_forste_hastegrad`: Hastegrad for første avdelingsopphold. 1 for akutt, 4 for elektiv
14. `EoC_uttilstand`: max(uttilstand) for oppholdene i en EoC ("som død" hvis ett av oppholdene er "som død")

### Forfatter

Opprettet 26.10.2016 av Frank Olsen

Endret 26.10.2016 av Frank Olsen

Endret 29.11.2016 av Arnfinn

