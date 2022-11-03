
# Dokumentasjon for filen *makroer/aggreger_sho.sas*

Makro for å aggregere datasett, slik at det kan brukes i rateprogrammet.
Basert på kode som er brukt i Barnehelseatlaset og Eldrehelseatlaset.

Kjøres på følgende måte:
```
%aggreger(inndata = , utdata = , agg_var = , mappe = work);
```

### Variabler
- `inndata` er det sensitive datasettet som skal aggregeres. Må inneholde følgende variabler:

```
sho_aar, ermann, sho_alder, komnr, bydel, 
sho_liggetid, sho_inndato, sho_utdato, sho_id
off, priv, elektiv, ohjelp, innlegg, poli, &agg_var # disse er 1 eller 0/.
```

- `utdata` er navnet på det aggregerte datasettet
- `agg_var` er variabelen det skal aggregeres på. Må være 1 eller 0/.
- `mappe`: navn på mappen der utdatasettet skal lagres (default = work)


## Makro `unik_pasient`


## Makro `unik_pasient_alle_aar`

