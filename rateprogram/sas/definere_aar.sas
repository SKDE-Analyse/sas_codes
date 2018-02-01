

%macro definere_aar;

/*!
Makro for Â definere de globale makrovariablene
Periode Antall_aar ≈r1 ≈r2 etc. basert pÂ &Start≈r og &Slutt≈r
*/

/*Beregne Âr1, Âr2 osv*/
%global Periode;
%let Periode=(&Start≈r:&Slutt≈r);
%global Antall_aar;
%let Antall_aar=%sysevalf(&Slutt≈r-&Start≈r+2);
%global ≈r1;
%let ≈r1=%sysevalf(&Start≈r);
%if &Antall_aar ge 2 %then %do;
    %global ≈r2;
	%let ≈r2=%sysevalf(&Start≈r+1);
%end;
%if &Antall_aar ge 3 %then %do;
    %global ≈r3;
	%let ≈r3=%sysevalf(&Start≈r+2);
%end;
%if &Antall_aar ge 4 %then %do;
    %global ≈r4;
	%let ≈r4=%sysevalf(&Start≈r+3);
%end;
%if &Antall_aar ge 5 %then %do;
    %global ≈r5;
	%let ≈r5=%sysevalf(&Start≈r+4);
%end;
%if &Antall_aar ge 6 %then %do;
    %global ≈r6;
	%let ≈r6=%sysevalf(&Start≈r+5);
%end;
%if &Antall_aar ge 7 %then %do;
    %global ≈r7;
	%let ≈r7=%sysevalf(&Start≈r+6);
%end;

%mend;

