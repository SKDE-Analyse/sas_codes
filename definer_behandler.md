
# Dokumentasjon for filen *makroer/definer_behandler.sas*


## Makro `definer_behandler`


Makro for å definere behandlende sykehus i Helse Nord, der det skilles på
eget lokalsykehus og andre sykehus etter følgende inndeling:

```sas
1="Eget lokalsykehus"
2="UNN Tromsø"
3="NLSH Bodø"
4="Annet sykehus i eget HF"
5="Annet HF i HN"
6="HF i andre RHF"
7="Private sykehus"
8="Avtalespesialister"
9="UNN HF"
10="NLSH HF"
```

Hvis sykehus er kodet på HF-nivå så kodes det som eget lokalsykehus.

