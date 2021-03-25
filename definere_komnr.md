
# Dokumentasjon for filen *rateprogram/sas/definere_komnr.sas*


## Makro `definere_komnr`

Makro for å definere komnr og bydel, hvis dette mangler men bohf er definert.

Denne makroen kjøres hvis man legger inn `%let manglerKomnr = 1;` i rateprogramfilen,
og vil definere komnr og bydel som en av kommunene/bydelene som sogner til allerede 
definert bohf.
