%macro hresept(inndata=, utdata=, ettersjekk = 1);

data qwerty_temp;
set &inndata;
where lopenr ne .;

aar_utlevering = year(utleveringsdato);
aar = periodeaar;

rename lopeNr = pid;
rename atc_1 = ATC;

ermann = .;
if kjonn eq "Mann" then ermann = 1; /*menn*/
if kjonn eq "Kvinne" then ermann = 0; /*kvinner*/
drop kjonn;

alder = aar - fodselsar;

run;

%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=qwerty_temp);

%include "&filbane/tilrettelegging/npr/2_tilrettelegging/bydel.sas";
%bydel(inndata=qwerty_temp, utdata=qwerty_temp);

%include "&filbane/makroer/boomraader.sas";
%boomraader(inndata=qwerty_temp);

%include "&filbane\tilrettelegging\hresept\lengde_formater.sas";
%lengde_formater(inndata=qwerty_temp ,utdata=qwerty_temp);

data &utdata;
set qwerty_temp;
/* sette ugyldige kommunenr til missing */
if bohf eq . then do;
        komnr = .;
        fylke = .;
        end;

keep ATC
ErMann
Fylke
refusjonsKodeResept
refusjonsKodeUtlevering
/* i stedet for ICD10 */
aar
aar_utlevering
alder
behandlingsstedReshID
bohf
borhf
boshhn
bydel
bydel2
fodselsar
forskrivningsDato
komnr
komnrhjem2
npkSærtjeneste_STGKode
orgNrForskrivendeEnhet
pas_reg2
pasfylke2
pid
reseptType
sh_reg
utleveringsdato
HReseptId_lnr; 
run;

%if &ettersjekk = 1 %then %do;
data ettersjekk;
set qwerty_temp;
run;
%end;

proc datasets nolist;
delete qwerty_temp;
run;

%mend;
