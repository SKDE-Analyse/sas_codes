
# Dokumentasjon for filen *makroer/aggreger.sas*


## Makro `aggreger`

Makro for å aggregere datasett, slik at det kan brukes i rateprogrammet.
Basert på kode som er brukt i Barnehelseatlaset og Eldrehelseatlaset.

Kjøres på følgende måte:
```
%aggreger(inndata = , utdata = , agg_var = , mappe = work);
```

### Variabler
- `inndata` er det sensitive datasettet som skal aggregeres. Må inneholde følgende variabler:

```
eoc_aar, ermann, eoc_alder, komnr, bydel, 
eoc_liggetid, eoc_inndato, eoc_utdato, eoc_id
off, priv, elektiv, ohjelp, innlegg, poli, &agg_var # disse er 1 eller 0/.
```

- `utdata` er navnet på det aggregerte datasettet
- `agg_var` er variabelen det skal aggregeres på. Må være 1 eller 0/.
- `mappe`: navn på mappen der utdatasettet skal lagres (default = work)

