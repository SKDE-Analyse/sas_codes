%macro andelsfig_0_100(n_datasett=, text_a1=, sortby=andel_ds1, bildeformat=png, noxlabel=0, sprak=no);

%merge(ant_datasett=&n_datasett, dsn_ut=qwerty_m); 

data qwerty_m;
set qwerty_m;
andel_alle=1;

if &n_datasett=3 then do;
andel_ds12=(rate_1+rate_2)/(rate_1+rate_2+rate_3);
andel_ds1=rate_1/(rate_1+rate_2+rate_3);
andel_ds2=rate_2/(rate_1+rate_2+rate_3);
andel_ds3=rate_3/(rate_1+rate_2+rate_3);
plass_scatter=&plass_scat;
andel_ds1_text=cat("&text_a1", put(andel_ds1, nlpct8.1));
tot_antall=antall_1+antall_2+antall_3;

if &vis_misstxt=1 then do;
if tot_antall lt &nkrav then do;
     andel_alle=.;
	 andel_ds12=.;
	 andel_ds1=.;
	 Misstext="N<&nkrav";
     plass=0.02;
end;
end;

end;

if &n_datasett=2 then do;
andel_ds1=rate_1/(rate_1+rate_2);
plass_scatter=&plass_scat;
andel_ds1_text=cat("&text_a1", put(andel_ds1, nlpct8.1));

if &vis_misstxt=1 then do;
	if tot_antall lt &nkrav then do;
     andel_alle=.;
	 andel_ds1=.;
	 Misstext="N<&nkrav";
     plass=0.02;
end;
end;

end;



run;

data qwerty_m;
set qwerty_m;
if bohf=8888 then do;
nandel_alle=andel_alle;
%if &n_datasett=2 %then %do;
nandel_ds1=andel_ds1;
%end;
%if &n_datasett=3 %then %do;
nandel_ds12=andel_ds12;
nandel_ds1=andel_ds1;
%end;
end;
run;

proc sort data=qwerty_m;
by descending &sortby;
run;

ODS Graphics ON /reset=All imagename="&tema._&type._andel100_&fignavn" imagefmt=&bildeformat border=off width=640px height=500px;
ODS Listing Image_dpi=300 GPATH="&bildelagring.&mappe";
proc sgplot data=qwerty_m noborder noautolegend sganno=anno pad=(Bottom=5%);

hbarparm category=bohf response=andel_alle / fillattrs=(color=CX95BDE6)  outlineattrs=(color=CX00509E) missing name="hp1" legendlabel="&label_alle"; 
hbarparm category=bohf response=nandel_alle / fillattrs=(color=CXC3C3C3)  outlineattrs=(color=CX4C4C4C); 


%if &n_datasett=2 %then %do;
hbarparm category=bohf response=andel_ds1  / fillattrs=(color=CX00509E)  outlineattrs=(color=CX00509E)  missing name="hp2" legendlabel="&label_1"; 
hbarparm category=bohf response=nandel_ds1 / fillattrs=(color=CX4C4C4C)  outlineattrs=(color=CX4C4C4C);
%end;

%if &n_datasett=3 %then %do;
hbarparm category=bohf response=andel_ds12 / fillattrs=(color=CX568BBF)  outlineattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_12";
hbarparm category=bohf response=nandel_ds12 / fillattrs=(color=CX969696)  outlineattrs=(color=CX4C4C4C);
hbarparm category=bohf response=andel_ds1  / fillattrs=(color=CX00509E)  outlineattrs=(color=CX00509E) missing name="hp3" legendlabel="&label_1"; 
hbarparm category=bohf response=nandel_ds1 / fillattrs=(color=CX4C4C4C)  outlineattrs=(color=CX4C4C4C);
%end;

%if &vis_misstxt=1 %then %do;
scatter x=plass y=bohf /datalabel=Misstext datalabelpos=right markerattrs=(size=0) datalabelattrs=(size=8pt);
%end;
*scatter x=plass_scatter y=bohf /datalabel=andel_ds1_text datalabelpos=right markerattrs=(size=0) datalabelattrs=(color=white weight=bold size=8);
*where bohf ne 8888;
	

	%if &n_datasett=3 %then %do;
	 keylegend "hp3" "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=8);
	%end;
	
	%if &n_datasett=2 %then %do;
	 keylegend "hp2" "hp1"/ location=outside position=bottom down=1 noborder titleattrs=(size=8);
	%end;
	
	Yaxistable &tabellvariable /Label location=inside labelpos=bottom position=right valueattrs=(size=8 family=arial) labelattrs=(size=8);

	%if &sprak=no %then %do;
    yaxis display=(noticks noline) label='Bosatte i opptaksområdene' labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
	%end;
	%else %if &sprak=en %then %do;
    yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=9);
	%end;

    %if &noxlabel=1 %then %do;
	 xaxis display=(nolabel) offsetmin=0.02 offsetmax=0.2 valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	%end;
	%else %do;
	 xaxis offsetmin=0.02 offsetmax=0.05 valueattrs=(size=8) label="&xlabel" labelattrs=(size=8 weight=bold);
	%end;
	label &labeltabell;
format andel_alle andel_ds12 andel_ds1 nlpct8.1 &formattabell;


run;ods listing close;

%mend andelsfig_0_100;

