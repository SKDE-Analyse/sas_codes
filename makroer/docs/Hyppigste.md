[Ta meg tilbake.](./)


# Hyppigste

%macro hyppigste_hjelp;
options nomlogic nomprint;
%put ================================================================================;
%put Hyppigste Makro - Opprettet 30/11-15 av Frank Olsen;
%put Endret 4/1-16 av Frank Olsen;
%put hyppigste(Ant_i_liste=, VarName=, data_inn=, Tillegg_tittel=, Where=);
%put Parametre:;
%put 1. Ant_i_liste: De X hyppigste - sett inn tall for X;
%put 2. VarName: Variabelen man analyserer;
%put 3. data_inn: datasett man utf�rer analysen p�;
%put 4. Tillegg_tittel: Dersom man �nsker tilleggsinfo i tittel;
%put 	- settes i hermetegn dersom mellomrom eller komma brukes;
%put 5.Where - dersom man trenger et where-statement:;
%put    - M� skrives slik: Where=Where Borhf=1;
%put ==================================================================================;
%mend hyppigste_hjelp;
