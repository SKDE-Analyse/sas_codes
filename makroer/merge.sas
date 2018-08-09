%macro merge(aar1=2014, aar2=2015, aar3=2016, ant_datasett=, dsn_ut=);

%if &ant_datasett=1 %then %do;
	data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt; rate_1_&aar1=rate&aar1; rate_1_&aar2=rate&aar2; rate_1_&aar3=rate&aar3;
	run;
%end;

%if &ant_datasett=2 %then %do;
	data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt; rate_1_&aar1=rate&aar1; rate_1_&aar2=rate&aar2; rate_1_&aar3=rate&aar3;
	run;
	data dsn2;
	set &dsn2;
	antall_2=&rv2; rate_2=ratesnitt; rate_2_&aar1=rate&aar1; rate_2_&aar2=rate&aar2; rate_2_&aar3=rate&aar3;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn2.antall_2,dsn2.rate_2,dsn2.rate_2_&aar1,dsn2.rate_2_&aar2,dsn2.rate_2_&aar3
	from dsn1 left join dsn2
	on dsn1.bohf=dsn2.bohf;
	quit;
%end;


%if &ant_datasett=3 %then %do;
	data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt; rate_1_&aar1=rate&aar1; rate_1_&aar2=rate&aar2; rate_1_&aar3=rate&aar3;
	run;
	data dsn2;
	set &dsn2;
	antall_2=&rv2; rate_2=ratesnitt; rate_2_&aar1=rate&aar1; rate_2_&aar2=rate&aar2; rate_2_&aar3=rate&aar3;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn2.antall_2,dsn2.rate_2,dsn2.rate_2_&aar1,dsn2.rate_2_&aar2,dsn2.rate_2_&aar3
	from dsn1 left join dsn2
	on dsn1.bohf=dsn2.bohf;
	quit;
	data dsn3;
	set &dsn3;
	antall_3=&rv3; rate_3=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn3.antall_3,dsn3.rate_3
	from dsn1 left join dsn3
	on dsn1.bohf=dsn3.bohf;
	quit;
%end;

%if &ant_datasett=4 %then %do;
	data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt; rate_1_&aar1=rate&aar1; rate_1_&aar2=rate&aar2; rate_1_&aar3=rate&aar3;
	run;
	data dsn2;
	set &dsn2;
	antall_2=&rv2; rate_2=ratesnitt; rate_2_&aar1=rate&aar1; rate_2_&aar2=rate&aar2; rate_2_&aar3=rate&aar3;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn2.antall_2,dsn2.rate_2,dsn2.rate_2_&aar1,dsn2.rate_2_&aar2,dsn2.rate_2_&aar3
	from dsn1 left join dsn2
	on dsn1.bohf=dsn2.bohf;
	quit;
	data dsn3;
	set &dsn3;
	antall_3=&rv3; rate_3=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn3.antall_3,dsn3.rate_3
	from dsn1 left join dsn3
	on dsn1.bohf=dsn3.bohf;
	quit;
	data dsn4;
	set &dsn4;
	antall_4=&rv4; rate_4=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn4.antall_4,dsn4.rate_4
	from dsn1 left join dsn4
	on dsn1.bohf=dsn4.bohf;
	quit;
%end;

%if &ant_datasett=5 %then %do;
	data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt; rate_1_&aar1=rate&aar1; rate_1_&aar2=rate&aar2; rate_1_&aar3=rate&aar3;
	run;
	data dsn2;
	set &dsn2;
	antall_2=&rv2; rate_2=ratesnitt; rate_2_&aar1=rate&aar1; rate_2_&aar2=rate&aar2; rate_2_&aar3=rate&aar3;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn2.antall_2,dsn2.rate_2,dsn2.rate_2_&aar1,dsn2.rate_2_&aar2,dsn2.rate_2_&aar3
	from dsn1 left join dsn2
	on dsn1.bohf=dsn2.bohf;
	quit;
	data dsn3;
	set &dsn3;
	antall_3=&rv3; rate_3=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn3.antall_3,dsn3.rate_3
	from dsn1 left join dsn3
	on dsn1.bohf=dsn3.bohf;
	quit;
	data dsn4;
	set &dsn4;
	antall_4=&rv4; rate_4=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn4.antall_4,dsn4.rate_4
	from dsn1 left join dsn4
	on dsn1.bohf=dsn4.bohf;
	quit;
	data dsn5;
	set &dsn5;
	antall_5=&rv5; rate_5=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn5.antall_5,dsn5.rate_5
	from dsn1 left join dsn5
	on dsn1.bohf=dsn5.bohf;
	quit;
%end;

%if &ant_datasett=6 %then %do;
	data dsn1;
	set &dsn1;
	antall_1=&rv1; rate_1=ratesnitt; rate_1_&aar1=rate&aar1; rate_1_&aar2=rate&aar2; rate_1_&aar3=rate&aar3;
	run;
	data dsn2;
	set &dsn2;
	antall_2=&rv2; rate_2=ratesnitt; rate_2_&aar1=rate&aar1; rate_2_&aar2=rate&aar2; rate_2_&aar3=rate&aar3;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn2.antall_2,dsn2.rate_2,dsn2.rate_2_&aar1,dsn2.rate_2_&aar2,dsn2.rate_2_&aar3
	from dsn1 left join dsn2
	on dsn1.bohf=dsn2.bohf;
	quit;
	data dsn3;
	set &dsn3;
	antall_3=&rv3; rate_3=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn3.antall_3,dsn3.rate_3
	from dsn1 left join dsn3
	on dsn1.bohf=dsn3.bohf;
	quit;
	data dsn4;
	set &dsn4;
	antall_4=&rv4; rate_4=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn4.antall_4,dsn4.rate_4
	from dsn1 left join dsn4
	on dsn1.bohf=dsn4.bohf;
	quit;
	data dsn5;
	set &dsn5;
	antall_5=&rv5; rate_5=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn5.antall_5,dsn5.rate_5
	from dsn1 left join dsn5
	on dsn1.bohf=dsn5.bohf;
	quit;
	data dsn6;
	set &dsn6;
	antall_6=&rv6; rate_6=ratesnitt;
	run;
	proc sql;
	create table dsn1 as
	select dsn1.*,dsn6.antall_6,dsn6.rate_6
	from dsn1 left join dsn6
	on dsn1.bohf=dsn6.bohf;
	quit;
%end;


data &dsn_ut;
set dsn1;
%if &ant_datasett=2 %then %do; 
antall_1_2=antall_1/antall_2; antall_2_1=antall_2/antall_1; 
andel_1_2=rate_1/rate_2; andel_2_1=rate_2/rate_1;
tot_rate=rate_1+rate_2;
tot_rate_&aar1=rate_1_&aar1+rate_2_&aar1;
tot_rate_&aar2=rate_1_&aar2+rate_2_&aar2;
tot_rate_&aar3=rate_1_&aar3+rate_2_&aar3;
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
tot_antall=antall_1+antall_2;
if bohf=8888 then do;
	nandel_rate1=andel_rate1;
	nandel_rate2=andel_rate2;
	nrate_1=rate_1; nrate_2=rate_2;;
	ntot_rate=tot_rate;
end;
%end;
%if &ant_datasett=3 %then %do; 
antall_1_2=antall_1/antall_2; antall_1_3=antall_1/antall_3; 
antall_2_1=antall_2/antall_1; antall_2_3=antall_2/antall_3; 
antall_3_1=antall_3/antall_1; antall_3_2=antall_3/antall_2;
andel_1_2=rate_1/rate_2; andel_1_3=rate_1/rate_3; 
andel_2_1=rate_2/rate_1; andel_2_3=rate_2/rate_3; 
andel_3_1=rate_3/rate_1; andel_3_2=rate_3/rate_2;
tot_rate=rate_1+rate_2;
tot_rate_&aar1=rate_1_&aar1+rate_2_&aar1;
tot_rate_&aar2=rate_1_&aar2+rate_2_&aar2;
tot_rate_&aar3=rate_1_&aar3+rate_2_&aar3;
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
*andel_rate3=rate_3/tot_rate;
tot_antall=antall_1+antall_2;
if bohf=8888 then do;
	nandel_rate1=andel_rate1;
	nandel_rate2=andel_rate2;
	*nandel_rate3=andel_rate3;
	nrate_1=rate_1; nrate_2=rate_2; nrate_3=rate_3;
	ntot_rate=tot_rate;
end;
%end;
%if &ant_datasett=4 %then %do; 
antall_1_2=antall_1/antall_2; antall_1_3=antall_1/antall_3; antall_1_4=antall_1/antall_4; 
antall_2_1=antall_2/antall_1; antall_2_3=antall_2/antall_3; antall_2_4=antall_2/antall_4;
antall_3_1=antall_3/antall_1; antall_3_2=antall_3/antall_2; antall_3_4=antall_3/antall_4;
antall_4_1=antall_4/antall_1; antall_4_3=antall_4/antall_3; antall_4_2=antall_4/antall_2;
andel_1_2=rate_1/rate_2; andel_1_3=rate_1/rate_3; andel_1_4=rate_1/rate_4; 
andel_2_1=rate_2/rate_1; andel_2_3=rate_2/rate_3; andel_2_4=rate_2/rate_4;
andel_3_1=rate_3/rate_1; andel_3_2=rate_3/rate_2; andel_3_4=rate_3/rate_4;
andel_4_1=rate_4/rate_1; andel_4_2=rate_4/rate_2; andel_4_3=rate_4/rate_3;
tot_rate=rate_1+rate_2;
tot_rate_&aar1=rate_1_&aar1+rate_2_&aar1;
tot_rate_&aar2=rate_1_&aar2+rate_2_&aar2;
tot_rate_&aar3=rate_1_&aar3+rate_2_&aar3;
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
*andel_rate3=rate_3/tot_rate;
*andel_rate4=rate_4/tot_rate;
tot_antall=antall_1+antall_2;
if bohf=8888 then do;
	nandel_rate1=andel_rate1;
	nandel_rate2=andel_rate2;
	*nandel_rate3=andel_rate3;
	*nandel_rate4=andel_rate4;
	nrate_1=rate_1; nrate_2=rate_2; nrate_3=rate_3; nrate_4=rate_4;
	ntot_rate=tot_rate;
end;
%end;
%if &ant_datasett=5 %then %do; 
antall_1_2=antall_1/antall_2; antall_1_3=antall_1/antall_3; antall_1_4=antall_1/antall_4; antall_1_5=antall_1/antall_5;
antall_2_1=antall_2/antall_1; antall_2_3=antall_2/antall_3; antall_2_4=antall_2/antall_4; antall_2_5=antall_2/antall_5;
antall_3_1=antall_3/antall_1; antall_3_2=antall_3/antall_2; antall_3_4=antall_3/antall_4; antall_3_5=antall_3/antall_5;
antall_4_1=antall_4/antall_1; antall_4_3=antall_4/antall_3; antall_4_2=antall_4/antall_2; antall_4_5=antall_4/antall_5;
antall_5_1=antall_5/antall_1; antall_5_2=antall_5/antall_2; antall_5_3=antall_5/antall_3; antall_5_4=antall_5/antall_4;
andel_1_2=rate_1/rate_2; andel_1_3=rate_1/rate_3; andel_1_4=rate_1/rate_4; andel_1_5=rate_1/rate_5;
andel_2_1=rate_2/rate_1; andel_2_3=rate_2/rate_3; andel_2_4=rate_2/rate_4; andel_2_5=rate_2/rate_5;
andel_3_1=rate_3/rate_1; andel_3_2=rate_3/rate_2; andel_3_4=rate_3/rate_4; andel_3_5=rate_3/rate_5;
andel_4_1=rate_4/rate_1; andel_4_2=rate_4/rate_2; andel_4_3=rate_4/rate_3; andel_4_5=rate_4/rate_5;
andel_5_1=rate_5/rate_1; andel_5_2=rate_5/rate_2; andel_5_3=rate_5/rate_3; andel_5_4=rate_5/rate_4;
tot_rate=rate_1+rate_2;
tot_rate_&aar1=rate_1_&aar1+rate_2_&aar1;
tot_rate_&aar2=rate_1_&aar2+rate_2_&aar2;
tot_rate_&aar3=rate_1_&aar3+rate_2_&aar3;
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
*andel_rate3=rate_3/tot_rate;
*andel_rate4=rate_4/tot_rate;
tot_antall=antall_1+antall_2;
if bohf=8888 then do;
	nandel_rate1=andel_rate1;
	nandel_rate2=andel_rate2;
	*nandel_rate3=andel_rate3;
	*nandel_rate4=andel_rate4;
	nrate_1=rate_1; nrate_2=rate_2; nrate_3=rate_3; nrate_4=rate_4; nrate_5=rate_5;
	ntot_rate=tot_rate;
end;
%end;
%if &ant_datasett=6 %then %do; 
antall_1_2=antall_1/antall_2; antall_1_3=antall_1/antall_3; antall_1_4=antall_1/antall_4; antall_1_5=antall_1/antall_5; antall_1_6=antall_1/antall_6;
antall_2_1=antall_2/antall_1; antall_2_3=antall_2/antall_3; antall_2_4=antall_2/antall_4; antall_2_5=antall_2/antall_5; antall_2_6=antall_2/antall_6;
antall_3_1=antall_3/antall_1; antall_3_2=antall_3/antall_2; antall_3_4=antall_3/antall_4; antall_3_5=antall_3/antall_5; antall_3_6=antall_3/antall_6;
antall_4_1=antall_4/antall_1; antall_4_3=antall_4/antall_3; antall_4_2=antall_4/antall_2; antall_4_5=antall_4/antall_5; antall_4_6=antall_4/antall_6;
antall_5_1=antall_5/antall_1; antall_5_2=antall_5/antall_2; antall_5_3=antall_5/antall_3; antall_5_4=antall_5/antall_4; antall_5_6=antall_5/antall_6;
antall_6_1=antall_6/antall_1; antall_6_2=antall_6/antall_2; antall_6_3=antall_6/antall_3; antall_6_4=antall_6/antall_4; antall_6_5=antall_6/antall_5;
andel_1_2=rate_1/rate_2; andel_1_3=rate_1/rate_3; andel_1_4=rate_1/rate_4; andel_1_5=rate_1/rate_5; andel_1_6=rate_1/rate_6;
andel_2_1=rate_2/rate_1; andel_2_3=rate_2/rate_3; andel_2_4=rate_2/rate_4; andel_2_5=rate_2/rate_5; andel_2_6=rate_2/rate_6;
andel_3_1=rate_3/rate_1; andel_3_2=rate_3/rate_2; andel_3_4=rate_3/rate_4; andel_3_5=rate_3/rate_5; andel_3_6=rate_3/rate_6;
andel_4_1=rate_4/rate_1; andel_4_2=rate_4/rate_2; andel_4_3=rate_4/rate_3; andel_4_5=rate_4/rate_5; andel_4_6=rate_4/rate_6;
andel_5_1=rate_5/rate_1; andel_5_2=rate_5/rate_2; andel_5_3=rate_5/rate_3; andel_5_4=rate_5/rate_4; andel_5_6=rate_5/rate_6;
andel_6_1=rate_6/rate_1; andel_6_2=rate_6/rate_2; andel_6_3=rate_6/rate_3; andel_6_4=rate_6/rate_4; andel_6_5=rate_6/rate_5;
tot_rate=rate_1+rate_2;
tot_rate_&aar1=rate_1_&aar1+rate_2_&aar1;
tot_rate_&aar2=rate_1_&aar2+rate_2_&aar2;
tot_rate_&aar3=rate_1_&aar3+rate_2_&aar3;
andel_rate1=rate_1/tot_rate;
andel_rate2=rate_2/tot_rate;
*andel_rate3=rate_3/tot_rate;
*andel_rate4=rate_4/tot_rate;
tot_antall=antall_1+antall_2;
if bohf=8888 then do;
	nandel_rate1=andel_rate1;
	nandel_rate2=andel_rate2;
	*nandel_rate3=andel_rate3;
	*nandel_rate4=andel_rate4;
	nrate_1=rate_1; nrate_2=rate_2; nrate_3=rate_3; nrate_4=rate_4; nrate_5=rate_5; nrate_6=rate_6;
	ntot_rate=tot_rate;
end;
%end;
run;

proc datasets nolist;
delete dsn:;
run;

%mend merge;