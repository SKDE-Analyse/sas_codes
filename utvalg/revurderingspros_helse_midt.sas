/*BESKRIVELSE:

Koder opp 18 definisjonsvariabler for alle de 18 prosedyrene som var med i Revurderingsprosjektet (2019-2023) - ledet av Helse Midt-Norge RHF
Utvalgskriterier er ihht. definisjonene vi har fått tilsendt av analysemiljøet i Helse Midt.
En oversikt over alle prosedyrene og definisjonene ligger i mappa \SKDE\Revurdering\Analyser\Prosedyrer i Helse Midt prosjektet

Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/revurderingspros_helse_midt.sas";
run;

*/


/*Søk etter prosedyrekoder*/
array prosedyre {*} NC:;
	do i=1 to dim(prosedyre);
	if prosedyre{i} = 'LCA10' then abrasio_pros=1;
	if prosedyre{i} = 'NBK13' then akromion_pros=1;
	if prosedyre{i} in ('QAE10','QBE10','QCE10','QDE10','QXE10') then hudtumor_pros=1;
    if prosedyre{i} in ('HAD30','HAD20') then bryst_pros=1;
    if prosedyre{i} = 'CBB00' then chalazion_pros=1;
    if prosedyre{i} in ('NDM19','NDM09') then dupuytren_pros=1;
    if prosedyre{i} in ('NDM39','NDR09') then ganglion_pros=1;
    if prosedyre{i} in ('JHA00','JHA20','JHB00') then hemoroide_pros=1;
    if prosedyre{i} in ('LCC10','LCD00','LCD30','LCD96','LCC20',
    'LCD10','LCD40','LCC11','LCD01','LCD04','LCD11','LCD31','LCD97'/*,'ZXC96'*/) then hysterektomi_pros=1;
    if prosedyre{i} in ('ACC51','NDE11','NDE12','NDL50','NDM19','NDM49') then karpaltunnel_pros=1;
    if prosedyre{i} in ('NGA11','NXGX23') then kneartroskopi_pros=1;
    if substr(prosedyre{i},1,3) = 'NGD' then menisk_pros=1;
    if prosedyre{i} in ('ENC30','ENC40','ENC45') then snorking_pros=1;
    if prosedyre{i} in ('EMB10','EMB12','EMB15','EMB20','EMB99') then tonsille_pros=1;
    if prosedyre{i} in ('NDE12','NDM49') then triggerfinger_pros=1;
    if prosedyre{i} ='DCA20' then oredren_pros=1;
    if prosedyre{i} in ('PHB10','PHB11','PHB12','PHB13','PHB14','PHB99','PHD10','PHD11',
    'PHD12','PHD15','PHD99') then varice_pros=1;

    if prosedyre{i} in ('PHV10','PHV12','PHV13','PHV14','PHV99','TPH10','PHX10','PHV10X',
    'PHV12X','PHV13X','PHV14X') then ekskl_pros_varice=1;
	if prosedyre{i} in ('WDAP57','WDAP89') then rygginj_pros=1;

	end;

/*Søk etter diagnoser*/
/*Søk i alle diagnosefelt*/
array diagnose {*} Hdiag: Bdiag:;
    do i = 1 to dim(diagnose); 	
	if substr(diagnose{i},1,1) = 'O' then ekskl_diag_abrasio=1; 
	if substr(diagnose{i},1,3) in ('C43','C44','C46','C49') then ekskl_diag_hudtumor=1;
    if substr(diagnose{i},1,1) = 'C' then ekskl_diag_allkreft=1;
    if diagnose{i} = 'H001' then chalazion_diag=1;
    if diagnose{i} = 'M720' then dupuytren_diag=1;
    if diagnose{i} = 'M674' then ganglion_diag=1;
    if substr(diagnose{i},1,3) = 'K64' then hemoroide_diag=1;
    if substr(diagnose{i},1,3) = 'N92' then hysterektomi_diag=1;
    if substr(diagnose{i},1,3) in ('D06','D07') then ekskl_diag_hyst=1;
    if substr(diagnose{i},1,3) in ('M15','M17') then kneartroskopi_diag=1;
    if diagnose{i} in ('M232','M233','S832') then menisk_diag=1;
    if diagnose{i} = 'G473' then ekskl_diag_snorking=1;
    if diagnose{i} in ('H652','H653') then tonsille_diag=1;
    if substr(diagnose{i},1,3) = 'J35' then tonsille_diag=1;
    if substr(diagnose{i},1,3) in ('G47','J36') then ekskl_diag_tonsille=1;
    if diagnose{i} = 'M653' then triggerfinger_diag=1;
    if diagnose{i} in ('H652','H653') then oredren_diag=1;
    if substr(diagnose{i},1,3) = 'H66' then oredren_diag=1;
    if diagnose{i} = 'H660' then ekskl_diag_oredren=1;
    if diagnose{i} = 'I872' then varice_diag=1;
    if substr(diagnose{i},1,3) = 'I83' then varice_diag=1;


    end;

/*Søk i hoveddiagnose*/
if hdiag = 'M754' then akromion_diag=1;
if hdiag = 'G560' then karpaltunnel_diag=1;
if hdiag in ('G551','G834','M518','M519','M545','M549') then rygginj_diag=1;


/*Søk i takster*/
array takst {*} normaltariff:;
	do i=1 to dim(takst);
	if takst{i} = 'k05c' then akromion_takst=1;
    if takst{i} = '140c' then dupuytren_takst=1;
    if takst{i} = '140c' then ganglion_takst=1;
    if takst{i} = '140l' then hemoroide_takst=1;
    if takst{i} = '140i' then karpaltunnel_takst=1;
    if takst{i} = 'k05b' then menisk_takst=1;
    if takst{i} in ('k02a','k02e','k02f','k02g') then tonsille_takst=1;
    if takst{i} = '140k' then triggerfinger_takst=1;
    if takst{i} in ('k02c','k02d','k02e','k02g','317b') then oredren_takst=1;
    if takst{i} = '145b' then varice_takst=1;

	end;


/*Kombinere flagg for pros/diag/takst*/
if abrasio_pros=1 and ekskl_diag_abrasio ne 1 then abrasio=1;
/*NB! Enkelte avtalespesialister sørpå har mange kontakter med LCA10 (abrasio) og LCA13 (fraksjonert abrasio). 
Dette er feilkoding og ble fjernet da vi gjorde analyser av abrasio i gynatlaset. 
Dersom man har med avtalespesialistdata i datagrunnlaget når man kjører denne makroen vil det gi 
mange kontakter med abrasio som ikke er reelle. Disse må derfor fjernes igjen.*/
abrasio2=abrasio;
if avtspes=1 then abrasio2=.;  

if akromion_takst=1 then akromion=1;
if akromion_pros=1 and akromion_diag=1 then akromion=1;

if hudtumor_pros=1 and ekskl_diag_hudtumor ne 1 then hudtumor=1;

if bryst_pros=1 and ekskl_diag_allkreft ne 1 then bryst=1;

if chalazion_pros=1 and chalazion_diag=1 then chalazion=1;

if dupuytren_takst=1 then dupuytren=1;
if dupuytren_pros=1 and dupuytren_diag=1 then dupuytren=1;

if ganglion_takst=1 then ganglion=1;
if ganglion_pros=1 and ganglion_diag=1 then ganglion=1;

if hemoroide_takst=1 and ekskl_diag_allkreft ne 1 then hemoroide=1;
if hemoroide_pros=1 and hemoroide_diag=1 and ekskl_diag_allkreft ne 1 then hemoroide=1;

if hysterektomi_pros =1 and hysterektomi_diag=1 and ekskl_diag_allkreft ne 1 and 
ekskl_diag_abrasio ne 1 and ekskl_diag_hyst ne 1 then hysterektomi=1;

if karpaltunnel_takst=1 then karpaltunnel=1;
if karpaltunnel_pros=1 and karpaltunnel_diag=1 then karpaltunnel=1;

if kneartroskopi_pros=1 and kneartroskopi_diag=1 then kneartroskopi=1;

if alder ge 45 and menisk_takst=1 then menisk=1;
if alder ge 45 and menisk_pros=1 and menisk_diag=1 then menisk=1;

if alder ge 18 and snorking_pros=1 and ekskl_diag_snorking ne 1 then snorking=1;

if tonsille_pros=1 and tonsille_diag=1 and ekskl_diag_allkreft ne 1 and ekskl_diag_tonsille ne 1 then tonsille=1;
if tonsille_takst=1 and ekskl_diag_allkreft ne 1 and ekskl_diag_tonsille ne 1 then tonsille=1;

if triggerfinger_pros=1 and triggerfinger_diag=1 then triggerfinger=1;
if triggerfinger_takst=1 then triggerfinger=1;

if alder le 17 and oredren_pros=1 and oredren_diag=1 and ekskl_diag_oredren ne 1 then oredren=1;
if alder le 17 and oredren_takst=1 and ekskl_diag_oredren ne 1 then oredren=1;

if varice_takst=1 and ekskl_pros_varice ne 1 then varice=1;
if varice_pros=1 and varice_diag=1 and ekskl_pros_varice ne 1 then varice=1;

if rygginj_diag=1 and rygginj_pros=1 then rygginj=1;