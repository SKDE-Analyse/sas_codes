%Macro kpr_lablerFormater (innData=, utData=);

Data &Utdata;
set &Inndata;

%if &diagnose ne 1 %then %do; /*koden skal ikke kj�res p� diagnosedata*/
    label KPR_pid='Personentydig l�penummer, numerisk (KPR/SKDE)'; 
    label BoHF='Opptaksomr�de (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label BoRHF='Opptaksomr�de (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label BoShHN='Opptaksomr�de (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label erMann='Er mann (kj�nn, mann=1) (SKDE)'; format ErMann ErMann.; 
    label Fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;
    label KomNR='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021, numerisk (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem (SKDE)'; format bydel bydel_fmt.;
    label bydel_org='Bydel (KPR)'; 
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
    label icpc2_hdiag='ICPC2 hoveddiagnoser p� regningskort (KPR/SKDE)'; format icpc2_hdiag $icpc2_fmt.;
    label icpc2_kap='ICPC2 kapittel, avledet fra diagnose (SKDE)'; format icpc2_kap $icpc2_kap.;
    label icpc2_type='(SKDE)'; format icpc2_type icpc2_type.;
%end;

/* Gjelder alle datasettene fra KPR */
    label aar='�r (KPR)';
    label enkeltregning_lnr='L�penummer for enkeltregninger (KPR)';
    label kodeverk='Angir aktuelt kodeverk for tilh�rende diagnose (KPR/SKDE)';

%if &diagnose eq 1 %then %do; /*gjelder kun diagnose-data*/
    label diag='diagnoseKode (KPR)';
    label kodenr='(KPR)';
    label erHdiag='erHoveddiagnose - angir om diagnosen er hoveddiagnose p� aktuell kontakt (SKDE)';
%end;


run;

%mend;