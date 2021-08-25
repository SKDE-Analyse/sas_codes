
# Dokumentasjon for filen *makroer/forny_komnr.sas*


## Makro `forny_komnr`


Endringslogg:
          Sist endret 25.08.2021 av Tove Johansen. 

 Input variable: 
          Inndata
          kommune_nr (Kommunenummer som skal fornyes, default er 'KomNrHjem2' - variabel utlevert fra NPR ) 

 Output variable: 
          KomNr 
          komnr_inn (input kommunenummer beholdes i utdata for evnt kontroll)

 OBS: bydeler blir ikke oppdatert når denne makroen kjøres. 
 Hvis det er bydeler i datasettet må de fornyes etter at denne makroen er kjørt. 
 Se makro 'bydel': \\tos-sas-skde-01\SKDE_SAS\felleskoder\master\tilrettelegging\npr\2_tilrettelegging\bydel.sas
