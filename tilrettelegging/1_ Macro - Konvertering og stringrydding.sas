%Macro Konvertering (Inndatasett=, Utdatasett=);

/*!**********************************************************************************************
************************************************************************************************
MACRO FOR KONVERTERING AV STRINGER TIL NUMERISK, DATO OG TID

Innhold:
1.1 Omkoding av stringer med tall til numeriske variable.
1.2 Konvertering av stringer til dato- og tidsvariable
1.3 Fjerner blanke felt og punktum i stringvariable, samt ny navngiving
1.4 Dropliste og variable lables

************************************************************************************************
***********************************************************************************************/

Data &Utdatasett;
%if &avtspes ne 0 %then %do;
Drop gyldig: TilSted FraSted omsorgsniva henv: ;  
%end;
%if &somatikk ne 0 %then %do;
Drop kommTjeneste /* kommer i 2016 */ henvFraTjeneste henvFraInstitusjonID frittSykehusvalg secondOpinion polkonAktivitet henvTilTjeneste henvTilInstitusjonID 
	nyTilstand fraSted tilSted gyldig: frittBehandlingsvalg  ;
%end;
Set &Inndatasett;
%if &avtspes ne 0 %then %do;
where kontakt in (4,5);
%end;

/*
********************************************************
1.1 Omkoding av stringer med tall til numeriske variable
********************************************************
*/

/*Gjenbruk av variabelnavn*/
PID=lnr+0;
%if &somatikk ne 0 %then %do;
Rehab=RehabType+0;
Drop RehabType lnr;
rename Rehab=RehabType;
%end;

/* Generere komNr og bydel_org, dropper så bydel slik at den ikke ligger på fila når ny variabel kalt bydel skal genereres i neste makro */
KomNr=KomNrHjem2+0;
bydel_org=bydel;
drop bydel;

/*
*******************************************************
1.2 Konvertering av stringer til dato- og tidsvariable
*******************************************************
*/
	/*Datoer*/
	Inndato1=Input(Inndato,Anydtdte10.);
	Utdato1=Input(Utdato,Anydtdte10.);
%if &avtspes ne 0 %then %do;
	Format Inndato1 Utdato1 Eurdfdd10.;
	Drop Inndato UtDato  ;
	rename Inndato1=Inndato Utdato1=UtDato;

if utdato lt MDY (1,1,2010) then utdato = .;
if utdato gt MDY (1,1,2016) then utdato = .;
%end;
%if &somatikk ne 0 %then %do;
	UtskrKlarDato1=Input(UtskrKlarDato,Anydtdte10.);

	tidspunkt_11=Input(tidspunkt_1,Anydtdte10.);
	tidspunkt_21=Input(tidspunkt_2,Anydtdte10.);
	tidspunkt_31=Input(tidspunkt_3,Anydtdte10.);
	tidspunkt_41=Input(tidspunkt_4,Anydtdte10.);
	tidspunkt_51=Input(tidspunkt_5,Anydtdte10.);

	/* Disse variablene leses ikke inn før vi eventuelt skal bruke dem i et konkret prosjekt */
	/* PO 30. mars 2017: Legges til Parvus for å prøves ut i eldreatalaset*/

	Format Inndato1 Utdato1 UtskrKlarDato1 tidspunkt_11 tidspunkt_21 tidspunkt_31 
	tidspunkt_41 tidspunkt_51 Eurdfdd10.;
	Drop Inndato UtDato emigrert_29082016 doddato_29082016 UtskrKlarDato tidspunkt_1 tidspunkt_2 tidspunkt_3 
	tidspunkt_4 tidspunkt_5  ;
	rename Inndato1=Inndato Utdato1=UtDato UtskrKlarDato1=UtskrKlarDato tidspunkt_11=tidspunkt_1 tidspunkt_21=tidspunkt_2 
		   tidspunkt_31=tidspunkt_3 tidspunkt_41=tidspunkt_4 tidspunkt_51=tidspunkt_5 ;

	/*Tider*/
	Inntid1=Input(Inntid, HHMMSS.);
	Uttid1=Input(uttid, HHMMSS.);
	Format Inntid1 Uttid1 Time8.;
	Drop Inntid uttid;
	rename InnTid1=InnTid UtTid1=UtTid;
%end;	

/*
**********************************************************************************************************************
1.3 	Fjerner blanke felt og punktum i stringvariable, samt ny navngiving. For 2014 navnes dup_tilstand til Tdiag.
**********************************************************************************************************************
*/

%if &somatikk ne 0 %then %do;
/*Fjerner blanke felt i DRG-koden og justerer til stor bokstav (upcase)*/
DRG=upcase(compress(DRG)); 
%end;

/*Fjerner punktum i diagnosekoder*/
/*Ous har rapportert enkelte diagnosekoder med punktum, eks.'C50.9' */
if substr(tilstand_1_1,4,1)='.' then substr(tilstand_1_1,4,1)=' '; 
if substr(tilstand_1_2,4,1)='.' then substr(tilstand_1_2,4,1)=' '; 

Tilstand_1_1=compress(Tilstand_1_1,,'s'); /*Fjerner space*/
Tilstand_1_2=compress(Tilstand_1_2,,'s');

/*Fjerner komma etter diagnosekoden'*/
if substr(tilstand_1_1,5,1)=',' then substr(tilstand_1_1,5,1)=' ';
Tilstand_1_1=compress(Tilstand_1_1,,'s'); /*Fjerner space*/

%if &avtspes ne 0 %then %do;
array Tilstand_{9} $
	tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1;
		do i=1 to 9;
%end;
%else %do;
array Tilstand_{19} $
	tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1
	tilstand_11_1 tilstand_12_1 tilstand_13_1 tilstand_14_1 tilstand_15_1 tilstand_16_1 tilstand_17_1 tilstand_18_1 tilstand_19_1 tilstand_20_1;
		do i=1 to 19;
%end;
               if substr(tilstand_{i},4,1)='.' then substr(tilstand_{i},4,1)=' '; 
			   Tilstand_{i}= compress(tilstand_{i},,'s');
    	end;

/*Fjerner blanke felt i diagnosevariable, justerer til stor bokstav (upcase) og navner om til hdiag/bdiag.*/
Hdiag=upcase(compress(Tilstand_1_1));
Hdiag2=upcase(compress(Tilstand_1_2));

%if &avtspes ne 0 %then %do;
array Bdiag{9} $
    Bdiag1-Bdiag9 ;

array Tilstand{9} $
	tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1;
		do i=1 to 9;
               Bdiag{i}=upcase(compress(Tilstand{i}));
		
    	end;
drop tilstand_1_1 tilstand_1_2 tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1 i; 
%end;
%else %do;
array Bdiag{19} $
    Bdiag1-Bdiag19 ;

array Tilstand{19} $
	tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1
	tilstand_11_1 tilstand_12_1 tilstand_13_1 tilstand_14_1 tilstand_15_1 tilstand_16_1 tilstand_17_1 tilstand_18_1 tilstand_19_1 tilstand_20_1;
		do i=1 to 19;
               Bdiag{i}=upcase(compress(Tilstand{i}));
    	end;
drop tilstand_1_1 tilstand_1_2 tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1
	tilstand_11_1 tilstand_12_1 tilstand_13_1 tilstand_14_1 tilstand_15_1 tilstand_16_1 tilstand_17_1 tilstand_18_1 tilstand_19_1 tilstand_20_1 i; 
%end;

/*Fjerner blanke felt i prosedyrevariable, og fjerner underscore (_) i variabelnavn*/
%if &avtspes ne 0 %then %do;
array ncsp{10} $ ncsp1-ncsp10;
array ncsp_{10} $ ncsp_1-ncsp_10;
          do i=1 to 10;
%end;
%else %do;
array ncsp{20} $ ncsp1-ncsp20;
array ncsp_{20} $ ncsp_1-ncsp_20;
          do i=1 to 20;
%end;
               ncsp{i}=upcase(compress(ncsp_{i}));
          end;
drop ncsp_: i; 

%if &avtspes ne 0 %then %do;
array ncmp{10} $ ncmp1-ncmp10;
array ncmp_{10} $ ncmp_1-ncmp_10;
          do i=1 to 10;
%end;
%else %do;
array ncmp{20} $ ncmp1-ncmp20;
array ncmp_{20} $ ncmp_1-ncmp_20;
          do i=1 to 20;
%end;
               ncmp{i}=upcase(compress(ncmp_{i}));
          end;
drop ncmp_: i; 

%if &somatikk ne 0 %then %do;
array ncrp{20} $ ncrp1-ncrp20;
array ncrp_{20} $ ncrp_1-ncrp_20;
          do i=1 to 20;
               ncrp{i}=upcase(compress(ncrp_{i}));
          end;
drop ncrp_: i;
%end;

%if &avtspes ne 0 %then %do;
/*Fjerner blanke felt i takstvariable, og navner om til Normaltariff1-15*/
array Normaltariff{15} $
	Normaltariff1-Normaltariff15;
array takst_{15} $
	takst_:;
          do i=1 to 15;
               Normaltariff{i}=compress(takst_{i});
			   Normaltariff{i}=lowcase(Normaltariff{i});
			   Normaltariff{i}=propcase(Normaltariff{i});
          end;
drop takst_: i;
Tell_normaltariff = Tell_takst;
drop tell_takst;

/*Dup_tilstand er fem variabler som samler usorterte diagnoser for 25545 kontakter i 2014. Disse er er identifisert med "dupli" som Hdiag. Navner om til Tdiag.*/

if aar = 2014 then do;
	array Tdiag{5} $
 	   Tdiag1-Tdiag5;

	array Dup_Tilstand{5} $
		Dup_tilstand_1 - Dup_tilstand_5;
			do i=1 to 5;
               Tdiag{i}=upcase(compress(Dup_Tilstand{i}));
 	   		end;
	drop Dup_tilstand_1 - Dup_tilstand_5 i; 
end;


/*
*************************************************
1.4 Dropliste og variable lables
*************************************************
*/
Drop lnr  ;
%end;

run;
%Mend Konvertering;
