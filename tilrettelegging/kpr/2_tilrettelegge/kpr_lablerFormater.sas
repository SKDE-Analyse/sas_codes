%Macro kpr_lablerFormater (innData=, utData=);

Data &Utdata;
set &Inndata;

/* Felles for alle lege-datasettene fra KPR */
    label aar='År (KPR)';
    label enkeltregning_Lnr='Løpenummer for enkeltregninger (KPR)';

/* Felles for regning- og diagnosefil */
%if &diagnose eq 1 or &regning eq 1 %then %do; 
    label kodeverk_kpr='Angir aktuelt kodeverk for tilhørende diagnose (SKDE)'; format kodeverk kodeverk.;
%end;

/* Gjelder kun regningsfil */
%if &regning eq 1 %then %do; 
    label pid_kpr='Personentydig løpenummer (SKDE)'; 
    label bohf='Opptaksområde (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label borhf='Opptaksområde (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label boshhn='Opptaksområde (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label erMann='Er mann (kjønn, mann=1) (SKDE)'; format ErMann ErMann.; 
    label Fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;
    label KomNR='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021 (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem (SKDE)'; format bydel bydel_fmt.;
    label kontakttype_kpr='(KPR)' ;format kontakttype_kpr kontakttyke_kpr. ;
    label tjenestetype_kpr='Avledet fra tjenestetypenavn (SKDE)'; format tjenestetype_kpr tjenestetype_kpr.;
    label minimumtidsbruk='(KPR)';
    label fritakskode='(KPR)';
    label egenandelpasient='Egenandel pasient (KPR)';
    label refusjonutbetalt='Refusjon utbetalt (KPR)';
    label hdiag_kpr='Hoveddiagnose - avledet fra diagnosefil (KPR/SKDE)';
    label Alder='Alder (KPR)';
    label fodselsar='Fødselsår (KPR)';
    label inndato='Inndato (SKDE)'; format inndato eurdfdd10.;
    label inntid='Tidspunkt for kontakt (SKDE)';format inntid_kpr time8.;
    label icpc2_hdiag='ICPC2 hoveddiagnose på regningskort (KPR/SKDE)'; format icpc2_hdiag $icpc2_fmt.;
    label icpc2_kap='ICPC2 kapittel, avledet fra diagnose (SKDE)'; format icpc2_kap $icpc2_kap.;
    label icpc2_type='Angir om det er sympt/plager, diagnose/sykdom eller prosesskode (SKDE)'; format icpc2_type icpc2_type.;
%end;

/* Gjelder kun diagnosefil */
%if &diagnose eq 1 %then %do; 
    label diag_kpr='diagnoseKode (KPR)';
    label kodenr='Angir nummer til diagnosene (KPR)';
    label erHdiag='erHoveddiagnose (SKDE/KPR)'; format erHdiag erHdiag.;
    label icpc2_diag='ICPC2-diagnoser avledet fra diagnoseKode (SKDE/KPR)';
%end;

/* Gjelder kun takstfil */
%if &takst eq 1 %then %do; 
    label KPRantall = 'Antall repetisjoner av takst (KPR)';
    label takstkode = 'Takst (KPR)';
%end;
run;
%mend kpr_lablerFormater;