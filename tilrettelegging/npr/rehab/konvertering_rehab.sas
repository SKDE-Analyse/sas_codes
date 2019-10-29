%Macro Konvertering_rehab (Inndatasett=, Utdatasett=);
/*!

MACRO FOR KONVERTERING AV STRINGER TIL NUMERISK, DATO OG TID

### Innhold
0. Fjerner (dropper) variabler som vi ikke trenger. 
1. Omkoding av stringer med tall til numeriske variable.
2. Konvertering av stringer til dato- og tidsvariable
3. Fjerner blanke felt og punktum i stringvariable, samt ny navngiving
4. Lager Hdiag / Bdiag
*/

Data &Utdatasett;
Set &Inndatasett;


/*!
- Lager `pid` fra `LNr` (løpenummer) og sletter `LNr`
*/
PID=LNr+0;
Drop LNr;


/*!
- Generere `komNr` fra `KomNrHjem2` og `bydel_innr` fra `bydel`. Dropper så `bydel` slik at den ikke ligger på fila når ny variabel kalt `bydel` skal genereres i neste makro
*/
KomNr=KomNrHjem2+0;
bydel_innr=bydel;
drop bydel;

/*!
### Konvertering av stringer til dato- og tidsvariable
*/


/*!
- Konvertere `inndato` og `utdato` til datoer
*/
	Inndato1=Input(Inndato,Anydtdte10.);
	Utdato1=Input(Utdato,Anydtdte10.);

	Format Inndato1 Utdato1 Eurdfdd10.;
	Drop Inndato UtDato  ;
	rename Inndato1=Inndato Utdato1=UtDato;
	
	/*!
- Konvertere `Inntid` og `uttid` til klokkeslett
*/
	/*Tider*/
	Inntid1=Input(Inntid, HHMMSS.);
	Uttid1=Input(uttid, HHMMSS.);
	Format Inntid1 Uttid1 Time8.;
	Drop Inntid uttid;
	rename InnTid1=InnTid UtTid1=UtTid;



/*!
- Konvertere `UtskrKlarDato`  til datoer
*/

	UtskrKlarDato1=Input(UtskrKlarDato,Anydtdte10.);


	Format UtskrKlarDato1  Eurdfdd10.;
	Drop UtskrKlarDato   ;
	rename UtskrKlarDato1=UtskrKlarDato  ;
		   
/*!
###	Fjerner blanke felt og punktum i stringvariable, samt ny navngiving. For 2014 navnes dup_tilstand til Tdiag.
*/


/*!
- Fjerner blanke felt i diagnosevariable, justerer til stor bokstav (upcase) og navner om til hdiag/bdiag.
*/



array Tilstand_{19} $
	tilstand_2_1 tilstand_3_1 tilstand_4_1 tilstand_5_1 tilstand_6_1 tilstand_7_1 tilstand_8_1 tilstand_9_1 tilstand_10_1
	tilstand_11_1 tilstand_12_1 tilstand_13_1 tilstand_14_1 tilstand_15_1 tilstand_16_1 tilstand_17_1 tilstand_18_1 tilstand_19_1 tilstand_20_1;
		do i=1 to 19;
               if substr(tilstand_{i},4,1)='.' then substr(tilstand_{i},4,1)=' ';
			   Tilstand_{i}= compress(tilstand_{i},,'s');
    	end;

Hdiag=upcase(compress(Tilstand_1_1));
Hdiag2=upcase(compress(Tilstand_1_2));


array Bdiag{19} $
    Bdiag1-Bdiag19 ;

		do i=1 to 19;
        Bdiag{i}=upcase(compress(Tilstand_{i}));
    	end;
drop tilstand_: i;

/*!
- Fjerner blanke felt i prosedyrevariable, og fjerner underscore (_) i variabelnavn
*/

array ncmp{20} $ ncmp1-ncmp20;
array ncmp_{20} $ ncmp_1-ncmp_20;
          do i=1 to 20;
               ncmp{i}=upcase(compress(ncmp_{i}));
          end;
drop ncmp_: i;



run;

%mend;
