[Ta meg tilbake.](./)

# Episode_of_care


Episode_of_care Makro - Opprettet 26.10.2016 av Frank Olsen
Endret 26.10.2016 av Frank Olsen
Endret 29.11.2016 av Arnfinn
Inndatasettet m� inneholde inndato utdato inntid og uttid
inntid og uttid m� (forel�pig) hentes fra parvus
%Episode_of_care(dsn=, Eoc_tid=28800, forste_hastegrad=1, behold_datotid=0, debug=0, nulle_liggedogn=0);
Parametre:
1. dsn: datasett man utf�rer analysen p�
2. Eoc_tid (=28800): tidskrav i sekunder (default 28800 er 8 timer) for opphold med tidsdifferanse - m� v�re et tall
3. forste_hastegrad (=1): Hastegrad for f�rste kontakt hvis ulik 0. Hvis 0: hastegrad for f�rste d�gnopphold
4. behold_datotid (=0): Hvis ulik 0, s� beholdes disse 
5. debug (=0): Spytter ut midlertidige datasett hvis forskjellig fra null
6. nulle_liggedogn (=0): Hvis forskjellig fra null, s� settes antall EoC_liggedogn til null hvis opphold er <8 timer
Episode of care omfatter da:
a. Dersom inndatotid p� nytt opphold er f�r utdatotid p� forrige opphold
b. Dersom nytt opphold er innen x sekunder fra utdatotid p� forrige opphold
Makroen lager 12 (eventuelt 14) nye variabler:
1.  EoC_nr_pid: Nummererte EoC-opphold pr pid, dersom EoC best�r av flere opphold har disse samme nummer
2.  EoC_id: Unik ID for hver EoC (pid+EoC_nr_pid)
3.  EoC_Intern_nr: Nummerer oppholdene innenfor hver EoC for hver pid
4.  EoC_Antall_i_EoC: Antall opphold i EoC
5.  EoC_inndato: inndato p� f�rste opphold i EoC
6.  EoC_utdato: utdato p� siste opphold i EoC
(7.  EoC_inndatotid: inntid (dato og tidspunkt) p� f�rste opphold i EoC (hvis behold_datotid ulik 0))
(8.  EoC_utdatotid: uttid (dato og tidspunkt) p� siste opphold i EoC (hvis behold_datotid ulik 0))
9.  EoC_aar: �r ved utskriving
10. EoC_liggetid: tidsdifferanse mellom inndatotid p� det f�rste oppholdet og utdatotid p� det siste oppholdet i EoC
11. EoC_aktivitetskategori3: 1 hvis ett av oppholdene er d�gn, eller 2 hvis ett av oppholdene er dag (og ingen d�gn), eller 3 hvis oppholdene er kun poli
12. EoC_hastegrad: 1 hvis ett av oppholdene er akutt, 4 ellers
13. EoC_forste_hastegrad: Hastegrad for f�rste avdelingsopphold. 1 for akutt, 4 for elektiv
14. EoC_uttilstand: max(uttilstand) for oppholdene i en EoC ("som d�d" hvis ett av oppholdene er "som d�d")
