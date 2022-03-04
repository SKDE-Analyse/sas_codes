
%macro kpr_avledede(inndata= , utdata=);
data &utdata;
set &inndata;

%if &diagnose eq 1 %then %do; /*kjøres kun på diagnosedata*/
/* 
- Lager numerisk 'kodeverk' fra string 'diagnosetabell'. Drop variabel 'diagnosetabell'
*/
if diagnosetabell eq "ICPC-2"                          then kodeverk = 1;
if diagnosetabell eq "ICPC-2B"                         then kodeverk = 2;
if diagnosetabell eq "ICD-10"                          then kodeverk = 3;
if diagnosetabell eq "ICD-DA-3"                        then kodeverk = 4;
if diagnosetabell eq "Akser i BUP-klassifikasjon"      then kodeverk = 5;
if diagnosetabell eq " "                               then kodeverk = .;
drop diagnosetabell;
%end;

%if &regning eq 1 %then %do; /*Kjøres kun på regningsdata*/
/* 
- Lager 'inndato' og 'inntid' fra 'datotid'. Drop 'datotid'. 
*/
inndato = datepart(datotid);
inntid = timepart(datotid);
drop datotid;

/*
- Lager 'ermann' fra variabel 'kjonn'. Drop 'kjonn'
*/
if kjonn eq 1 then ermann = 1; /*menn*/
if kjonn eq 2 then ermann = 0; /*kvinner*/
if kjonn eq . then ermann = .; /*missing*/
drop kjonn kjonn_navn;

/* 
- Lager 'tjenestetype_kpr' fra 'tjenestetypenavn'. Sletter 'tjenestetypenavn'
*/
if tjenestetypenavn eq "Fastlege"                       then tjenestetype_kpr = 1; 
if tjenestetypenavn eq "Legevakt"                       then tjenestetype_kpr = 2; 

if tjenestetypenavn eq "Fysioterapeut privat"           then tjenestetype_kpr = 3; 
if tjenestetypenavn eq "Fysioterapeut kommunal"         then tjenestetype_kpr = 4; 
if tjenestetypenavn eq "Kiropraktor"                    then tjenestetype_kpr = 5; 

if tjenestetypenavn eq "Tannlege"                       then tjenestetype_kpr = 6; 
if tjenestetypenavn eq "Kjeveortoped"                   then tjenestetype_kpr = 7; 
if tjenestetypenavn eq "Tannpleier"                     then tjenestetype_kpr = 8; 

if tjenestetypenavn eq "Helsestasjon"                   then tjenestetype_kpr = 9; 
if tjenestetypenavn eq "Logoped"                        then tjenestetype_kpr = 10; 
if tjenestetypenavn eq "Ridefysioterapi"                then tjenestetype_kpr = 11; 
if tjenestetypenavn eq "Audiopedagog"                   then tjenestetype_kpr = 12; 
if tjenestetypenavn eq "Ortoptist"                      then tjenestetype_kpr = 13; 

if tjenestetypenavn eq "Ukjent" 
    or tjenestetypenavn eq " "                          then tjenestetype_kpr = 14; 
drop tjenestetypenavn;
%end;
run;
%mend kpr_avledede;
