
# Dokumentasjon for filen *makroer/reinnleggelser.sas*

### Beskrivelse

Makro for Ã¥ markere EoC som er en reinnleggelse 

**Makroen Episode_of_care mÃ¥ vÃ¦re kjÃ¸rt fÃ¸r reinnleggelse-makroen**

```
%reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=0, primaer = alle, forste_utdato =0, siste_utdato ='31Dec2020'd);
```

### Parametre

- `dsn`:             datasett man utfÃ¸rer analysen pÃ¥
- `ReInn_Tid` (=30): tidskrav i dager mellom primÃ¦ropphold og et eventuelt reinnleggelsesopphold
- `eks_diag` (=0):   Hvis ulik 0, innleggelser som inneholder hoved- eller bi-diagnoser, som brukt av kunnskapssenteret, er ikke en reinnl.
- `primaer` (=alle): Markere opphold som har primaer = 1 som primÃ¦ropphold.
- `forste_utdato` (=0): Kun regne primÃ¦re innleggelser etter denne dato
- `siste_utdato` (='31Dec2020'd): Ikke regne primÃ¦re innleggelser etter denne dato
- `kun_innleggelser` (= 1): Hvis denne er ulik null, teller kun de som er `eoc_aktivitetskategori3 = 1` som en primÃ¦rinnleggelse

Makroen produserer fÃ¸lgende 3 variabler
- `reinnleggelse`: Alle avdelingsopphold i en EoC som er en reinnleggelse (reinnleggelse = 1)
- `primaerinnleggelse`: Alle opphold som kan gi en reinnleggelse (primaerinnleggelse = 1)
- `primaer_med_reinn`: PrimÃ¦ropphold som fÃ¸rer til en reinnleggelse (primaer_med_reinn = 1)

Man kan sÃ¥ i ettertid telle opp antall opphold som er en reinnleggelse.

### Eksempel:
```
%reinnleggelser(dsn=mittdatasett, ReInn_Tid = 14, primaer = kols, forste_utdato ='18Dec2012', siste_utdato ='17Dec2015'd);
```
- Vil markere alle innleggelser som har `kols = 1` som primÃ¦rinnleggelser (variablen `kols` mÃ¥ vÃ¦re definert som 1 pÃ¥ forhÃ¥nd). 
- Innleggelser med utskrivelsesedato fra og med 14 dager fÃ¸r nyttÃ¥r fÃ¸rste Ã¥r til og med 14 dager fÃ¸r nyttÃ¥r siste Ã¥r teller som primÃ¦rinnleggelser. 
- Alle akutte innleggelser, som ikke har en av de ekskluderte diagnosene, som skjer innen 14 dager etter en primÃ¦rinnleggelse, vil bli markert som en reinnleggelse

### Forfatter

Opprettet av Arnfinn 1. des. 2016 
