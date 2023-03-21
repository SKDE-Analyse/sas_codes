
%macro takst(inndata=);
data &inndata;
set &inndata;
	array Normaltariff{15} $ Normaltariff1-Normaltariff15;
	array takst_{15} $ takst_:;
	do i=1 to 15;
		Normaltariff{i}=propcase(compress(takst_{i}));
	end;
	drop takst_: i;
run; 
%mend;
