
# Dokumentasjon for filen *makroer/flerniva_fixed_2niva.sas*


## Makro `flerniva_fixed_2niva;
`


HGLM - Hierarchical generalized linear models

Referanse se: https://support.sas.com/resources/papers/proceedings15/3430-2015.pdf

Outcome: Behandling (0,1) Binary/Dikotom
Individ-nivÃ¥:
- Alder - numerisk, centering ifht snittalder totalt i utvalget
- KjÃ¸nn (0,1)

Kommune-nivÃ¥:
- Utdanning - kategorisk, ordinal (Lav, Middels, HÃ¸y)
- Kommune_alder - gjennomsnittsalder i kommunen, centering av snittalder i hver kommune ifht snittalder totalt i utvalget

SpÃ¸rsmÃ¥l som Ã¸nskes besvart (med resultater fra eksemplet - datasett:frank.hglm):
1. Hva er andelen Behandling i en typisk kommune?
PP (predicted probability) for Behandling er 0.0600, se tab.1
PP=[e^n/(1+e^n)], hvor n=-2.75, (estimate intercept), e^n=0.0354 (henter n fra tabellen: Estimater for modellen)
2. Varierer andelen med Behandling mellom kommunene?
2,4% av variasjonen i Behandling skyldes kommunene, se tab.1 (ICC)
3. Hva er beste modell og hva er PP da?
Modell 3 er beste modell (se tab.2) og PP=0.0341
PP=[e^n/(1+e^n)], hvor n=-3.3442, (estimate intercept), e^n=0.0353 (se tab.3)
PP nÃ¥r alder er lik snittalder, kjÃ¸nn lik snitt-kjÃ¸nn, kommune med snittalder lik kommune-snitt-alder og kommunalt utdanningsnivÃ¥ lik snitt
4. Hva er sammenhengen mellom pasientens alder og likelihood for Behandling nÃ¥r 
man kontrollerer for pasient- og kommunekarakteristika?
Jo, hÃ¸yere alder jo lavere odds for Behandling (OR=0.951) (se tab.5)
5. Hva er sammenhengen mellom utdanningsnivÃ¥ pÃ¥ kommunenivÃ¥ og likelihood for Behandling 
nÃ¥r man kontrollerer for pasient- og kommunekarakteristika?
Og, hva er PP (predikted probability) for de ulike utdanningsnivÃ¥ene (gitt alt annet lik snitt)
Jo, hÃ¸yere utdanningsnivÃ¥ jo hÃ¸yere odds for Behandling (OR=1.077) (se tab.5).
P(kommune med lav utd)=0.034 , P=[e^n/(1+e^n)], hvor n=-3.34 (estimate intercept), e^n=0.0354 (se tab.3)
P(kommune med middels utd)=0.037 , P=[e^n/(1+e^n)], hvor n=-3.27 (estimate intercept+estimate kom_utd), e^n=0.0380
P(kommune med hÃ¸y utd)=0.039 , P=[e^n/(1+e^n)], hvor n=-3.2 (estimate intercept+2*estimate kom_utd), e^n=0.0407


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


