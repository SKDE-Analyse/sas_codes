

%macro definere_aar;

/*!
Makro for å definere de globale makrovariablene
Periode Antall_aar År1 År2 etc. basert på &StartÅr og &SluttÅr
*/

/*Beregne år1, år2 osv*/
%global Periode;
%let Periode=(&StartÅr:&SluttÅr);
%global Antall_aar;
%let Antall_aar=%sysevalf(&SluttÅr-&StartÅr+2);
%global År1;
%let År1=%sysevalf(&StartÅr);
%if &Antall_aar ge 2 %then %do;
    %global År2;
	%let År2=%sysevalf(&StartÅr+1);
%end;
%if &Antall_aar ge 3 %then %do;
    %global År3;
	%let År3=%sysevalf(&StartÅr+2);
%end;
%if &Antall_aar ge 4 %then %do;
    %global År4;
	%let År4=%sysevalf(&StartÅr+3);
%end;
%if &Antall_aar ge 5 %then %do;
    %global År5;
	%let År5=%sysevalf(&StartÅr+4);
%end;
%if &Antall_aar ge 6 %then %do;
    %global År6;
	%let År6=%sysevalf(&StartÅr+5);
%end;
%if &Antall_aar ge 7 %then %do;
    %global År7;
	%let År7=%sysevalf(&StartÅr+6);
%end;

%if &Antall_aar=2 %then %do;
	proc format; Value aar
	&År1="&År1" 9999='Snitt';	run;
%end;
%if &Antall_aar=3 %then %do;
	proc format; Value aar
	&År1="&År1" &År2="&År2" 9999='Snitt';	run;
%end;
%if &Antall_aar=4 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3" 9999='Snitt';	run;
%end;
%if &Antall_aar=5 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3"	&År4="&År4" 9999='Snitt';	run;
%end;
%if &Antall_aar=6 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3" &År4="&År4" &År5="&År5"	9999='Snitt';	run;
%end;
%if &Antall_aar=7 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3"	&År4="&År4" &År5="&År5"	&År6="&År6" 9999='Snitt';	run;
%end;
%if &Antall_aar=8 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3"	&År4="&År4" &År5="&År5"	&År6="&År6" &År7="&År7" 9999='Snitt';	run;
%end;

%mend;

