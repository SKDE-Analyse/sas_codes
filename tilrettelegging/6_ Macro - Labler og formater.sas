
/**************************************
*** 3. Legger på formater og labler ***
******'*******************************/

%Macro LablerFormater (innDataSett=, utDataSett=);
Data &Utdatasett;
set &Inndatasett;

label aar='År (NPR)';
label Aktivitetskategori='Aktivitetskatgori 10-delt (SAMDATA)'; format Aktivitetskategori AKTIVITETSKATEGORI.; 
label Aktivitetskategori2='Aktivitetskatgori 2-delt (SAMDATA)'; format Aktivitetskategori2 AKTIVITETSKATEGORI2F.; 
label Aktivitetskategori3='Aktivitetskatgori 3-delt (SAMDATA)'; format Aktivitetskategori3 AKTIVITETSKATEGORI3F.; 
label Aktivitetskategori4='Aktivitetskatgori 4-delt (SAMDATA)'; format Aktivitetskategori4 AKTIVITETSKATEGORI4F.; 

label Alder='Alder (SKDE)';
label Ald_gr5 ='Aldersgruppe 5 kategorier (SKDE)'; format Ald_gr5 Ald_5gr.; 
label ald_gr='Aldersgruppe (NPR)'; format ald_gr ald_gr.; 

label behandlingsstedKode2='Behandlingssted (NPR)'; format behandlingsstedKode2 BEHANDLINGSSTEDKODE2F.; 
label behandlingsstedKode_original='Behandlingssted som innrapportert, identifiserer stråleterapienheter (NPR-melding)'; format behandlingsstedKode_original; 
label BehHF='Behandlende HF (SKDE)'; format BehHF behHF.; 
label behRHF='Behandlende RHF (SKDE)'; format BehRHF behRHF.; 
label BehSh='Behandlende sykehus (SKDE)'; format BehSh BehSh.; 

label BoHF='Opptaksområde (HF) (SKDE)'; format BoHF boHF_kort.; 
label BoRHF='Opptaksområde (RHF) (SKDE)'; format BoRHF boRHF.; 
label BoShHN='Opptaksområde (sykehus HN) (SKDE)';format BoShHN boshHN.; 

label drg='Diagnoserelatert gruppe (NPK)';
label dag_kir='Dagkirurgiske DRG (NPR)';
label niva='Nivå på episode (NPK)';
label korrvekt='Korrigert vekt (NPK)';
label vekt='DRG-vekt (NPK)';
label trimpkt='Trimpunkt (NPK)';
label drg_type='Type DRG (NPK)'; format DRG_type DRG_type.; 
label komp_drg='Kompliserende DRG (NPK)'; format KOMP_DRG $KOMP_DRG.;
label dag_kir='Dagkirurgisk DRG (NPK)'; format dag_kir $DAG_KIR.;
label spes_drg='Spesifikk DRG (NPK)'; format SPES_DRG $SPES_DRG.;
label rehabType='Type rehabilitering (NPK)'; format rehabType REHABTYPE.;
label utforendeHelseperson='Utførende helsepersonell (NPK)'; format UTFORENDEHELSEPERSON UTFORENDEHELSEPERSON.;
label polIndirekteAktivitet='polIndirekteAktivitet (NPK)'; format polIndirekteAktivitet POLINDIR.;
lable polIndir='Indirekte aktiviteter (NPR-melding)'; format polIndir POLINDIR.;
label aggrshoppID='Id for aggregert sykehusopphold (NPK)'; 
label hdg='Hoveddiagnosegruppe (NPK)'; format HDG HDG.; 

label polUtforende_1='Utførende helsepersonell 1 (NPK)'; format POLUTFORENDE_1 POLUTFORENDE_1F.;
label polUtforende_2='Utførende helsepersonell 2 (NPK)'; format POLUTFORENDE_2 POLUTFORENDE_2F.;
label isf_opphold='ISF-opphold (NPR)'; format ISF_OPPHOLD ISF_OPPHOLD.;
label pakkeforlop='Pakkeforløp kreft (NPR-melding)'; format pakkeforlop pakkeforlop.;
/*label kommTjeneste='Kommunal tjeneste (NPR-melding)'; format kommTjeneste kommTjeneste.; - Fra 2016*/
label relatertKontaktID='Id for relaterte kontakter (NPK)';
label henvType='Utfall av vurdering av henvisningen (NPR-melding)'; format henvType henvType.;

label Hastegrad='Hastegrad - akutt/elektivt (SKDE)'; format hastegrad Hastegrad.;
label DRGtypeHastegrad='Kombinert DRG-type og hastegrad (SKDE)'; format DRGtypeHastegrad DRGtypeHastegrad.; 
 
label erMann='Er mann (kjønn, mann=1) (SKDE)'; format ErMann ErMann.; 
label kjonn='Kjønn (NPR)'; format kjonn kjonn.; 
label Fylke='Fylke (pasientens bosted) (SKDE)'; format Fylke fylke.; 

label ICD10Kap='ICD-10 kapittel for første kode hovedtilstand (ICD-10/SKDE)'; format ICD10Kap ICD10Kap.;
label ICD10KatBlokk='ICD-10 kategoriblokk for første kode hovedtilstand (ICD-10/SKDE)'; format ICD10KatBlokk ICD10KatBlokk.; 

label innmateHast='Hastegrad ved ankomst (NPR-melding)'; format innmateHast innmateHast.; 
label innmnd='Innskrivelsesmåned (NPR)'; 
label utmnd='Utskrivelsesmåned (NPR)';
label innTid='Innskrivelsestidspunkt (NPR-melding)'; *format innTid Eurdfdd10.; 
label utTid='Utskrivelsestidspunkt (NPR-melding)'; *format utTid Eurdfdd10.; 
label innDato='Innskrivelsesdato (NPR-melding)';
label utDato='Utskrivelsesdato (NPR-melding)';

label InstitusjonID='Org.nr. til rapporteringsenhet (NPR-melding)'; format InstitusjonId INSTITUSJONID_2011_2015F.;
label InstitusjonID_original='Org.nr. til rapporteringsenhet, identifiserer stråleterapienheter (NPR-melding)'; format InstitusjonId InstitusjonID_original.; 
/*format FraInstitusjonId TilInstitusjonId FRAINSTITUSJONID.; label FraInstitusjonId='Fra institusjon'; label TilInstitusjonId='Til institusjon';*/
label InstitusjonId_omkodet='Org.nr. til rapporteringsenhet, private sykehus med flere org.nr. omkodet (SKDE)'; format InstitusjonId_omkodet INSTITUSJONID_2011_2015F.;

label kontaktType='Kontakttype (NPR-melding)'; format kontaktType kontaktType.; 
label komNrHjem2='Kommunenummer vasket mot Folkeregisteret (NPR-melding)'; format KomNrHjem2 $KOMNRHJEM2F.; 
label KomNR='Kommunenummer vasket mot Folkeregisteret, numerisk (NPR-melding/SKDE)'; 
label bydel2='Bydel vasket mot Folkeregisteret (NPR)';
label bydel2_num='Bydel vasket mot Folkeregisteret (NPR), numerisk';
label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem vasket mot Folkeregisteret (SKDE)'; format bydel bydel_alle.;
label bydel_Oslo='Bydel i Oslo vasket mot Folkeregisteret (NPR-melding/SKDE)'; format bydel_Oslo bydel_Oslo.; 
label bydel_Bergen='Bydel i Bergen vasket mot Folkeregisteret (NPR-melding/SKDE)'; format bydel_Bergen bydel_Bergen.; 
label bydel_Stavanger='Bydel i Stavanger vasket mot Folkeregisteret (NPR-melding/SKDE)'; format bydel_Stavanger bydel_Stavanger.; 
label bydel_Trondheim='Bydel i Trondheim vasket mot Folkeregisteret (NPR-melding/SKDE)'; format bydel_Trondheim bydel_Trondheim.; 
/*label bydel_alle='Bydeler for Oslo, Stavanger, Bergen og Trondheim'; format bydel_alle bydel_alle.;*/

label g_omsorgsniva='Gammelt omsorgsnivå (NPR)'; format g_omsorgsniva g_omsorgsniva.; 
label liggetid='Liggetid (NPK og NPR)';
label omsorgsniva='Omsorgsnivå (NPR-melding)'; format omsorgsniva omsorgsniva.; 
label oppholdstype='Oppholdstype (NPR-melding)'; format oppholdstype oppholdstype.; 

label VertskommHN='Vertskommune (HN) (SKDE)'; format VertskommHN VertskommHN.; 
label tjenesteenhetKode='Avdelingskode (NPR-melding)';
/*label utskrKlarDager='Liggedøgn som utskrivingsklar (NPR)';*/
label versjon='Versjon av NPR-melding (NPR-melding)';

label komp_drg='Kompliserende DRG (NPR)'; format komp_drg komp_drg.; 
label korrvekt='Korrigert vekt (NPK)';
label trimpkt='Trimpunkt (NPK)';
label innTid='Innskrivelsestidspunkt (NPR-melding)';
label utmnd='Utskrivelsesmåned (NPR)';
label utTilstand='Tilstand ved utskriving (NPR-melding)'; format utTilstand utTilstand.; 

label fodselsar_ident='Fødselsår fra personnr - ident-info per 29082019 (NPR)';
label kjonn_ident='Kjønn fra personnr - ident info-per 29082019 (NPR)'; format kjonn_ident kjonn.;   
label fodt_mnd_ident='Fødselsmåned fra personnr - ident-info per 29082019 (NPR)';
label emigrertDato='Emigrert dato - ident-info per 29082019 (NPR)';
label dodDato='Dødedato - ident-info per 29082019 (NPR)';

label Hdiag='Hovedtilstand kode 1 (ICD-10/NPR-melding/SKDE)';
label Hdiag2='Hovedtilstand kode 2 (ICD-10/NPR-melding/SKDE)';
label Hdiag3tegn='Hovedtilstand kode 1, 3 tegn (ICD-10/NPR-melding/SKDE)'; *format Hdiag3tegn icd3tegn.; 
label Bdiag1='Bitilstand kode 1 (ICD-10/NPR-melding/SKDE)';
label Bdiag2='Bitilstand kode 2 (ICD-10/NPR-melding/SKDE)';
label Bdiag3='Bitilstand kode 3 (ICD-10/NPR-melding/SKDE)';
label Bdiag4='Bitilstand kode 4 (ICD-10/NPR-melding/SKDE)';
label Bdiag5='Bitilstand kode 5 (ICD-10/NPR-melding/SKDE)';
label Bdiag6='Bitilstand kode 6 (ICD-10/NPR-melding/SKDE)';
label Bdiag7='Bitilstand kode 7 (ICD-10/NPR-melding/SKDE)';
label Bdiag8='Bitilstand kode 8 (ICD-10/NPR-melding/SKDE)';
label Bdiag9='Bitilstand kode 9 (ICD-10/NPR-melding/SKDE)';
label Bdiag10='Bitilstand kode 10 (ICD-10/NPR-melding/SKDE)';
label Bdiag11='Bitilstand kode 11 (ICD-10/NPR-melding/SKDE)';
label Bdiag12='Bitilstand kode 12 (ICD-10/NPR-melding/SKDE)';
label Bdiag13='Bitilstand kode 13 (ICD-10/NPR-melding/SKDE)';
label Bdiag14='Bitilstand kode 14 (ICD-10/NPR-melding/SKDE)';
label Bdiag15='Bitilstand kode 15 (ICD-10/NPR-melding/SKDE)';
label Bdiag16='Bitilstand kode 16 (ICD-10/NPR-melding/SKDE)';
label Bdiag17='Bitilstand kode 17 (ICD-10/NPR-melding/SKDE)';
label Bdiag18='Bitilstand kode 18 (ICD-10/NPR-melding/SKDE)';
label Bdiag19='Bitilstand kode 19 (ICD-10/NPR-melding/SKDE)';

label ncmp1='NCMP kode 1 (NCMP/NPR-melding/SKDE)'; label ncmp2='NCMP kode 2 (NCMP/NPR-melding/SKDE)'; 
label ncmp3='NCMP kode 3 (NCMP/NPR-melding/SKDE)'; label ncmp4='NCMP kode 4 (NCMP/NPR-melding/SKDE)';
label ncmp5='NCMP kode 5 (NCMP/NPR-melding/SKDE)'; label ncmp6='NCMP kode 6 (NCMP/NPR-melding/SKDE)'; 
label ncmp7='NCMP kode 7 (NCMP/NPR-melding/SKDE)'; label ncmp8='NCMP kode 8 (NCMP/NPR-melding/SKDE)';
label ncmp9='NCMP kode 9 (NCMP/NPR-melding/SKDE)'; label ncmp10='NCMP kode 10 (NCMP/NPR-melding/SKDE)'; 
label ncmp11='NCMP kode 11 (NCMP/NPR-melding/SKDE)'; label ncmp12='NCMP kode 12 (NCMP/NPR-melding/SKDE)';
label ncmp13='NCMP kode 13 (NCMP/NPR-melding/SKDE)'; label ncmp14='NCMP kode 14 (NCMP/NPR-melding/SKDE)'; 
label ncmp15='NCMP kode 15 (NCMP/NPR-melding/SKDE)'; label ncmp16='NCMP kode 16 (NCMP/NPR-melding/SKDE)';
label ncmp17='NCMP kode 17 (NCMP/NPR-melding/SKDE)'; label ncmp18='NCMP kode 18 (NCMP/NPR-melding/SKDE)'; 
label ncmp19='NCMP kode 19 (NCMP/NPR-melding/SKDE)'; label ncmp20='NCMP kode 20 (NCMP/NPR-melding/SKDE)';

label ncsp1='NCSP kode 1 (NCSP/NPR-melding/SKDE)'; label ncsp2='NCSP kode 2 (NCSP/NPR-melding/SKDE)'; label ncsp3='NCSP kode 3 (NCSP/NPR-melding/SKDE)';
label ncsp4='NCSP kode 4 (NCSP/NPR-melding/SKDE)'; label ncsp5='NCSP kode 5 (NCSP/NPR-melding/SKDE)'; label ncsp6='NCSP kode 6 (NCSP/NPR-melding/SKDE)'; 
label ncsp7='NCSP kode 7 (NCSP/NPR-melding/SKDE)'; label ncsp8='NCSP kode 8 (NCSP/NPR-melding/SKDE)'; label ncsp9='NCSP kode 9 (NCSP/NPR-melding/SKDE)'; 
label ncsp10='NCSP kode 10 (NCSP/NPR-melding/SKDE)'; label ncsp11='NCSP kode 11 (NCSP/NPR-melding/SKDE)'; label ncsp12='NCSP kode 12 (NCSP/NPR-melding/SKDE)';
label ncsp13='NCSP kode 13 (NCSP/NPR-melding/SKDE)'; label ncsp14='NCSP kode 14 (NCSP/NPR-melding/SKDE)'; label ncsp15='NCSP kode 15 (NCSP/NPR-melding/SKDE)'; 
label ncsp16='NCSP kode 16 (NCSP/NPR-melding/SKDE)'; label ncsp17='NCSP kode 17 (NCSP/NPR-melding/SKDE)'; label ncsp18='NCSP kode 18 (NCSP/NPR-melding/SKDE)'; 
label ncsp19='NCSP kode 19 (NCSP/NPR-melding/SKDE)'; label ncsp20='NCSP kode 20 (NCSP/NPR-melding/SKDE)';

label ATC_1='ATC kode 1 (ATC/NPR-melding)'; 
label ATC_2='ATC kode 2 (ATC/NPR-melding)'; 
label ATC_3='ATC kode 3 (ATC/NPR-melding)'; 
label ATC_4='ATC kode 4 (ATC/NPR-melding)'; 
label ATC_5='ATC kode 5 (ATC/NPR-melding)';

label cyto_1='Cytostatika kode 1 (Oncolex/NPR-melding)'; 
label cyto_2='Cytostatika kode 2 (Oncolex/NPR-melding)'; 
label cyto_3='Cytostatika kode 3 (Oncolex/NPR-melding)'; 
label cyto_4='Cytostatika kode 4 (Oncolex/NPR-melding)'; 
label cyto_5='Cytostatika kode 5 (Oncolex/NPR-melding)'; 

Label PID="Personentydig løpenummer, numerisk (NPR)"; 
label NPRId_reg='Status for kobling mot ident-melding (NPR)';format NPRId_reg NPRId_reg.;
label opphold_id='Generert opphold_id - koblingsnøkkel (NPR)';
label avdOpp_id='Id for avdelingsopphold - generert av NPR (NPR)';
label versjon='Versjon av NPR-melding (NPR-melding)';
label fodselsvekt='Fødselsvekt (NPR-melding)';
label alderIDager='Alder i dager per startdato for episoden (barn < 1 år) (NPR-melding)';
label fagomrade='Fagområde for henvisningen (NPR-melding)'; format fagomrade $fagomrade.; 
label episodeFag='Fagområde for Episoden (NPR-melding)'; format episodeFag $fagomrade.; 
label fodselsar='Fødselsår (NPR-melding)';
label permisjonsdogn='Permisjonsdøgn (NPR-melding)';
label debitor='Debitor (NPR-melding)'; format debitor debitor.;
label inntilstand='Tilstand ved ankomst (NPR-melding)'; format inntilstand inntilstand.;
label stedAktivitet='Sted for aktivitet (NPR-melding)'; format STEDAKTIVITET STEDAKTIVITET.;
label intern_kons='Intern konsultasjon på inneliggende pasient (NPR)'; format INTERN_KONS INTERN_KONS.;
label tjenesteenhetKode='Tjenesteenhet kode (NPR-melding)';
label tjenesteenhetLokal='Tjenesteenhet navn (NPR-melding)';
label tjenesteenhetReshID='Tjenesteenhet ReshID (NPR-melding)';
label fagenhetKode='Fagenhet kode (NPR-melding)';
label fagenhetLokal='Fagenhet navn (NPR-melding)';
label fagenhetReshID='Fagenhet ReshID (NPR-melding)';
label behandlingsstedKode='Behandlingssted kode (NPR-melding)';
label behandlingsstedLokal='Behandlingssted navn (NPR-melding)';
label behandlingsstedReshID='Behandlingssted ReshID (NPR-melding)';

label tell_ATC='Antall ATC-koder innrapportert (NPR)';
label tell_ICD10='Antall ICD-10-koder innrapportert (NPR)';
label tell_NCMP='Antall NCMP-koder innrapportert (NPR)';
label tell_NCSP='Antall NCSP-koder innrapportert (NPR)';
label tell_cyto='Antall cytostatika-koder innrapportert (NPR)';

label KoblingsID='Unik id for påkobling av variabler (SKDE)'; 

run;

%Mend LablerFormater;




