/* Denne makroen må kjøres før NY_BEHANDLER */
/* Korrigere behandlingssted før en lager behandlingssted2 */

%macro fix_behandlingssted(inndata= , beh=behandlingsstedkode, utdata=);


data &utdata;
set &inndata;

/* Ta vare på original variabel 'behandlingsstedkode' - lage en 'tmp_beh' */
tmp_beh = &beh; 

/* 2016 */
if aar = 2016 then do; 
if tmp_beh = 974377779 then tmp_beh = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
if tmp_beh = 974733213 then tmp_beh = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feilplassert siffer, mens instititusjonid har riktig orgnr.*/
end;
/* 2017 */
if aar = 2017 then do; 
if tmp_beh = 974377779 then tmp_beh = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
if tmp_beh = 974733213 then tmp_beh = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feil siffer(2 i stedet for  0), mens instititusjonid har riktig orgnr.*/
if tmp_beh = 383971636  then tmp_beh = institusjonid  ; /*Akershus - fysioterapi - behandlingsstedkode har et feil siffer(starter med 3 i stedet for 9, er orgnr til hovedenhet/HF). Bruker institusjonid som har orgnr til Ahus Nordbyhagen somatikk.*/
end;
/* 2018 */
if aar = 2018 then do; 
if tmp_beh = 974377779 then tmp_beh = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
if tmp_beh = 383971636  then tmp_beh = hf  ; /*Akershus - fysioterapi - behandlingsstedkode har et feil siffer(starter med 3 i stedet for 9, er orgnr til hovedenhet/HF). Bruker hf som er til Ahus HF (institusjonid har orgnr til Ahus Nordbyhagen somatikk).*/
if tmp_beh = 939617671  then tmp_beh = institusjonid ; /*Behandlingsstedlokal sier 'Otta somatikk'. Orgnr tilhører Sel kommune. Bruker institusjonid som viser til Sykehuset Innlandet Hamar.*/
end;
/* 2019 */
if aar = 2019 then do; 
if tmp_beh = 974377779 then tmp_beh = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
end;
/* 2020 */
if aar = 2020 then do; 
if tmp_beh = 974377779 then tmp_beh = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
end;

/* Alle med missing behandlingsstedkode får tmp_beh = institusjonid */
if tmp_beh = . then tmp_beh = institusjonid;

run;

%mend;