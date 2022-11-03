
# Dokumentasjon for filen *makroer/telle_pr_PID.sas*

Makro som gir oversikt over antall ulike verdier av en variabel, hvilke verdier som forekommer i variabelen og hvor mange ganger hver verdi forekommer, PER PID.

## INPUT:
 
Inndata: navn pÃ¥ inndatasett
utdata: navn pÃ¥ utdatasett
variabel: navn pÃ¥ variabel
type: c for character eller n for numerisk (default er numerisk)



F.eks: Antall ulike behandlingssteder en person er registrert pÃ¥, hvilke behandlingssteder og hvor mange ganger personen er registrert pÃ¥ hvert behandlingssted.

Makroen kan hÃ¥ndtere inntil 9 ulike verdier for en variabel pr PID. NB: MISSING-VERDIER IGNORERES.

To datasett lages:
&utdata og &utdata._oversikt

---------------------------------------

&utdata bestÃ¥r av inndatasettet pluss en rekke nye variabler:

unik: angir ny unik PID. Settes lik 1 pÃ¥ fÃ¸rste rad med en ny PID
oppholdsnummer: teller antall opphold pr PID


unik_&variabel: angir ny unik verdi i &variabel. Settes lik 1 pÃ¥ fÃ¸rste rad med en ny verdi.
&variabel._teller: teller antall forekomster av hver verdi for &variabel.



&variabel._1: Inneholder den fÃ¸rste verdien som forekommer i &variabel
&variabel._2: Inneholder den andre verdien som forekommer i &variabel
....
&variabel._9: Inneholder den niende verdien som forekommer i &variabel



&variabel._1_teller: Inneholder antall ganger verdien i &variabel_1 forekommer
&variabel._2_teller: Inneholder antall ganger verdien i &variabel_2 forekommer
....
&variabel._9_teller: Inneholder antall ganger verdien i &variabel_9 forekommer

-------------------------------------

&utdata._oversikt gir en oppsummering med en rad pr PID.


## Forfatter

Hanne Sigrun


## Makro `telle_pr_PID`

