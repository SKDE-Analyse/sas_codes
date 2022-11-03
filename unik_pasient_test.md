
# Dokumentasjon for filen *tests/unik_pasient_test.sas*

Makro for Ã¥ teste unik_pasient-makro.

KjÃ¸rer unik_pasient-makroen pÃ¥ et test-datasett (`test.unik_pasient_start`).
Sammenligner dette datasettet med en referanse (`test.ref_unik_pasient_&navn`).

### Parametre

- `branch = main`: Bestemmer hvilken unik_pasient-makro som kjÃ¸res (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.unik_pasient_start` pÃ¥ nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_unik_pasient_&navn` pÃ¥ nytt.

### Tester

KjÃ¸rer alle testene med og uten `pr_aar`, siden makroen er delt i to pÃ¥ dette (halve makroen er kode som gjelder pr_aar, mens andre halvdel ikke gjelder pr_aar).

#### Test default

KjÃ¸rer med `%Unik_pasient(inn_data=testset_&navn, pr_aar=, sorter=, Pid=PID, Merke_variabel=kontakt);`

#### Test pr_aar = aar

KjÃ¸rer med `pr_aar = aar`

#### Test sorter

Sorterer ogsÃ¥ pÃ¥ hdiag `sorter=hdiag`.
#### Test sorter_aar

Sorterer ogsÃ¥ pÃ¥ hdiag `sorter=hdiag`, pr. Ã¥r `pr_aar=aar`.

#### Test pid

Unik Hdiag i stedet for unik pid `Pid=hdiag`

#### Test pid pr_aar

Unik Hdiag i stedet for unik pid `Pid=hdiag`, per Ã¥r `pr_aar=aar`.

