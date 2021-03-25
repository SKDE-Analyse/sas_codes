
# Dokumentasjon for filen *makroer/Label_m_info.sas*


## Makro `Label_m_info`

### Beskrivelse

For å legge på f.eks n=antall obs i label for boområder i søylediagram
```
%Label_m_info(inn_data=, Label_variabel=, Info_variabel=, Info_variabel_tekst=);
```

### Parametre

1. `Inn_data`: datasett man utfører analysen på
2. `Label_variabel`: Variabelen man ønsker å legge ekstra informasjon på
3. `Info_variabel`: Variabelen som har ekstra informasjonen man ønsker å legge på
4. `Info_variabel_tekst`: Forklaringsteksten for ekstra informasjonen

### Forfatter

Opprettet 30/11-15 av Frank Olsen
