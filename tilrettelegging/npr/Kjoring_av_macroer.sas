/*!
Denne filen kjører all tilrettelegging.


*/

%macro kjor_tilrettelegg(aar =, fil =, sektor =, taar =);

%Konvertering     (innDataSett=npr&taar..&fil., utDataSett=work_&aar.);
%Merge_persondata (innDataSett=work_&aar., utDataSett=work_&aar.);
%Bobehandler      (innDataSett=work_&aar., utDataSett=work_&aar.);
%ICD              (innDataSett=work_&aar., utDataSett=work_&aar.);
%Avledede         (innDataSett=work_&aar., utDataSett=work_&aar.);
%KoblingsID       (innDataSett=work_&aar., utDataSett=work_&aar., fil=&sektor.);
%LablerFormater   (innDataSett=work_&aar., utDataSett=work_&aar.);
%reduser_lengde   (innDataSett=work_&aar., utDataSett=work_&aar.);
%if &avtspes=1 %then %do;
%splitt_avtspes(datasett =work_&aar., utsett = skde&taar..T&taar._extra_&sektor._20&aar.);
%end;
%Splitte          (innDataSett=work_&aar., utDataSettEN=skde&taar..T&taar._magnus_&sektor._20&aar.,utDataSettTO=skde&taar..T&taar._parvus_&sektor._20&aar.);

%mend;

/* Definer tilretteleggingsåret*/
%let taar = 19;

%include "&filbane\tilrettelegging\npr\Formater.sas";
%include "&filbane\tilrettelegging\npr\1_Macro-Konvertering_og_stringrydding.sas";
%include "&filbane\tilrettelegging\npr\2_Macro-Bo_og_behandler.sas";
%include "&filbane\tilrettelegging\npr\2b_Macro-behandler.sas";
%include "&filbane\tilrettelegging\npr\2c_Macro-AvtaleRHF.sas";
%include "&filbane\tilrettelegging\npr\3_Macro-ICD10.sas";
%include "&filbane\tilrettelegging\npr\4_Macro-Ovrige_avledede_variable.sas";
%include "&filbane\tilrettelegging\npr\5_Macro-Lage_unik_ID.sas";
%include "&filbane\tilrettelegging\npr\6_Macro-Labler_og_formater.sas";
%include "&filbane\tilrettelegging\npr\7_Macro-Redusere_variabelstorrelser.sas";
%include "&filbane\tilrettelegging\npr\8_Macro-Merge_persondata.sas";
%include "&filbane\tilrettelegging\npr\8b_Macro-splitt_avtspes.sas";
%include "&filbane\tilrettelegging\npr\9_Macro-Dele_datasett.sas";
%include "&filbane\tilrettelegging\npr\fag_skde.sas";

/************************************
*************************************
Kjøre makroene for avdelingsopphold
*************************************
*************************************/

%let avtspes = 0;
%let somatikk = 1;

%kjor_tilrettelegg(fil=m&taar._avd20%sysevalf(&taar-1)_utleveringsfil, aar=%sysevalf(&taar-1), sektor=avd, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avd20%sysevalf(&taar-2)_utleveringsfil, aar=%sysevalf(&taar-2), sektor=avd, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avd20%sysevalf(&taar-3)_utleveringsfil, aar=%sysevalf(&taar-3), sektor=avd, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avd20%sysevalf(&taar-4)_utleveringsfil, aar=%sysevalf(&taar-4), sektor=avd, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avd20%sysevalf(&taar-5)_utleveringsfil, aar=%sysevalf(&taar-5), sektor=avd, taar = &taar.);

/**********************************
***********************************
Kjøre makroene for sykehusopphold
***********************************
***********************************/

%let avtspes = 0;
%let somatikk = 1;

%kjor_tilrettelegg(fil=m&taar._sho20%sysevalf(&taar-1)_utleveringsfil, aar=%sysevalf(&taar-1), sektor=sho, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._sho20%sysevalf(&taar-2)_utleveringsfil, aar=%sysevalf(&taar-2), sektor=sho, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._sho20%sysevalf(&taar-3)_utleveringsfil, aar=%sysevalf(&taar-3), sektor=sho, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._sho20%sysevalf(&taar-4)_utleveringsfil, aar=%sysevalf(&taar-4), sektor=sho, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._sho20%sysevalf(&taar-5)_utleveringsfil, aar=%sysevalf(&taar-5), sektor=sho, taar = &taar.);

/*************************************
**************************************
Kjøre makroene for avtalespesialister
**************************************
**************************************/

%let avtspes = 1;
%let somatikk = 0;

%kjor_tilrettelegg(fil=m&taar._avtspessom20%sysevalf(&taar-1)_utl_fil, aar=%sysevalf(&taar-1), sektor=avtspes, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avtspessom20%sysevalf(&taar-2)_utl_fil, aar=%sysevalf(&taar-2), sektor=avtspes, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avtspessom20%sysevalf(&taar-3)_utl_fil, aar=%sysevalf(&taar-3), sektor=avtspes, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avtspessom20%sysevalf(&taar-4)_utl_fil, aar=%sysevalf(&taar-4), sektor=avtspes, taar = &taar.);
%kjor_tilrettelegg(fil=m&taar._avtspessom20%sysevalf(&taar-5)_utl_fil, aar=%sysevalf(&taar-5), sektor=avtspes, taar = &taar.);
