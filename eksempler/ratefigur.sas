
/*  enkel ratefigur*/

* include format and anno for logo and kilde;

%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/NPR_somatikk.sas";
%include "&filbane/formater/bo.sas";
%include "&filbane/formater/beh.sas";

%include "&filbane/stiler/anno_logo_kilde_npr_ssb.sas";
%let anno=anno;


Data inngrep_totskulderkir_bohf;
  set kurs.inngrep_totskulderkir_bohf;

   *create 3 variables that look exactly like bohf;
   *use them to draw scatter plot (årsvariasjon) so that we can use the label for keylegend;
   bohf2016=bohf;
   bohf2017=bohf;
   bohf2018=bohf;
   label  bohf2016="2016" bohf2017="2017" bohf2018="2018";
   format bohf2018 bohf2016 bohf2017 bohf_kort.;

run;

/*Forholdstall som kan vises på figuren*/
Data _null_;
  set inngrep_totskulderkir_bohf;

  call symput('FT1',trim(left(put(FT,8.2))));
  call symput('FT2',trim(left(put(FT2,8.2))));
  call symput('FT3',trim(left(put(FT3,8.2))));
run;


proc sort data=inngrep_totskulderkir_bohf;
   by descending rateSnitt2;
run;

ODS Graphics ON /reset=All imagename="totskulderkir" imagefmt=png border=off height=500px;
ODS Listing Image_dpi=300 GPATH="&mappe";
title "Antall Skulderoperasjoner";

proc sgplot data=inngrep_totskulderkir_bohf noborder noautolegend sganno=&anno pad=(Bottom=5%);

    * columns for each bohf in blue(CX95BDE6);
    hbarparm category=bohf response=Ratesnitt2 / fillattrs=(color=CX95BDE6) missing outlineattrs=(color=grey);
  
    * column for Norge in grey(CXC3C3C3);
    hbarparm category=bohf response=Snittrate / fillattrs=(color=CXC3C3C3) outlineattrs=(color=grey);	

    * symbols for årsvariasjon;
	scatter x=rate2018 y=Bohf2018 / markerattrs=(symbol=circle       color=black size=9pt) name="y3"; 
	scatter x=rate2017 y=Bohf2017 / markerattrs=(symbol=circlefilled color=grey  size=7pt) name="y2"; 
	scatter x=rate2016 y=bohf2016 / markerattrs=(symbol=circlefilled color=black size=5pt) name="y1";

	* draw a line to connect the årsvariasjon;
	Highlow Y=Bohf low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); 

	* legend for the årsvariasjon symbols;
	keylegend "y1" "y2" "y3" / across=1 position=bottomright location=inside noborder valueattrs=(size=7pt);

	* display forholdstall (using the macro variables we created earlier by using call symput);
	inset "FT1 = &FT1" "FT2 = &FT2" "FT3 = &FT3" / position=right textattrs=(size=9) valuealign=right; 

	* setting for x- and y- axis;
	xaxis offsetmin=0.02 offsetmax=0.04 values=(0 to 300 by 50) valueattrs=(size=8) label="Antall Skulderoperasjoner, kjønns- og aldersstandardiserte rater pr. 100 000 innbyggere, gjennomsnitt per år i perioden 2016-18." labelattrs=(size=8 weight=bold);
    yaxis display=(noticks noline) label='Bosatte i opptaksområdene' labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);

	* tabell til høyre;
    Yaxistable inngrep_TotSkulderkir Innbyggere /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);
    Label  inngrep_TotSkulderkir="Inngrep" Innbyggere="Innbyggere";
    Format inngrep_TotSkulderkir           Innbyggere  NLnum8.0;
    
run;

Title; 
ods listing close;

