/************************************************/
/* Makro for � hente diagnoser fra diagnosefilen*/
/************************************************/

/* 
Input: 	1) inndata (navn p� hovedfil/regningsfil som skal tilrettelegges)
		2) utdata (navn p� utdata, m� v�re ulikt inndata)
		3) let-statement (%let aar=, %let suffix=)
Output: tre variabler 
		1) hdiag_kpr (hoveddiagnose tilknyttet enkeltregningen)
		2) kodeverk (angir hvilket kodeverk diagnosen tilh�rer, f.eks icd10, icpc2 osv. Gj�r den om til numerisk.)
		3) ant_bdiag_kpr (antall bidiagnoser tilknyttet enkeltregningen) 
*/

%macro kpr_diagnoser(inndata= , utdata=);

/* hente inn hoveddiagnose fra diagnosefilen */
proc sql;
	create table tmp_utdata as
	select a.*, b.diagnosekode as hdiag_kpr, 
					case 	when b.diagnosetabell eq "ICPC-2" 						then 1 
							when b.diagnosetabell eq "ICPC-2B" 						then 2 
					 		when b.diagnosetabell eq "ICD-10" 						then 3
							when b.diagnosetabell eq "ICD-DA-3"  					then 4
					 		when b.diagnosetabell eq "Akser i BUP-klassifikasjon"  	then 5
							when b.diagnosetabell eq " "                            then .					
					end as kodeverk_kpr
	from &inndata a
	left join hnmot.kpr_l_diagnose_&aar._&suffix. b
	on a.enkeltregning_lnr=b.enkeltregning_lnr 
		and b.erhoveddiagnose eq 1; /*kun ta med hoveddiagnose*/
quit;

/* Telle antall rader med bidiagnose til det enkelte enkeltregning_lnr */
proc sql;
	create table ant_bdiag as
	select enkeltregning_lnr, count(*) as ant_b
	from hnmot.kpr_l_diagnose_&aar._&suffix. 
	where erhoveddiagnose ne 1 /*ikke telle raden som er hoveddiagnose*/
	group by enkeltregning_lnr;
quit;
/* koble p� antall bidiagnoser p� fil som tilrettelegges */
proc sql;
	create table &utdata as
	select a.*, b.ant_b as ant_bdiag_kpr
	from tmp_utdata a
	left join ant_bdiag b
	on a.enkeltregning_lnr=b.enkeltregning_lnr;
quit;
/* slette tmp-data */
proc datasets nolist;
delete tmp_utdata ant_bdiag;
run;

%mend kpr_diagnoser;