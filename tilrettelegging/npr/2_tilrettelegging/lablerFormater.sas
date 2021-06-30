
%Macro LablerFormater (innDataSett=, utDataSett=);

/*!
Legger på formater og labler
*/
/* 
Different levels: felles, somatikk, avtalespesialist
within each level, there is also : mottatt = 1 (NPR raw var) or 0 (SKDE derived var), and datagrunnlag = SKDE or RHF

Tree structure:
- felles
    - raw
        - SKDE datagrunnlag
    - derived

- somatikk
    - raw
        - SKDE datagrunnlag
    - derived
        - RHF datagrunnlag

- avtspes
    - raw
        - SKDE datagrunnlag
    - derived

Need these macro variables assigned before using the macro:
%let mottatt=;      * 1 for npr raw data, 0 or skde derived data;
%let datagrunnlag=; * SKDE, or RHF;
%let somatikk=;     * 1 for somatikk, 0 otherwise;
%let avtspes=;      * 1 for avtalespesialist, 0 otherwise;
 */

Data &Utdatasett;
set &Inndatasett;

/* If the macro variable mottatt is not assigned, assume it is in the tilrettelegging step and assign label and format on both raw and skde variables */
%if %sysevalf(%superq(mottatt)=,boolean) %then %let mottatt = 0;
%if %sysevalf(%superq(datagrunnlag)=,boolean) %then %let datagrunnlag = 0;

/* FELLES variables in both somatikk and avtspes */

/************************/
/* FELLES raw variables */
/************************/
/* apply in both step 1 control, and step 2 tilrettelegging */ 

label aar='År (NPR)';
label pas_reg2='Region (pasientregion) (NPR)'; format pas_reg2 region.;
label pasfylke2='Fylke (pasientens bosted) (NPR)'; format pasfylke2 fylke.;
label sh_reg='Region (sykehusregion) (NPR)'; format sh_reg region.;
label shfylke='Fylke (sykehusfylke) (NPR)';  format shfylke fylke.;
label innmateHast='Hastegrad ved ankomst (NPR-melding)'; format innmateHast innmateHast.; 
label innDato='Innskrivelsesdato (NPR-melding)'; format innDato Eurdfdd10.;
label utDato='Utskrivelsesdato (NPR-melding), utDato=innDato for avtSpes'; format utDato Eurdfdd10.;
label InstitusjonID='Org.nr. til rapporteringsenhet (NPR-melding)'; format InstitusjonId org_fmt.;
label KomNrHjem2='Innrapportert kommunenummer, numerisk (NPR-melding)'; format KomNR komnr_fmt.; 
label bydel2='Bydel vasket mot Folkeregisteret (NPR)'; format bydel bydel_fmt.;
label innTid='Innskrivelsestidspunkt (NPR-melding)'; 
label kontaktType='Kontakttype (NPR-melding)'; format kontaktType kontaktType.; 
label omsorgsniva='Omsorgsnivå (NPR-melding)'; format omsorgsniva omsorgsniva.;
label polIndir='Indirekte aktiviteter (NPR-melding)'; format polIndir POLINDIR.;
label stedAktivitet='Sted for aktivitet (NPR-melding)'; format STEDAKTIVITET STEDAKTIVITET.;
label utTid='Utskrivelsestidspunkt (NPR-melding)'; 
label komNrHjem2='Kommunenummer vasket mot Folkeregisteret (NPR-melding)'; format KomNrHjem2 komnr_fmt.; 
label komNrHjem='Kommunenummer, innrapportert (NPR-melding)'; 
label dodDato='Døddato (NPR)';
label ATC_1='ATC kode 1 (ATC/NPR-melding)'; 
label ATC_2='ATC kode 2 (ATC/NPR-melding)'; 
label ATC_3='ATC kode 3 (ATC/NPR-melding)'; 
label ATC_4='ATC kode 4 (ATC/NPR-melding)'; 
label ATC_5='ATC kode 5 (ATC/NPR-melding)';
label episodeFag='Fagområde for Episoden (NPR-melding)'; format episodeFag $fagomrade.;
label debitor='Debitor (NPR-melding)'; format debitor debitor.;
label henvFraTjeneste='Henvist fra tjeneste (NPR-melding)'; format HENVFRATJENESTE HENVFRATJENESTE.;
label henvTilTjeneste='Henvist til tjeneste (NPR-melding)'; format HENVTILTJENESTE HENVTILTJENESTE.;

/* Raw variables in SKDE datagrunnlag, not RHF datagrunnlag */
%if &datagrunnlag = SKDE %then %do;
    label NPRId_reg='Status for kobling mot ident-melding (NPR)'; format NPRId_reg NPRId_reg.;
    label emigrertDato='Emigrert dato (NPR)';
    label tell_ATC='Antall ATC-koder innrapportert (NPR)';
    label tell_ICD10='Antall ICD-10-koder innrapportert (NPR)';
    label tell_NCMP='Antall NCMP-koder innrapportert (NPR)';
    label tell_NCSP='Antall NCSP-koder innrapportert (NPR)';
    label tilSted='Til sted (NPK)'; format tilsted tilsted.;
    label fraSted='Fra sted (NPK)'; format frasted frasted.; 
    label polkonAktivitet='Aktivitetstype (NPR-melding)'; format polkonAktivitet POLKONAKTIVITET.;
    label oppholdstype='oppholdstype, ikke lenger i bruk etter 2017';
    label behandlingssted2='behandlingssted (NPR)'; format behandlingssted2 org_fmt.;

%end;

/****************************/
/* FELLES derived variables */
/****************************/
/* apply only in step 2 tilrettelegging */ 

%if &mottatt = 0 %then %do;
    label Alder='Alder (SKDE)';
    label BoHF='Opptaksområde (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label BoRHF='Opptaksområde (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label BoShHN='Opptaksområde (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label erMann='Er mann (kjønn, mann=1) (SKDE)'; format ErMann ErMann.; 
    label kjonn='Kjønn (NPR-melding)'; format kjonn kjonn.; 
    label Fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;

    label ICD10Kap='ICD-10 kapittel for første kode hovedtilstand (ICD-10/SKDE)'; format ICD10Kap ICD10Kap.;
    label ICD10KatBlokk='ICD-10 kategoriblokk for første kode hovedtilstand (ICD-10/SKDE)'; format ICD10KatBlokk ICD10KatBlokk.; 
    label KomNR='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021, numerisk (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem vasket mot Folkeregisteret (SKDE)'; format bydel bydel_fmt.;

    label Hdiag='Hovedtilstand kode 1 (ICD-10/NPR-melding/SKDE)'; format hdiag $icd10_fmt.;
    label Hdiag2='Hovedtilstand kode 2 (ICD-10/NPR-melding/SKDE)'; format hdiag2 $icd10_fmt.;
    label Hdiag3tegn='Hovedtilstand kode 1, 3 tegn (ICD-10/NPR-melding/SKDE)'; format Hdiag3tegn $hdiag3tegn.; 
    label Bdiag1='Bitilstand kode 1 (ICD-10/NPR-melding/SKDE)'; format Bdiag1 $icd10_fmt.;
    label Bdiag2='Bitilstand kode 2 (ICD-10/NPR-melding/SKDE)'; format Bdiag2 $icd10_fmt.;
    label Bdiag3='Bitilstand kode 3 (ICD-10/NPR-melding/SKDE)'; format Bdiag3 $icd10_fmt.;
    label Bdiag4='Bitilstand kode 4 (ICD-10/NPR-melding/SKDE)';
    label Bdiag5='Bitilstand kode 5 (ICD-10/NPR-melding/SKDE)';
    label Bdiag6='Bitilstand kode 6 (ICD-10/NPR-melding/SKDE)';
    label Bdiag7='Bitilstand kode 7 (ICD-10/NPR-melding/SKDE)';
    label Bdiag8='Bitilstand kode 8 (ICD-10/NPR-melding/SKDE)';
    label Bdiag9='Bitilstand kode 9 (ICD-10/NPR-melding/SKDE)';
    label Bdiag10='Bitilstand kode 10 (ICD-10/NPR-melding/SKDE)';

    label ncmp1='NCMP kode 1 (NCMP/NPR-melding/SKDE)'; label ncmp2='NCMP kode 2 (NCMP/NPR-melding/SKDE)'; 
    label ncmp3='NCMP kode 3 (NCMP/NPR-melding/SKDE)'; label ncmp4='NCMP kode 4 (NCMP/NPR-melding/SKDE)';
    label ncmp5='NCMP kode 5 (NCMP/NPR-melding/SKDE)'; label ncmp6='NCMP kode 6 (NCMP/NPR-melding/SKDE)'; 
    label ncmp7='NCMP kode 7 (NCMP/NPR-melding/SKDE)'; label ncmp8='NCMP kode 8 (NCMP/NPR-melding/SKDE)';
    label ncmp9='NCMP kode 9 (NCMP/NPR-melding/SKDE)'; label ncmp10='NCMP kode 10 (NCMP/NPR-melding/SKDE)'; 

    label ncsp1='NCSP kode 1 (NCSP/NPR-melding/SKDE)'; label ncsp2='NCSP kode 2 (NCSP/NPR-melding/SKDE)'; 
    label ncsp3='NCSP kode 3 (NCSP/NPR-melding/SKDE)'; label ncsp4='NCSP kode 4 (NCSP/NPR-melding/SKDE)'; 
    label ncsp5='NCSP kode 5 (NCSP/NPR-melding/SKDE)'; label ncsp6='NCSP kode 6 (NCSP/NPR-melding/SKDE)'; 
    label ncsp7='NCSP kode 7 (NCSP/NPR-melding/SKDE)'; label ncsp8='NCSP kode 8 (NCSP/NPR-melding/SKDE)'; 
    label ncsp9='NCSP kode 9 (NCSP/NPR-melding/SKDE)'; label ncsp10='NCSP kode 10 (NCSP/NPR-melding/SKDE)'; 

    Label PID='Personentydig løpenummer, numerisk (NPR/SKDE)'; 
    label fodselsar_org='Fødselsår fra personnr og innrapportert (NPR)';
    label fodselsar    ='Fødselsår fra personnr og innrapportert (SKDE)';
    label KoblingsID='Unik id for påkobling av variabler (SKDE)'; 

    /* label VertskommHN='Vertskommune (HN) (SKDE)'; format VertskommHN VertskommHN.;  */
    label bydel2_num='Bydel vasket mot Folkeregisteret (NPR), numerisk';
    label bydel_innr='Bydel, innrapportert (SKDE), numerisk';
    label bydel_org='Bydel, backup av bydel2 (SKDE), numerisk';

    label Hastegrad='Hastegrad - akutt/elektivt (SKDE)'; format hastegrad Hastegrad.;
    label sektor='Sektor (SKDE), basert på sektor_org'; format sektor sektor.;

    label fodtAar_DSF='Fødselsår fra f.nr. ved siste kontakt med spes.helsetjenesten';
    label fodtMnd_DSF='Fødselsmåned fra f.nr. ved siste kontakt med spes.helsetjenesten';
    label kjonn_DSF  ='Kjønn fra f.nr. ved siste kontakt med spes.helsetjenesten'; format kjonn_DSF kjonn.; 
    label emigrertDato_DSF='Emigrert dato DSF (NPR)';
    label dodDato_DSF='Dødedato DSF (NPR)';

%end;


%if &somatikk ne 0 %then %do;
    
    /**************************/
    /* SOMATIKK raw variables */
    /**************************/
    label Aktivitetskategori='Aktivitetskatgori 10-delt (SAMDATA)'; format Aktivitetskategori AKTIVITETSKATEGORI.; 
    label Aktivitetskategori3='Aktivitetskatgori 3-delt (SAMDATA)'; format Aktivitetskategori3 AKTIVITETSKATEGORI3F.; 
    label drg='Diagnoserelatert gruppe (NPK)'; format drg $drg.;
    label dag_kir='Dagkirurgiske DRG (NPR)';
    label niva='Nivå på episode (NPK)'; format niva $NIVA.;
    label korrvekt='Korrigert vekt (NPK)';
    label vekt='DRG-vekt (NPK)';
    label trimpkt='Trimpunkt (NPK)';
    label drg_type='Type DRG (NPK)'; format DRG_type $DRG_type.; 
    label komp_drg='Kompliserende DRG (NPK)'; format KOMP_DRG $KOMP_DRG.;
    label dag_kir='Dagkirurgisk DRG (NPK)'; format dag_kir $DAG_KIR.;
    label spes_drg='Spesifikk DRG (NPK)'; format SPES_DRG $SPES_DRG.;
    label rehabType='Type rehabilitering (NPK)'; format rehabType REHABTYPE.;
    label utforendeHelseperson='Utførende helsepersonell (NPR-melding)'; format utforendeHelseperson UTFORENDEHELSEPERSON.;
    label aggrshoppID_LNr='Id for aggregert sykehusopphold (NPK)'; 
    label hdg='Hoveddiagnosegruppe (NPK)'; format HDG HDG.; 
    label nyTilstand='Ny Tilstand (NPR-melding)'; format nyTilstand NYTILSTAND.;
    /*these 4 variables are removed for avtsp, keep in here in case we still have them for som*/
    label tilSted='Til sted (NPK)'; format tilsted tilsted.;
    label fraSted='Fra sted (NPK)'; format frasted frasted.; 
    label polIndirekteAktivitet='polIndirekteAktivitet (NPK)'; format polIndirekteAktivitet POLINDIR.;
    /* NPK */ /* Variable label basert på informasjon i ISF-regelverk 2017, poengberegningsreglene og informasjon fra Eva K. Håndlykken i NPR. Ikke bekreftet av Helsedirektoratete. Noe usikkerhet rundt innhold i variablene. */
    label npkopphold_poengsum='DRGBasispoeng pluss tilleggspoeng og fradragspoeng (NPK)'; 
    label NPKResultat_oppholdID='Unik ID innen kjørejobb (NPK)'; 
    label npkOpphold_ISFPoeng='Sum av ISFPoeng for alle Opphold og Særtjenester (NPK)';  
    label npkOpphold_ErTellendeISFOppholdO='1=ISF-opphold, 0=Ikke ISF-opphold (NPK)'; 
    label npkOpphold_DRGBasispoeng='Kostnadsvekt +/- korreksjonsfaktorer (NPK)'; 
    label npkOpphold_antallKontakter='Antall kontakter som inngår i det aggregerte "sykehusoppholdet" (NPK)';
    label npkOpphold_antallAvdelingsopphol='Antall avdelingsopphold som inngår i det aggregerte "sykehusoppholdet" (NPK)'; 
    label polUtforende_1='Utførende helsepersonell 1 (NPK)'; format polUtforende_1 UTFORENDEHELSEPERSON.; 
    label polUtforende_2='Utførende helsepersonell 2 (NPK)'; format polUtforende_2 UTFORENDEHELSEPERSON.; 
    label polUtforende_3='Utførende helsepersonell 3 (NPK)'; format polUtforende_3 UTFORENDEHELSEPERSON.; 
    label relatertKontaktID='Id for relaterte kontakter (NPK)';
    label henvType='Utfall av vurdering av henvisningen (NPR-melding)'; format henvType henvType.;
    label henvFraInstitusjonID='Henvist fra institusjon (NPK)'; format HENVFRAINSTITUSJONID HENVFRAINSTITUSJONID.;
    label innmnd='Innskrivelsesmåned (NPR)'; 
    label utmnd='Utskrivelsesmåned (NPR)';
    label utskrKlarDato='Utskrivningsklar dato - dato valgt av (NPR)';
    label utskrKlarDato2='Utskrivningsklar dato - alternativ dato valgt av NPR (NPR)';
    label tidspunkt_1='Første dato for utskrivingsklar pasient';
    label tidspunkt_2='Andre dato for utskrivingsklar pasient';
    label tidspunkt_3='Tredje dato for utskrivingsklar pasient';
    label tidspunkt_4='Fjerde dato for utskrivingsklar pasient';
    label tidspunkt_5='Femte dato for utskrivingsklar pasient';
    label typeTidspunkt_1='Type tidspukt for første dato for utskrivingsklar pasient (NPR-melding)'; format typeTidspunkt_1 typeTidspunkt_2 typeTidspunkt_3 typeTidspunkt_4 typeTidspunkt_5 TYPETIDSPUNKT.;
    label typeTidspunkt_2='Type tidspukt for andre dato for utskrivingsklar pasient (NPR-melding)'; 
    label typeTidspunkt_3='Type tidspukt for tredje dato for utskrivingsklar pasient (NPR-melding)'; 
    label typeTidspunkt_4='Type tidspukt for fjerde dato for utskrivingsklar pasient (NPR-melding)'; 
    label typeTidspunkt_5='Type tidspukt for femte dato for utskrivingsklar pasient (NPR-melding)'; 
    label g_omsorgsniva='Gammelt omsorgsnivå (NPR)'; format g_omsorgsniva g_omsorgsniva.; 
    label omsorgsniva='Omsorgsnivå (NPR)'; format omsorgsniva omsorgsniva.; 
    label liggetid='Liggetid (NPK og NPR)';
    label komp_drg='Kompliserende DRG (NPR)'; format komp_drg komp_drg.; 
    label korrvekt='Korrigert vekt (NPK)';
    label trimpkt='Trimpunkt (NPK)';
    label innTid='Innskrivelsestidspunkt (NPR-melding)';
    label utmnd='Utskrivelsesmåned (NPR)';
    label utTilstand='Tilstand ved utskriving (NPR-melding)'; format utTilstand utTilstand.; 
    label cyto_1='Cytostatika kode 1 (Oncolex/NPR-melding)'; 
    label cyto_2='Cytostatika kode 2 (Oncolex/NPR-melding)'; 
    label cyto_3='Cytostatika kode 3 (Oncolex/NPR-melding)'; 
    label cyto_4='Cytostatika kode 4 (Oncolex/NPR-melding)'; 
    label cyto_5='Cytostatika kode 5 (Oncolex/NPR-melding)'; 
    label fodselsvekt='Fødselsvekt (NPR-melding)';
    label fagomrade='Fagområde for henvisningen (NPR-melding)'; format fagomrade $fagomrade.; 
    label permisjonsdogn='Permisjonsdøgn (NPR-melding)';
    label inntilstand='Tilstand ved ankomst (NPR-melding)'; format inntilstand inntilstand.;
    label tjenesteenhetKode='Tjenesteenhet kode (NPR-melding)';
    label tjenesteenhetLokal='Tjenesteenhet navn (NPR-melding)';
    label tjenesteenhetReshID='Tjenesteenhet ReshID (NPR-melding)';
    label fagenhetKode='Fagenhet kode (NPR-melding)';
    label fagenhetLokal='Fagenhet navn (NPR-melding)';
    label fagenhetReshID='Fagenhet ReshID (NPR-melding)';
    label behandlingsstedKode='Behandlingssted kode (NPR-melding)'; format behandlingsstedKode org_fmt.;
    label behandlingsstedLokal='Behandlingssted navn (NPR-melding)';
    label behandlingsstedReshID='Behandlingssted ReshID (NPR-melding)';
    label hf='Behandlende helseforetak (NPR)'; format hf org_fmt.;

    /* somatikk raw data only in SKDE datagrunnlag  */
    %if &datagrunnlag=SKDE %then %do;
        label isf_opphold='ISF-opphold (NPR)'; format ISF_OPPHOLD ISF_OPPHOLD.;
        label pakkeforlop='Pakkeforløp kreft (NPR-melding)'; format pakkeforlop pakkeforlop.;
        label ant_tidspunkt='Antall tidspunkt for utskrivningsklar pasient';
        label bydel_DSF='Bydel fra Folkeregisteret (NPR)';
        label versjon='Versjon av NPR-melding (NPR-melding)';
        label utskrKlarDager='Liggedøgn som utskrivingsklar (NPR)';
        label InstitusjonID_original='Org.nr. til rapporteringsenhet, identifiserer stråleterapienheter (NPR-melding)'; format InstitusjonId_original INSTITUSJONID_2013_2017F.; 
        label liggetid_periode='Liggetid i utskrivelsesåret (NPR)';
        label fodselsAar_ident='Fødselsår fra personnr - ident-info fra koblingsdato (NPR)';
        label fodt_mnd='Fødselsmåned fra personnr - ident-info fra nasjonal fil (NPR)';
        label opphold_id='Generert opphold_id - koblingsnøkkel (NPR)';
        label avdOpp_id='Id for avdelingsopphold - generert av NPR (NPR)';
        label Aktivitetskategori2='Aktivitetskatgori 2-delt (SAMDATA)'; format Aktivitetskategori2 AKTIVITETSKATEGORI2F.; 
        label Aktivitetskategori4='Aktivitetskatgori 4-delt (SAMDATA)'; format Aktivitetskategori4 AKTIVITETSKATEGORI4F.; 
        label polkonAktivitet='Aktivitetstype (NPR-melding)'; format polkonAktivitet POLKONAKTIVITET.;
        label frittSykehusvalg='Fritt sykehusvalg (NPK)'; format FRITTSYKEHUSVALG FRITTSYKEHUSVALG.;
        label frittBehandlingsvalg='Fritt behandlingsvalg (NPK)'; format FRITTBehandlingsvalg frittBehandlingsvalg.;
        label secondOpinion='Second Opinion (NPK)'; format SECONDOPINION SECONDOPINION.;
        label tell_NCRP='Antall NCRP-koder innrapportert (NPR)';
        label tell_cyto='Antall cytostatika-koder innrapportert (NPR)';
        label gyldig_ICD_1_1='Gyldighet av ICD-10-kode 1_1 (ICD-10/NPR)'; label gyldig_ICD_1_2='Gyldighet av ICD-10-kode 1_2 (ICD-10/NPR)';
        label gyldig_ICD_2_1='Gyldighet av ICD-10-kode 2_1 (ICD-10/NPR)'; label gyldig_ICD_3_1='Gyldighet av ICD-10-kode 3_1 (ICD-10/NPR)'; label gyldig_ICD_4_1='Gyldighet av ICD-10-kode 4_1 (ICD-10/NPR)';
        label gyldig_ICD_5_1='Gyldighet av ICD-10-kode 5_1 (ICD-10/NPR)'; label gyldig_ICD_6_1='Gyldighet av ICD-10-kode 6_1 (ICD-10/NPR)'; label gyldig_ICD_7_1='Gyldighet av ICD-10-kode 7_1 (ICD-10/NPR)';
        label gyldig_ICD_8_1='Gyldighet av ICD-10-kode 8_1 (ICD-10/NPR)'; label gyldig_ICD_9_1='Gyldighet av ICD-10-kode 9_1 (ICD-10/NPR)'; label gyldig_ICD_10_1='Gyldighet av ICD-10-kode 10_1 (ICD-10/NPR)';
        label gyldig_ICD_11_1='Gyldighet av ICD-10-kode 11_1 (ICD-10/NPR)';label gyldig_ICD_12_1='Gyldighet av ICD-10-kode 12_1 (ICD-10/NPR)'; label gyldig_ICD_13_1='Gyldighet av ICD-10-kode 13_1 (ICD-10/NPR)';
        label gyldig_ICD_14_1='Gyldighet av ICD-10-kode 14_1 (ICD-10/NPR)'; label gyldig_ICD_15_1='Gyldighet av ICD-10-kode 15_1 (ICD-10/NPR)'; label gyldig_ICD_16_1='Gyldighet av ICD-10-kode 16_1 (ICD-10/NPR)';
        label gyldig_ICD_17_1='Gyldighet av ICD-10-kode 17_1 (ICD-10/NPR)'; label gyldig_ICD_17_1='Gyldighet av ICD-10-kode 17_1 (ICD-10/NPR)'; label gyldig_ICD_18_1='Gyldighet av ICD-10-kode 18_1 (ICD-10/NPR)';
        label gyldig_ICD_19_1='Gyldighet av ICD-10-kode 19_1 (ICD-10/NPR)'; label gyldig_ICD_20_1='Gyldighet av ICD-10-kode 20_1 (ICD-10/NPR)'; 
        label gyldig_NCMP_1='Gyldighet av NCMP-kode 1 (NCMP/NPR)'; label gyldig_NCMP_2='Gyldighet av NCMP-kode 2 (NCMP/NPR)'; label gyldig_NCMP_3='Gyldighet av NCMP-kode 3 (NCMP/NPR)'; 
        label gyldig_NCMP_4='Gyldighet av NCMP-kode 4 (NCMP/NPR)'; label gyldig_NCMP_5='Gyldighet av NCMP-kode 5 (NCMP/NPR)'; label gyldig_NCMP_6='Gyldighet av NCMP-kode 6 (NCMP/NPR)'; 
        label gyldig_NCMP_7='Gyldighet av NCMP-kode 7 (NCMP/NPR)'; label gyldig_NCMP_8='Gyldighet av NCMP-kode 8 (NCMP/NPR)'; label gyldig_NCMP_9='Gyldighet av NCMP-kode 9 (NCMP/NPR)'; 
        label gyldig_NCMP_10='Gyldighet av NCMP-kode 10 (NCMP/NPR)'; label gyldig_NCMP_11='Gyldighet av NCMP-kode 11 (NCMP/NPR)'; label gyldig_NCMP_12='Gyldighet av NCMP-kode 12 (NCMP/NPR)'; 
        label gyldig_NCMP_13='Gyldighet av NCMP-kode 13 (NCMP/NPR)'; label gyldig_NCMP_14='Gyldighet av NCMP-kode 14 (NCMP/NPR)'; label gyldig_NCMP_15='Gyldighet av NCMP-kode 15 (NCMP/NPR)'; 
        label gyldig_NCMP_16='Gyldighet av NCMP-kode 16 (NCMP/NPR)'; label gyldig_NCMP_17='Gyldighet av NCMP-kode 17 (NCMP/NPR)'; label gyldig_NCMP_18='Gyldighet av NCMP-kode 18 (NCMP/NPR)'; 
        label gyldig_NCMP_19='Gyldighet av NCMP-kode 19 (NCMP/NPR)'; label gyldig_NCMP_20='Gyldighet av NCMP-kode 20 (NCMP/NPR)'; 
        label gyldig_NCRP_1='Gyldighet av NCRP-kode 1 (NCRP/NPR)'; label gyldig_NCRP_2='Gyldighet av NCRP-kode 2 (NCRP/NPR)'; label gyldig_NCRP_3='Gyldighet av NCRP-kode 3 (NCRP/NPR)'; 
        label gyldig_NCRP_4='Gyldighet av NCRP-kode 4 (NCRP/NPR)'; label gyldig_NCRP_5='Gyldighet av NCRP-kode 5 (NCRP/NPR)'; label gyldig_NCRP_6='Gyldighet av NCRP-kode 6 (NCRP/NPR)'; 
        label gyldig_NCRP_7='Gyldighet av NCRP-kode 7 (NCRP/NPR)'; label gyldig_NCRP_8='Gyldighet av NCRP-kode 8 (NCRP/NPR)'; label gyldig_NCRP_9='Gyldighet av NCRP-kode 9 (NCRP/NPR)'; 
        label gyldig_NCRP_10='Gyldighet av NCRP-kode 10 (NCRP/NPR)'; label gyldig_NCRP_11='Gyldighet av NCRP-kode 11 (NCRP/NPR)'; label gyldig_NCRP_12='Gyldighet av NCRP-kode 12 (NCRP/NPR)'; 
        label gyldig_NCRP_13='Gyldighet av NCRP-kode 13 (NCRP/NPR)'; label gyldig_NCRP_14='Gyldighet av NCRP-kode 14 (NCRP/NPR)'; label gyldig_NCRP_15='Gyldighet av NCRP-kode 15 (NCRP/NPR)'; 
        label gyldig_NCRP_16='Gyldighet av NCRP-kode 16 (NCRP/NPR)'; label gyldig_NCRP_17='Gyldighet av NCRP-kode 17 (NCRP/NPR)'; label gyldig_NCRP_18='Gyldighet av NCRP-kode 18 (NCRP/NPR)'; 
        label gyldig_NCRP_19='Gyldighet av NCRP-kode 19 (NCRP/NPR)'; label gyldig_NCRP_20='Gyldighet av NCRP-kode 20 (NCRP/NPR)'; 
        label gyldig_NCSP_1='Gyldighet av NCSP-kode 1 (NCSP/NPR)'; label gyldig_NCSP_2='Gyldighet av NCSP-kode 2 (NCSP/NPR)'; label gyldig_NCSP_3='Gyldighet av NCSP-kode 3 (NCSP/NPR)'; 
        label gyldig_NCSP_4='Gyldighet av NCSP-kode 4 (NCSP/NPR)'; label gyldig_NCSP_5='Gyldighet av NCSP-kode 5 (NCSP/NPR)'; label gyldig_NCSP_6='Gyldighet av NCSP-kode 6 (NCSP/NPR)'; 
        label gyldig_NCSP_7='Gyldighet av NCSP-kode 7 (NCSP/NPR)'; label gyldig_NCSP_8='Gyldighet av NCSP-kode 8 (NCSP/NPR)'; label gyldig_NCSP_9='Gyldighet av NCSP-kode 9 (NCSP/NPR)'; 
        label gyldig_NCSP_10='Gyldighet av NCSP-kode 10 (NCSP/NPR)'; label gyldig_NCSP_11='Gyldighet av NCSP-kode 11 (NCSP/NPR)'; label gyldig_NCSP_12='Gyldighet av NCSP-kode 12 (NCSP/NPR)'; 
        label gyldig_NCSP_13='Gyldighet av NCSP-kode 13 (NCSP/NPR)'; label gyldig_NCSP_14='Gyldighet av NCSP-kode 14 (NCSP/NPR)'; label gyldig_NCSP_15='Gyldighet av NCSP-kode 15 (NCSP/NPR)'; 
        label gyldig_NCSP_16='Gyldighet av NCSP-kode 16 (NCSP/NPR)'; label gyldig_NCSP_17='Gyldighet av NCSP-kode 17 (NCSP/NPR)'; label gyldig_NCSP_18='Gyldighet av NCSP-kode 18 (NCSP/NPR)'; 
        label gyldig_NCSP_19='Gyldighet av NCSP-kode 19 (NCSP/NPR)'; label gyldig_NCSP_20='Gyldighet av NCSP-kode 20 (NCSP/NPR)'; 
        format gyldig_ICD: gyldig_NCMP: gyldig_NCRP: gyldig_NCSP: GYLDIG.; 
        label intern_kons='Intern konsultasjon på inneliggende pasient (NPR)'; format INTERN_KONS INTERN_KONS.;
    %end;

   /******************************/
   /* SOMATIKK derived variables */
   /******************************/
   %if &mottatt=0 %then %do;
       label DRGtypeHastegrad='Kombinert DRG-type og hastegrad (SKDE)'; format DRGtypeHastegrad DRGtypeHastegrad.; 
       label BehHF='Behandlende HF (SKDE)'; format BehHF behhfkort_fmt.; 
       label behRHF='Behandlende RHF (SKDE)'; format BehRHF behrhfkort_fmt.; 
       label BehSh='Behandlende sykehus (SKDE)'; format BehSh behsh_fmt.; 
       /* label InstitusjonID_original='Org.nr. til rapporteringsenhet, identifiserer stråleterapienheter (NPR-melding)'; format InstitusjonId_original INSTITUSJONID_2013_2017F.;  */
       label komNr_org='Backup av komNrHjem2 (SKDE)';
       label Bdiag11='Bitilstand kode 11 (ICD-10/NPR-melding/SKDE)';
       label Bdiag12='Bitilstand kode 12 (ICD-10/NPR-melding/SKDE)';
       label Bdiag13='Bitilstand kode 13 (ICD-10/NPR-melding/SKDE)';
       label Bdiag14='Bitilstand kode 14 (ICD-10/NPR-melding/SKDE)';
       label Bdiag15='Bitilstand kode 15 (ICD-10/NPR-melding/SKDE)';
       label Bdiag16='Bitilstand kode 16 (ICD-10/NPR-melding/SKDE)';
       label Bdiag17='Bitilstand kode 17 (ICD-10/NPR-melding/SKDE)';
       label Bdiag18='Bitilstand kode 18 (ICD-10/NPR-melding/SKDE)';
       label Bdiag19='Bitilstand kode 19 (ICD-10/NPR-melding/SKDE)';
       label ncmp11='NCMP kode 11 (NCMP/NPR-melding/SKDE)'; label ncmp12='NCMP kode 12 (NCMP/NPR-melding/SKDE)';
       label ncmp13='NCMP kode 13 (NCMP/NPR-melding/SKDE)'; label ncmp14='NCMP kode 14 (NCMP/NPR-melding/SKDE)'; 
       label ncmp15='NCMP kode 15 (NCMP/NPR-melding/SKDE)'; label ncmp16='NCMP kode 16 (NCMP/NPR-melding/SKDE)';
       label ncmp17='NCMP kode 17 (NCMP/NPR-melding/SKDE)'; label ncmp18='NCMP kode 18 (NCMP/NPR-melding/SKDE)'; 
       label ncmp19='NCMP kode 19 (NCMP/NPR-melding/SKDE)'; label ncmp20='NCMP kode 20 (NCMP/NPR-melding/SKDE)';
       label ncsp11='NCSP kode 11 (NCSP/NPR-melding/SKDE)'; label ncsp12='NCSP kode 12 (NCSP/NPR-melding/SKDE)';
       label ncsp13='NCSP kode 13 (NCSP/NPR-melding/SKDE)'; label ncsp14='NCSP kode 14 (NCSP/NPR-melding/SKDE)'; 
       label ncsp15='NCSP kode 15 (NCSP/NPR-melding/SKDE)'; label ncsp16='NCSP kode 16 (NCSP/NPR-melding/SKDE)'; 
       label ncsp17='NCSP kode 17 (NCSP/NPR-melding/SKDE)'; label ncsp18='NCSP kode 18 (NCSP/NPR-melding/SKDE)'; 
       label ncsp19='NCSP kode 19 (NCSP/NPR-melding/SKDE)'; label ncsp20='NCSP kode 20 (NCSP/NPR-melding/SKDE)';
       label ncrp1='NCRP kode 1 (NCRP/NPR-melding/SKDE)'; label ncrp2='NCRP kode 2 (NCRP/NPR-melding/SKDE)'; 
       label ncrp3='NCRP kode 3 (NCRP/NPR-melding/SKDE)'; label ncrp4='NCRP kode 4 (NCRP/NPR-melding/SKDE)'; 
       label ncrp5='NCRP kode 5 (NCRP/NPR-melding/SKDE)'; label ncrp6='NCRP kode 6 (NCRP/NPR-melding/SKDE)'; 
       label ncrp7='NCRP kode 7 (NCRP/NPR-melding/SKDE)'; label ncrp8='NCRP kode 8 (NCRP/NPR-melding/SKDE)'; 
       label ncrp9='NCRP kode 9 (NCRP/NPR-melding/SKDE)'; label ncrp10='NCRP kode 10 (NCRP/NPR-melding/SKDE)'; 
       label ncrp11='NCRP kode 11 (NCRP/NPR-melding/SKDE)'; label ncrp12='NCRP kode 12 (NCRP/NPR-melding/SKDE)';
       label ncrp13='NCRP kode 13 (NCRP/NPR-melding/SKDE)'; label ncrp14='NCRP kode 14 (NCRP/NPR-melding/SKDE)'; 
       label ncrp15='NCRP kode 15 (NCRP/NPR-melding/SKDE)'; label ncrp16='NCRP kode 16 (NCRP/NPR-melding/SKDE)'; 
       label ncrp17='NCRP kode 17 (NCRP/NPR-melding/SKDE)'; label ncrp18='NCRP kode 18 (NCRP/NPR-melding/SKDE)'; 
       label ncrp19='NCRP kode 19 (NCRP/NPR-melding/SKDE)'; label ncrp20='NCRP kode 20 (NCRP/NPR-melding/SKDE)';
       /* format NCRP: $ncrp.; */
       label alderIDager_org='Alder i dager per startdato for episoden (barn < 1 år) (NPR-melding)';
       label alderIDager    ='Alder i dager per startdato for episoden (barn < 1 år) (SKDE)';
       label liggetid_org='Liggetid (NPK og NPR)';
       label liggetid    ='Liggetid, utdato minus inndato (SKDE)';

       /* somatikk derived variables for RHF datagrunnlag */
       %if &datagrunnlag = RHF %then %do;
           label behandlingsstedkode2='Behandlingssted (SKDE)'; format behandlingsstedkode2 org_fmt.; 
       %end;
   %end;
%end;


%if &avtspes ne 0 %then %do;

    /****************************/
    /* AVTALESPES raw variables */
    /****************************/

    label fag='Fagfelt for avtalespesialisen (NPR)'; format fag fag_skde.;

    label ulikt_kjonn='Ulikt kjønn i innrapportert data og i f.nr./D-nr. (SKDE)';
    label kontakt ='Kontakttype, f.eks. enkel, spesialist eller lysbehandling (NPR)'; format kontakt kontakt.;
    label bydel2_org='Bydel (NPR)';
    label bydel_org='Bydel (NPR)';

    drop avtalerhf_old;

    %if &datagrunnlag=SKDE %then %do;
        label bydel='Bydel (NPR)';
        label tell_Normaltariff='Antall normaltariff-koder innrapportert (NPR)';
        label Fag_navn='Fagfelt for avtalespesialisen (NPR)';
        label fagLogg='Fagfelt for avtalespesialisen - mangler data (NPR)';
        label hjemmelstr ='Hjemmelstørrelse i prosent (NPR)';

        label Tdiag1='Diagnose som ikke kan sorteres i H/Bi kode 1 (ICD-10/NPR)'; label Tdiag2='Diagnose som ikke kan sorteres i H/Bi kode 2 (ICD-10/NPR)'; 
        label Tdiag3='Diagnose som ikke kan sorteres i H/Bi kode 3 (ICD-10/NPR)'; label Tdiag4='Diagnose som ikke kan sorteres i H/Bi kode 4 (ICD-10/NPR)'; 
        label Tdiag5='Diagnose som ikke kan sorteres i H/Bi kode 5 (ICD-10/NPR)';

        label Komplett = 'Komplettheten i innrapportert data (NPR)'; format komplett komplett.;

    %end;

    /********************************/
    /* AVTALESPES derived variables */
    /********************************/
    %if &mottatt=0 %then %do;
        label Normaltariff1='Normaltariff kode 1 (Normaltariff for avtalespesialister)'; label Normaltariff2='Normaltariff kode 2 (Normaltariff for avtalespesialister)'; 
        label Normaltariff3='Normaltariff kode 3 (Normaltariff for avtalespesialister)'; label Normaltariff4='Normaltariff kode 4 (Normaltariff for avtalespesialister)';
        label Normaltariff5='Normaltariff kode 5 (Normaltariff for avtalespesialister)'; label Normaltariff6='Normaltariff kode 6 (Normaltariff for avtalespesialister)'; 
        label Normaltariff7='Normaltariff kode 7 (Normaltariff for avtalespesialister)'; label Normaltariff8='Normaltariff kode 8 (Normaltariff for avtalespesialister)';
        label Normaltariff9='Normaltariff kode 9 (Normaltariff for avtalespesialister)'; label Normaltariff10='Normaltariff kode 10 (Normaltariff for avtalespesialister)'; 
        label Normaltariff11='Normaltariff kode 11 (Normaltariff for avtalespesialister)'; label Normaltariff12='Normaltariff kode 12 (Normaltariff for avtalespesialister)';
        label Normaltariff13='Normaltariff kode 13 (Normaltariff for avtalespesialister)'; label Normaltariff14='Normaltariff kode 14 (Normaltariff for avtalespesialister)'; 
        label Normaltariff15='Normaltariff kode 15 (Normaltariff for avtalespesialister)';

        label fag_SKDE='Fagfelt for avtalespesialisen (SKDE)'; format FAG_SKDE FAG_SKDE.;
        label SpesialistKomHN='Kommunenummer for avtalespesialistens praksis i Helse Nord (SKDE)';
        label AvtSpesKomHN='Kontakt med avtalespesialist i HN (SKDE)';
        label AvtSpes='Kontakt hos avtalespesialist (SKDE)'; format avtSpes avtSpes.;
        label AvtaleRHF='RHF-et spesialisten har avtale med (NPR)'; format avtaleRHF boRHF_fmt.;

        label bydel='Bydel (SKDE)';
        label omsorgsniva_org='Omsorgsnivå (NPR-melding)'; format omsorgsniva_org omsorgsniva.; 
        label omsorgsniva='Omsorgsnivå (SKDE)'; format omsorgsniva omsorgsniva.; 
        label aar_org='År (NPR)';
        label aar='År fra utdato (SKDE)';
        label innDato_org='Innskrivelsesdato innrapportert (NPR-melding)'; format innDato Eurdfdd10.;
        label inndato='Inndato (SKDE)';
        label utDato_org='Utskrivelsesdato innrapportert (NPR-melding)'; format utDato Eurdfdd10.;
        label utdato='Utdato satt til å lik inndato (SKDE)';

    %end;


%end;

drop orgnr;

run;

%Mend LablerFormater;

