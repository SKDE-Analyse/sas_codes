[Ta meg tilbake.](./)


# reinnleggelser

Reinnleggelser-makro - opprettet av Arnfinn 1. des. 2016 
Makro for � markere EoC som er en reinnleggelse 
Makroen Episode_of_care m� v�re kj�rt f�r reinnleggelse-makroen

reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=0, primaer = alle, forste_utdato =0, siste_utdato ='31Dec2020'd)
dsn:             datasett man utf�rer analysen p�
ReInn_Tid (=30): tidskrav i dager mellom prim�ropphold og et eventuelt reinnleggelsesopphold
eks_diag (=0):   Hvis ulik 0, innleggelser som inneholder hoved- eller bi-diagnoser, som brukt av kunnskapssenteret, er ikke en reinnl.
primaer (=alle): Markere opphold som har primaer = 1 som prim�ropphold.
forste_utdato (=0): Kun regne prim�re innleggelser etter denne dato
siste_utdato (='31Dec2020'd): Ikke regne prim�re innleggelser etter denne dato
kun_innleggelser (= 0): Hvis denne er ulik null, teller kun de som er eoc_aktivitetskategori3 = 1 som en prim�rinnleggelse

Makroen produserer f�lgende 3 variabler
- reinnleggelse: Alle avdelingsopphold i en EoC som er en reinnleggelse (reinnleggelse = 1)
- primaerinnleggelse: Alle opphold som kan gi en reinnleggelse (primaerinnleggelse = 1)
- primaer_med_reinn: Prim�ropphold som f�rer til en reinnleggelse (primaer_med_reinn = 1)
Man kan s� i ettertid telle opp antall opphold som er en reinnleggelse.

Eksempel:
reinnleggelser(dsn=mittdatasett, ReInn_Tid = 14, primaer = kols, forste_utdato ='18Dec2012', siste_utdato ='17Dec2015'd)
Vil markere alle innleggelser som har kols = 1 som prim�rinnleggelser
(variablen kols m� v�re definert som 1 p� forh�nd). Innleggelser med utskrivelsesedato
fra og med 14 dager f�r nytt�r f�rste �r til og med 14 dager f�r nytt�r siste �r
teller som prim�rinnleggelser. Alle akutte innleggelser,
som ikke har en av de ekskluderte diagnosene, som skjer innen 14 dager
etter en prim�rinnleggelse, vil bli markert som en reinnleggelse

