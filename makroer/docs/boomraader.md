[Ta meg tilbake.](./)

# boomraader

Boomraade-makro

- Definerer boområder ut fra komnr og bydel

**OBS: Denne makroen må kjøres inne i et datasteg** slik:
```
data ut;
set inn;
%Boomraader;
run;
```

Makroen kjører med følgende verdier, hvis ikke annet er gitt:
```
%Boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 0, boaar=2015);
```

- Hvis `haraldsplass ne 0`: del Bergen i Haraldsplass og Bergen
- Hvis `indreOslo ne 0`: Slå sammen Diakonhjemmet og Lovisenberg
- Hvis `bydel = 0`: Vi mangler bydel og må bruke gammel boomr.-struktur (bydel 030110, 030111, 030112 går ikke til Ahus men til Oslo)
- Hvis `barn ne 0`: Lager boområder som i det første barnehelseatlaset
- `boaar = ?`: Opptaksområdene kan endres over år. `boaar` velger hvilket år vi tar utgangspunkt i. Foreløpig kun Sagene, som ble flyttet fra Lovisenberg til OUS i 2015. Kjør med `boaar=2014` eller mindre hvis man vil ha Sagene til Lovisenberg.

Følgende variabler nulles ut i begynnelsen av makroen, og lages av makroen:
```
BoShHN
VertskommHN
BoHF
BoRHF
Fylke
```
