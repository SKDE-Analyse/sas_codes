
# Dokumentasjon for filen *makroer/Unik_pasient.sas*

### Beskrivelse

For å finne unike pasienter, oppholdsnr og antall opphold pr pasient ut fra et *merke*
```
%Unik_pasient(inn_data=, pr_aar=, sorter=, Pid=, Merke_variabel=);
```

### Parametre

1. `Inn_data`: datasett man utfører analysen på
2. `pr_aar`: settes=aar dersom man ønsker å finne unike pasienter pr år, ellers la stå tom
3. `sorter`: Andre variable det skal sorteres på, f.eks inndato og utdato
4. `Pid`: Settes `=PID` så lenge *PID* angir pasient_id
5. `Merke_variabel`: Variabel det skal telles opp fra, må være merket med 1 for aktuelle

Det lages tre nye variable i datasettet:
1. `Unik_Pas_<Merke_variabel>` --> lik 1 for unike pasienter
2. `Nr_pr_pas_<Merke_variabel>` --> Nummererer de aktuelle oppholdene pr pasient i rekkefølge
3. `N_pr_pas_<Merke_variabel>` --> Antall opphold totalt pr pasient, settes på alle opphold

### Forfatter

Opprettet 1/12-15 av Frank Olsen
