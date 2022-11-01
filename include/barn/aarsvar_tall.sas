data frank.B_A_&IA._&forbruksmal_fa;
set Bohf_agg_rate;
length utvalg $32.;
utvalg="&IA._&forbruksmal_fa";
keep aar bohf rv_just_rate utvalg;
where aar ne 9999;
run;
