/* Inkluderer makroer: lagre_dataNorge, lagre_dataN, lagre_dataHN */

%macro lagre_dataNorge;
/*!
Beskrivelse
*/
    %if %sysevalf(%superq(datanavn)=,boolean) %then %let datanavn = &forbruksmal;
	data &forbruksmal._&bo; set &bo._agg_rate; run;
%mend lagre_dataNorge;


%macro lagre_dataN;
/*!
Beskrivelse
*/
    %if %sysevalf(%superq(datanavn)=,boolean) %then %let datanavn = &forbruksmal;
%if &Ut_sett=1 %then %do;
	data &datanavn._S_&bo; set &bo._agg_rate; run;
%end;

%else %do;
	data &datanavn._&bo; set &bo._aarsvar; drop aar rv_just_rate_sum; run;
%end;

%mend lagre_dataN;

%macro lagre_dataHN;
/*!
Beskrivelse

Aldri brukes?
*/
    %if %sysevalf(%superq(datanavn)=,boolean) %then %let datanavn = &forbruksmal;
%if &Ut_sett=1 %then %do;
	data &datanavn._S_&bo._HN; set &bo._agg_rate; run;
%end;

%else %do;
	data &datanavn._&bo._HN; set &bo._aarsvar; drop aar rv_just_rate_sum; run;
%end;

%mend lagre_dataHN;
