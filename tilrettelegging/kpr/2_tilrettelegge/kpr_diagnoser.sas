/************************************************/
/* Makro for å hente diagnoser fra diagnosefilen*/
/************************************************/

/* 
Input: 	1) inndata (navn på hovedfil/regningsfil som skal tilrettelegges)
		2) utdata (navn på utdata, må være ulikt inndata)
		3) let-statement (%let aar=, %let suffix=)
Output: tre variabler 
		1) hdiag_kpr (hoveddiagnose tilknyttet enkeltregningen)
		2) kodeverk (angir hvilket kodeverk diagnosen tilhører, f.eks icd10, icpc2 osv.)
		3) ant_bdiag_kpr (antall bidiagnoser tilknyttet enkeltregningen) 
*/

%macro kpr_diagnoser(inndata= , utdata=);

/* hente inn hoveddiagnose fra diagnosefilen */
proc sql;
	create table tmp_utdata as
	select *, b.diagnose as hdiag_kpr, b.diagnosetabell as kodeverk
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
/* koble på antall bidiagnoser på fil som tilrettelegges */
proc sql;
	create table &utdata as
	select a.*, b.ant_b as ant_bdiag_kpr
	from tmp_utdata a
	left join ant_bdiag b
	on a.enkeltregning_lnr=b.enkeltregning_lnr;
quit;
/* slette tmp-data */
proc datasets nolist;
delete tmp_utdata;
run;

%mend kpr_diagnoser;