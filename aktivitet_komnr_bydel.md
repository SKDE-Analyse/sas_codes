
# Dokumentasjon for filen *tilrettelegging/npr/1_kontroll_foer_tilrette/aktivitet_komnr_bydel.sas*

### Beskrivelse

Makro for å kontrollere at mottatte data inneholder data for alle kommuner og bydeler.
Kan også brukes for data uten bydeler.

```
%aktivitet_komnr_bydel(inndata= ,komnr_navn=, bydel_navn=);
```

### Input 
      - Inndata: 
      - komnr_navn:  Navn på kommunenummer-variabel
      - bydel_navn:  Navn på bydels-variabel, la være blank hvis ingen bydel i aktuelt datasett 
	  - bydel: 		 Angi om det er bydel i data som kontrolleres, default: bydel =1
	  - forny_komnr: Angi om makro forny_komnr skal kjøres, aktuelt for data levert med eldre kommunenummer, default: forny_komnr = 1

### Output 
      - Melding i resultatvindu i SAS EG angir om det er data for alle kommuner og bydeler, hvis ikke printes en liste med hvilke som mangler data.

### Endringslogg:
    - Tove: Opprettet desember 2022
	- Tove: tilpasset til bruk i makro for kontroll av mottatte data
