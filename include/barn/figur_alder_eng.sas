proc sgplot data=agg_alder_kjonn noautolegend noborder sganno=annoarsvar pad=(Bottom=5%);
	vbar alder / response=tot stat=sum group=ermann groupdisplay=cluster name="Vbar";
	keylegend "Vbar" / location=outside position=topright noborder titleattrs=(size=6);
    yaxis display=(noticks noline) values=&skala_alder label=&label_alder 
		labelattrs=(size=7 weight=bold) valuesformat=COMMA8.0 valueattrs=(size=7);
	xaxis offsetmin=0.035 label='Age' labelattrs=(size=7 weight=bold) valuesformat=NLNUM8.0 valueattrs=(size=7);
   *format &Yaxistable COMMA8.0;
run;
ods graphics off;