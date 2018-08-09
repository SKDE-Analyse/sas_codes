%macro panelfig(aar1=2014, aar2=2015, aar3=2016);

data norge;
  set &tema.&teknikk._dp_tot_bohf(keep=rate20: bohf);
  where bohf=8888;
run;

%macro trans_N(yr=);
data yr&yr(keep=aar Nrate);
  set norge;
  aar=&yr;
  rename rate&yr=Nrate;
run;
%mend;
%trans_N(yr=&aar1);
%trans_N(yr=&aar2);
%trans_N(yr=&aar3);
data N;
  set yr&aar1 yr&aar2 yr&aar3;
run;


%macro trans_hf(yr=,innfil=);
data yr&yr(keep=aar RV_just_rate BoHF);
  set &innfil;
  aar=&yr;
  rename rate&yr=RV_just_rate;
run;
%mend;
%trans_hf(yr=&aar1, innfil=&tema.&teknikk._dp_tot_bohf);
%trans_hf(yr=&aar2, innfil=&tema.&teknikk._dp_tot_bohf);
%trans_hf(yr=&aar3, innfil=&tema.&teknikk._dp_tot_bohf);
data hf;
  set yr&aar1 yr&aar2 yr&aar3;
    where bohf <> 8888;

run;

proc sql;
create table Panel_&tema.&teknikk as
select *
from hf left join n
on hf.aar=n.aar;
quit; title;

ODS Graphics ON /reset=All imagename="Panel_&tema.&teknikk" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
/*title "&tema &niva";*/
proc sgpanel data=Panel_&tema.&teknikk noautolegend sganno=&anno pad=(Bottom=5%);
PANELBY bohf / columns=4 rows=6 novarname spacing=2 HEADERATTRS=(Color=black Family=Arial Size=7);
series x=aar y=nrate /lineattrs=(color=darkgrey pattern=2) name="norge" legendlabel="Norge";
scatter X = aar Y = RV_just_rate / filledoutlinedmarkers markerfillattrs=(color=black) markeroutlineattrs=(color=black)
   markerattrs=(symbol=circlefilled);
keylegend "norge" / noborder position=top;
colaxis label='År' valueattrs=(size=5) labelattrs=(size=8 weight=bold);
rowaxis label="&aksetekst" valueattrs=(size=6) labelattrs=(size=8 weight=bold);
RUN; ods listing close;

proc datasets nolist;
delete N HF yr: norge;
run;
%mend panelfig;
