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
%include "&filbane\tilrettelegging\npr\konvertering.sas";
%include "&filbane\tilrettelegging\npr\bobehandler.sas";
%include "&filbane\tilrettelegging\npr\behandler.sas";
%include "&filbane\tilrettelegging\npr\avtaleRHF_spesialistkomHN.sas";
%include "&filbane\tilrettelegging\npr\icd10.sas";
%include "&filbane\tilrettelegging\npr\avledede.sas";
%include "&filbane\tilrettelegging\npr\koblingsID.sas";
%include "&filbane\tilrettelegging\npr\lablerFormater.sas";
%include "&filbane\tilrettelegging\npr\reduser_lengde.sas";
%include "&filbane\tilrettelegging\npr\merge_persondata.sas";
%include "&filbane\tilrettelegging\npr\splitt_avtspes.sas";
%include "&filbane\tilrettelegging\npr\splitte.sas";
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
