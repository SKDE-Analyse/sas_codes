/***********************************************************************************************
************************************************************************************************
MACRO FOR KONVERTERING AV STRINGER TIL NUMERISK, DATO OG TID

Innhold:
1.1 Omkoding av stringer med tall til numeriske variable
1.2 Konvertering av stringer til dato- og tidsvariable
1.3 Fjerner blanke felt og punktum i stringvariable, samt ny navngiving
1.4 Dropliste og variable lables

************************************************************************************************
***********************************************************************************************/
%Macro Konvertering (innDataSett=, utDataSett=);
Data &Utdatasett;
Drop kommTjeneste /* kommer i 2016 */ henvFraTjeneste henvFraInstitusjonID frittSykehusvalg secondOpinion polkonAktivitet henvTilTjeneste henvTilInstitusjonID nyTilstand fraSted tilSted 
 ant_tidspunkt typeTidspunkt_: tidspunkt_: gyldig: frittBehandlingsvalg utskrKlarDato ;
Set &Inndatasett;

/*
********************************************************
1.1 Omkoding av stringer med tall til numeriske variable
********************************************************
*/

/*Gjenbruk av variabelnavn*/
PID=NPR_Lopenummer+0;
Rehab=RehabType+0;
Drop RehabType NPR_Lopenummer;
rename Rehab=RehabType;


/*
*******************************************************
1.2 Konvertering av stringer til dato- og tidsvariable
*******************************************************
*/
	/*Datoer*/
	Inndato1=Input(Inndato,Anydtdte10.);
	Utdato1=Input(Utdato,Anydtdte10.);
	EmigrertDato=Input(emigrert_29082016,Anydtdte10.);
	DodDato=Input(doddato_29082016,Anydtdte10.);

/*	tidspunkt_11=Input(tidspunkt_1,Anydtdte10.);*/
/*	tidspunkt_21=Input(tidspunkt_2,Anydtdte10.);*/
/*	tidspunkt_31=Input(tidspunkt_3,Anydtdte10.);*/
/*	tidspunkt_41=Input(tidspunkt_4,Anydtdte10.);*/
/*	tidspunkt_51=Input(tidspunkt_5,Anydtdte10.);*/
/*	UtskrKlarDato1=Input(utskrKlarDato,Anydtdte10.); Disse variablene leses ikke inn før vi eventuelt skal bruke dem i et konkret prosjekt */

	Format Inndato1 Utdato1 emigrertdato doddato /* tidspunkt_11 tidspunkt_21 tidspunkt_31 
	tidspunkt_41 tidspunkt_51 utskrKlarDato1*/ Eurdfdd10.;
	Drop Inndato UtDato emigrert_29082016 doddato_29082016 /* tidspunkt_1 tidspunkt_2 tidspunkt_3 
	tidspunkt_4 tidspunkt_5 utskrKlarDato */;
	rename Inndato1=Inndato Utdato1=UtDato /* tidspunkt_11=tidspunkt_1 tidspunkt_21=tidspunkt_2 
		   tidspunkt_31=tidspunkt_3 tidspunkt_41=tidspunkt_4 tidspunkt_51=tidspunkt_5 
		   UtskrKlardato1=UtskrKlarDato */;

	/*Tider*/
	Inntid1=Input(Inntid, HHMMSS.);
	Uttid1=Input(uttid, HHMMSS.);
	Format Inntid1 Uttid1 Time8.;
	Drop Inntid uttid;
	rename InnTid1=InnTid UtTid1=UtTid;

	/* Indent-variabler per 29082016*/
	fodselsar_ident=fodselsAar_29082016;
	kjonn_ident=kjonn_29082016;
	fodt_mnd_ident=fodt_mnd_29082016;
	drop fodselsAar_29082016 kjonn_29082016 fodt_mnd_29082016;



/*
*****************************************************************************************************
1.3 	Fjerner blanke felt og punktum i stringvariable, samt ny navngiving
*****************************************************************************************************;

/*Fjerner blanke felt i DRG-koden og justerer til stor bokstav (upcase)*/
DRG=upcase(compress(DRG)); 

/*Fjerner punktum i diagnosekoder fjerde felt '/
/*Ous har rapportert enkelte diagnosekoder med punktum, eks.'C50.9' */
if substr(tilstand_1_1,4,1)='.' then substr(tilstand_1_1,4,1)=' '; 
if substr(tilstand_1_2,4,1)='.' then substr(tilstand_1_2,4,1)=' '; 

Tilstand_1_1=compress(Tilstand_1_1,,'s'); /*Fjerner space*/
Tilstand_1_2=compress(Tilstand_1_2,,'s');

/*Fjerner komma etter diagnosekoden'*/
if substr(tilstand_1_1,5,1)=',' then substr(tilstand_1_1,5,1)=' ';
Tilstand_1_1=compress(Tilstand_1_1,,'s'); /*Fjerner space*/

array Tilstand_{19} $
	tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1
	tilstand_11_1 tilstand_12_1 tilstand_13_1 tilstand_14_1 tilstand_15_1 tilstand_16_1 tilstand_17_1 tilstand_18_1 tilstand_19_1 tilstand_20_1;
		do i=1 to 19;
               if substr(tilstand_{i},4,1)='.' then substr(tilstand_{i},4,1)=' '; 
			   Tilstand_{i}=compress(tilstand_{i},,'s');
    	end;

/*Fjerner blanke felt i diagnosevariable, justerer til stor bokstav (upcase) og navner om til hdiag/bdiag.*/
Hdiag=upcase(compress(Tilstand_1_1));
Hdiag2=upcase(compress(Tilstand_1_2));

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


/*Fjerner blanke felt i prosedyrevariable, og fjerner underscore (_) i variabelnavn*/
array ncsp{20} $ ncsp1-ncsp20;
array ncsp_{20} $ ncsp_1-ncsp_20;
          do i=1 to 20;
               ncsp{i}=upcase(compress(ncsp_{i}));
          end;
drop ncsp_: i; 

array ncmp{20} $ ncmp1-ncmp20;
array ncmp_{20} $ ncmp_1-ncmp_20;
          do i=1 to 20;
               ncmp{i}=upcase(compress(ncmp_{i}));
          end;
drop ncmp_: i; 

run;
%Mend Konvertering;
