[Ta meg tilbake.](./)


# reinnleggelser

Reinnleggelser-makro - opprettet av Arnfinn 1. des. 2016 
Makro for å markere EoC som er en reinnleggelse 
Makroen Episode_of_care må være kjørt før reinnleggelse-makroen

reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=0, primaer = alle, forste_utdato =0, siste_utdato ='31Dec2020'd)
dsn:             datasett man utfører analysen på
ReInn_Tid (=30): tidskrav i dager mellom primæropphold og et eventuelt reinnleggelsesopphold
eks_diag (=0):   Hvis ulik 0, innleggelser som inneholder hoved- eller bi-diagnoser, som brukt av kunnskapssenteret, er ikke en reinnl.
primaer (=alle): Markere opphold som har primaer = 1 som primæropphold.
forste_utdato (=0): Kun regne primære innleggelser etter denne dato
siste_utdato (='31Dec2020'd): Ikke regne primære innleggelser etter denne dato
kun_innleggelser (= 0): Hvis denne er ulik null, teller kun de som er eoc_aktivitetskategori3 = 1 som en primærinnleggelse

Makroen produserer følgende 3 variabler
- reinnleggelse: Alle avdelingsopphold i en EoC som er en reinnleggelse (reinnleggelse = 1)
- primaerinnleggelse: Alle opphold som kan gi en reinnleggelse (primaerinnleggelse = 1)
- primaer_med_reinn: Primæropphold som fører til en reinnleggelse (primaer_med_reinn = 1)
Man kan så i ettertid telle opp antall opphold som er en reinnleggelse.

Eksempel:
reinnleggelser(dsn=mittdatasett, ReInn_Tid = 14, primaer = kols, forste_utdato ='18Dec2012', siste_utdato ='17Dec2015'd)
Vil markere alle innleggelser som har kols = 1 som primærinnleggelser
(variablen kols må være definert som 1 på forhånd). Innleggelser med utskrivelsesedato
fra og med 14 dager før nyttår første år til og med 14 dager før nyttår siste år
teller som primærinnleggelser. Alle akutte innleggelser,
som ikke har en av de ekskluderte diagnosene, som skjer innen 14 dager
etter en primærinnleggelse, vil bli markert som en reinnleggelse


