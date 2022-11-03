
# Dokumentasjon for filen *tests/unik_pasient_test.sas*

Makro for å teste unik_pasient-makro.

Kjører unik_pasient-makroen på et test-datasett (`test.unik_pasient_start`).
Sammenligner dette datasettet med en referanse (`test.ref_unik_pasient_&navn`).

### Parametre

- `branch = main`: Bestemmer hvilken unik_pasient-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.unik_pasient_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_unik_pasient_&navn` på nytt.

### Tester

Kjører alle testene med og uten `pr_aar`, siden makroen er delt i to på dette (halve makroen er kode som gjelder pr_aar, mens andre halvdel ikke gjelder pr_aar).

#### Test default

Kjører med `%Unik_pasient(inn_data=testset_&navn, pr_aar=, sorter=, Pid=PID, Merke_variabel=kontakt);`

#### Test pr_aar = aar

Kjører med `pr_aar = aar`

#### Test sorter

Sorterer også på hdiag `sorter=hdiag`.
#### Test sorter_aar

Sorterer også på hdiag `sorter=hdiag`, pr. år `pr_aar=aar`.

#### Test pid

Unik Hdiag i stedet for unik pid `Pid=hdiag`

#### Test pid pr_aar

Unik Hdiag i stedet for unik pid `Pid=hdiag`, per år `pr_aar=aar`.

