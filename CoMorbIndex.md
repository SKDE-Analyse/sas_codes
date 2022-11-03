
# Dokumentasjon for filen *makroer/CoMorbIndex.sas*

- Opprettet 28/11-17 - Frank Olsen
- Redigert 30/11-17 - Frank olsen

```
%CoMorbIndex(dsn_index=,dsn_alle=,periode=365,alle=1);
```

### Variable:

1. `dsn_index` - datasett med indexopphold
2. `dsn_alle` - datasett med alle opphold (døgn, dag og poli) for alle aktuelle pasienter
3. `periode` - hvor mange dager bakover vi leter (standard er 365 dager)
4. `alle` - lik 1 --> leter i både hoved- og bi-diagnoser (default), ulik 1 --> let kun i hdiag

Makroen produserer tre komorbiditetsindekser:
1. `CCI` - Charlson - kan endres ved å endre vekting
2. `PRI` - Pasient Register Index - kan endres ved å endre vekting
3. `CoMorb` - egendefinert index - kan endres ved å endre vekting

Diagnosekoder er hentet fra *Quan 2005*, Vekting er hentet fra *Nilssen 2014*

## Makro `CoMorbIndex`

