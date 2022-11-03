
# Dokumentasjon for filen *makroer/aggreger_sho.sas*

Makro for Ã¥ aggregere datasett, slik at det kan brukes i rateprogrammet.
Basert pÃ¥ kode som er brukt i Barnehelseatlaset og Eldrehelseatlaset.

KjÃ¸res pÃ¥ fÃ¸lgende mÃ¥te:
```
%aggreger(inndata = , utdata = , agg_var = , mappe = work);
```

### Variabler
- `inndata` er det sensitive datasettet som skal aggregeres. MÃ¥ inneholde fÃ¸lgende variabler:

```
sho_aar, ermann, sho_alder, komnr, bydel, 
sho_liggetid, sho_inndato, sho_utdato, sho_id
off, priv, elektiv, ohjelp, innlegg, poli, &agg_var # disse er 1 eller 0/.
```

- `utdata` er navnet pÃ¥ det aggregerte datasettet
- `agg_var` er variabelen det skal aggregeres pÃ¥. MÃ¥ vÃ¦re 1 eller 0/.
- `mappe`: navn pÃ¥ mappen der utdatasettet skal lagres (default = work)


## Makro `unik_pasient`


## Makro `unik_pasient_alle_aar`

