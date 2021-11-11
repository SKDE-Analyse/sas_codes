/* 
- Lage egen variabel som heter icpc2_hdiag
    - gjelder for de med kodeverk 1 og 2 (icpc2 og icpc2 beriket)
    - flertallet bruker icpc2, slik at icpc2 beriket får også en vanlig icpc2-kode
    - sette på format på icpc2_hdiag
 */

%macro kpr_icpc2(inndata=, utdata=);

data icpc2_data icpc2b_data rest;
  set &inndata;
  drop icpc2: ; /*slette gamle icpc2_*variabler som er i datasett*/
  if kodeverk eq 1 then output icpc2_data;
  if kodeverk eq 2 then output icpc2b_data;
  if kodeverk in (3:5) then output rest;
  run;

/* ICPC-2 */
    proc sql;
        create table icpc2_data2 as
        select a.*, b.icpc2_kode as icpc2_hdiag, b.icpc2_kap, b.icpc2_type
        from icpc2_data a
        left join hnref.ref_icpc2 b
        on a.Hdiag=b.icpc2_kode;
    quit;

/* ICPC-2 beriket */
    proc sql;
        create table icpc2b_data2 as
        select a.*, b.icpc2_kode as icpc2_hdiag, b.icpc2_kap, b.icpc2_type, b.icpc2b_icd10_kode /*evnt sett inn icpc2b_koden*/
        from icpc2b_data a
        left join hnref.ref_icpc2_beriket b
        on a.Hdiag=b.icpc2b_kode;
    quit;

/* Sette sammen datasettene */
data &utdata;
set icpc2_data2 icpc2b_data2 rest;
format icpc2_kap $icpc2_kap. icpc2_type icpc2_type. icpc2_hdiag $icpc2_fmt. icpc2b_icd10_kode $icd10_fmt. ;
run;

proc delete data= icpc2_data icpc2_data2 icpc2b_data icpc2b_data2 rest ;
run;
%mend;