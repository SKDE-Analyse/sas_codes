/*!
Inputvariabler: ant_datasett

Datasettene som skal brukes angis med %Let statements før makroen kjøres:

%Let dsn1=
%Let dsn2=
...
%Let dsnXX=

Makro som lager en "matrise" (egentlig en masse nye variabler) hvor 
antall (personer/episoder/liggedøgn...) og rater fra to eller flere 
ulike datasett deles på hverandre ihht tabellene under.

Eksempel med tre datasett:

				  |	antall1	(rv1)				antall1	(rv2)			antall1	(rv2)
	--------------|--------------------------------------------------------------------
	antall1	(rv1) |	antall_1_1 = rv1/rv1	antall_2_1 = rv2/rv1	antall_3_1 = rv3/rv1
				  |
	antall2	(rv2) |	antall_1_2 = rv1/rv2	antall_2_2 = rv2/rv2	antall_3_2 = rv3/rv2
				  |
	antall3 (rv3) |	antall_1_3 = rv1/rv3	antall_2_3 = rv2/rv3	antall_3_3 = rv3/rv3
	
	
		  |			rate1						rate2						rate3			
	------|----------------------------------------------------------------------------------
	rate1 |	andel_1_1 = rate1/rate1		andel_2_1 = rate2/rate1		andel_3_1 = rate3/rate1
		  |
	rate2 |	andel_1_2 = rate1/rate2		andel_2_2 = rate2/rate2		andel_3_2 = rate3/rate2
		  |
	rate3 |	andel_1_3 = rate1/rate3		andel_2_3 = rate2/rate3		andel_3_3 = rate3/rate3

Makroen lager også variablene: 

tot_rate=rate1 + rate2
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
tot_antall=antall_1+antall_2;

Kan f.eks brukes til å lage tabeller med utfyllende informasjon til høyre for en rate/andelsfigur.
	
*/


%macro ForholdsMatrise(ant_datasett=);

data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt;
run;

%do i=2 %to &ant_datasett;

	data dsn&i;
	set &&dsn&i;
	antall_&i=&&rv&i; rate_&i=ratesnitt;
	run;

	proc sql;
	create table dsn1 as
	select dsn1.*,dsn&i..antall_&i,dsn&i..rate_&i
	from dsn1 left join dsn&i
	on dsn1.bohf=dsn&i..bohf;
	quit;

%end;

data dsn1;
	set dsn1;

%do j=1 %to &ant_datasett;
	%do i=1 %to &ant_datasett;

		antall_&j._&i=antall_&j/antall_&i; antall_&i._&j=antall_&i/antall_&j;
		andel_&j._&i=rate_&j/rate_&i; andel_&i._&j=rate_&i/rate_&j;

	%end;
	%if bohf=8888 %then %do;
		nrate_&j=rate_&j;
	%end;
%end;

tot_rate=rate_1+rate_2;
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
tot_antall=antall_1+antall_2;

%if bohf=8888 %then %do;
	nandel_rate1=andel_rate1;
	nandel_rate2=andel_rate2;
	ntot_rate=tot_rate;
%end;

run;

%mend ForholdsMatrise;