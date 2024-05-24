
/* korrelasjon spearman */
/* opprettet av Janice S. 2024 */

%macro korrelasjon (fil1= /* name of the first file */,
                    var1= /* variable on the first file to be considered for correlation */, 
                    ylab=, 
                    ylegend=,  
                    fil2= /* name of the second file */, 
                    var2= /* variable on the second file for correlation */, 
                    y2lab=, 
                    y2legend=, 
                    utplot=, 
                    andel=0 /* 0 if want correlation between the two variable, 1 if want correlation between var1 and var2/var1 */ , 
                    bildefmt=png, 
                    show_pval=0);
    data korr;
        merge &fil1(keep=bohf &var1 rename=(&var1=bar))
              &fil2(keep=bohf &var2 rename=(&var2=line) );
        by bohf;
        andel=line/bar;
        if bohf=8888 then bar_no=bar;
        format bohf bohf_fmt. andel percent8.2;
    run;
    
    %let corr1=bar;
    %if &andel=0 %then %do;
        %let corr2=line;
    %end;
    %if &andel=1 %then %do;
        %let corr2=andel;
    %end;
    
    ods graphics on;
    proc corr data=korr spearman plots=scatter(noinset ellipse=none);
    ods output spearmanCorr=p;
        where bohf le 23;
        var &corr1 &corr2;
    run;
    ods graphics off;
    
    data p;
      set p ;
      where &corr1=1;
      keep &corr2 p&corr2;
    run;
    
    proc sql;
      select &corr2 into :r
      from p;
    quit;
    proc sql;
      select p&corr2 into :p
      from p;
    quit;
    
    proc sort data=korr;
      by &corr1;
    run;
    
    ODS Graphics ON /reset=All imagename="&utplot" imagefmt=&bildefmt border=off height=500px ;
    ODS Listing Image_dpi=300 GPATH="&bildesti";
    proc sgplot data=korr sganno=anno;
       vbar  bohf / response=&corr1    categoryorder=respasc fillattrs=(color=CX95BDE6) name="bar" legendlabel="&ylegend";
       *vbar  bohf / response=bar_no categoryorder=respasc fillattrs=(color=CXC3C3C3) outlineattrs=(color=CX4C4C4C);
       vline bohf / response=&corr2 y2axis name="line" legendlabel="&y2legend";
       xaxis valuesrotate=diagonal2 label="Bosatte i opptaksområdene";
       yaxis label="&ylab";
       %if &andel=0 %then %do;
       y2axis label="&y2lab" min=0  ;
       %end;
       %if &andel=1 %then %do;
       y2axis label="&y2lab" min=0  valuesformat= percent8.0;
       %end;
       keylegend "bar" "line";
       %if &show_pval=1%then %do;
         INSET ("p =" = "&p" "r =" = "&r" ) / BORDER;
       %end;
    title;
    run;
    ods listing close; ods graphics off;
%mend;