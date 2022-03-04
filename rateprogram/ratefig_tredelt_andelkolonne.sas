%macro ratefig_tredelt_andelkolonne(
    del1=, /*Datasett første del av søylen*/
    del2=, /*Datasett andre del av søylen*/
    del3=, /*Datasett tredje del av søylen*/
    label_1=, /*Legendnavn første del */
    label_2=, /*Legendnavn andre del*/
    label_3=, /*Legendnavn tredje del*/
    tabellvariable=andel_12, /*Variabel som brukes til kolonnen til høyre, default satt til sum av andel 1 + andel 2*/
    labeltab=andel_1+2, /*Tekst til kolonnen til høyre*/
    sprak=no /*=en*/, /*Norsk eller engelsk tekst i figur, default satt til norsk*/
    bo=bohf /*=borhf eller =boshhn*/,  /*Opptaksområder, default satt til bohf*/
    bildeformat=png, /*Bildeformat, default satt til png*/
    skala=, /*Bestemmes av data når ikke angitt*/
    figurnavn = , /*Første del av figurnavn*/
    xlabel =  /*Tekst under x-aksen*/
);
/*! 
### Beskrivelse

Makro for å lage tredelt søylefigur.

```
Kortversjon (kjøres med default verdier for resten):
%ratefig_tredelt_andelkolonne(del1=, del2=, del3=, label_1=, label_2=, label_3=, figurnavn=, xlabel= )
```
### Input
- Tre datasett/output fra rateprogram (del1, del2 og del3)
- Ett let-statement for å angi &bildesti
- Ett include-statement for å angi &anno 

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Tove
*/
proc sql;
	create table &figurnavn._&bo. as
	select a.&bo., a.ratesnitt as ratesnitt_1, b.ratesnitt as ratesnitt_2, c.ratesnitt as ratesnitt_3,

			sum(ratesnitt_1,ratesnitt_2,ratesnitt_3) as ratesnitt_tot,
			sum(ratesnitt_1, ratesnitt_2) as ratesnitt_12,

			ratesnitt_1 / calculated ratesnitt_tot as andel_1,
			ratesnitt_2 / calculated ratesnitt_tot as andel_2,
			ratesnitt_3 / calculated ratesnitt_tot as andel_3,

			case when a.&bo. in (8888,7777) then calculated ratesnitt_tot end as ratesnittN_tot,
			case when a.&bo. in (8888,7777) then calculated ratesnitt_12 end as ratesnittN_12,
			case when a.&bo. in (8888,7777) then ratesnitt_1 end as ratesnittN_1,

			calculated andel_1 + calculated andel_2 as andel_12

	from &del1. a
	left join &del2. b
	on a.&bo.=b.&bo.
	left join &del3. c
	on a.&bo.=c.&bo.

order by calculated ratesnitt_tot desc;
quit;

%let skala=/*values=(0 to 1.5 by 0.5)*/;

%if &sprak=no %then %do;
	%let opptak_txt = "Bosatte i opptaksområdene";
	%let format_percent = nlpct8.0;
	%let format_num = nlnum8.0;
%end;
%else %if &sprak=en %then %do;
	%let opptak_txt = "Hospital referral area";
	%let format_percent = percent8.0;
	%let format_num = comma8.0;
%end;
/*figur tegner først total rate, deretter sum av del1 og del2, deretter del1 til sist. */
ODS Graphics ON /reset=All imagename="&figurnavn._&bo._tredelt" imagefmt=&bildeformat. border=off height=500px ;
ODS Listing Image_dpi=300 GPATH="&bildesti";
proc sgplot data=&figurnavn._&bo. noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=&bo. response=RateSnitt_tot / fillattrs=(color=CX95BDE6) outlineattrs=(color=CX00509E) missing name="hp1" legendlabel="&label_3";
hbarparm category=&bo. response=RateSnitt_12 / fillattrs=(color=CX568BBF) outlineattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_2";
hbarparm category=&bo. response=ratesnitt_1 / fillattrs=(color=CX00509E) outlineattrs=(color=CX00509E) missing name="hp3" legendlabel="&label_1" ; 

hbarparm category=&bo. response=RateSnittN_tot / fillattrs=(color=CXC3C3C3) outlineattrs=(color=CX4C4C4C); 
hbarparm category=&bo. response=RateSnittN_12 / fillattrs=(color=CX969696) outlineattrs=(color=CX4C4C4C);
hbarparm category=&bo. response=ratesnittN_1 / fillattrs=(color=CX4C4C4C) outlineattrs=(color=CX4C4C4C);

	keylegend "hp3" "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=7 weight=bold);
    Yaxistable &tabellvariable/Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
   
    yaxis display=(noticks noline) label=&opptak_txt labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
	xaxis offsetmin=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	Label &tabellvariable="&labeltab";
	Format  &tabellvariable &format_percent ;
run;
%mend ratefig_tredelt_andelkolonne;