/*!
SAS template for å lage LaTeX-tabeller av SAS-tabeller. Brukes som følger:

```
%include "&filbane\include\latexTabell.sas";

ods tagsets.tablesonlylatex tagset=event1
file="\\hn.helsenord.no\RHF\SKDE\ANALYSE\helseatlas\...\filename.tex"   (notop nobot) style=journal;

PROC TABULATE  ORDEr=data DATA=tabell; 
	class  nmr nmr_to;
	var n alder_Mean Kvinneandel FT FT2 min_rate maks_rate min_bohf maks_bohf ;
	TABLE nmr='' *nmr_to=''*sum='', n='N'*F=Numeric12.0 
	alder_Mean='Alder, gj. snitt'*F=Numeric6.1 Kvinneandel*F=PERCENT6.1
	min_rate='Laveste rate'*F=Numeric6.1 maks_rate='Høyeste rate'*F=Numeric6.1 FT*F=Numeric6.1 FT2*F=Numeric6.1 
	min_bohf='BoHf med laveste rate'*F=BoHF_kort. maks_bohf='Bohf med høyeste rate'*F=BoHF_kort.  ;
RUN;
ods tagsets.tablesonlylatex close;
```

*/


proc template;
 define tagset Tagsets.event1;

/* Nulle ut alle events */
    define event byline;end;
    define event proc_title;end;
    define event note;end;
    define event Error;end;
    define event Warn;end;
    define event Fatal;end;
    define event system_footer;end;
    define event leaf;end;
    define event proc_branch;end;
    define event branch;end;
    define event pagebreak;end;
    define event system_title;end;
    define event table;end;
    define event table_head;
    finish:
          put "\midrule" NL;
end;
    define event colspecs;end;
    define event colspec_entry;end;

 define event table;
  start:
  put NL;
  put NL;
  put "\vspace*{10 px}" NL;
  put "\begin{scriptsize}" NL "\begin{tabularx}{\textwidth}";
  finish:
  put "\midrule" NL "\end{tabularx}" NL "\end{scriptsize}";
  put NL;
 end;
 define event tabular;
  start:
  put NL;
  put "\begin{tabular}";
  trigger alignment;
  finish:
  put "\end{tabular}" NL;
  end;
 define event colspecs;
  start:
  put "{";
  finish:
  put "}" NL;
 end;

 define event colspec_entry;
/*put just /if ^cmp( just, "d");*/
/*put "r" /if cmp( just, "d");*/

  put "r" /if ^cmp( just, "c");
  put "X" /if cmp( just, "c");
 end;

 define event row;
  finish:
  put "\\" NL;
 end;

 define event header;
  start:
  trigger data;
  finish:
  trigger data;
 end;

 define event data;
  start:
  put VALUE /if cmp( $sascaption, "true");
  break /if cmp( $sascaption, "true");
  put %nrstr(" & ") /if ^cmp( COLSTART, "1");
  put " ";
  unset $colspan;
  set $colspan colspan;
  do /if exists( $colspan) | exists ( $cell_align );
  put "\multicolumn{";
  put colspan /if $colspan;
  put "1" /if ^$colspan;
  put "}{";
  put "l" /if ^$instacked;
 /*put just;
 put "|" /if ^$instacked;*/
  put "}{";
  done;
  put tranwrd(VALUE,"-","$-$") /if contains( HTMLCLASS, "data");
  put strip(VALUE) /if ^contains( HTMLCLASS, "data");
  finish:
  break /if cmp( $sascaption, "true");
  put "}" /if exists( $colspan) | exists ( $cell_align );
 end;

 define event rowspanfillsep;
  put %nrstr(" & ");
 end;

 define event rowspancolspanfill;
  put " ~";
 end;

 define event image;
  put "\includegraphics{";
  put BASENAME /if ^exists( NOBASE);
  put URL;
  put "}" NL;
 end;

 parent = tagsets.latex;
 end;
run;
