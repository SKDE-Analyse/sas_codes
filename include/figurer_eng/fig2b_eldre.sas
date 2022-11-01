/* 
Splittet søyle-figur - befolkningssammensetningen
*/

%let soylebredde = 0.8;

options locale=NB_no;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\Helseatlas\Eldre\&katalog.\&mappe";

Proc sgplot data=innb sganno=Anno Pad=(Bootiom=4%)noautolegend noborder;
styleattrs datacontrastcolors=(CX00509E) datacolors=(CX95BDE6 CX00509E);
hbarparm category=BoHF Response=Snittinnb /  grouporder=ascending group=ermann groupdisplay=Stacked name="Innb" barwidth=&soylebredde;
scatter x=plassering y=bohf /datalabel=Andel datalabelpos=center datalabelattrs=(color=white WEIGHT=BOLD size=7) markerattrs=(size=0) ; 
Keylegend "Innb" /location=inside position=bottomright down=2 noborder titleattrs=(Size=7);
yaxistable  Snittinnbtot Snittalder/ label location=inside labelpos=top position=right 
valueattrs=(Size=7 family=arial) labelattrs=(Size=7 family=arial);
yaxis display=(noticks noline) type=discrete discreteorder=data label="Hospital referral area" labelattrs=(size=&fontst) valueattrs=(size=&fontst) ;
xaxis label = " Number of inhabitants ((*ESC*){unicode'2265'x}75 years old)" values=(0 to 35000 by 5000) min=0 offsetmin=0 labelattrs=(size=&fontst) valueattrs=(size=&fontst);
format Snittinnbtot Snittinnb NLNUM8.0 andel percent8.0 ermann ermann. snittalder Nlnum8.1;
run;

ods graphics off;