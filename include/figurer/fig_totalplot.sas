

/*
Totalplot-figur
*/

Options locale=NB_no mlogic symbolgen mprint;
%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB.sas";

ODS Graphics ON / imagemap reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off width=14.0cm height=10.0cm;
ODS Listing style=Stil_figur Image_dpi=300 
GPATH="\\hn.helsenord.no\RHF\SKDE\Analyse\Helseatlas\Eldre\&katalog.\&mappe";
proc sgpanel data=datasett;
panelby bohf / spacing=2 rows=4 columns=5 novarname nowall ;
scatter x=x y=faktor2 / jitter markerattrs=(SYMBOL=circleFilled color=blue) /*tip=(utvalg)*/ /*dataskin=crisp */;
refline 1 / axis=y;
colaxis display=(noticks nolabel novalues) type=discrete;
rowaxis display=(nolabel ) values=(0.2 to 2.0 by 0.4);
run;
ods listing close;
ods graphics off; 
