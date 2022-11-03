
# Dokumentasjon for filen *makroer/Episode_of_care.sas*

### Beskrivelse

Makro for Ã¥ markere opphold som regnes som en sykehusepisode. 
Inndatasettet mÃ¥ inneholde pid inndato utdato inntid og uttid

```
%Episode_of_care(dsn=, Eoc_tid=28800, forste_hastegrad=1, behold_datotid=0, debug=0, nulle_liggedogn=0);
```

### Parametre

- `dsn`: datasett man utfÃ¸rer analysen pÃ¥
- `Eoc_tid` (=28800): tidskrav i sekunder (default 28800 er 8 timer) for opphold med tidsdifferanse - mÃ¥ vÃ¦re et tall
- `forste_hastegrad` (=1): Hastegrad for fÃ¸rste kontakt hvis ulik 0. Hvis 0: hastegrad for fÃ¸rste dÃ¸gnopphold
- `behold_datotid` (=0): Hvis ulik 0, sÃ¥ beholdes disse 
- `debug` (=0): Spytter ut midlertidige datasett hvis forskjellig fra null
- `nulle_liggedogn` (=0): Hvis forskjellig fra null, sÃ¥ settes antall EoC_liggedogn til null hvis opphold er <8 timer
- `inndeling` (= 0):
  - 0: alle kontakter til pasient, uavhengig av behandler, teller som en episode
  - 1: alle kontakter til pasient internt i et behandlende RHF teller som en episode
  - 2: alle kontakter til pasient internt i et behandlende HF teller som en episode
  - 3: alle kontakter til pasient internt i et behandlende sykehus teller som en episode
- `separer_ut_poli` (=0): Hvis ulik null teller alle poliklinikkonsultasjoner og konsultasjoner hos avtalespesialist som egne EoC (alle konsultasjoner der aktivitetskategori3 ikke er 1 eller 2)
- `separer_ut_dag` (=0): Hvis ulik null teller alle dagbehandlinger som egne EoC (alle konsultasjoner der aktivitetskategori3 er 2)
  
Episode of care omfatter da:
- Dersom inndatotid pÃ¥ nytt opphold er fÃ¸r utdatotid pÃ¥ forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid pÃ¥ forrige opphold

### Variabler

Makroen lager 12 (eventuelt 14) nye variabler:
1.  `EoC_nr_pid`: Nummererte EoC-opphold pr pid, dersom EoC bestÃ¥r av flere opphold har disse samme nummer
2.  `EoC_id`: Unik ID for hver EoC (pid+EoC_nr_pid)
3.  `EoC_Intern_nr`: Nummerer oppholdene innenfor hver EoC for hver pid
4.  `EoC_Antall_i_EoC`: Antall opphold i EoC
5.  `EoC_inndato`: inndato pÃ¥ fÃ¸rste opphold i EoC
6.  `EoC_utdato`: utdato pÃ¥ siste opphold i EoC
7.  [eventuelt] `EoC_inndatotid`: inntid (dato og tidspunkt) pÃ¥ fÃ¸rste opphold i EoC (hvis behold_datotid ulik 0))
8.  [eventuelt] `EoC_utdatotid`: uttid (dato og tidspunkt) pÃ¥ siste opphold i EoC (hvis behold_datotid ulik 0))
9.  `EoC_aar`: Ã¥r ved utskriving - alternativt minaar=1 (Ã¥r ved fÃ¸rste opphold)
10. `EoC_liggetid`: tidsdifferanse mellom inndatotid pÃ¥ det fÃ¸rste oppholdet og utdatotid pÃ¥ det siste oppholdet i EoC
11. `EoC_aktivitetskategori3`: 1 hvis ett av oppholdene er dÃ¸gn, eller 2 hvis ett av oppholdene er dag (og ingen dÃ¸gn), eller 3 hvis oppholdene er kun poli
12. `EoC_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `EoC_forste_hastegrad`: Hastegrad for fÃ¸rste avdelingsopphold. 1 for akutt, 4 for elektiv
14. `EoC_uttilstand`: max(uttilstand) for oppholdene i en EoC ("som dÃ¸d" hvis ett av oppholdene er "som dÃ¸d")

### Endringslogg

- 26.10.2016 Opprettet av Frank Olsen
- 26.10.2016 Endret av Frank Olsen
- november 2016 Diverse endringer av Arnfinn
- desember 2016, Arnfinn
  - nytt argument: nulle_liggedogn
  - diverse andre endringer
- mai 2017, Arnfinn
  - eoc_hastegrad defineres kun for innleggelser
- august 2017, Arnfinn
  - hastegrad_inn = hastegrad hvis dÃ¸gn
  - hvis kols = 0 sÃ¥ er EoC_hastegrad = min(hastegrad_inn)
  - hvis kols ne 0 sÃ¥ er EoC_hastegrad = min(hastegrad)
  - EoC-makroen fungerte ikke hvis man hadde med avtalespesialister
- april 2018, Arnfinn
  - nytt argument: inndeling 
  - nytt argument: separer_ut_poli
- mars 2020, Frank
	- nytt: dersom man Ã¸nsker Ã¥ bruke fÃ¸rste opphold for Ã¥ definere EoC_Aar
	--> minaar=1

