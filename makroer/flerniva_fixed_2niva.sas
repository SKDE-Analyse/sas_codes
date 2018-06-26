
%macro flerniva_fixed_2niva;

/*!

HGLM - Hierarchical generalized linear models

Referanse se: https://support.sas.com/resources/papers/proceedings15/3430-2015.pdf

Outcome: Behandling (0,1) Binary/Dikotom
Individ-nivå:
- Alder - numerisk, centering ifht snittalder totalt i utvalget
- Kjønn (0,1)

Kommune-nivå:
- Utdanning - kategorisk, ordinal (Lav, Middels, Høy)
- Kommune_alder - gjennomsnittsalder i kommunen, centering av snittalder i hver kommune ifht snittalder totalt i utvalget

Spørsmål som ønskes besvart (med resultater fra eksemplet - datasett:frank.hglm):
1. Hva er andelen Behandling i en typisk kommune?
PP (predicted probability) for Behandling er 0.0600, se tab.1
PP=[e^n/(1+e^n)], hvor n=-2.75, (estimate intercept), e^n=0.0354 (henter n fra tabellen: Estimater for modellen)
2. Varierer andelen med Behandling mellom kommunene?
2,4% av variasjonen i Behandling skyldes kommunene, se tab.1 (ICC)
3. Hva er beste modell og hva er PP da?
Modell 3 er beste modell (se tab.2) og PP=0.0341
PP=[e^n/(1+e^n)], hvor n=-3.3442, (estimate intercept), e^n=0.0353 (se tab.3)
PP når alder er lik snittalder, kjønn lik snitt-kjønn, kommune med snittalder lik kommune-snitt-alder og kommunalt utdanningsnivå lik snitt
4. Hva er sammenhengen mellom pasientens alder og likelihood for Behandling når 
man kontrollerer for pasient- og kommunekarakteristika?
Jo, høyere alder jo lavere odds for Behandling (OR=0.951) (se tab.5)
5. Hva er sammenhengen mellom utdanningsnivå på kommunenivå og likelihood for Behandling 
når man kontrollerer for pasient- og kommunekarakteristika?
Og, hva er PP (predikted probability) for de ulike utdanningsnivåene (gitt alt annet lik snitt)
Jo, høyere utdanningsnivå jo høyere odds for Behandling (OR=1.077) (se tab.5).
P(kommune med lav utd)=0.034 , P=[e^n/(1+e^n)], hvor n=-3.34 (estimate intercept), e^n=0.0354 (se tab.3)
P(kommune med middels utd)=0.037 , P=[e^n/(1+e^n)], hvor n=-3.27 (estimate intercept+estimate kom_utd), e^n=0.0380
P(kommune med høy utd)=0.039 , P=[e^n/(1+e^n)], hvor n=-3.2 (estimate intercept+2*estimate kom_utd), e^n=0.0407


## Eksempel
```
%let inndatasett=hglm;
%let utkomme=Behandling;
%let niva2=komnr;
%let niva2_txt=kommune;
%let mod1param=0;
%let mod2param=2;
%let mod3param=3;
%let mod2var=ermann alder_p;
%let mod3var=ermann alder_p alder_k kom_utd;

%flerniva_fixed_2niva;
```


*/

/* Modell 1:  Tom modell uten prediktorer */
ods trace on;
ods output ParameterEstimates=mod1PE CovParms=mod1CV FitStatistics=mod1FT;
proc glimmix data=&inndatasett method=laplace noclprint;
class &niva2;
model &utkomme (event=last)= / cl dist=binary link=logit solution;
random intercept / subject=&niva2 type=vc;
covtest / wald;
run;
ods trace off;

/*resultat fra 
Fixed Effects (ParameterEstimates) - Estimate = -2.7515 brukes for å bergene p_suksess*
CovParms brukes til å bergene ICC - andel av vraisjon som  skyldes nivå 2
FitStatistics gir -2LL - beholder kun denne og sletter AIC osv*/

data mod1PE;
set mod1PE;
P_s=exp(estimate)/(1+exp(estimate));
P_f=1-P_s;
CALL Symput ('mod1p',put(p_s,PVALUE6.4));
run;

data mod1CV;
set mod1CV;
ICC=estimate/(estimate+3.29);
rename estimate=estimateCV stderr=StdErrCV;
CALL Symputx ('mod1ICC',Put(ICC,PERCENT6.1));
run;

data mod1FT;
set mod1FT;
where descr='-2 Log Likelihood';
run;

data model1;
merge mod1:;
model=1;
run;

/* Modell 2:  modell med prediktorer på nivå 1 */
ods trace on;
ods output ParameterEstimates=mod2PE CovParms=mod2CV FitStatistics=mod2FT OddsRatios=mod2OR;
proc glimmix data=&inndatasett method=laplace noclprint;
class &niva2;
model &utkomme (event=last)= &mod2var / cl dist=binary link=logit 
solution oddsratio (diff=first label);
random intercept / subject=&niva2 type=vc;
covtest / wald;
run;
ods trace off;

data mod2PE;
set mod2PE;
P_s=exp(estimate)/(1+exp(estimate));
P_f=1-P_s;
run;

data mod2CV;
set mod2CV;
ICC=estimate/(estimate+3.29);
rename estimate=estimateCV stderr=StdErrCV;
run;

data mod2FT;
set mod2FT;
where descr='-2 Log Likelihood';
run;

data mod2OR;
set mod2OR;
keep Label Estimate Lower Upper;
rename Estimate=EstimateOR;
run;

data model2;
merge mod2PE mod2CV mod2FT;
model=2;
run;

data mod2OR;
set mod2OR;
Keep Label Estimate Lower Upper EstimateOR LowerOR UpperOR EffectOR;
rename Estimate=EstimateOR Label=LabelOR Lower=LowerOR Upper=UpperOR;
EffectOR=scan(label, 4, ' ');
run;

proc sql;
create table model2 as
select *
from model2 as a left join mod2OR as b
on a.effect = b.EffectOR;
quit; 

/* Modell 3:  modell med prediktorer på nivå 1 og nivå 2*/
ods trace on;
ods output ParameterEstimates=mod3PE CovParms=mod3CV FitStatistics=mod3FT OddsRatios=mod3OR;
proc glimmix data=&inndatasett method=laplace noclprint;
class &niva2;
model &utkomme (event=last)= &mod3var / cl dist=binary link=logit 
solution oddsratio (diff=first label);
random intercept / subject=&niva2 type=vc;
covtest / wald;
run;
ods trace off;

data mod3PE;
set mod3PE;
P_s=exp(estimate)/(1+exp(estimate));
P_f=1-P_s;
run;

data mod3CV;
set mod3CV;
ICC=estimate/(estimate+3.29);
rename estimate=estimateCV stderr=StdErrCV;
run;

data mod3FT;
set mod3FT;
where descr='-2 Log Likelihood';
run;

data model3;
merge mod3PE mod3CV mod3FT;
model=3;
run;

data mod3OR;
set mod3OR;
Keep Label Estimate Lower Upper EstimateOR LowerOR UpperOR EffectOR;
rename Estimate=EstimateOR Label=LabelOR Lower=LowerOR Upper=UpperOR;
EffectOR=scan(label, 4, ' ');
run;

proc sql;
create table model3 as
select *
from model3 as a left join mod3OR as b
on a.effect = b.EffectOR;
quit; 

proc format;
value model_fmt
1='Model 1'
2='Model 2'
3='Model 3';
run;

data tot_modell;
set model1 model2 model3;
format model model_fmt.;
if Effect = 'Intercept' then do;
	if model=1 then do;
		mod12LL=Value; mod1param=&mod1param; /*antall parametre i modellen*/
	end;
	if model=2 then do;
		mod22LL=Value; mod2param=&mod2param; /*antall parametre i modellen*/
	end;
	if model=3 then do;
		mod32LL=Value; mod3param=&mod3param; /*antall parametre i modellen*/
	end;
end;
rename Value=L2L;
run;

proc datasets nolist;
delete mod:;
run;

PROC SQL;
   CREATE TABLE TOT_MODELL AS 
   SELECT *, MAX(mod12LL) AS Mod1_2LL, MAX(mod1param) AS Mod1_param,
			MAX(mod22LL) AS Mod2_2LL, MAX(mod2param) AS Mod2_param,
			MAX(mod32LL) AS Mod3_2LL, MAX(mod3param) AS Mod3_param          
      FROM TOT_MODELL;
QUIT;

data tot_modell;
set tot_modell;
if model = 2 and Effect = 'Intercept' then do;
	X2diff_1_2=Mod1_2LL-Mod2_2LL;
end;
if model = 3 and Effect = 'Intercept' then do;
	X2diff_2_3=Mod2_2LL-Mod3_2LL;
end;
DF_1_2=Mod2_param-Mod1_param;
DF_3_2=Mod3_param-Mod2_param;
drop mod1: mod2: mod3:;
if model = 2 and Effect = 'Intercept' then do;
	P_X2_1_2=1-probchi(X2diff_1_2,DF_1_2); /*p-verdi chi-square-test*/
end;
if model = 3 and Effect = 'Intercept' then do;
	P_X2_2_3=1-probchi(X2diff_2_3,DF_3_2);
end;
run;

PROC SQL;
   CREATE TABLE TOT_MODELL AS 
   SELECT *, MAX(P_X2_1_2) AS Mod2P, MAX(P_X2_2_3) AS Mod3P        
      FROM TOT_MODELL;
QUIT;

data tot_modell;
set tot_modell;
if mod2p<0.05 then do;
	if mod3p<0.05 then best_model=3;
	else best_model=2;
end;
else best_model=1;
drop mod2p mod3p;
CALL Symputx ('best_model',best_model);
run;

Title "Tab.1. Sannsynlighet for &utkomme for typisk &niva2_txt (p=&mod1p.), andel av variasjon som skyldes &niva2_txt.ne (&mod1ICC.)";
PROC TABULATE DATA=tot_modell;
where Effect = 'Intercept';
	VAR P_s P_f ICC L2L;
	CLASS model /	ORDER=UNFORMATTED MISSING;
	TABLE P_s={LABEL="P (&utkomme=1)"}*F=PVALUE6.4 P_f={LABEL="P (&utkomme=0)"}*F=PVALUE6.4
	ICC*F=PERCENT6.1 L2L={LABEL="-2LL"}*f=8.2,
	model={LABEL="Predicted probabilities"}*Sum={LABEL=""};
RUN; Title;

Title "Tab.2. Beste modell: Modell &best_model";
PROC TABULATE DATA=TOT_MODELL;
	WHERE( Effect = 'Intercept');	
	VAR L2L X2diff_1_2 X2diff_2_3 P_X2_1_2 P_X2_2_3;
	CLASS model /	ORDER=UNFORMATTED MISSING;
	TABLE L2L={LABEL="-2  log likelihood"}*f=8.2
		X2diff_1_2={LABEL="Diff 1 vs 2"}*f=8.2 
		X2diff_2_3={LABEL="Diff 2 vs 3"}*f=8.2 
		P_X2_1_2={LABEL="p-value 1 vs 2"}*f=PVALUE6.4 
		P_X2_2_3={LABEL="p-value 2 vs 3"}*f=PVALUE6.4,
	model={LABEL="Model Fit"}*Sum={LABEL=""};
RUN; title;

Title "Tab.3. Estimater for modellen";
PROC TABULATE DATA=TOT_MODELL;	
	VAR Estimate StdErr Probt;
	CLASS Effect /	ORDER=DATA MISSING;
	CLASS model /	ORDER=UNFORMATTED MISSING;
	TABLE Effect={LABEL=""},
		model={LABEL="Fixed effects"}*(Estimate={LABEL="Est"}*Sum={LABEL=""}*F=8.2 StdErr={LABEL="StdErr"}*Sum={LABEL=""}*f=8.2 Probt={LABEL="p"}*Sum={LABEL=""}*F=PVALUE6.4);
RUN; Title;

Title "Tab.4. Error variance";
PROC TABULATE DATA=TOT_MODELL;
where Effect = 'Intercept';	
	VAR EstimateCV StdErrCV ProbZ;
	CLASS Effect /	ORDER=DATA MISSING;
	CLASS model /	ORDER=UNFORMATTED MISSING;
	TABLE Effect={LABEL=""},
		model={LABEL="Error Variance - Level-2 intercept"}*(EstimateCV={LABEL="Est"}*Sum={LABEL=""}*F=8.2 StdErrCV={LABEL="StdErr"}*Sum={LABEL=""}*f=8.2 ProbZ={LABEL="p"}*Sum={LABEL=""}*F=PVALUE6.4);
RUN; title;

Title "tab.5. OddsRatios for beste modell: Modell &best_model";
PROC TABULATE DATA=TOT_MODELL;
	WHERE model = &best_model and effect ne 'Intercept';	
	VAR EstimateOR LowerOR UpperOR;
	CLASS Effect /	ORDER=data MISSING;
	TABLE Effect={LABEL=""},
	EstimateOR*Sum={LABEL=""}*f=8.3 LowerOR={LABEL="Lower"}*Sum={LABEL=""}*f=8.3 UpperOR={LABEL="Upper"}*Sum={LABEL=""}*f=8.3;
RUN; title;

%mend flerniva_fixed_2niva;