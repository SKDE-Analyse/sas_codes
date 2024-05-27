%macro ratefigur_tredelt(
    dsn=, /*tilrettelagt datasett*/
    var1=, /*variabel første del av søylen*/
    var2=, /*Variabel andre del av søylen*/
    var3=, /*Variabel tredje del av søylen*/
    label1=, /*Legendnavn første del */
    label2=, /*Legendnavn andre del*/
    label3=, /*Legendnavn tredje del*/
    /*Y-axsis table*/
    ant_kol= 2, /* Antall kolonner i y-axsis table (1,2,3), uten tabell hvis blank */
    tabvar1=, /* Variabel til Første kolonne i Y-axis table*/
    tabvar2=, /* Variabel til Andre kolonne i Y-axis table*/
    tabvar3=, /* Variabel til Tredje kolonne i Y-axis table*/
    tablabel1=, /* Overskrift til Første kolonne i Y-axis table*/
    tablabel2=, /* Overskrift til Andre kolonne i Y-axis table*/
    tablabel3=, /* Overskrift til Tredje kolonne i Y-axis table*/
    fmt_tabvar1=, /* Format til variabel Første kolonne i Y-axis table*/
    fmt_tabvar2=, /* Format til variabel Andre kolonne i Y-axis table*/
    fmt_tabvar3=, /* Format til variabel Tredje kolonne i Y-axis table*/
    sprak=no /*=en*/, /*Norsk eller engelsk tekst i figur, default satt til norsk*/
    bo=bohf /*=borhf eller =boshhn*/,  /*Opptaksområder, default satt til bohf*/
    bildeformat=png, /*Bildeformat, default satt til png*/
    skala=, /*Bestemmes av data når ikke angitt*/
    figurnavn = , /*Første del av figurnavn*/
    xlabel =  /*Tekst under x-aksen*/,
    sortby=ratetot /* Hvordan skulle figuren rangeres */
);
/*! 
### Beskrivelse

Makro for å lage tredelt søylefigur.

```
Kortversjon (kjøres med default verdier for resten):
%ratefigur_tredelt(dsn= ,var1= ,var2= ,var3= ,
    label1= ,label2= ,label3= ,
    tabvar1= ,tabvar2= ,
    tablabel1= ,tablabel2= ,
    fmt_tabvar1= ,fmt_tabvar2= ,
    figurnavn= ,xlabel= )
    
```
### Input
- Ett tilpasset datasett fra rateprogram
- Ett let-statement for å angi &bildesti (%let bildesti = &filbane/Analyse/prosjekter/eksempelmappe/figurer;)
- Ett include-statement for angi &anno
- Ett include-statement for å angi sti til makro (%include "&filbane/rateprogram/ratefigur_tredelt.sas";)

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
*/

data xyz_&dsn;
set &dsn;
ratetot=&var1+&var2+&var3;
rate1_2=&var1+&var2;
if &bo in (8888,7777) then do;
	rateN1=&var1;
	rateN2=&var2;
    rateN3=&var3;
	rateNtot=&var1+&var2+&var3;
    rateN1_2=&var1+&var2;
end;
%if &ant_kol=1 %then %do;
    format &tabvar1 &fmt_tabvar1;
%end;
%if &ant_kol=2 %then %do;
    format &tabvar1 &fmt_tabvar1 &tabvar2 &fmt_tabvar2;
%end;
%if &ant_kol=3 %then %do;
    format &tabvar1 &fmt_tabvar1 &tabvar2 &fmt_tabvar2 &tabvar3 &fmt_tabvar3;
%end;
run;

proc sort data=xyz_&dsn;
by descending &sortby;
run;

%let skala=/*values=(0 to 1.5 by 0.5)*/;

%if &sprak=no %then %do;
	%let opptak_txt = "Bosatte i opptaksområdene";
%end;
%else %if &sprak=en %then %do;
	%let opptak_txt = "Hospital referral area";
%end;

/*figur tegner først total rate, deretter sum av del1 og del2, deretter del1 til sist. */
ODS Graphics ON /reset=All imagename="&figurnavn._&bo._tredelt" imagefmt=&bildeformat border=off height=500px ;
ODS Listing Image_dpi=300 GPATH="&bildesti";
proc sgplot data=xyz_&dsn noborder noautolegend sganno=anno pad=(Bottom=5%);

hbarparm category=&bo. response=ratetot / fillattrs=(color=CX95BDE6) outlineattrs=(color=CX00509E) missing name="hp1" legendlabel="&label3";
hbarparm category=&bo. response=rate1_2 / fillattrs=(color=CX568BBF) outlineattrs=(color=CX00509E) missing name="hp2" legendlabel="&label2";
hbarparm category=&bo. response=&var1 / fillattrs=(color=CX00509E) outlineattrs=(color=CX00509E) missing name="hp3" legendlabel="&label1" ; 

hbarparm category=&bo. response=RateNtot / fillattrs=(color=CXC3C3C3) outlineattrs=(color=CX4C4C4C); 
hbarparm category=&bo. response=rateN1_2 / fillattrs=(color=CX969696) outlineattrs=(color=CX4C4C4C);
hbarparm category=&bo. response=rateN1 / fillattrs=(color=CX4C4C4C) outlineattrs=(color=CX4C4C4C);

keylegend "hp3" "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=7 weight=bold);

    %if &ant_kol=1 %then %do;
    Yaxistable &tabvar1 /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
    Label &tabvar1="&tablabel1" ;
    Format  &tabvar1 &fmt_tabvar1;
    %end;

    %if &ant_kol=2 %then %do;
    Yaxistable &tabvar1 &tabvar2 /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
        Label &tabvar1="&tablabel1" &tabvar2="&tablabel2";
    Format  &tabvar1 &fmt_tabvar1  &tabvar2 &fmt_tabvar2;
    %end;

    %if &ant_kol=3 %then %do;
    Yaxistable &tabvar1 &tabvar2 &tabvar3 /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
    Label &tabvar1="&tablabel1" &tabvar2="&tablabel2" &tabvar3="&tablabel3";
    Format  &tabvar1 &fmt_tabvar1  &tabvar2 &fmt_tabvar2 &tabvar3 &fmt_tabvar3;
    %end;
   
    yaxis display=(noticks noline) label=&opptak_txt labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
	xaxis offsetmin=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
run;

ods listing close; ods graphics off;

proc datasets nolist;
delete xyz_:;
run;

%mend ratefigur_tredelt;
