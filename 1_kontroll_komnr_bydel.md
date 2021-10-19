
# Dokumentasjon for filen *tilrettelegging/npr/1_kontroll_foer_tilrette/1_kontroll_komnr_bydel.sas*


## Makro `kontroll_komnr_bydel`

### Beskrivelse

Makro for å kontrollere at mottatte data inneholder gyldige komrn og bydel
Den sier ikke noe om det er løpenr ifeks Oslo 0301 som mangler bydel

```
%kontroll_komnr_bydel(inndata= ,komnr=komnrhjem2, bydel=bydel2, aar=)
```

### Input 
      - Inndata: 
      - kommune_nr:  Kommunenummer som skal skjekkes, default er 'KomNrHjem2' - variabel utlevert fra NPR 
      - bydel     :  Bydelnummer som skal skjekkes, default er 'bydel2' - variabel utlevert fra NPR 

### Output 
      - Godkjent lister som SAS datasett
      - Error lister gir oversikt over ugyldige komnr eller bydeler i mottatt data.  De lages som SAS, og printes ut til results vinduet hvis det er noe.

### Endringslogg:
    - Opprettet før 2020
    - september 2021, Janice
          - dokumentasjon markdown
          - bydel til numerisk før kombineres med komnr
          - error lister printes ut
