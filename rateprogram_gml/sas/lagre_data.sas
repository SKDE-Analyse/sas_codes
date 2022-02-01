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
	data &datanavn._&bo; set &bo._aarsvar; drop aar &rate_var._sum; run;
	%dele_tabell; /*JS 27.02.2020 - moved this from rateberegninger.sas to here so that if we are running rateprogram for more than one &bo (f.eks. HF=1 and RFH=1) then it makes the tables for all of them; */
%end;

%else %do;
	data &datanavn._&bo; set &bo._aarsvar; drop aar &rate_var._sum; run;
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
	data &datanavn._&bo._HN; set &bo._aarsvar; drop aar &rate_var._sum; run;
	%dele_tabell;
%end;

%else %do;
	data &datanavn._&bo._HN; set &bo._aarsvar; drop aar &rate_var._sum; run;
%end;

%mend lagre_dataHN;
