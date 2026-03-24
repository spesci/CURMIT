<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom08 22/05/2024 Su segnalazione di Regione Marche e Sandro ora per gli impianti del teleriscaldamento
    rom08            tengo in considerazione solo i generatori con potenza > di 10 kW.
    rom08            Per gli impianti del caldo e cogenerazione tengo in considerazione solo i generatori
    rom08            con potenza >= di 10 kW. Per il freddo non ho modifcato nulla
    rom08            perchè viene usata una query diversa.

    rom07 28/02/2023 Su segnalazione di Regione Marche e Sandro ora per gli impianti del caldo
    rom07            tengo in considerazione solo i generatori con potenza >= di 10 kW.
    rom07            Per gli impianti del freddo tengo in considerazione solo i generatori che
    rom07            hanno la maggiore tra potenza in riscaldamento e raffrescamento >= di 12 Kw.

    mic01 07/07/2022 Su segnalazione di Regione Marche e Sandro modificate query sel_gend_fr e
    mic01            sel_tot_gend_fr per fare in modo che vengano presi in considerazione solo i generatori
    mic01            che hanno la maggiore tra potenza in riscaldamento e raffrescamento maggiore di 12 Kw.

    sim01 30/06/2021 Corretto visualizzazione sugli impianti con generatori del freddo che hanno solo
    sim01            la potenza di riscaldamento.

    rom06 04/08/2020 Su segnalazione di Giugliodori (Marche) vado ad esporre, per gli impianti del freddo,
    rom06            la maggiore tra la potenza frigorifera nominale e la potenza termica nominale dell impianto 
    rom06            nella sezione della scheda 1 bis.

--> 		     	   
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_gend">
       <querytext>
       select * 
            , $select_anni
         from (
           select a.gen_prog
                , a.gen_prog_est
                , a.descrizione    
                , c.descr_comb     
                , iter_edit_data(a.data_installaz) as data_installaz_edit
                , case a.flag_attivo
                       when 'S' then 'S&igrave;'
                       when 'N' then '<font color=red><b>No</b></font>'
                       else '&nbsp;'
                  end as flag_attivo
                , iter_edit_num(a.pot_utile_nom,2) || ' (kW)' as potenza
                , f.cod_impianto_est
                , '€ ' || iter_edit_num(t.importo,2) as importo
                , a.pot_utile_nom as potenza_num
                , c.cod_combustibile as combustibile
                , f.flag_tipo_impianto
            from coimgend a
  left outer join coimcomb c
               on c.cod_combustibile = a.cod_combustibile
             inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
    left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                  from coimtari d
                                  where d.cod_potenza = f.cod_potenza
                                    and d.tipo_costo != 7 --escludo i contributi
                                    and d.cod_listino = '0'
                                    and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto
      --rom07 and a.pot_utile_nom >10
              and (case when f.flag_tipo_impianto ='T' 
                        then a.pot_utile_nom > 10
                        else a.pot_utile_nom >= 10 end) --rom08
      --rom08 and a.pot_utile_nom >= 10 --rom07
              and flag_attivo = 'S' --rom01
              and f.flag_tipo_impianto !='F'
           ) gen
         order by flag_attivo desc
                , cod_impianto_est
                , gen_prog_est
       </querytext>
    </partialquery>

    <partialquery name="sel_tot_gend">
       <querytext>
       select iter_edit_num(sum(potenza),2) || ' (kW)' as tot_potenza
            , case when tipo = 'G' then 'GASSOSO'
                   when tipo = 'L' then 'LIQUIDO'
                   when tipo = 'S' then 'SOLIDO'
                   when tipo = 'A' then 'ALTRO'
                   end as tipo_combustibile
	    ,' € ' || importo as tot_importo
	    , $select_anni_tot
	 from (
           select a.pot_utile_nom as potenza
                , c.tipo
	        , iter_edit_num(t.importo , 2) as importo
		, a.pot_utile_nom as potenza_num
                , c.cod_combustibile as combustibile
		, f.flag_tipo_impianto
             from coimgend a
  left outer join coimcomb c
               on c.cod_combustibile = a.cod_combustibile
       inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
  left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                     from coimtari d
                                    where d.cod_potenza = f.cod_potenza
                                      and d.tipo_costo != 7 --escludo i contributi
                                      and d.cod_listino = '0'
                                      and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto
	      and f.flag_tipo_impianto !='F'
      --rom07 and a.pot_utile_nom >10
              and (case when f.flag_tipo_impianto ='T' 
                        then a.pot_utile_nom > 10
                        else a.pot_utile_nom >= 10 end) --rom08
      --rom08 and a.pot_utile_nom >= 10 --rom07
              and flag_attivo ='S' --rom01
           ) gen
         group by tipo, importo,flag_tipo_impianto,combustibile--, anni
       </querytext>
     </partialquery>

    <partialquery name="sel_gend_fr">
       <querytext>
       select * 
            , $select_anni_fr
         from (
           select a.gen_prog
                , a.gen_prog_est
                , case a.flag_attivo
                       when 'S' then 'S&igrave;'
                       when 'N' then '<font color=red><b>No</b></font>'
                       else '&nbsp;'
                  end as flag_attivo
      --rom06  , iter_edit_num(a.pot_focolare_nom,2) || ' (kW)' as potenza
                , iter_edit_num(greatest(a.pot_focolare_nom, a.pot_focolare_lib),2) || ' (kW)' as potenza --rom06
                , f.cod_impianto_est
                , '€ ' || iter_edit_num(t.importo,2) as importo
                , a.pot_focolare_nom as potenza_num
                , f.flag_tipo_impianto
                , a.cod_tpco
                , coalesce(p.descr_tpco, '&nbsp;') as descr_tpco  --rom04
		, case when coalesce(a.flag_prod_acqua_calda,'N') = 'S'
		        and coalesce(a.flag_clima_invernale,'N')  = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Produzione ACS'
	               when coalesce(a.flag_clima_invernale,'N')  = 'S'
		        and coalesce(a.flag_prod_acqua_calda,'N') = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Climatizzazione invernale'
                       when coalesce(a.flag_clim_est,'N')         = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'N'
		       and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione estiva'
		      when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'N' then 'Produzione ACS +<br>Climatizzazione invernale'
                      when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'N' then 'Produzione ACS +<br>Climatizzazione estiva'
         	      when coalesce(a.flag_clima_invernale,'N')   = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'S'
		       and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione invernale +<br>Climatizzazione estiva'
                      when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'S' then 'Produzione ACS +<br>Climatizzazione invernale +<br>Climatizzazione estiva'
                      when coalesce(a.flag_prod_acqua_calda,'N')  = 'N'
  		       and coalesce(a.flag_clima_invernale,'N')   = 'N'
		       and coalesce(a.flag_clim_est,'N')          = 'N' then ''
		      else '' end as tipo_climatizzazione --rom05
             from coimgend a
  left outer join coimtpco p              --rom04
               on p.cod_tpco = a.cod_tpco --rom04 
             inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
    left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                  from coimtari d
                                  where d.cod_potenza = f.cod_potenza
                                    and d.tipo_costo != 7 --escludo i contributi
                                    and d.cod_listino = '0'
                                    and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto
	      and f.flag_tipo_impianto = 'F'
--mic01       and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 10 --sim01
--rom07       and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 12 --mic01
              and greatest(a.pot_focolare_nom, a.pot_focolare_lib) >= 12 --rom07
--sim01              and a.pot_focolare_nom >10
              and flag_attivo = 'S' --rom01
           ) gen
         order by flag_attivo desc
                , cod_impianto_est
                , gen_prog_est
       </querytext>
    </partialquery>

    <partialquery name="sel_tot_gend_fr">
       <querytext>
       select iter_edit_num(sum(potenza),2) || ' (kW)' as tot_potenza
	    ,' € ' || importo as tot_importo
	    , $select_anni_tot_fr
	    , coalesce(descr_tpco,'') as tot_descr_tpco --rom04
	    , coalesce(tipo_climatizzazione,'') as tot_tipo_climatizzazione --rom05
	 from (
           select --rom06 a.pot_focolare_nom as potenza
	          greatest(a.pot_focolare_nom, a.pot_focolare_lib) as potenza --rom06
                , coalesce(p.descr_tpco, '&nbsp;') as descr_tpco  --rom04
	        , iter_edit_num(t.importo , 2) as importo
	--rom06, a.pot_focolare_nom as potenza_num
                , greatest(a.pot_focolare_nom, a.pot_focolare_lib) as potenza_num_fr --rom06
	        , f.flag_tipo_impianto
                , a.cod_tpco
		, case when coalesce(a.flag_prod_acqua_calda,'N') = 'S'
		        and coalesce(a.flag_clima_invernale,'N')  = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Produzione ACS'
	               when coalesce(a.flag_clima_invernale,'N')  = 'S'
		        and coalesce(a.flag_prod_acqua_calda,'N') = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Climatizzazione invernale'
                       when coalesce(a.flag_clim_est,'N')         = 'S'
  		        and coalesce(a.flag_clima_invernale,'N')   = 'N'
		        and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione estiva'
		       when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		        and coalesce(a.flag_clima_invernale,'N')   = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'N' then 'Produzione ACS +<br>Climatizzazione invernale'
                       when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'S'
		        and coalesce(a.flag_clima_invernale,'N')   = 'N' then 'Produzione ACS +<br>Climatizzazione estiva'
         	       when coalesce(a.flag_clima_invernale,'N')   = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'S'
		        and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione invernale +<br>Climatizzazione estiva'
                       when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		        and coalesce(a.flag_clima_invernale,'N')   = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'S' then 'Produzione ACS +<br>Climatizzazione invernale +<br>Climatizzazione estiva'
                       when coalesce(a.flag_prod_acqua_calda,'N')  = 'N'
  		        and coalesce(a.flag_clima_invernale,'N')   = 'N'
		        and coalesce(a.flag_clim_est,'N')          = 'N' then ''
		       else '' end as tipo_climatizzazione --rom05
             from coimgend a
  left outer join coimtpco p              --rom04
               on p.cod_tpco = a.cod_tpco --rom04
       inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
  left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                     from coimtari d
                                    where d.cod_potenza = f.cod_potenza
                                      and d.tipo_costo != 7 --escludo i contributi
                                      and d.cod_listino = '0'
                                      and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto
	      and f.flag_tipo_impianto = 'F'
   --mic01    and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 10 --sim01
   --rom07    and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 12 --mic01
              and greatest(a.pot_focolare_nom, a.pot_focolare_lib) >= 12 --rom07
	      --sim01              and a.pot_focolare_nom >10
              and flag_attivo ='S' --rom01
           ) gen
         group by importo, descr_tpco, tipo_climatizzazione,cod_tpco --anni
       </querytext>
     </partialquery>

</queryset>
