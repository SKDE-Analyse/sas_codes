
# Dokumentasjon for filen *tilrettelegging/npr/1_kontroll_foer_tilrette/1_kontroll_komnr_bydel.sas*

### Beskrivelse

Makro for å kontrollere at mottatte data inneholder gyldige komnr og bydel
Den sier ikke noe om det er løpenr ifeks Oslo 0301 som mangler bydel

```
%kontroll_komnr_bydel(inndata= ,komnr=komnrhjem2, bydel=bydel2, aar=)
```

### Input 
      - Inndata: 
      - kommune_nr:  Kommunenummer som skal sjekkes, default er 'KomNrHjem2' - variabel utlevert fra NPR 
      - bydel     :  Bydelnummer som skal sjekkes, default er 'bydel2' - variabel utlevert fra NPR 

### Output 
      - Godkjent lister som SAS datasett
      - Error lister gir oversikt over ugyldige komnr eller bydeler i mottatt data.  De lages som SAS, og printes ut til results vinduet hvis det er noe.

### Endringslogg:
    - Opprettet før 2020
    - september 2021, Janice
          - dokumentasjon markdown
          - bydel til numerisk før kombineres med komnr
          - error lister printes ut
    - november 2021, Tove
          - inkluderer tidligere bydelskommuner 1201 og 4601 i steg 2 hvor bydel kontrolleres 
          - fjerne rad med missing komnr i steg 1 slik at rader med manglende komnr i kontrollert data kommer i output error-liste
