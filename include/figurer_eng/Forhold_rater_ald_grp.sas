

DATA femti_&datasett;
set &dsn_femti._bohf;
	keep bohf rateSnitt &dsn_femti rate_femti;
	rate_femti = ratesnitt;
	drop ratesnitt;
run;


DATA syttifem_&datasett;
set &dsn_syttifem._bohf;
	keep bohf rateSnitt &dsn_syttifem rate_syttifem;
	rate_syttifem = ratesnitt;
	drop rateSnitt;
run;


proc sort data=femti_&datasett;
	by bohf;
run;


proc sort data=syttifem_&datasett;
	by bohf;
run;


data &datasett;
merge femti_&datasett syttifem_&datasett;
	by bohf;
	forh_tall = rate_syttifem/rate_femti;
run;

data &datasett;
set &datasett;
	if bohf = 8888 then forh_tall_no = forh_tall;
	prosent = forh_tall ;
	if bohf = 8888 then prosent_no = prosent;
	if prosent > 1 then do;
		pros_pos = prosent;
		if bohf = 8888 then pros_pos_no = prosent;
	end;
	if prosent < 1 then do;
		pros_neg = prosent;
		if bohf = 8888 then pros_neg_no = prosent;
	end;
	Length Mistext $ 10;
	if &dsn_syttifem lt 30 then do;
	 rate_syttifem =.;
	 pros_neg =.;
     Mistext="N<30";
     Plassering=&MisT_posisjon;
	 prosent=.;
end;
	label rate_femti="Rate 50-74" rate_syttifem="Rate 75+" str_tot_unik='Patients 75+' str50pluss_tot_unik='Patients 50-74' ; 
run;


proc sql;
   create table &datasett as 
   select *, max(rate_syttifem) as maks75, min(rate_syttifem) as min75, max(rate_femti) as maks50, min(rate_femti) as min50
   from &datasett;
   quit;

data &datasett; 
set &datasett;
FT_50=round((maks50/min50),0.1);
FT_75=round((maks75/min75),0.1);
drop maks: min50 min75;
run;

Data _null_;
set &datasett;
call symput('FT_50', trim(left(put(FT_50,8.1))));
call symput('FT_75', trim(left(put(FT_75,8.1))));
run;

proc sort data=&datasett;
	by descending prosent;
run;



%let fontst = 7;
%let mappe = rapport;
%let bildeformat = pdf;

%include "&filbane/include/figurer_eng/fig3_eldre.sas";


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

%include "&filbane/include/figurer_eng/fig3_eldre.sas";


%let fontst = 7;
%let mappe = png;
%let bildeformat = png;

%include "&filbane/include/figurer_eng/fig3_eldre.sas";





Proc datasets nolist;
delete femti: sytti:;
run;


