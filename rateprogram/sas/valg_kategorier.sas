

%macro valg_kategorier;

/*!
## **valg_kategorier**

#### Formål
{: .no_toc}

Dele alder inn i kategorier, basert på verdi av `Alderskategorier`

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. Kjører en av alderinndeling-makroene, basert på verdien av Alderskategorier
   - Der defineres `Startgr1`, `SluttGr1` etc.
2. Definerer `alder_ny` til 1, 2 etc. ut fra `Startgr1`, `SluttGr1` etc.

#### Avhengig av følgende datasett
{: .no_toc}

- utvalgx

#### Lager følgende datasett
{: .no_toc}

Ingen (legger til variablen `alder_ny` til datasettet utvalgx)


#### Avhengig av følgende variabler
{: .no_toc}

- `Alderskategorier`

#### Definerer følgende variabler
{: .no_toc}

Ingen

#### Kalles opp av følgende makroer
{: .no_toc}

- [utvalgX](#utvalgx)

#### Bruker følgende makroer
{: .no_toc}

- [Todeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- [Tredeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- [Firedeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- [Femdeltalder](#todeltalder-tredeltalder-firedeltalder-femdeltalder)
- `Alderkat` (hvis Alderskategorier = 99; makroen defineres i selve rateprogrammet)

#### Annet
{: .no_toc}

*/

%if &Alderskategorier=20 %then %do;
	%Todeltalder;
	data utvalgx;
	set utvalgx;
		if Alder le &SluttGr1 then alder_ny=1; 
		else alder_ny=2;
	run;
%end;
%else %if &Alderskategorier=30 %then %do;
	%Tredeltalder;
	data utvalgx;
	set utvalgx;
		if Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
		else if alder ge &StartGr3 then alder_ny=3;
	run;
%end;
%else %if &Alderskategorier=21 %then %do;
	%Todeltalder;
	data utvalgx;
	set utvalgx;
		if alder ge &startgr1 and Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
	run;
%end;
%else %if &Alderskategorier=31 %then %do;
	%Tredeltalder;
	data utvalgx;
	set utvalgx;
		if alder ge &startgr1 and Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
		else if alder ge &StartGr3 and alder le &SluttGr3 then alder_ny=3;
	run;
%end;

%if &Alderskategorier=40 %then %do;
	%Firedeltalder;
	data utvalgx;
	set utvalgx;
		if Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
		else if alder ge &StartGr3 and alder le &SluttGr3 then alder_ny=3;
		else if alder ge &StartGr4 then alder_ny=4;
	run;
%end;
%else %if &Alderskategorier=50 %then %do;
	%Femdeltalder;
	data utvalgx;
	set utvalgx;
		if alder le &Kvantil1slutt then alder_ny=1; 
		else if alder ge &Kvantil2start and alder le &Kvantil2slutt then alder_ny=2;
		else if alder ge &Kvantil3start and alder le &Kvantil3slutt then alder_ny=3;
		else if alder ge &Kvantil4start and alder le &Kvantil4slutt then alder_ny=4;
		else if alder ge &Kvantil5start then alder_ny=5;
	run;
%end;
%else %if &Alderskategorier=41 %then %do;
	%Firedeltalder;
	data utvalgx;
	set utvalgx;
		if alder ge &startgr1 and Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
		else if alder ge &StartGr3 and alder le &SluttGr3 then alder_ny=3;
		else if alder ge &StartGr4  and alder le &SluttGr4 then alder_ny=4;
	run;
%end;
%else %if &Alderskategorier=51 %then %do;
	%Femdeltalder;
	data utvalgx;
	set utvalgx;
		if alder ge &Kvantil1start and Alder le &Kvantil1slutt then alder_ny=1; 
		else if alder ge &Kvantil2start and alder le &Kvantil2slutt then alder_ny=2;
		else if alder ge &Kvantil3start and alder le &Kvantil3slutt then alder_ny=3;
		else if alder ge &Kvantil4start and alder le &Kvantil4slutt then alder_ny=4;
		else if alder ge &Kvantil5start and alder le &Kvantil5slutt then alder_ny=5;
	run;
%end;
%else %if &Alderskategorier=99 %then %do;
	data utvalgx;
	set utvalgx;
		%Alderkat;
	run;
%end;
%mend  valg_kategorier;
