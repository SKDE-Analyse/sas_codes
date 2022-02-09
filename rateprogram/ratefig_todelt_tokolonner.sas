%macro ratefig_todelt_tokolonner(
    del1=, /*Datasett første del av søylen, f.eks offentlig*/
    del2=, /*Datasett andre del av søylen, f.eks privat*/
    teller= , /*Datasett som skal brukes til kolonne, f.eks kontaktrate*/
    nevner= , /*Datasett som skal brukes til kolonne, f.eks pasientrate*/
    label_1=del1, /*Legendnavn første del */
    label_2=del2, /*Legendnavn andre del*/
    tabellvariable1=andel_1, /*Variabel som brukes til kolonne1 til høyre, default satt til andel_1*/
    tabellvariable2=ant_kont_pas, /*variabel som brukes til kolonne 2 til høyre, default satt til ant_kont_pas*/
    labeltab1= andel1, /*Tekst over kolonne 1 til høyre*/
    labeltab2=ant_per, /*Tekst over kolonne 2 til høyre*/
    sprak=no /*=en*/, /*Norsk eller engelsk tekst i figur, default satt til norsk*/
    bo=bohf /*=borhf eller =boshhn*/,  /*Opptaksområder, default satt til bohf*/
    bildeformat=png, /*Bildeformat, default satt til png*/
    skala=, /*Bestemmes av data når ikke angitt*/
    figurnavn = , /*Første del av figurnavn*/
    xlabel =  /*Tekst under x-aksen*/
);
/*! 
### Beskrivelse

Makro for å lage trodelt søylefigur, og ha to kolonner på y-aksen. 

```
Kortversjon (kjøres med default verdier for resten):
%ratefig_todelt_tokolonner(del1=, del2=,dsn3=, dsn4=, label_1=, label_2=, figurnavn=, xlabel= )
```
### Input
- Fire datasett/output fra rateprogram (del1 og del2, dsn3 og dsn4 som brukes til kolonnen ant kontakter per pasient )
- Ett let-statement for å angi &bildesti (%let bildesti = \\&filbane\Analyse\prosjekter\eksempelmappe\figurer;)
- Ett include-statement for å angi anno 

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Tove
*/
proc sql;
	create table &figurnavn._&bo as
	select a.&bo.,  a.ratesnitt as ratesnitt_1, 
                    b.ratesnitt as ratesnitt_2,
				    c.ratesnitt as ant_kontakter, 
                    d.ratesnitt as ant_pas,

			sum(ratesnitt_1,ratesnitt_2) as ratesnitt_tot, /*sum av del 1 og del 2*/
			ant_kontakter / ant_pas as ant_kont_pas, /*antall kontakter per pasient fra dsn3 og dsn4*/

			ratesnitt_1 / calculated ratesnitt_tot as andel_1, /*andel del 1 av total*/
			ratesnitt_2 / calculated ratesnitt_tot as andel_2, /*andel del 2 av total*/

            /*egen variabel til Norge i figuren*/
			case when a.&bo. in (8888,7777) then calculated ratesnitt_tot end as ratesnittN_tot, 
			case when a.&bo. in (8888,7777) then ratesnitt_1 end as ratesnittN_1,
            case when a.&bo. in (8888,7777) then ratesnitt_2 end as ratesnittN_2

	from &del1. a
	left join &del2. b
	on a.&bo.=b.&bo.
	left join &teller. c
	on a.&bo.=c.&bo.
	left join &nevner. d
	on a.&bo.=d.&bo.
order by calculated ratesnitt_tot desc;
quit;
			
%let skala=/*values=(0 to 1.5 by 0.5)*/;

%if &sprak=no %then %do;
	%let opptak_txt = "Bosatte i opptaksområdene";
	%let format_percent = nlpct8.0;
	%let format_num = nlnum8.1;
%end;
%else %if &sprak=en %then %do;
	%let opptak_txt = "Hospital referral area";
	%let format_percent = percent8.0;
	%let format_num = comma8.1;
%end;
/* figur tegner først totalrater, så tegnes del 1 over. */
ODS Graphics ON /reset=All imagename="&figurnavn._&bo._todelt_kolonne" imagefmt=&bildeformat border=off height=500px ;
ODS Listing Image_dpi=300 GPATH="&bildesti";
proc sgplot data=&figurnavn._&bo noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=&bo. response=RateSnitt_tot / fillattrs=(color=CX95BDE6) outlineattrs=(color=CX00509E) missing name="hp1" legendlabel="&label_2";
hbarparm category=&bo. response=ratesnitt_1 / fillattrs=(color=CX00509E) outlineattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_1" ; 

hbarparm category=&bo. response=RateSnittN_tot / fillattrs=(color=CXC3C3C3) outlineattrs=(color=CX4C4C4C); 
hbarparm category=&bo. response=ratesnittN_1 / fillattrs=(color=CX4C4C4C) outlineattrs=(color=CX4C4C4C);

	keylegend "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=7 weight=bold);
    Yaxistable &tabellvariable1 &tabellvariable2/Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
   
    yaxis display=(noticks noline) label=&opptak_txt labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
	xaxis offsetmin=0.02 &skala valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	Label &tabellvariable1="&labeltab1" &tabellvariable2="&labeltab2";
	Format  &tabellvariable1 &format_percent &tabellvariable2 &format_num;
run;
%mend ratefig_todelt_tokolonner;