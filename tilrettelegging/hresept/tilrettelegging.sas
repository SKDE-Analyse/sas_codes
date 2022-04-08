%macro hresept(inndata=, utdata=, ettersjekk = 1);

data qwerty_temp;
set &inndata;
where lopenr ne .;

aar = year(utleveringsdato);

rename lopeNr = pid;
rename atc_1 = ATC;

ermann = .;
if kjonn eq "Mann" then ermann = 1; /*menn*/
if kjonn eq "Kvinne" then ermann = 0; /*kvinner*/

alder = aar - fodselsar;

if komnrhjem2 = 1103 and bydel2 in (1103, 1141, 1142, 111403) then bydel2 = 99;
if komnrhjem2 = 4601 and bydel2 in (1201, 4601) then bydel2 = 99;
if komnrhjem2 = 5001 and bydel2 in (5001, 5030) then bydel2 = 99;
if komnrhjem2 = 301 and bydel2 in (301, 30401) then bydel2 = 99;

run;

%include "&filbane\makroer\forny_komnr.sas";
%forny_komnr(inndata=qwerty_temp);

%include "&filbane\tilrettelegging\npr\2_tilrettelegging\bydel.sas";
%let avtspes = 0;
%let datagrunnlag = RHF;
%bydel(inndata=qwerty_temp, utdata=qwerty_temp);

%include "&filbane\makroer\boomraader.sas";
%boomraader(inndata=qwerty_temp);


data &utdata;
retain pid aar ermann alder bohf borhf komnr bydel refusjonsKodeResept refusjonsKodeUtlevering atc;
set qwerty_temp;

keep ATC
ErMann
Fylke
refusjonsKodeResept
refusjonsKodeUtlevering
/* i stedet for ICD10 */
aar
alder
behandlingsstedReshID
bohf
borhf
boshhn
bydel
bydel2
fodselsar
forskrivningsDato
kjonn
komnr
komnrhjem2
npkS�rtjeneste_STGKode
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
