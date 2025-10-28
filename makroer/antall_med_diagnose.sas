/*

beregner antall med diagnose i Helse Nord (antall henvisninger og antall pasienter)
eksempel for bruk: minst en dataset og minst en ICD-10 kode må angis;
Hvis flere koder 
Pass på at psykiatriske ICD koder kan dukke opp i somatikk;
alder - <18 år og >=18 år; Angi - YES or NO
kjonn - ErMann - 0 og 1; Angi - YES or NO
Behhf - HF i HelseNord, 99 - avtalespesialister i HN; Angi - YES or NO;

Tenk på personvern.

%antall_med_diagnose_HN(
  data_phbu= HNANA.PHBU_2017_T3 HNANA.PHBU_2018_T3 HNANA.PHBU_2019_T3 HNANA.PHBU_2020_T3
             HNANA.PHBU_2021_T3 HNANA.PHBU_2022_T3 HNANA.PHBU_2023_T3 HNANA.PHBU_2024_T3
             HNANA.PHBU_2025_09,
  data_som = HNANA.SHO_2017_T3 HNANA.SHO_2018_T3 HNANA.SHO_2019_T3 HNANA.SHO_2020_T3
             HNANA.SHO_2021_T3 HNANA.SHO_2022_T3 HNANA.SHO_2023_T3 HNANA.SHO_2024_T3 
				HNANA.SHO_2025_09,
  data_phv = HNANA.PHV_RUS_2017_T3 HNANA.PHV_RUS_2018_T3 HNANA.PHV_RUS_2019_T3 HNANA.PHV_RUS_2020_T3
             HNANA.PHV_RUS_2021_T3 HNANA.PHV_RUS_2022_T3 HNANA.PHV_RUS_2023_T3 HNANA.PHV_RUS_2024_T3
             HNANA.PHV_RUS_2025_09,
  data_aspes = HNANA.ASPES_2017_T3 HNANA.ASPES_2018_T3 HNANA.ASPES_2019_T3 HNANA.ASPES_2020_T3
               HNANA.ASPES_2021_T3 HNANA.ASPES_2022_T3 HNANA.ASPES_2023_T3 HNANA.ASPES_2024_T3
               HNANA.ASPES_2025_T1,
  data_aspes_phv = HNANA.ASPES_PHV_2017_T3 HNANA.ASPES_PHV_2018_T3 HNANA.ASPES_PHV_2019_T3
                   HNANA.ASPES_PHV_2020_T3 HNANA.ASPES_PHV_2021_T3 HNANA.ASPES_PHV_2022_T3
                   HNANA.ASPES_PHV_2023_T3 HNANA.ASPES_PHV_2024_T3 HNANA.ASPES_PHV_2025_T1,

  alder=NO,
  kjonn=YES,
  Behhf=YES,
  codes=F32 F33
);

dataset som kommer ut: 
QUERY_HENV_DIAG - antall henvisninger med gitt diagnose i HN fordelt på år, alder, kjonn, og HF
QUERY_PID_DIAG - antall personer (PID) med gitt diagnose i HN fordelt på år, alder, kjonn, og HF
*/



%macro antall_med_diagnose_HN(
    data_phbu=,
    data_som=,
    data_phv=,
    data_aspes=,
    data_aspes_phv=,
    alder=NO,
    kjonn=NO,
    Behhf=NO,
    codes=  
  );

  %local _stack;
    %let _stack=;

    /***************** PHBU *****************/
    %if %length(&data_phbu) %then %do;
        data diag_phbu;
            set &data_phbu;

    length diag 8;
    diag = 0;

    /* Same diagnosis-like variables by prefix */
    array diagnose {*} $ akse1: tilst1: tilst2: tilst3: tilst4: tilst5: tilst6: ;

    do i = 1 to dim(diagnose);
      if missing(diagnose{i}) then continue;

      /* Check against each requested code prefix */
      %local n code;
      %let n = 1;
      %let code = %qscan(&codes, &n, %str( ));  

      %do %while(%superq(code) ne );
        if upcase(substr(diagnose{i}, 1, %length(%unquote(&code))))
             = "%upcase(%unquote(&code))" then do;
          diag = 1;
          leave;  /* stop scanning variables once a match is found */
        end;

        %let n = %eval(&n + 1);
        %let code = %qscan(&codes, &n, %str( ,));
      %end;
    end;

    drop i;

            Ansvarlig_RHF = 'Andre regioner'; 
            Ansvarlig_HF  = 'Andre HF';

            IF BEHHF = 1 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'FIN'; END;
            ELSE IF boHF = 1 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='FIN'; END;

            IF BEHHF = 2 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'UNN'; END;
            ELSE IF boHF = 2 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='UNN'; END;

            IF BEHHF = 3 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'NLSH'; END;
            ELSE IF boHF = 3 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='NLSH'; END;

            IF BEHHF = 4 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'HSYK'; END;
            ELSE IF boHF = 4 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='HSYK'; END;

            label Ansvarlig_RHF = 'Ansvarlig RHF'
                  Ansvarlig_HF  = 'Ansvarlig HF';
        run;

        data diag_phbu2;
            set diag_phbu;
            where diag=1 and Ansvarlig_RHF='Helse Nord RHF';
            ref_dato = coalesce(ansiendato, mottaksDato);
            format ref_dato yymmdd10.;
            HenvisningsID = catx('_',pid,ref_dato);
            keep pid aar alder ErMann HenvisningsID kilde BehHF ref_dato ansiendato mottaksDato inndato diag ventetidsluttdato ventetidsluttkode;
            length kilde $12;
            kilde='phbu';
        run;

        %let _stack=&_stack diag_phbu2;
    %end;

    /***************** SOM *****************/
    %if %length(&data_som) %then %do;
        data diag_som;
            set &data_som;
    length diag 8;
    diag = 0;

    /* Same diagnosis-like variables by prefix */
    array diagnose {*} $ Hdiag: bdiag: ;

    do i = 1 to dim(diagnose);
      if missing(diagnose{i}) then continue;

      /* Check against each requested code prefix */
      %local n code;
      %let n = 1;
      %let code = %qscan(&codes, &n, %str( ));  

      %do %while(%superq(code) ne );
        if upcase(substr(diagnose{i}, 1, %length(%unquote(&code))))
             = "%upcase(%unquote(&code))" then do;
          diag = 1;
          leave;  /* stop scanning variables once a match is found */
        end;

        %let n = %eval(&n + 1);
        %let code = %qscan(&codes, &n, %str( ,));
      %end;
    end;

            drop i;

            Ansvarlig_RHF = 'Andre regioner'; 
            Ansvarlig_HF  = 'Andre HF';

            IF BEHHF = 1 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'FIN'; END;
            ELSE IF boHF = 1 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='FIN'; END;

            IF BEHHF = 2 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'UNN'; END;
            ELSE IF boHF = 2 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='UNN'; END;

            IF BEHHF = 3 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'NLSH'; END;
            ELSE IF boHF = 3 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='NLSH'; END;

            IF BEHHF = 4 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'HSYK'; END;
            ELSE IF boHF = 4 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='HSYK'; END;

            label Ansvarlig_RHF = 'Ansvarlig RHF'
                  Ansvarlig_HF  = 'Ansvarlig HF';
        run;

        data diag_som2;
            set diag_som;
            where diag=1 and Ansvarlig_RHF='Helse Nord RHF';
            ref_dato = coalesce(ansiendato, mottaksDato);
            format ref_dato yymmdd10.;
            HenvisningsID = catx('_',pid,ref_dato);
            keep pid aar alder ErMann HenvisningsID BehHF kilde ref_dato ansiendato mottaksDato inndato diag ventetidsluttdato ventetidsluttkode;
            length kilde $12;
            kilde='somatikk';
        run;

        %let _stack=&_stack diag_som2;
    %end;

    /***************** PHV *****************/
    %if %length(&data_phv) %then %do;
        data diag_phv;
            set &data_phv;
    length diag 8;
    diag = 0;

    /* Same diagnosis-like variables by prefix */
    array diagnose {*} $ Hdiag: bdiag: ;

    do i = 1 to dim(diagnose);
      if missing(diagnose{i}) then continue;

      /* Check against each requested code prefix */
      %local n code;
      %let n = 1;
      %let code = %qscan(&codes, &n, %str( ));  

      %do %while(%superq(code) ne );
        if upcase(substr(diagnose{i}, 1, %length(%unquote(&code))))
             = "%upcase(%unquote(&code))" then do;
          diag = 1;
          leave;  /* stop scanning variables once a match is found */
        end;

        %let n = %eval(&n + 1);
        %let code = %qscan(&codes, &n, %str( ,));
      %end;
    end;

            drop i;

            Ansvarlig_RHF = 'Andre regioner'; 
            Ansvarlig_HF  = 'Andre HF';

            IF BEHHF = 1 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'FIN'; END;
            ELSE IF boHF = 1 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='FIN'; END;

            IF BEHHF = 2 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'UNN'; END;
            ELSE IF boHF = 2 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='UNN'; END;

            IF BEHHF = 3 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'NLSH'; END;
            ELSE IF boHF = 3 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='NLSH'; END;

            IF BEHHF = 4 THEN DO; Ansvarlig_RHF = 'Helse Nord RHF'; Ansvarlig_HF = 'HSYK'; END;
            ELSE IF boHF = 4 AND BEHRHF IN (5) AND DEBITOR NOT IN (43, 44, 47) THEN DO; Ansvarlig_RHF='Helse Nord RHF'; Ansvarlig_HF='HSYK'; END;

            label Ansvarlig_RHF = 'Ansvarlig RHF'
                  Ansvarlig_HF  = 'Ansvarlig HF';
        run;

        data diag_phv2;
            set diag_phv;
            where diag=1 and Ansvarlig_RHF='Helse Nord RHF';
            ref_dato = coalesce(ansiendato, mottaksDato);
            format ref_dato yymmdd10.;
            HenvisningsID = catx('_',pid,ref_dato);
            keep pid aar alder diag ErMann HenvisningsID BehHF kilde ref_dato ansiendato mottaksDato inndato adhd ventetidsluttdato ventetidsluttkode;
            length kilde $12;
            kilde='phv_rus';
        run;

        %let _stack=&_stack diag_phv2;
    %end;

    /***************** ASPES *****************/
    %if %length(&data_aspes) %then %do;
        data diag_aspes;
            set &data_aspes;
    length diag 8;
    diag = 0;

    /* Same diagnosis-like variables by prefix */
    array diagnose {*} $ Hdiag: bdiag: ;

    do i = 1 to dim(diagnose);
      if missing(diagnose{i}) then continue;

      /* Check against each requested code prefix */
      %local n code;
      %let n = 1;
      %let code = %qscan(&codes, &n, %str( ));  

      %do %while(%superq(code) ne );
        if upcase(substr(diagnose{i}, 1, %length(%unquote(&code))))
             = "%upcase(%unquote(&code))" then do;
          diag = 1;
          leave;  /* stop scanning variables once a match is found */
        end;

        %let n = %eval(&n + 1);
        %let code = %qscan(&codes, &n, %str( ,));
      %end;
    end;

            drop i;

            if borhf=1 and AvtaleRHF=1 then Ansvarlig_RHF='Helse Nord RHF';
            else Ansvarlig_RHF='Andre regioner';

            Ansvarlig_HF='Andre HF';
            if bohf=1 and AvtaleRHF=1 then Ansvarlig_HF='FIN';
            else if bohf=2 and AvtaleRHF=1 then Ansvarlig_HF='UNN';
            else if bohf=3 and AvtaleRHF=1 then Ansvarlig_HF='NLSH';
            else if bohf=4 and AvtaleRHF=1 then Ansvarlig_HF='HSYK';
        run;

        data diag_aspes2;
            set diag_aspes;
            where diag=1 and Ansvarlig_RHF='Helse Nord RHF';
            HenvisningsID = catx('_',pid,fag);
            keep pid aar alder ErMann HenvisningsID inndato diag kilde;
            length kilde $12;
            kilde='aspes';
        run;

        %let _stack=&_stack diag_aspes2;
    %end;

    /***************** ASPES_PHV *****************/
    %if %length(&data_aspes_phv) %then %do;
        data diag_aspes_phv;
            set &data_aspes_phv;
    length diag 8;
    diag = 0;

    /* Same diagnosis-like variables by prefix */
    array diagnose {*} $ Hdiag: bdiag: ;

    do i = 1 to dim(diagnose);
      if missing(diagnose{i}) then continue;

      /* Check against each requested code prefix */
      %local n code;
      %let n = 1;
      %let code = %qscan(&codes, &n, %str( ));  

      %do %while(%superq(code) ne );
        if upcase(substr(diagnose{i}, 1, %length(%unquote(&code))))
             = "%upcase(%unquote(&code))" then do;
          diag = 1;
          leave;  /* stop scanning variables once a match is found */
        end;

        %let n = %eval(&n + 1);
        %let code = %qscan(&codes, &n, %str( ,));
      %end;
    end;
            drop i;

            if borhf=1 and AvtaleRHF=1 then Ansvarlig_RHF='Helse Nord RHF';
            else Ansvarlig_RHF='Andre regioner';

            Ansvarlig_HF='Andre HF';
            if bohf=1 and AvtaleRHF=1 then Ansvarlig_HF='FIN';
            else if bohf=2 and AvtaleRHF=1 then Ansvarlig_HF='UNN';
            else if bohf=3 and AvtaleRHF=1 then Ansvarlig_HF='NLSH';
            else if bohf=4 and AvtaleRHF=1 then Ansvarlig_HF='HSYK';
        run;

        data diag_aspes_phv2;
            set diag_aspes_phv;
            where diag=1 and Ansvarlig_RHF='Helse Nord RHF';
            ref_dato = coalesce(ansiendato, mottaksDato);
            format ref_dato yymmdd10.;
            HenvisningsID = catx('_',pid,ref_dato);
            keep pid aar alder ErMann HenvisningsID inndato diag kilde;
            length kilde $12;
            kilde='aspes_phv';
        run;

        %let _stack=&_stack diag_aspes_phv2;
    %end;

    /* If nothing was created, stop early */
    %if %length(&_stack)=0 %then %do;
        %put NOTE: No input datasets specified. Nothing to do.;
        %return;
    %end;

    /***************** STACK ALL SELECTED SOURCES *****************/
    data diag_b;
        set &_stack;
            length alder_2 $11;
            if 0 <= alder < 18 then alder_2 = "barn, <18";
            else if alder >= 18 then alder_2 = "voksen, >18";
               
            if BehHF = . then BehHF = 99; /* Avtalespesialister */
        
    run;

    /* Keep 1 row per HenvisningsID: earliest inndato */
    proc sort data=diag_b; by HenvisningsID inndato; run;
    data diag_henv; set diag_b; by HenvisningsID inndato; if first.HenvisningsID; run;

    /* Keep 1 row per PID: earliest inndato */
    proc sort data=diag_b; by pid inndato; run;
    data diag_pid; set diag_b; by pid inndato; if first.pid; run;

    /***************** PARAM-DRIVEN GROUPING TABLES *****************/
    %local _grp _sel;
    %let _grp=;
    %let _sel=;

    %if %upcase(&alder)=YES %then %do;
        %let _grp=&_grp t1.alder_2,;
        %let _sel=&_sel t1.alder_2,;
    %end;
    %if %upcase(&kjonn)=YES %then %do;
        %let _grp=&_grp t1.ErMann,;
        %let _sel=&_sel t1.ErMann,;
    %end;
    %if %upcase(&Behhf)=YES %then %do;
        %let _grp=&_grp t1.BehHF,;
        %let _sel=&_sel t1.BehHF,;
    %end;

    %let _grp=&_grp t1.aar;   /* aar is always included */
    %let _sel=&_sel t1.aar;

    /* HENV-level */
    %if %sysfunc(exist(work.diag_henv)) %then %do;
        proc sql noprint;
            create table work.QUERY_HENV_DIAG as
            select &_sel,
                   count(t1.pid) as COUNT_of_henv
            from work.diag_henv t1
            group by &_grp;
        quit;
    %end;

    /* PID-level */
    %if %sysfunc(exist(work.diag_pid)) %then %do;
        proc sql noprint;
            create table work.QUERY_PID_DIAG as
            select &_sel,
                   count(t1.pid) as COUNT_of_pid
            from work.diag_pid t1
            group by &_grp;
        quit;
    %end;


%mend antall_med_diagnose_HN;