%Macro kpr_lablerFormater (innData=, utData=);

Data &Utdata;
set &Inndata;

%if &diagnose ne 1 %then %do; /*koden skal ikke kjøres på diagnosedata*/
    label KPR_pid='Personentydig løpenummer, numerisk (KPR/SKDE)'; 
    label BoHF='Opptaksområde (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label BoRHF='Opptaksområde (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label BoShHN='Opptaksområde (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label erMann='Er mann (kjønn, mann=1) (SKDE)'; format ErMann ErMann.; 
    label Fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;
    label KomNR='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021, numerisk (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem (SKDE)'; format bydel bydel_fmt.;
    label bydel_org='Bydel (KPR)'; format bydel bydel_fmt.;
    label kontakttype='';
    label tjenestetype='';
    label behandlingsnr='Antall behandlinger pasienten har hatt (KPR)';
    label minimumtidsbruk='';
    label fritakskode='';
    label egenandelpasient='';
    label refusjonutbetalt='';
    label bostedavledet='(KPR)';
    label Hdiag='Hoveddiagnose (KPR)';
    label Alder='Alder (KPR)';
    label fodselsar='(KPR)';
    label dato='Dato for aktuell kontakt (SKDE)';
    label tid='Tidspunkt for aktuelle kontakt (SKDE)';
    label icpc2_hdiag='ICPC2 hoveddiagnoser på regningskort (KPR/SKDE)';
%end;

    label aar='År (KPR)';
    label enkeltregning_lnr='Løpenummer for enkeltregninger (KPR)';
    label kodeverk='Angir aktuelt kodeverk for tilhørende diagnose (KPR/SKDE)';

%if &diagnose eq 1 %then %do;
    label diag='Diagnose (KPR)';
    label kodenr='(KPR)';
    label erHdiag='Er diagnosen hoveddiagnose på aktuell kontakt (1=ja) (SKDE)';
%end;


run;

%mend;