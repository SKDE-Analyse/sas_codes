%Macro kpr_lablerFormater (innData=, utData=);

Data &Utdata;
set &Inndata;

/* Felles for alle lege-datasettene fra KPR */
    label aar='År (KPR)';
    label enkeltregning_Lnr='Løpenummer for enkeltregninger (KPR)';

/* Felles for regning- og diagnosefil */
%if &sektor=diagnose or &sektor=enkeltregning %then %do; 
    label kodeverk_kpr='Angir kodeverk for tilhørende diagnose (KPR/SKDE)'; format kodeverk_kpr kodeverk_kpr.;
%end;

/* Gjelder kun regningsfil */
%if &sektor=enkeltregning %then %do; 
    label pid_kpr='Personentydig løpenummer (KPR)'; 
    label bohf='Opptaksområde (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label borhf='Opptaksområde (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label boshhn='Opptaksområde (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label ermann='Er mann (kjønn, mann=1) (SKDE)'; format ErMann ErMann.; 
    label fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;
    label komnr='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021 (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem (SKDE)'; format bydel bydel_fmt.;
    label kontakttype_kpr='Kontakttype (KPR/SKDE)' ;format kontakttype_kpr kontakttype_kpr. ;
    label tjenestetype_kpr='Tjenestetype (KPR/SKDE)'; format tjenestetype_kpr tjenestetype_kpr.;
    label fritakskode='Fritakskode (KPR)';
    label egenandelpasient='Egenandel pasient (KPR)';
    label refusjonutbetalt='Refusjon utbetalt (KPR)';
    label hdiag_kpr='Hoveddiagnose - hentet fra diagnosefil (KPR/SKDE)';
    label Alder='Alder';format alder best8.;
    label fodselsar='Fødselsår';
    label inndato='Inndato'; format inndato eurdfdd10.;
    label inntid='Tidspunkt for kontakt';format inntid time8.;
    label icpc2_hdiag='ICPC2 hoveddiagnose på regningskort (SKDE)'; format icpc2_hdiag $icpc2_fmt.;
    label icpc2_kap='ICPC2 kapittel, avledet fra diagnose (SKDE)'; format icpc2_kap $icpc2_kap.;
    label icpc2_type='Angir om det er sympt/plager, diagnose/sykdom eller prosesskode (SKDE)'; format icpc2_type icpc2_type.;
    label ant_bdiag_kpr='Antall bidiagnoser på regning (SKDE)'; format ant_bdiag_kpr best2.;
%end;

/* Gjelder kun diagnosefil */
%if &sektor=diagnose %then %do; 
    label diag_kpr='DiagnoseKode (KPR)';
    label kodenr='Angir nummer i rekken av diagnoser (KPR)';
    label erhdiag_kpr='Hoveddiagnose = 1 (SKDE/KPR)'; format erHdiag_kpr erHdiag_kpr.;
    label icpc2_diag='ICPC2 diagnose på regningskort (SKDE)'; format icpc2_diag $icpc2_fmt.;

%end;

/* Gjelder kun takstfil */
%if &sektor=takst %then %do; 
    label KPRantall = 'Antall repetisjoner av takst (KPR)';
    label takstkode = 'Takst (KPR)';
%end;
run;
%mend kpr_lablerFormater;