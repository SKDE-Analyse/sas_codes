/* compare data received at the end of June with the ones at the beginning of July */

/* move the June data to NPR_DATA */
/* save the July data in NPR18 */
/* save parallel files under the same name */

%macro Sammenligne_som (Data=);
proc delete data= juni juli; run;
proc sort data= NPR18.&data out=Juli; by lopenr opphold_id; run;
proc sort data= NPR_Data.&data out=Juni; by lopenr opphold_id; run;
Proc compare base=Juni compare=Juli BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
%mend Sammenligne_som; 

%Sammenligne_som(data=M18_SOMSH2013_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_SOMSH2014_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_SOMSH2015_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_SOMSH2016_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_SOMSH2017_UTLEVERINGSFIL);

%Sammenligne_som(data=M18_AVD2013_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_AVD2014_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_AVD2015_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_AVD2016_UTLEVERINGSFIL);
%Sammenligne_som(data=M18_AVD2017_UTLEVERINGSFIL);

*compare tell_atc, tell_cyto, utTilstand, typeTidspunkt_1 to 5 with M17 files;

%macro Sammenligne_som (Data=);
/*proc delete data= M17 M18; run;*/
proc sort data= NPR18.M18_&data(keep=lopenr opphold_id tell_atc tell_cyto utTilstand
                                     typeTidspunkt_1 typeTidspunkt_2 typeTidspunkt_3 typeTidspunkt_4 typeTidspunkt_5 
                                rename=(lopenr=lnr)) out=M18; 
  by lnr opphold_id; 
run;
proc sort data= NPR_DATA.M17_&data(keep=lnr opphold_id tell_atc tell_cyto utTilstand
                                     typeTidspunkt_1 typeTidspunkt_2 typeTidspunkt_3 typeTidspunkt_4 typeTidspunkt_5 
                                  ) out=M17; 
  by lnr opphold_id; 
run;

Proc compare base=M17 compare=M18 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
%mend Sammenligne_som; 

%Sammenligne_som(data=AVD2013_UTLEVERINGSFIL);

/* files from different years are hard to compare since they have different oppholds_id therefor can not be sorted in the same order */



%macro Sammenligne_avtspes (Data=);
proc delete data= juni juli; run;
proc sort data= NPR18.&data out=Juli; by lopenr inndato nprid_reg fag fagLogg; run;
proc sort data= NPR_Data.&data out=Juni; by lopenr inndato nprid_reg fag fagLogg; run;
Proc compare base=Juni compare=Juli BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
%mend Sammenligne_avtspes; 

%Sammenligne_avtspes(data=M18_AVTSPESSOM2013_UTL_FIL);
%Sammenligne_avtspes(data=M18_AVTSPESSOM2014_UTL_FIL);
%Sammenligne_avtspes(data=M18_AVTSPESSOM2015_UTL_FIL);
%Sammenligne_avtspes(data=M18_AVTSPESSOM2016_UTL_FIL);
%Sammenligne_avtspes(data=M18_AVTSPESSOM2017_UTL_FIL);




%macro Sammenligne_rehab (Data=);
proc delete data= juni juli; run;
proc sort data= NPR18.&data out=Juli; by lopenr nprid_reg inndato utdato institusjonid inntid uttid henvfratjeneste; run;
proc sort data= NPR_Data.&data out=Juni; by lopenr nprid_reg inndato utdato institusjonid inntid uttid henvfratjeneste; run;
Proc compare base=Juni compare=Juli BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
%mend Sammenligne_rehab;


proc compare base=NPR18.M18_DIALYSE16_17 compare=NPR_DATA.M18_DIALYSE16_17 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;

proc compare base=NPR18.M18_PAKKEFORLOP15_17 compare=NPR_DATA.M18_PAKKEFORLOP15_17 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;

proc compare base=NPR18.M18_PROSDATOFIL2013_2017 compare=NPR_DATA.M18_PROSDATOFIL2013_2017 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;

proc compare base=NPR18.M18_SYKESTUE13 compare=NPR_DATA.M18_SYKESTUE13 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=NPR18.M18_SYKESTUE14 compare=NPR_DATA.M18_SYKESTUE14 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=NPR18.M18_SYKESTUE15 compare=NPR_DATA.M18_SYKESTUE15 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=NPR18.M18_SYKESTUE16 compare=NPR_DATA.M18_SYKESTUE16 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=NPR18.M18_SYKESTUE17 compare=NPR_DATA.M18_SYKESTUE17 BRIEF WARNING LISTVAR METHOD=ABSOLUTE;




/* PERSONDATA */

proc sort data=npr_data.M18_persondata19062018 out=juni; by lopenr; run;
proc sort data=npr18.M18_persondata19062018 out=juli; by lopenr; run;

data overlap;
  merge juni(in=a keep=lopenr) juli(in=b keep=lopenr);
  by lopenr;
  if a and b;
run;

data juni;
  merge juni(in=a) overlap(in=b);
  by lopenr;
  if b;
run;

data juli;
  merge juli(in=a) overlap(in=b);
  by lopenr;
  if b;
run;

Proc compare base=juni compare=juli BRIEF WARNING LISTVAR METHOD=ABSOLUTE;

data both;
  merge juni(rename=(fodselsaar_ident19062018=fodaar_6 
                     fodt_mnd_ident19062018=fodmnd_6 
                     kjonn_ident19062018=kjonn_6 
                     doddato19062018=doddt_6 
                     emigrertdato19062018=emidt_6))
        juli(rename=(fodselsaar_ident19062018=fodaar_7 
                     fodt_mnd_ident19062018=fodmnd_7 
                     kjonn_ident19062018=kjonn_7 
                     doddato19062018=doddt_7 
                     emigrertdato19062018=emidt_7));
  by lopenr;
run;

data diff;
  set both;
  where fodaar_6 ne fodaar_7 or fodmnd_6 ne fodmnd_7 or kjonn_6 ne kjonn_7 or doddt_6 ne doddt_7 or emidt_6 ne emidt_7;
run;

proc sort data=diff;
  by descending doddt_6;
run;

/*Conclusion of the PERSONDATA comparison:  */
/*Some differences make sense, while some others appear quite strange.  */
/*However, the size of the problem is extremely miniscule that does not warrent any further investigation.*/
