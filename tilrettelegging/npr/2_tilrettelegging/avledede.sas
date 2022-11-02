%Macro Avledede (innDataSett=, utDataSett=);

/*!

MACRO FOR AVLEDEDE VARIABLE

### Innhold i macroen:
1. Retting av ugyldig fødselsår og avleding av aldersgrupper
2. Definisjon av Alder, Ald_gr og Ald_gr5
3. Omkoding av KJONN til ErMann
5. DRGTypeHastegrad


### Steg for steg

*/

Data &Utdatasett;
set &Inndatasett;

/* fix variable anomaly that was discovered in the step 1 control */

/* isolated case, one line in 2018, one line in 2019 to be fixed */
if aar=2018 and liggetid>6000 then inndato=utdato;
if aar=2019 and liggetid> 800 then inndato=utdato;


/*!
- Retting av ugyldig fødselsår
*/

/* JS 17/07/2019- If year and month from persondata is available and valid, then use it as primary source */
tmp_alder=aar-fodtAar_DSF;
fodselsar_org=fodselsar;

if fodtAar_DSF > 1900 and 0 <= tmp_alder <= 110 
then fodselsar=fodtAar_DSF;

/* if fødselsår is still invalid */
if fodselsar > aar or fodselsar=. then fodselsar=9999;
if aar-fodselsar > 110 then fodselsar=9999;

/* Tove 31.03.2022 - ikke aktuelt for RHF-data somatikk og avtspes */
*doddato=DodDato_DSF;
*emigrertdato=emigrertDato_DSF;

/*!
- Definerer Alder basert på Fodselsår
*/

Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/
drop tmp_alder;

/*!
- Omkoding av KJONN til ErMann
*/
     if KJONN eq 1     then ErMann=1; /* Mann */
     if KJONN eq 2     then ErMann=0; /* Kvinne */
     if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;

/* ukjent kjønn i data får fikset til kjonn_DSF hvis det er kjente */
If ErMann=. and kjonn_DSF in (1,2) then do;
	if kjonn_DSF = 1 then ErMann = 1;
	if kjonn_DSF = 2 then ErMann = 0;
end;

ulikt_kjonn=.;
if kjonn=1 and kjonn_DSF=2 then ulikt_kjonn=1;
if kjonn=2 and kjonn_DSF=1 then ulikt_kjonn=1;


/*!
- Definere `hastegrad` og `DRGtypeHastegrad` (kun for somatikk). 
Definerer `hastegrad = 4` (planlagt) for avtalespesialistkonsultasjoner.
*/

%if &somatikk=1 %then %do;

  %if &sektor = SOM %then %do;/* this &sektor is the macro variable set in the SAS-project */
    if alderIdager ne . then do;
      if alderIdager < 0 then alderIdager=.;
    end;
 /* beregne liggetid som differanse utdato - inndato  */
    liggetid_org=liggetid;
    liggetid=utdato-inndato;
/* hastegrad */
    hastegrad=.;
    if innmateHast in (1,2,3)   then hastegrad=1; /*Akutt*/
    if innmateHast=4            then hastegrad=4; /*Planlagt*/
    if innmateHast=5            then hastegrad=5; /*Tilbakeføring av pasient fra annet sykehus (gjelder fra 2016)*/
/* DRG */
             if DRG_type='M' and hastegrad=4 /*Planlagt*/   then DRGtypeHastegrad=1;
        else if DRG_type='M' and hastegrad=1 /*Akutt*/      then DRGtypeHastegrad=2;
        else if DRG_type='K' and hastegrad=4 /*Planlagt*/   then DRGtypeHastegrad=3;
        else if DRG_type='K' and hastegrad=1 /*Akutt*/      then DRGtypeHastegrad=4;
        if DRG_TYPE=' ' then DRGtypeHastegrad=9;
        if hastegrad=.  then DRGtypeHastegrad=9;

/* 12.04.2021 - All lines in somatic files have the same value for sektor variable. Not sure why it is 4 since sektor 4 means avtspes in other files.
                       Recode this to 1 so that we can use the same format for sektor as we use in avtspes and pysk files */
        if sektor=4 then sektor=1; /*Somatiske aktivitetsdata*/    /* this sektor is a variable in the dataset */
    %end;
%end;

%if &sektor = REHAB %then %do;
  if sektor = 5 then sektor = 1;
%end;


%if &avtspes=1 %then %do;
    /*!
    - Sett alle hos avtalespesialister til planlagt (hastegrad 4), poliklinikk (omsorgsniva 3, utdato=inndato)
    */
    hastegrad=4;
    omsorgsniva=3; 
    utdato=inndato;

    if sektor='SOM' then tmp_sektor=5; /*Avtalespesialister, som*/
    if sektor='PHV' then tmp_sektor=4; /*Avtalespesialister, psyk*/
    drop sektor;
    rename tmp_sektor=sektor;
    
    /*
    ************************************************************************************************
    3.7	FAG_SKDE
    ************************************************************************************************
    /*!
    - Lager ny harmonisert variabel fra FAG og Fag_navn (gjelder kun avtalespesialister). 
    */

    if Fag = 1 then Fag_SKDE = 1;
    if Fag = 2 then Fag_SKDE = 2;
    if Fag = 3 then Fag_SKDE = 3;
    if Fag = 4 then Fag_SKDE = 4;
    if Fag = 5 then Fag_SKDE = 5;
    if Fag in (6:10,24,25) then Fag_SKDE = 6;
    if Fag in (11:14) then Fag_SKDE = 11;
    if Fag = 15 then Fag_SKDE = 15;
    if Fag = 16 then Fag_SKDE = 16;
    if Fag = 17 then Fag_SKDE = 17;
    if Fag = 18 then Fag_SKDE = 18;
    if Fag = 19 then Fag_SKDE = 19;
    if Fag = 20 then Fag_SKDE = 20;
    if Fag = 21 then Fag_SKDE = 21;
    if Fag = 22 then Fag_SKDE = 22;
    if Fag = 23 then Fag_SKDE = 23;
    if Fag = 30 then Fag_SKDE = 30;
    if Fag = 31 then Fag_SKDE = 31;

    /* SKDE data for 2015-2019 has fag in words, not in codes. */
    if Fag = 'anestesi'           then Fag_SKDE =  1;
    if Fag = 'barn'               then Fag_SKDE =  2;
    if Fag = 'fys med'            then Fag_SKDE =  3;
    if Fag = 'gyn'                then Fag_SKDE =  4;
    if Fag = 'hud'                then Fag_SKDE =  5;
    if substr(Fag,1,8) = 'indremed' and index(fag,'evma')<=0  then Fag_SKDE =  6;   /* indremed excluding revma */
    if substr(Fag,1,7) = 'kirurgi'  and index(fag,'plast')<=0 then Fag_SKDE = 11; /* kirurgi excluding plast */
    if Fag = 'nevrologi'          then Fag_SKDE = 15;
    if Fag = 'ortopedi'           then Fag_SKDE = 16;
    if Fag = 'kirurgi, plastisk'  then Fag_SKDE = 17;
    if Fag = 'radiologi'          then Fag_SKDE = 18;
    if index(fag,'evma')>0        then Fag_SKDE = 19; /* revma */
    if Fag = 'urologi'            then Fag_SKDE = 20;
    if Fag = 'ønh'                then Fag_SKDE = 21;
    if Fag = 'øye'                then Fag_SKDE = 22;
    if Fag = 'onkologi'           then Fag_SKDE = 23;
    if Fag = 'psykiatri'          then Fag_SKDE = 30;
    if Fag = 'psykologi'          then Fag_SKDE = 31;


    AvtSpes=1;
    liggetid=0;

    /*
    Definere spesialistenes avtale-RHF
    */
    /* JS/LL 11Jul2019
     use sh_reg instead of hard coding using institusjonID
    */
         if sh_reg=5 then AvtaleRHF=1; /* Helse Nord RHF*/     
    else if sh_reg=4 then AvtaleRHF=2; /*Helse Midt-Norge RHF*/
    else if sh_reg=3 then AvtaleRHF=3; /*Helse Vest RHF*/
    else if sh_reg=7 then AvtaleRHF=4; /*Helse Sør-Øst-RHF*/

%end;

run;

%mend;
