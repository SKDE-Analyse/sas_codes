/* Denne makroen må kjøres før NY_BEHANDLER */
/* Korrigere behandlingssted før en lager behandlingssted2 */

%macro fix_behandlingssted(inndata= , beh=behandlingsstedkode, utdata=);


data &utdata;
set &inndata;

/* Ta vare på original variabel 'behandlingsstedkode' - lage en 'behandlingsstedkode2' */
behandlingsstedkode2 = &beh+0; 

/* 2016 */
if aar = 2016 then do; 
if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
if behandlingsstedkode2 = 974733213 then behandlingsstedkode2 = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feilplassert siffer, mens instititusjonid har riktig orgnr.*/
end;
/* 2017 */
if aar = 2017 then do; 
if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
if behandlingsstedkode2 = 974733213 then behandlingsstedkode2 = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feil siffer(2 i stedet for  0), mens instititusjonid har riktig orgnr.*/
if behandlingsstedkode2 = 383971636 then behandlingsstedkode2 = institusjonid  ; /*Akershus - fysioterapi - behandlingsstedkode har et feil siffer(starter med 3 i stedet for 9, er orgnr til hovedenhet/HF). Bruker institusjonid som har orgnr til Ahus Nordbyhagen somatikk.*/
end;
/* 2018 */
if aar = 2018 then do; 
if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
if behandlingsstedkode2 = 383971636 then behandlingsstedkode2 = hf  ; /*Akershus - fysioterapi - behandlingsstedkode har et feil siffer(starter med 3 i stedet for 9, er orgnr til hovedenhet/HF). Bruker hf som er til Ahus HF (institusjonid har orgnr til Ahus Nordbyhagen somatikk).*/
if behandlingsstedkode2 = 939617671 then behandlingsstedkode2 = institusjonid ; /*Behandlingsstedlokal sier 'Otta somatikk'. Orgnr tilhører Sel kommune. Bruker institusjonid som viser til Sykehuset Innlandet Hamar.*/
end;
/* 2019 */
if aar = 2019 then do; 
if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
end;

/* 2020 - T3-data */
if aar = 2020 then do; 
if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = 974737779 ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer. Bruker ikke 'institusjonID' som vanlig da den viser til hovedenhet i denne utleveringen.*/
if behandlingsstedkode2 = 825222332 then behandlingsstedkode2 = 919028513 ; /*LHL-klinikk Tønsberg. Bruke til hovedenhet.*/
if behandlingsstedkode2 = 924445114 then behandlingsstedkode2 = institusjonid ; /*Martina Hansens Hospital avd radiologi. InstitusjonId viser til hovedenhet.*/
if behandlingsstedkode2 =           then behandlingsstedkode2 = institusjonid ; /**/
if behandlingsstedkode2 =           then behandlingsstedkode2 = institusjonid ; /**/
end;

/* 2021 */
if aar = 2021 then do; 
if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = 974737779 ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer. Bruker ikke 'institusjonID' som vanlig da den viser til hovedenhet i denne utleveringen.*/
if behandlingsstedkode2 = 825222332 then behandlingsstedkode2 = 919028513 ; /*LHL-klinikk Tønsberg. Bruke til hovedenhet.*/
if behandlingsstedkode2 = 919122609 then behandlingsstedkode2 = institusjonid ; /*LHL sykehuset Vestfold. InstitusjonID viser til hovedenhet.*/
if behandlingsstedkode2 = 924445114 then behandlingsstedkode2 = institusjonid ; /*Martina Hansens Hospital avd radiologi. InstitusjonId viser til hovedenhet.*/
end;


/* Alle med missing behandlingsstedkode får behandlingsstedkode2 = institusjonid */
if behandlingsstedkode2 = . then behandlingsstedkode2 = institusjonid;

run;

%mend;


%macro fix_behandlingssted_rehab(inndata= , beh=behandlingsstedkode, utdata=);


data &utdata;
set &inndata;

/* Ta vare på original variabel 'behandlingsstedkode' - lage en 'behandlingsstedkode2' */
behandlingsstedkode2 = &beh+0; 

/* error in code?  typo, digit swap */
if behandlingsstedkode2 = 974841984 then behandlingsstedkode2 = 974841894;

/* Alle med missing behandlingsstedkode får behandlingsstedkode2 = institusjonid */
if behandlingsstedkode2 = . then behandlingsstedkode2 = institusjonid;

run;

%mend;