
# Dokumentasjon for filen *makroer/fremskrive_boomr.sas*


## Makro `fremskrive_boomr`


#Sist oppdatert
Sist oppdatert 7 november 2025 av Hanne Sigrun Byhring


# VARIABLER SOM BRUKES I MAKROEN (MÅ FINNES I DATA) 


- alder
- ermann
- aar
- komnr
- BoRHF

#TELLE PR SYKEHUSOPPHOLD ELLER PR PASIENT?

**Dersom sykehusoppholdsmakro er kjørt** 
og du skal bruke **sho_alder** og **sho_aar** må disse navnes om til **alder** og **aar**. 

**Hvis du skal telle kun en rad pr sykehusopphold eller en rad pr pasient** 
må du først redusere datasettet slik at det kun inneholder en rad pr sykehusopphold/pasient. 
Makroen summerer/aggregerer fremskrivningsvariabelen over alle rader i datasettet.

# FORKLARING TIL INPUT 

##Variabler for inndata:
- **inndata**=navn på inndatasett
- **utdata**=navn på utdatasett
- **frem_var**=variabel i inndatasett som skal fremskrives
- **bovar**=boområdevariabel, eks. BoHF eller BoShHN

##Variabler for aldersgruppeinndeling:
- **int**=aldersintervall (eks 5 for 5-årige aldersgrupper), default er 10
- **alder_min**=laveste alder, default er null
- **alder_maks**=høyeste alder, default er 105
- **overste_agr**=laveste alder i øverste aldersgruppe (eks. 90 for å slå sammen alle over 90)

##Variabler for basisperiode for fremskrivningsperiode:
Basisperioden må angis som periode med min og max år, men du kan ekskludere ETT år i perioden (eks 2020).
- **min_aar**=første år, settes lik data_start om den ikke angis
- **max_aar**=siste år, settes lik data_slutt om den ikke angis
- **ekskludert_aar**= År som skal ekskluderes fra basisperiode - eks lik 2020 hvis 2020 skal ekskluderes
- **frem_slutt**= sluttår for fremskrivingsperiode (eks. 2030, 2040 eller 2050)
- **frem_fil**= fil med fremskrevne innbyggertall

##Input for figur:
- **where_bo**= Hvilke boområder skal det plottes for? eks: bohf in (1:4);
- **bildesti**=sti for bildelagring
- **ylabel**=Tekst på y-akse
- **bildeformat**=pdf eller png
- **bildenavn**=ekstra streng som skal inn i bildefilnavnet

##Debugge?
- **debug**=sett lik en for å unngå sletting av midlertidige datasett, default=0

