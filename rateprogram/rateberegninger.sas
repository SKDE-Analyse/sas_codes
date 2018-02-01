%let makrobane=\\tos-sas-skde-01\SKDE_SAS\rateprogram\master\sas;
%include "\\tos-sas-skde-01\SKDE_SAS\Makroer\master\Boomraader.sas";
%include "&makrobane\lag_kart.sas";
%include "&makrobane\omraade.sas";
%include "&makrobane\omraadeHN.sas";
%include "&makrobane\utvalgx.sas";
%include "&makrobane\lag_aarsvarbilde.sas";
%include "&makrobane\lag_aarsvarfigur.sas";
%include "&makrobane\aldersgrupper.sas";
%include "&makrobane\valg_kategorier.sas";
%include "&makrobane\tabeller.sas";
%include "&makrobane\KI.sas";
%include "&makrobane\lagre_data.sas";
%include "&makrobane\aarsvar.sas";
%include "&makrobane\definere_aar.sas";


/*!
Denne filen inneholder alle makroene til rateprogrammet, bortsett fra
`boomraader`-makroen.
*/

/* Ny versjon Rateprogram
Frank Olsen 19/10-15
*/

%macro omraadeNorge;

%mend;


%macro rateberegninger;
/*!
#### Form�l

Makro som beregner rater og spytter ut tabeller og figurer.

#### "Steg for steg"-beskrivelse

1. Lager datasettet `Norgeaarsspenn` fra `RV` og henter ut variablene min_aar og max_aar
2. Legger variablen alder til `norge_agg_snitt`
   - `alder=(substr(alder_ny,1,((find(alder_ny,'-','i'))-1)))-0;`
3. Lager tabell over aldersstruktur, basert p� datasett `norge_agg_snitt`
4. Definere variablene Periode, Antall_aar, �r1 etc. (dette gj�res ogs� i utvalgX-makroen)
5. Kaller opp [omraade](#omraade)-makroen, som beregner ratene etc. ut fra `Bo`. `Bo` kan v�re

|`Bo`        |variabel = 1        |makro       |
| ---------- | -----------        | ---------- |
| Norge      |                    | [omraade](#omraade)    |
| BoRHF      | &RHF=1             | [omraade](#omraade)    |
| BoHF       | &HF=1              | [omraade](#omraade)    | 
| BoShHN     | &sykehus_HN=1      | [omraadeHN](#omraadehn)|
| komnr      | &kommune=1         | [omraade](#omraade)    | 
| komnr      | &kommune_HN=1      | [omraadeHN](#omraadehn)|
| fylke      | &fylke=1           | [omraade](#omraade)    |
| VK         | &Verstkommune_HN=1 | [omraadeHN](#omraadehn)|
| bydel      | &oslo=1            | [omraade](#omraade)    |
   
6. Kaller opp tabell-rutiner, figur-rutiner etc. basert p� valg gjort i rateprogrammet (se variabelliste under)

#### Avhengig av f�lgende datasett

- `RV`
- `norge_agg_snitt`

#### Lager f�lgende datasett

- Norgeaarsspenn (kun for � finne min_aar og max_aar?)

#### Avhengig av f�lgende variabler

- tallformat
- ratevariabel
- forbruksmal
- boomraadeN
- boomraade
- Vis_tabeller
- RHF
- kart
- aarsvarfigur
- Fig_AA_RHF
- KIfigur
- Fig_KI_RHF
- HF
- Fig_AA_HF
- Fig_KI_HF
- sykehus_HN
- Fig_AA_ShHN
- Fig_KI_ShHN
- kommune
- Fig_AA_kom
- Fig_KI_kom
- kommune_HN
- Fig_AA_komHN
- Fig_KI_komHN
- fylke
- Fig_AA_fylke
- Fig_KI_fylke
- Verstkommune_HN
- oslo
- Fig_AA_Oslo
- Fig_KI_Oslo


#### Definerer f�lgende variabler

Sjekk hvilke som brukes av andre makroer og hvilke som kun er interne.

- aarsvarfigur (defineres ogs� i [utvalgX](#utvalgx))
- Periode (defineres ogs� i [utvalgX](#utvalgx))
- Antall_aar (defineres ogs� i [utvalgX](#utvalgx))
- �r1 etc. (defineres ogs� i [utvalgX](#utvalgx))
- Bo (brukes i tabell-rutiner og figur-rutiner som kalles opp)


#### Kalles opp av f�lgende makroer

Ingen

#### Bruker f�lgende makroer

- [omraade](#omraade) (selve rateberegningene)
- [tabell_1](#tabell_1) (hvis Vis_tabeller=1,2,3 og tallformat=NLnum) Kj�res for Bo=Norge, Bo=BoRHF, , 
- [tabell_1e](#tabell_1e) (hvis Vis_tabeller=1,2,3 og tallformat=Excel)
- [tabell_3N](#tabell_3n) (hvis Vis_tabeller=3 og tallformat=NLnum)
- [tabell_3Ne](#tabell_3ne) (hvis Vis_tabeller=3 og tallformat=Excel)
- [lagre_dataNorge](#lagre_datanorge)
- [tabell_CV](#tabell_cv)
- [tabell_CVe](#tabell_cve)
- [tabell_3](#tabell_3)
- [tabell_3e](#tabell_3e)
- [lag_kart](#lag_kart)
- [lag_aarsvarbilde](#lag_aarsvarbilde)
- [lag_aarsvarfigur](#lag_aarsvarfigur)
- [KI_bilde](#ki_bilde)
- [KI_figur](#ki_figur)
- [lagre_dataN](#lagre_datan)
- [omraadeHN](#omraadehn)

#### Annet

Kj�res som tredje makro av rateprogrammet (etter [utvalgX](#utvalgX) og [omraadeNorge](#omraadeNorge))

*/

proc sql;
create table Norgeaarsspenn as
select distinct max(aar) as maxaar, min(aar) as minaar
from RV
where aar ne 9999;
quit;

Data _null_;
set Norgeaarsspenn;
call symput('Min_aar', trim(left(put(minaar,8.))));
call symput('Max_aar', trim(left(put(maxaar,8.))));
run;

%let Bo=Norge; 	
%omraade;

data norge_agg_snitt;
set Norge_agg_snitt;
alder=(substr(alder_ny,1,((find(alder_ny,'-','i'))-1)))-0;
run;

proc sort data=NORGE_AGG_SNITT;
by alder;
run;

%if &tallformat=NLnum %then %do;
title "Aldersstruktur for snitt i perioden (&min_aar-&max_aar), Andeler for &boomraadeN, Rater for &boomraade";
PROC TABULATE DATA=NORGE_AGG_SNITT;	
	VAR N_RV N_Innbyggere;
	CLASS alder_ny /	ORDER=data MISSING;
	TABLE alder_ny={LABEL=""} all={Label="Totalt"},
	N_RV={LABEL="&ratevariabel"}*(Sum={LABEL="&forbruksmal"}*F=NLNUM12.0 ColPctSum={LABEL="Andel (%)"}*F=NLNUM8.1*{STYLE={JUST=CENTER}}) 
	N_Innbyggere={LABEL="Innbyggere"}*(Sum={LABEL="Antall"}*F=NLNUM12.0 ColPctSum={LABEL="Andel (%)"}*F=NLNUM8.1*{STYLE={JUST=CENTER}})
	/ BOX={LABEL="Alderskategorier"};
RUN; Title;
%end;

%if &tallformat=Excel %then %do;
title "Aldersstruktur for snitt i perioden (&min_aar-&max_aar), Andeler for &boomraadeN, Rater for &boomraade";
PROC TABULATE DATA=NORGE_AGG_SNITT;	
	VAR N_RV N_Innbyggere;
	CLASS alder_ny /	ORDER=data MISSING;
	TABLE alder_ny={LABEL=""} all={Label="Totalt"},
	N_RV={LABEL="&ratevariabel"}*(Sum={LABEL="&forbruksmal"}*F=12.0 ColPctSum={LABEL="Andel (%)"}*F=8.1*{STYLE={JUST=CENTER}}) 
	N_Innbyggere={LABEL="Innbyggere"}*(Sum={LABEL="Antall"}*F=12.0 ColPctSum={LABEL="Andel (%)"}*F=8.1*{STYLE={JUST=CENTER}})
	/ BOX={LABEL="Alderskategorier"};
RUN; Title;
%end;

%definere_aar;

%if %sysevalf(%superq(aarsvarfigur)=,boolean) %then %let aarsvarfigur = 1;

%let Bo=Norge; 	*%omraade; /*m� lage egen for Norge*/
	%if &Vis_tabeller=1 %then %do;
		%if &tallformat=NLnum %then %do;
			%tabell_1;
		%end;
		%if &tallformat=Excel %then %do;
			%tabell_1e;
		%end;
	%end;

	%if &Vis_tabeller=2 %then %do;
		%if &tallformat=NLnum %then %do;
			%tabell_1;
		%end;
		%if &tallformat=Excel %then %do;
			%tabell_1e;
		%end;
	%end;

	%if &Vis_tabeller=3 %then %do;
		%if &tallformat=NLnum %then %do;
			%tabell_1; %tabell_3N;
		%end;
		%if &tallformat=Excel %then %do;
			%tabell_1e; %tabell_3Ne;
		%end;
	%end; %lagre_dataNorge;

	%if &RHF=1 %then %do;
		%let Bo=BoRHF;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_RHF=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_RHF ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_RHF=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_RHF ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &HF=1 %then %do;
		%let Bo=BoHF;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_HF=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_HF ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_HF=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_HF ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &sykehus_HN=1 %then %do;
		%let Bo=BoShHN;
		%omraadeHN; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_ShHN=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_ShHN ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_ShHN=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_ShHN ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &kommune=1 %then %do;
		%let Bo=komnr;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_kom=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_kom ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_kom=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_kom ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &kommune_HN=1 %then %do;
		%let Bo=komnr;
		%omraadeHN; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end; 
		%if &aarsvarfigur=1 and &Fig_AA_komHN=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_komHN ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_komHN=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_komHN ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &fylke=1 %then %do;
		%let Bo=fylke;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_fylke=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_fylke ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_fylke=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_fylke ne 1 %then %do;
			%KI_figur;
		%end; 
		%lagre_dataN;
	%end;

	%if &Verstkommune_HN=1 %then %do;
		%let Bo=VK;
		%omraadeHN; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end; 
		%lagre_dataN;
	%end;

		%if &oslo=1 %then %do;
		%let Bo=bydel;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_Oslo=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_Oslo ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_Oslo=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_Oslo ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

%mend rateberegninger;

