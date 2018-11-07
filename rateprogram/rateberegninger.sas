%let makrobane=&filbane\rateprogram\sas;
%include "&filbane\makroer\boomraader.sas";
%include "&filbane\makroer\forny_komnr.sas";
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
%include "&makrobane\definere_format.sas";
%include "&makrobane\aldersfigur.sas";
%include "&makrobane\print_info.sas";
%include "&makrobane\definere_komnr.sas";
%include "&makrobane\ekskluderingstabeller.sas";
%include "&makrobane\dele_tabell.sas";


/*!
Denne filen inneholder alle makroene til rateprogrammet, bortsett fra
`boomraader`-makroen.
*/

%macro omraadeNorge;
/*!
Tom makro, for å unngå feilmeldinger i eldre rateprogram-beregninger.
*/


%mend;


%macro rateberegninger;
/*!
#### Formål

Makro som beregner rater og spytter ut tabeller og figurer.

#### "Steg for steg"-beskrivelse

1. Lager datasettet `Norgeaarsspenn` fra `RV` og henter ut variablene min_aar og max_aar
2. Legger variablen alder til `norge_agg_snitt`
   - `alder=(substr(alder_ny,1,((find(alder_ny,'-','i'))-1)))-0;`
3. Lager tabell over aldersstruktur, basert på datasett `norge_agg_snitt`
4. Definere variablene Periode, Antall_aar, År1 etc. (dette gjøres også i utvalgX-makroen)
5. Kaller opp [omraade](#omraade)-makroen, som beregner ratene etc. ut fra `Bo`. `Bo` kan være

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
   
6. Kaller opp tabell-rutiner, figur-rutiner etc. basert på valg gjort i rateprogrammet (se variabelliste under)

#### Avhengig av følgende datasett

- `RV`
- `norge_agg_snitt`

#### Lager følgende datasett

- Norgeaarsspenn (kun for å finne min_aar og max_aar?)

#### Avhengig av følgende variabler

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


#### Definerer følgende variabler

Sjekk hvilke som brukes av andre makroer og hvilke som kun er interne.

- aarsvarfigur (defineres også i [utvalgX](#utvalgx))
- Periode (defineres også i [utvalgX](#utvalgx))
- Antall_aar (defineres også i [utvalgX](#utvalgx))
- År1 etc. (defineres også i [utvalgX](#utvalgx))
- Bo (brukes i tabell-rutiner og figur-rutiner som kalles opp)


#### Kalles opp av følgende makroer

Ingen

#### Bruker følgende makroer

- [omraade](#omraade) (selve rateberegningene)
- [tabell_1](#tabell_1) (hvis Vis_tabeller=1,2,3) Kjøres for Bo=Norge, Bo=BoRHF, , 
- [tabell_CV](#tabell_cv) (hvis Vis_tabeller=2)
- [tabell_3N](#tabell_3n) (hvis Vis_tabeller=3)
- [tabell_3](#tabell_3) (hvis Vis_tabeller=3)
- [lagre_dataNorge](#lagre_datanorge)
- [lag_kart](#lag_kart)
- [lag_aarsvarbilde](#lag_aarsvarbilde)
- [lag_aarsvarfigur](#lag_aarsvarfigur)
- [KI_bilde](#ki_bilde)
- [KI_figur](#ki_figur)
- [lagre_dataN](#lagre_datan)
- [omraadeHN](#omraadehn)

#### Annet

Kjøres som andre makro av rateprogrammet (etter [utvalgX](#utvalgX))

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


%definere_aar;
%definere_format;

%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 0;
%if &silent=0 %then %do;
title "Aldersstruktur for snitt i perioden (&min_aar-&max_aar), Andeler for &boomraadeN, Rater for &boomraade";
PROC TABULATE DATA=NORGE_AGG_SNITT;	
	VAR N_RV N_Innbyggere;
	CLASS alder_ny /	ORDER=data MISSING;
	TABLE alder_ny={LABEL=""} all={Label="Totalt"},
	N_RV={LABEL="&ratevariabel"}*(Sum={LABEL="&forbruksmal"}*F=&talltabformat..0 ColPctSum={LABEL="Andel (%)"}*F=&talltabformat2..1*{STYLE={JUST=CENTER}}) 
	N_Innbyggere={LABEL="Innbyggere"}*(Sum={LABEL="Antall"}*F=&talltabformat..0 ColPctSum={LABEL="Andel (%)"}*F=&talltabformat2..1*{STYLE={JUST=CENTER}})
	/ BOX={LABEL="Alderskategorier"};
RUN; 
Title;
%end;


%if %sysevalf(%superq(aarsvarfigur)=,boolean) %then %let aarsvarfigur = 1;

%let Bo=Norge; 	*%omraade; /*må lage egen for Norge*/
%if &Vis_tabeller=1 %then %do;
	%tabell_1;
%end;

%if &Vis_tabeller=2 %then %do;
	%tabell_1;
%end;

%if &Vis_tabeller=3 %then %do;
	%tabell_1; %tabell_3N;
%end; 
	
%lagre_dataNorge;

	%if &RHF=1 %then %do;
		%let Bo=BoRHF;
		%omraade; 

		%lag_tabeller;

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

		%lag_tabeller;

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

		%lag_tabeller;

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

		%lag_tabeller;

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

		%lag_tabeller;

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

		%lag_tabeller;

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

		%lag_tabeller;

		%lagre_dataN;
	%end;

	%if &oslo=1 %then %do;
		%let Bo=bydel;
		%omraade; 

		%lag_tabeller;

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

%if &ut_sett=1 %then %do;
%dele_tabell;
%end;

%mend rateberegninger;

