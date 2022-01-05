
%macro kpr_avledede(inndata= , utdata=);
data &utdata;
set &inndata;

%if &diagnose eq 1 %then %do; /*kjøres kun på diagnosedata*/
/* 
- Lager 'kodeverk' fra 'diagnosetabell'. Slette variabel 'diagnosetabell'
*/
if diagnosetabell eq "ICPC-2"                          then kodeverk = 1;
if diagnosetabell eq "ICPC-2B"                         then kodeverk = 2;
if diagnosetabell eq "ICD-10"                          then kodeverk = 3;
if diagnosetabell eq "ICD-DA-3"                        then kodeverk = 4;
if diagnosetabell eq "Akser i BUP-klassifikasjon"      then kodeverk = 5;
if diagnosetabell eq " "                               then kodeverk = .;
drop diagnosetabell;
format kodeverk kodeverk.;
%end;


%if &diagnose ne 1 %then %do; /*Kjøres kun på regningsdata*/
/* 
- Lager 'kodeverk' fra 'hoveddiagnosetabell'. Slette variabel 'hoveddiagnosetabell'
*/
if hoveddiagnosetabell eq "ICPC-2"                          then kodeverk = 1;
if hoveddiagnosetabell eq "ICPC-2B"                         then kodeverk = 2;
if hoveddiagnosetabell eq "ICD-10"                          then kodeverk = 3;
if hoveddiagnosetabell eq "ICD-DA-3"                        then kodeverk = 4;
if hoveddiagnosetabell eq "Akser i BUP-klassifikasjon"      then kodeverk = 5;
if hoveddiagnosetabell eq " "                               then kodeverk = .;
drop hoveddiagnosetabell;
format kodeverk kodeverk.;

/* 
- Lager 'dato' og 'tid' fra 'datotid'. Sletter variabel 'datotid'. 
*/
dato = datepart(datotid);
tid = timepart(datotid);
format dato eurdfdd10. tid time8.;
drop datotid;

/*
- Lager 'ermann' fra variabel 'kjonn'. Rename 'kjonn' til 'kjonn_org'
*/
if kjonn eq 1 then ermann = 1; /*menn*/
if kjonn eq 2 then ermann = 0; /*kvinner*/
kjonn_org = kjonn;
format ermann ermann.;

/* 
- Lager 'tjenestetype' fra 'tjenestetypenavn'. Sletter 'tjenestetypenavn'
*/
if tjenestetypenavn eq "Fastlege"                       then tjenestetype = 1; 
if tjenestetypenavn eq "Legevakt"                       then tjenestetype = 2; 

if tjenestetypenavn eq "Fysioterapeut privat"           then tjenestetype = 3; 
if tjenestetypenavn eq "Fysioterapeut kommunal"         then tjenestetype = 4; 
if tjenestetypenavn eq "Kiropraktor"                    then tjenestetype = 5; 

if tjenestetypenavn eq "Tannlege"                       then tjenestetype = 6; 
if tjenestetypenavn eq "Kjeveortoped"                   then tjenestetype = 7; 
if tjenestetypenavn eq "Tannpleier"                     then tjenestetype = 8; 

if tjenestetypenavn eq "Helsestasjon"                   then tjenestetype = 9; 
if tjenestetypenavn eq "Logoped"                        then tjenestetype = 10; 
if tjenestetypenavn eq "Ridefysioterapi"                then tjenestetype = 11; 
if tjenestetypenavn eq "Audiopedagog"                   then tjenestetype = 12; 
if tjenestetypenavn eq "Ortoptist"                      then tjenestetype = 13; 

if tjenestetypenavn eq "Ukjent" 
    or tjenestetypenavn eq " "                          then tjenestetype = 14; 
drop tjenestetypenavn;
format tjenestetype tjenestetype.;
%end;
run;
%mend;
