
/* BESKRIVELSE

Definerer opp angiografi, bypassoperasjoner og PCI 
Koden ble brukt i utvalgsprosjektet i 2022 (sykehusutalget og kvinnehelseutvalget)


Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/pci_angio_revask.sas";
run;
*/

array pci_pros {*} NC:;
     do l=1 to dim(pci_pros);

		if substr(pci_pros{l},1,3) = 'FNG' 											then pci=1;
		if substr(pci_pros{l},1,6) in ('FNP02B','FNP12B','FNQ05B','FNQ12B')/*2016*/ 	then pci=1;

		if substr(pci_pros{l},1,6) in ('FYDB11','FYDB12','FYDB13')						then angio_2015=1;
		if substr(pci_pros{l},1,6) in ('SXF0BB','SXF0CB','SXF0DB')						then angio_2016=1;
		if substr(pci_pros{l},1,6) in ('SFY0BB','SFN0CB','SFN0DB','SFY0EB')			then angio_2017=1;
		if substr(pci_pros{l},1,6) in ('FYDB14','SFX0EB')			then angio_2022=1;	/*Lagt til 29 nov 2023 HSB */

		if substr(pci_pros{l},1,3) in ('FNA','FNB','FNC','FNE')						then bypass=1;
		if substr(pci_pros{l},1,5) in ('FND10','FND20','FND98')						then bypass=1;
end;

if angio_2015 eq 1 or angio_2016 eq 1 or angio_2017 eq 1 or pci eq 1                    then angio = 1;
if angio_2015 eq 1 or angio_2016 eq 1 or angio_2017 eq 1 or angio_2022 eq 1 or pci eq 1  then angio2 = 1;
if bypass eq 1 or pci eq 1                                                              then revask = 1;

drop l;