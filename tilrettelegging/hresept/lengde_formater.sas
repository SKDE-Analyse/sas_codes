%macro lengde_formater(inndata=, utdata=);

data &utdata;
/* alle datasettene */
    retain pid aar ermann alder bohf borhf komnr bydel refusjonsKodeResept refusjonsKodeUtlevering atc;
    length aar bohf borhf boshhn fodselsar fylke komnr              4;
    length pid bydel                                                6;
    length ermann                                                   3;
set &inndata;
    Label PID='Personentydig l�penummer, numerisk (NPR/SKDE)'; 
    label Alder='Alder (SKDE)';
    label BoHF='Opptaksomr�de (HF) (SKDE)'; format BoHF boHF_fmt.; 
    label BoRHF='Opptaksomr�de (RHF) (SKDE)'; format BoRHF boRHF_fmt.; 
    label BoShHN='Opptaksomr�de (sykehus HN) (SKDE)';format BoShHN boshhn_fmt.; 
    label erMann='Er mann (kj�nn, mann=1) (SKDE)'; format ErMann ErMann.; 
    label Fylke='Fylke (pasientens bosted) (SKDE)'; format fylke fylke.;
    label aar='PeriodeAar (NPR)'; format aar best4.;
    label KomNR='Kommunenummer fornyet til gyldig komnr-struktur pr 01.01.2021, numerisk (SKDE)'; format KomNR komnr_fmt.; 
    label bydel='Bydel i Oslo, Bergen, Stavanger og Trondhem (SKDE)'; format bydel bydel_fmt.;
    label sh_reg='Region (sykehusregion) (NPR)'; format sh_reg region.;
    label pasfylke2='Fylke (pasientens bosted) (NPR)'; format pasfylke2 fylke.;
    label pas_reg2='Region (pasientregion) (NPR)'; format pas_reg2 region.;
    label komnrhjem2='Innrapportert kommunenummer, numerisk (NPR-melding)';  
run;
%mend lengde_formater;