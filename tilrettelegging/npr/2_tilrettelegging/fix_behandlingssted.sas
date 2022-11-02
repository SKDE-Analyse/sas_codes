/* Makroen fix_behandlingssted bruker mottatt variabel 'behandlingsstedkode' til å lage 'behandlingsstedkode2' */
/* Den korrigerer feil i de enkelte år, og hos radene som mangler 'behandlingsstedkode' brukes variabel 'institusjonID'  */
/* OBS: Feilene angitt for de enkelte år gjelder RHF-data. */
/* Mottatt variabel behandlingsstedkode beholdes uendret */


%macro fix_behandlingssted(inndata= , beh=behandlingsstedkode, utdata=);

data &utdata;
set &inndata;

%if &datagrunnlag=RHF %then %do;
    /* Ta vare på original variabel 'behandlingsstedkode' - lage en 'behandlingsstedkode2' */
    behandlingsstedkode2 = &beh+0; 

    %if &sektor=SOM %then %do;

        /* 2016 */
        if aar = 2016 then do; 
            if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
            if behandlingsstedkode2 = 974733213 then behandlingsstedkode2 = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feilplassert siffer, mens instititusjonid har riktig orgnr.*/
        end;
        /* 2017 */
        if aar = 2017 then do; 
            if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = institusjonid ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer, mens institusjonid har riktig orgnr.*/
            if behandlingsstedkode2 = 974733213 then behandlingsstedkode2 = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feil siffer(2 i stedet for  0), mens instititusjonid har riktig orgnr.*/
            if behandlingsstedkode2 = 974733113 then behandlingsstedkode2 = institusjonid ; /*Somatikk Kristiansand - fysioterapi - behandlingsstedkode har et feil siffer(1 i stedet for  0), mens instititusjonid har riktig orgnr.*/
            if behandlingsstedkode2 = 383971636 then behandlingsstedkode2 = institusjonid  ; /*Akershus - fysioterapi - behandlingsstedkode har et feil siffer(starter med 3 i stedet for 9, er orgnr til hovedenhet/HF). Bruker institusjonid som har orgnr til Ahus Nordbyhagen somatikk.*/
            if institusjonid = 974116804 then behandlingsstedkode2 = institusjonid ; /* Diakonhjemmet kodet enkelt kontakter med behandlingsstedkode2 = 999999999 i 2017 */
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
            if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = 974737779 ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer. Bruker ikke 'institusjonID' (det er gjort tidligere år) da den viser til hovedenhet i denne utleveringen.*/
        end;

        /* Tove 31.03.2022: 2021-data */
        /* For lukkede data har Betanien rapportert med riktig orgnr*/
        *if aar = 2021 then do; 
            *if behandlingsstedkode2 = 974377779 then behandlingsstedkode2 = 974737779 ; /*Betanien spesialistpoliklinikk - behandlingsstedkode har et feilplassert siffer. Bruker ikke 'institusjonID' (det er gjort tidligere år) da den viser til hovedenhet i denne utleveringen.*/
        *end;
    %end;


    %if &sektor=REHAB %then %do;
        /* error in code?  typo, digit swap */
        if behandlingsstedkode2 = 974841984 then behandlingsstedkode2 = 974841894;

        if aar = 2021 then do;
            if behandlingsstedkode2 = 912985519 then behandlingsstedkode2 = 912685519; /* instID=912663272, according to Brønnøysundreg. one of their underenhet is 912685519.  Assume typo. */

        end;
    %end;

    /* Alle med missing behandlingsstedkode får behandlingsstedkode2 = institusjonid */
    if behandlingsstedkode2 = . then behandlingsstedkode2 = institusjonid;
%end;

%if &datagrunnlag=SKDE %then %do;
  * ta vare på original data;
  behandlingssted2_org=behandlingssted2;

  * utfylle missing med institusjonid;
  if behandlingssted2=. then behandlingssted2=institusjonID;
%end;

run;

%mend;

