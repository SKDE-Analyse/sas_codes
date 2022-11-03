%Macro Konvertering (Inndatasett=, Utdatasett=, pid=);

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
Set &Inndatasett 
/*Tove 01.04.2022: kan ikke kjøres på avtspes-tilrettelegging, men skal kjøres i somatikk-tilrettelegging.*/
%if &somatikk ne 0 %then %do;
(rename=(episodeFag=episodefag_org)) 
%end;
;

/* Sletter variabler vi ikke trenger fra somatikkfilene. */
%if &somatikk ne 0 %then %do;
drop oppholdstype /*Tove 30.03.2022: 'oppholdstype' i mottatte data er tom - fjernes fra tilrettelagt fil*/
	 cyto:; 
%end;
/*!
### Omkoding av stringer med tall til numeriske variable
*/

/*!
- Lager `pid` fra `LNr` (løpenummer) og sletter `LNr`
*/
rename &pid = PID;

/*!
- Generere `bydel_org` fra `bydel` og `bydel2_org` fra `bydel2`. Dropper så `bydel` slik at den ikke ligger på fila når ny variabel kalt `bydel` skal genereres i neste makro
*/

%if &datagrunnlag=SKDE %then %do;
	bydel_org=bydel;
	bydel2_org=bydel2;
	drop bydel;
%end;


/*!
### Konvertering av stringer til dato- og tidsvariable
*/
/* files received in 2020 for the pandemic project has dates and time already in the correct format.*/


/*!
###	Fjerner blanke felt og punktum i stringvariable, samt ny navngiving. For 2014 navnes dup_tilstand til Tdiag.
*/
		/*
		- Episodefag manglet ledende null for avtalespesialister enkelte år.
		- convert to character if numeric
		*/
%if &somatikk ne 0 %then %do;
    episodefag=put(episodefag_org,3.);
		if lengthn(compress(episodefag_org)) = 2 then episodefag = compress("0"||episodefag_org);
		if episodefag in ("0","950") then episodefag="999";
	drop episodefag_org;

/*!
- Fjerner blanke felt i DRG-koden og justerer til stor bokstav (upcase)
*/
	DRG=upcase(compress(DRG));
%end;

/*!
- Fjerner punktum, space, og komma i diagnosekoder. (OUS har rapportert enkelte diagnosekoder med punktum, eks. `C50.9`) Navner om til hdiag/bdiag.
*/

array tilstand(*) $ tilstand:;
do i = 1 to dim(tilstand);
  tilstand(i)=upcase(compress(tilstand(i),"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890","ki")); /*The modifier "ki" means Keep the characters in the list and Ignore the case of the characters */
end;

/* Hdiag */
Hdiag=Tilstand_1_1;
Hdiag2=Tilstand_1_2;

/* Bdiag */
%if &avtspes ne 0 %then %do;
	%let nkode=10;
%end;
%else %do;
	%let nkode=20;
%end;

%let nkode_1=%eval(&nkode.-1);

array Bdiag{*} $ Bdiag1-Bdiag&nkode_1 ;
array bTilstand{*} $ tilstand_2_1 -- tilstand_&nkode._1;
do i=1 to dim(bTilstand);
    Bdiag{i}=(bTilstand{i});
end;
drop tilstand_: i;

/*!
- Fjerner blanke felt i prosedyrevariable, og fjerner underscore (_) i variabelnavn
*/

%if &sektor ne REHAB %then %do;
array ncsp{&nkode} $ ncsp1-ncsp&nkode;
array ncsp_{&nkode} $ ncsp_1-ncsp_&nkode;
do i=1 to &nkode; 
   ncsp{i}=upcase(compress(ncsp_{i}));
end;
drop ncsp_: i ;
%end;

array ncmp{&nkode} $ ncmp1-ncmp&nkode;
array ncmp_{&nkode} $ ncmp_1-ncmp_&nkode;
do i=1 to &nkode; 
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
	/*!
	- Fjerner blanke felt i takstvariable, og navner om til Normaltariff1-15
	*/
	array Normaltariff{15} $ Normaltariff1-Normaltariff15;
	array takst_{15} $ takst_:;
	do i=1 to 15;
		Normaltariff{i}=propcase(lowcase(compress(takst_{i})));
	end;
	drop takst_: i;

	%if &datagrunnlag=SKDE %then %do;
		Tell_normaltariff = Tell_takst;
		drop tell_takst;
	%end;

	/* 12Jul2019 JS - det ligger ICD-10-koder i ATC_1 -- ATC_5 i 2014.  Koden ATC_1 er identisk med koden i tilstand_1_1, og ATC_2 er identisk med koden i tilstand_1_2.
	   Flytter ACT_2 til ATC_5 til tilstand_2_1 til tilstand_4_1 som Bdiag */
	/* ingjen ATC var i 2020T1 data
	 if &avtspes=1 and ATC_1 ne '' then do;
	   tilstand_2_1=ATC_3;
	   tilstand_3_1=ATC_4;
	   tilstand_4_1=ATC_5;
	 end;  
	*/

	/*
	- Dup_tilstand er fem variabler som samler usorterte diagnoser for 25545 kontakter i 2014. 
	Disse er identifisert med "(dupli" som Hdiag. Navner om til Tdiag.
	*/
	/*
	if aar in  (2014,2018) then do;
		array Tdiag{5} $
	 	   Tdiag1-Tdiag5;

		array Dup_Tilstand{5} $
			Dup_tilstand_1 - Dup_tilstand_5;
				do i=1 to 5;
	               Tdiag{i}=upcase(compress(Dup_Tilstand{i}));
	 	   		end;
		drop Dup_tilstand_1 - Dup_tilstand_5 i;
	end;
	*/
%end;

/* Tove 01.04.2022: fjerner tomme variabler fra tilrettelagte data */
%if &sektor=ASPES %then %do;
	drop drg drgreturkode hdg kontakt npkopphold_ertellendeISFopphold spes_drg dag_kir niva vekt komp_drg drg_type korrvekt rehabtype;
%end;

/* Tove 07.04.2022: fjerner tomme variabler fra tilrettelagte data (+ noen variabler med annen type enn i somatikkfil..) */
%if &sektor=REHAB %then %do;
	drop oppholdstype fagenhetisfrefusjon utforendeHelseperson fagenhetKode fagomrade episodefag;
%end;

run;
%mend;