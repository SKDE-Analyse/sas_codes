%macro univsh(dsn =, behandlingssted2 = 0);

/*!
Markerer universitetssykehus (BehUSh)

Følgende sykehus er definert som universitetssykehus 1 (BehUSh = 1):
- UNN Tromsø
- St. Olavs hospital Trondheim
- Haukeland
- Oslo universitetssykehus (Rikshospitalet, Ullevål, Radiumhospitalet)

Følgende sykehus er definert som universitetssykehus 2 (BehUSh = 2):
- Stavanger universitetssykehus
- Akershus universitetssykehus

Defineres ut i fra variablen `BehSh`.
*/

proc format;

value BehUSh
1 = "Universitetssykehus 1"
2 = "Universitetssykehus 2"
3 = "Lokalsykehus";

data &dsn;
set &dsn;

if BehSh in (21, /* UNN Tromsø */
             61, /* St. Olavs hospital Trondheim */
             101, /* Haukeland */
             180, /* Oslo universitetssykehus HF */
             181, /* OUS, Rikshospitalet */
             182, /* OUS, Aker */
             184, /* OUS, Ullevål */
             186 /* OUS, Radiumhospitalet */
             ) then BehUSh = 1;
else if BehSh in (121, /* Stavanger universitetssykehus */
                  160  /* Akershus universitetssykehus */
                  ) then BehUSh = 2;
else BehUSh = 3;

/* Akershus universitetssykehus, Ski  er ikke universitetssykehus */
if behandlingssted2 = 974705192 then BehUSh = 3; 

format BehUSh BehUSh.;
run;



%mend;
