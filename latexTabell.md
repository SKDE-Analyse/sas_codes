
# Dokumentasjon for filen *include/latexTabell.sas*

SAS template for å lage LaTeX-tabeller av SAS-tabeller. Brukes som følger:

```sas
%include "&filbane/include/latexTabell.sas";

ods tagsets.tablesonlylatex tagset=event1
file="<FOLDER>\filename.tex"   (notop nobot) style=journal;

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

