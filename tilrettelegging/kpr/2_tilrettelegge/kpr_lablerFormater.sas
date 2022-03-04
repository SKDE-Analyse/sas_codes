%Macro kpr_lablerFormater (innData=, utData=);

Data &Utdata;
set &Inndata;

/* Felles for alle lege-datasettene fra KPR */
    label aar='�r (KPR)';
    label enkeltregning_Lnr='L�penummer for enkeltregninger (KPR)';

/* Felles for regning- og diagnosefil */
%if &diagnose eq 1 or &regning eq 1 %then %do; 
    label kodeverk='Angir aktuelt kodeverk for tilh�rende diagnose (SKDE)'; format kodeverk kodeverk.;
%end;

/* Gjelder kun regningsfil */
%if &regning eq 1 %then %do; 
    label pid_kpr='Personentydig l�penummer (SKDE)'; 
    label bohf='Opptaksomr�de (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label borhf='Opptaksomr�de (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label boshhn='Opptaksomr�de (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label erMann='Er mann (kj�nn, mann=1) (SKDE)'; format ErMann ErMann.; 
    *label kjonn_kpr='Kj�nn (KPR)';
    label Fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;
    label KomNR='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021 (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem (SKDE)'; format bydel bydel_fmt.;
    *label bydel_kpr='Bydel (KPR)'; 
    label kontakttype_kpr='(KPR)' ;format kontakttype_kpr kontakttyke_kpr. ;
    label tjenestetype_kpr='Avledet fra tjenestetypenavn (SKDE)'; format tjenestetype_kpr tjenestetype_kpr.;
    *label behandlingsnr='Angir hvilket nr. i rekken i en behandlingsserie regningen utgj�r (KPR)';
    *label minimumtidsbruk='(KPR)';
    label fritakskode='(KPR)';
    label egenandelpasient='Egenandel pasient (KPR)';
    label refusjonutbetalt='Refusjon utbetalt (KPR)';
    *label bostedavledet='Bostedavledet - HDIR sin versjon av folkeregisteret (KPR)';
    label hdiag_kpr='Hoveddiagnose (KPR)';
    label Alder='Alder (KPR)';
    label fodselsar='F�dsels�r (KPR)';
    label inndato='Inndato (SKDE)'; format inndato eurdfdd10.;
    *label datotid_kpr = 'Rapportert dato og tid (KPR)';
    label inntid_kpr='Tidspunkt for kontakt (SKDE)';format inntid_kpr time8.;
    label icpc2_hdiag='ICPC2 hoveddiagnose p� regningskort (KPR/SKDE)'; format icpc2_hdiag $icpc2_fmt.;
    label icpc2_kap='ICPC2 kapittel, avledet fra diagnose (SKDE)'; format icpc2_kap $icpc2_kap.;
    label icpc2_type='Angir om det er sympt/plager, diagnose/sykdom eller prosesskode (SKDE)'; format icpc2_type icpc2_type.;
%end;

/* Gjelder kun diagnosefil */
%if &diagnose eq 1 %then %do; 
    label diag='diagnoseKode (KPR)';
    label kodenr='(KPR)';
    label erHdiag='erHoveddiagnose (SKDE)'; format erHdiag erHdiag.;
%end;

/* Gjelder kun takstfil */
%if &takst eq 1 %then %do; 
    label KPRantall = 'Antall repetisjoner av takst (KPR)';
    label takstkode = 'Takst (KPR)';
%end;
run;
%mend kpr_lablerFormater;