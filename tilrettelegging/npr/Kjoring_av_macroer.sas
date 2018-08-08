/**********************************************************************
***********************************************************************
Kjøre makroene for 2012-2016 - AVDELINGSOPPHOLD
***********************************************************************
**********************************************************************/

%let avtspes = 0;
%let somatikk = 1;

/***********
*** 2016 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_avd2016_Utleveringsfil, utDataSett=work_2016);
%Bobehandler (innDataSett=work_2016, utDataSett=work_2016);
%ICD (innDataSett=work_2016, utDataSett=work_2016);
%Avledede (innDataSett=work_2016, utDataSett=work_2016);
%KoblingsID_avd (innDataSett=work_2016, utDataSett=work_2016);
%LablerFormater (innDataSett=work_2016, utDataSett=work_2016);
%reduser_lengde (innDataSett=work_2016, utDataSett=work_2016);
%Merge_persondata (innDataSett=work_2016, utDataSett=work_2016);
%Splitte (innDataSett=work_2016, utDataSettEN=npr_skde.T17_Magnus_Avd_2016,utDataSettTO=npr_skde.T17_Parvus_Avd_2016);


proc contents data=npr_skde.T17_Magnus_Avd_2016;
proc contents data=npr_skde.T17_Parvus_Avd_2016;

/***********
*** 2015 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_avd2015_Utleveringsfil, utDataSett=work_2015);
%Bobehandler (innDataSett=work_2015, utDataSett=work_2015);
%ICD (innDataSett=work_2015, utDataSett=work_2015);
%Avledede (innDataSett=work_2015, utDataSett=work_2015);
%KoblingsID_avd (innDataSett=work_2015, utDataSett=work_2015);
%LablerFormater (innDataSett=work_2015, utDataSett=work_2015);
%reduser_lengde (innDataSett=work_2015, utDataSett=work_2015);
%Merge_persondata (innDataSett=work_2015, utDataSett=work_2015);
%Splitte (innDataSett=work_2015, utDataSettEN=npr_skde.T17_Magnus_Avd_2015,utDataSettTO=npr_skde.T17_Parvus_Avd_2015);


proc contents data=npr_skde.T17_Magnus_Avd_2015;
proc contents data=npr_skde.T17_Parvus_Avd_2015;

/***********
*** 2014 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_avd2014_Utleveringsfil, utDataSett=work_2014);
%Bobehandler (innDataSett=work_2014, utDataSett=work_2014);
%ICD (innDataSett=work_2014, utDataSett=work_2014);
%Avledede (innDataSett=work_2014, utDataSett=work_2014);
%KoblingsID_avd (innDataSett=work_2014, utDataSett=work_2014);
%LablerFormater (innDataSett=work_2014, utDataSett=work_2014);
%reduser_lengde (innDataSett=work_2014, utDataSett=work_2014);
%Merge_persondata (innDataSett=work_2014, utDataSett=work_2014);
%Splitte (innDataSett=work_2014, utDataSettEN=npr_skde.T17_Magnus_Avd_2014,utDataSettTO=npr_skde.T17_Parvus_Avd_2014);

proc contents data=npr_skde.T17_Magnus_Avd_2014;
proc contents data=npr_skde.T17_Parvus_Avd_2014;

/***********
*** 2013 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_avd2013_Utleveringsfil, utDataSett=work_2013);
%Bobehandler (innDataSett=work_2013, utDataSett=work_2013);
%ICD (innDataSett=work_2013, utDataSett=work_2013);
%Avledede (innDataSett=work_2013, utDataSett=work_2013);
%KoblingsID_avd (innDataSett=work_2013, utDataSett=work_2013);
%LablerFormater (innDataSett=work_2013, utDataSett=work_2013);
%reduser_lengde (innDataSett=work_2013, utDataSett=work_2013);
%Merge_persondata (innDataSett=work_2013, utDataSett=work_2013);
%Splitte (innDataSett=work_2013, utDataSettEN=npr_skde.T17_Magnus_Avd_2013,utDataSettTO=npr_skde.T17_Parvus_Avd_2013);


proc contents data=npr_skde.T17_Magnus_Avd_2013;
proc contents data=npr_skde.T17_Parvus_Avd_2013;

/***********
*** 2012 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_avd2012_Utleveringsfil, utDataSett=work_2012);
%Bobehandler (innDataSett=work_2012, utDataSett=work_2012);
%ICD (innDataSett=work_2012, utDataSett=work_2012);
%Avledede (innDataSett=work_2012, utDataSett=work_2012);
%KoblingsID_avd (innDataSett=work_2012, utDataSett=work_2012);
%LablerFormater (innDataSett=work_2012, utDataSett=work_2012);
%reduser_lengde (innDataSett=work_2012, utDataSett=work_2012);
%Merge_persondata (innDataSett=work_2012, utDataSett=work_2012);
%Splitte (innDataSett=work_2012, utDataSettEN=npr_skde.T17_Magnus_Avd_2012,utDataSettTO=npr_skde.T17_Parvus_Avd_2012);


proc contents data=npr_skde.T17_Magnus_Avd_2012;
proc contents data=npr_skde.T17_Parvus_Avd_2012;

/**********************************************************************
***********************************************************************
Kjøre makroene for 2012-2016 - SYKEHUSOPPHOLD
***********************************************************************
**********************************************************************/

%let avtspes = 0;
%let somatikk = 1;

/***********
*** 2016 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_sho2016_Utleveringsfil, utDataSett=work_2016);
%Bobehandler (innDataSett=work_2016, utDataSett=work_2016);
%ICD (innDataSett=work_2016, utDataSett=work_2016);
%Avledede (innDataSett=work_2016, utDataSett=work_2016);
%KoblingsID_sho (innDataSett=work_2016, utDataSett=work_2016);
%LablerFormater (innDataSett=work_2016, utDataSett=work_2016);
%reduser_lengde (innDataSett=work_2016, utDataSett=work_2016);
%Merge_persondata (innDataSett=work_2016, utDataSett=work_2016);
%Splitte (innDataSett=work_2016, utDataSettEN=npr_skde.T17_Magnus_SHO_2016,utDataSettTO=npr_skde.T17_Parvus_SHO_2016);

proc contents data=npr_skde.T17_Magnus_SHO_2016;
proc contents data=npr_skde.T17_Parvus_SHO_2016;

/***********
*** 2015 ***
***********/;

%Konvertering (innDataSett=NPR_data.M17_sho2015_Utleveringsfil, utDataSett=work_2015);
%Bobehandler (innDataSett=work_2015, utDataSett=work_2015);
%ICD (innDataSett=work_2015, utDataSett=work_2015);
%Avledede (innDataSett=work_2015, utDataSett=work_2015);
%KoblingsID_sho (innDataSett=work_2015, utDataSett=work_2015);
%LablerFormater (innDataSett=work_2015, utDataSett=work_2015);
%reduser_lengde (innDataSett=work_2015, utDataSett=work_2015);
%Merge_persondata (innDataSett=work_2015, utDataSett=work_2015);
%Splitte (innDataSett=work_2015, utDataSettEN=npr_skde.T17_Magnus_SHO_2015,utDataSettTO=npr_skde.T17_Parvus_SHO_2015);

proc contents data=npr_skde.T17_Magnus_SHO_2015;
proc contents data=npr_skde.T17_Parvus_SHO_2015;


/*/************/
/**** 2014 ****/
/************/*;
%Konvertering (innDataSett=NPR_data.M17_sho2014_Utleveringsfil, utDataSett=work_2014);
%Bobehandler (innDataSett=work_2014, utDataSett=work_2014);
%ICD (innDataSett=work_2014, utDataSett=work_2014);
%Avledede (innDataSett=work_2014, utDataSett=work_2014);
%KoblingsID_sho (innDataSett=work_2014, utDataSett=work_2014);
%LablerFormater (innDataSett=work_2014, utDataSett=work_2014);
%reduser_lengde (innDataSett=work_2014, utDataSett=work_2014);
%Merge_persondata (innDataSett=work_2014, utDataSett=work_2014);
%Splitte (innDataSett=work_2014, utDataSettEN=npr_skde.T17_Magnus_SHO_2014,utDataSettTO=npr_skde.T17_Parvus_SHO_2014);
proc contents data=npr_skde.T17_Magnus_SHO_2014;
proc contents data=npr_skde.T17_Parvus_SHO_2014;

/***********
*** 2013 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_sho2013_Utleveringsfil, utDataSett=work_2013);
%Bobehandler (innDataSett=work_2013, utDataSett=work_2013);
%ICD (innDataSett=work_2013, utDataSett=work_2013);
%Avledede (innDataSett=work_2013, utDataSett=work_2013);
%KoblingsID_sho (innDataSett=work_2013, utDataSett=work_2013);
%LablerFormater (innDataSett=work_2013, utDataSett=work_2013);
%reduser_lengde (innDataSett=work_2013, utDataSett=work_2013);
%Merge_persondata (innDataSett=work_2013, utDataSett=work_2013);
%Splitte (innDataSett=work_2013, utDataSettEN=npr_skde.T17_Magnus_SHO_2013,utDataSettTO=npr_skde.T17_Parvus_SHO_2013);
proc contents data=npr_skde.T17_Magnus_SHO_2013;
proc contents data=npr_skde.T17_Parvus_SHO_2013;


/***********
*** 2012 ***
***********/

%Konvertering (innDataSett=NPR_data.M17_sho2012_Utleveringsfil, utDataSett=work_2012);
%Bobehandler (innDataSett=work_2012, utDataSett=work_2012);
%ICD (innDataSett=work_2012, utDataSett=work_2012);
%Avledede (innDataSett=work_2012, utDataSett=work_2012);
%KoblingsID_sho (innDataSett=work_2012, utDataSett=work_2012);
%LablerFormater (innDataSett=work_2012, utDataSett=work_2012);
%reduser_lengde (innDataSett=work_2012, utDataSett=work_2012);
%Merge_persondata (innDataSett=work_2012, utDataSett=work_2012);
%Splitte (innDataSett=work_2012, utDataSettEN=npr_skde.T17_Magnus_SHO_2012,utDataSettTO=npr_skde.T17_Parvus_SHO_2012);
proc contents data=npr_skde.T17_Magnus_SHO_2012;
proc contents data=npr_skde.T17_Parvus_SHO_2012;


/**********************************************************************
***********************************************************************
Kjøre makroene for 2012-2016 - AVTALESPESIALISTER
***********************************************************************
**********************************************************************/

%let avtspes = 1;
%let somatikk = 0;

/***********
*** 2012 ***
***********/


%Konvertering (Inndatasett=Npr_data.M17_AvtspesSom2012_Utl_fil, Utdatasett=PrivSpes2012);
%Merge_persondata(innDataSett=PrivSpes2012, utDataSett=PrivSpes2012);
%Bo_Beh (Inndatasett=PrivSpes2012, Utdatasett=PrivSpes2012);
%Avledede (Inndatasett=PrivSpes2012, Utdatasett=PrivSpes2012);
%formater (Inndatasett=PrivSpes2012, Utdatasett=PrivSpes2012);
%KoblingsID (Inndatasett=PrivSpes2012, Utdatasett=PrivSpes2012);
%reduser_lengde (Inndatasett=PrivSpes2012, Utdatasett=PrivSpes2012);
%Splitte (Inndatasett=Privspes2012, UtdatasettEN=npr_skde.T17_Magnus_AvtSpes_2012,UtdatasettTO=npr_skde.T17_Parvus_AvtSpes_2012);

/***********
*** 2013 ***
***********/

%Konvertering (Inndatasett=Npr_data.M17_AvtspesSom2013_Utl_fil, Utdatasett=PrivSpes2013);
%Merge_persondata(innDataSett=PrivSpes2013, utDataSett=PrivSpes2013);
%Bo_Beh (Inndatasett=PrivSpes2013, Utdatasett=PrivSpes2013);
%Avledede (Inndatasett=PrivSpes2013, Utdatasett=PrivSpes2013);
%formater (Inndatasett=PrivSpes2013, Utdatasett=PrivSpes2013);
%KoblingsID (Inndatasett=PrivSpes2013, Utdatasett=PrivSpes2013);
%reduser_lengde (Inndatasett=PrivSpes2013, Utdatasett=PrivSpes2013);
%Splitte (Inndatasett=Privspes2013, UtdatasettEN=npr_skde.T17_Magnus_AvtSpes_2013,UtdatasettTO=npr_skde.T17_Parvus_AvtSpes_2013);

/***********
*** 2014 ***
***********/

%Konvertering (Inndatasett=Npr_data.M17_AvtspesSom2014_Utl_fil, Utdatasett=PrivSpes2014);
%Merge_persondata(innDataSett=PrivSpes2014, utDataSett=PrivSpes2014);
%Bo_Beh (Inndatasett=PrivSpes2014, Utdatasett=PrivSpes2014);
%Avledede (Inndatasett=PrivSpes2014, Utdatasett=PrivSpes2014);
%formater (Inndatasett=PrivSpes2014, Utdatasett=PrivSpes2014);
%KoblingsID (Inndatasett=PrivSpes2014, Utdatasett=PrivSpes2014);
%reduser_lengde (Inndatasett=PrivSpes2014, Utdatasett=PrivSpes2014);
%Splitte (Inndatasett=Privspes2014, UtdatasettEN=npr_skde.T17_Magnus_AvtSpes_2014,UtdatasettTO=npr_skde.T17_Parvus_AvtSpes_2014);

/***********
*** 2015 ***
***********/

%Konvertering (Inndatasett=Npr_data.M17_AvtspesSom2015_Utl_fil, Utdatasett=PrivSpes2015);
%Merge_persondata(innDataSett=PrivSpes2015, utDataSett=PrivSpes2015);
%Bo_Beh (Inndatasett=PrivSpes2015, Utdatasett=PrivSpes2015);
%Avledede (Inndatasett=PrivSpes2015, Utdatasett=PrivSpes2015);
%formater (Inndatasett=PrivSpes2015, Utdatasett=PrivSpes2015);
%KoblingsID (Inndatasett=PrivSpes2015, Utdatasett=PrivSpes2015);
%reduser_lengde (Inndatasett=PrivSpes2015, Utdatasett=PrivSpes2015);
%Splitte (Inndatasett=Privspes2015, UtdatasettEN=npr_skde.T17_Magnus_AvtSpes_2015,UtdatasettTO=npr_skde.T17_Parvus_AvtSpes_2015);

/***********
*** 2016 ***
***********/

%Konvertering (Inndatasett=Npr_data.M17_AvtspesSom2016_Utl_fil, Utdatasett=PrivSpes2016);
%Merge_persondata(innDataSett=PrivSpes2016, utDataSett=PrivSpes2016);
%Bo_Beh (Inndatasett=PrivSpes2016, Utdatasett=PrivSpes2016);
%Avledede (Inndatasett=PrivSpes2016, Utdatasett=PrivSpes2016);
%formater (Inndatasett=PrivSpes2016, Utdatasett=PrivSpes2016);
%KoblingsID (Inndatasett=PrivSpes2016, Utdatasett=PrivSpes2016);
%reduser_lengde (Inndatasett=PrivSpes2016, Utdatasett=PrivSpes2016);
%Splitte (Inndatasett=Privspes2016, UtdatasettEN=npr_skde.T17_Magnus_AvtSpes_2016,UtdatasettTO=npr_skde.T17_Parvus_AvtSpes_2016);

