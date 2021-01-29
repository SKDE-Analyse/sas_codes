%Macro Bobehandler (innDataSett=, utDataSett=);

/*!
MACRO FOR BOSTED OG BEHANDLER

### Innhold i syntaxen:
Bomr�der og behandlingssteder
1. Numerisk kommunenummer og bydel (for Oslo)
2. BoShHN - Opptaksomr�der for lokalsykehusene i Helse Nord
3. BoHF - Opptaksomr�der for helseforetakene
4. BoRHF - Opptaksomr�der for RHF'ene
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
  - Kj�rer n� `forny_komnr`-makroen

### Steg for steg
*/

Data &Utdatasett;
Set &Inndatasett;



%if &somatikk ne 0 %then %do;
/*!
- Skille Glittre og Feiring i behandlingssted2  da dette ikke er gjort fra NPR. Begge rapporterer p� org.nr til Feiring (973144383) fra og med 2015.
*/
if behandlingssted2 in (973144383, 974116561) and tjenesteenhetKode=3200 then behandlingssted2=974116561;
%end;


/* 2021- USE THIS INSTEAD of the hard coding below ... MAYBE... CHECK!!!  */
if &bydel in (1:9) then bydel_fix = cats(&komnr,'0', &bydel);
else if &bydel in (10:99) then bydel_fix = cats(&komnr, &bydel);
else if &bydel eq . then bydel_fix = .;
bydel = input(bydel_fix, best6.); /*endre til numerisk*/



/*!
- Numerisk kommunenummer og bydel (for Oslo, Stavanger, Bergen og Trondheim)
*/

bydel2_num=.;
bydel2_num=bydel2+0;
bydel=.;
/* Oslo */
if komNr=0301 and bydel2_num=01 then bydel=030101; /* Gamle Oslo */
if komNr=0301 and bydel2_num=02 then bydel=030102; /* Gr�nerl�kka */
if komNr=0301 and bydel2_num=03 then bydel=030103; /* Sagene */
if komNr=0301 and bydel2_num=04 then bydel=030104; /* St. Hanshaugen */
if komNr=0301 and bydel2_num=05 then bydel=030105; /* Frogner */
if komNr=0301 and bydel2_num=06 then bydel=030106; /* Ullern */
if komNr=0301 and bydel2_num=07 then bydel=030107; /* Vestre Aker */
if komNr=0301 and bydel2_num=08 then bydel=030108; /* Nordre Aker */
if komNr=0301 and bydel2_num=09 then bydel=030109; /* Bjerke */
if komNr=0301 and bydel2_num=10 then bydel=030110; /* Grorud */
if komNr=0301 and bydel2_num=11 then bydel=030111; /* Stovner */
if komNr=0301 and bydel2_num=12 then bydel=030112; /* Alna */
if komNr=0301 and bydel2_num=13 then bydel=030113; /* �stensj� */
if komNr=0301 and bydel2_num=14 then bydel=030114; /* Nordstrand */
if komNr=0301 and bydel2_num=15 then bydel=030115; /* S�ndre Nordstrand */
if komNr=0301 and bydel2_num=16 then bydel=030116; /* Sentrum */
if komNr=0301 and bydel2_num=17 then bydel=030117; /* Marka */
if komNr=0301 and bydel2_num=. then bydel=030199; /* Uoppgitt bydel Oslo */
if komNr=0301 and bydel2_num=99 then bydel=030199; /* Uoppgitt bydel Oslo */


/* Stavanger */
if komNr=1103 and bydel2_num=01 then bydel=110301; /* Hundv�g */
if komNr=1103 and bydel2_num=02 then bydel=110302; /* Tasta */
if komNr=1103 and bydel2_num=03 then bydel=110303; /* Eiganes/V�land */
if komNr=1103 and bydel2_num=04 then bydel=110304; /* Madla */
if komNr=1103 and bydel2_num=05 then bydel=110305; /* Storhaug */
if komNr=1103 and bydel2_num=06 then bydel=110306; /* Hillev�g */
if komNr=1103 and bydel2_num=07 then bydel=110307; /* Hinna */
if komNr=1103 and bydel2_num=. then bydel=110399; /* Uoppgitt bydel Stavanger */
if komNr=1103 and bydel2_num=99 then bydel=110399; /* Uoppgitt bydel Stavanger */


/* Bergen */
if komNr=1201 and bydel2_num=01 then bydel=120101; /* Arna */
if komNr=1201 and bydel2_num=02 then bydel=120102; /* Bergenhus */
if komNr=1201 and bydel2_num=03 then bydel=120103; /* Fana */
if komNr=1201 and bydel2_num=04 then bydel=120104; /* Fyllingsdalen */
if komNr=1201 and bydel2_num=05 then bydel=120105; /* Laksev�g */
if komNr=1201 and bydel2_num=06 then bydel=120106; /* Ytrebygda */
if komNr=1201 and bydel2_num=07 then bydel=120107; /* �rstad */
if komNr=1201 and bydel2_num=08 then bydel=120108; /* �sane */
if komNr=1201 and bydel2_num=. then bydel=120199; /* Uoppgitt bydel Bergen */
if komNr=1201 and bydel2_num=99 then bydel=120199; /* Uoppgitt bydel Bergen */

/* Trondheim */
if komNr=1601 and bydel2_num=01 then bydel=160101; /* Midtbyen */
if komNr=1601 and bydel2_num=02 then bydel=160102; /* �stbyen */
if komNr=1601 and bydel2_num=03 then bydel=160103; /* Lerkendal */
if komNr=1601 and bydel2_num=04 then bydel=160104; /* Heimdal */
if komNr=1601 and bydel2_num=. then bydel=160199; /* Uoppgitt bydel Trondheim */
if komNr=1601 and bydel2_num=99 then bydel=160199; /* Uoppgitt bydel Trondheim */

if komNr=5001 and bydel2_num=01 then bydel=500101; /* Midtbyen */
if komNr=5001 and bydel2_num=02 then bydel=500102; /* �stbyen */
if komNr=5001 and bydel2_num=03 then bydel=500103; /* Lerkendal */
if komNr=5001 and bydel2_num=04 then bydel=500104; /* Heimdal */
if komNr=5001 and bydel2_num=. then bydel=500199; /* Uoppgitt bydel Trondheim */
if komNr=5001 and bydel2_num=99 then bydel=500199; /* Uoppgitt bydel Trondheim */

/*Ukjente kommunenummer*/
if KomNr in (0,8888,9999) then KomNr=9999;

/* Backup av komnr og bydel f�r "fornying" */
Komnr_org = KomNr;
bydel_org = bydel;

run;

/*!
- Definere `komNr` til siste �r (pr. 1. januar 2018) ved � kj�re makroen
`forny_komnr`
*/

%forny_komnr(datasett = &Utdatasett, aar = 2019);

Data &Utdatasett;
Set &Utdatasett;
/*!
- Kj�re makroen `boomraader` for � definere opptaksomr�der
*/
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 0, boaar=2018);

run;

%if &somatikk ne 0 %then %do;

/*!
- Kj�re behandler-makroen for � definere behandlende sykehus, HF og RHF
*/

%behandler(innDataSett=&Utdatasett, utDataSett=&Utdatasett);

%end;

%if &avtspes ne 0 %then %do;

/*!
- Kj�re AvtaleRHF_spesialistkomHN-makroen for � definere `AvtaleRHF` og
`spesialistkomHN` for avtalespesialister.
*/

%AvtaleRHF_spesialistkomHN(innDataSett=&Utdatasett;, utDataSett=&Utdatasett);

%end;


%mend;