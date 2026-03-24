<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 29/09/2025 Aggiunto condizione su ditta di manutenzione presente assente (punto 33 MEV regione Marche 2025)

    rom03 06/04/2022 MEV Ibrido per regione Marche: aggiunto sel_ibrido.

    rom02 19/03/2019 Aggiunta condizione where_gend 

    rom01 12/07/2018 Aggiunta condizione where_manu.

    san02 19/07/2016 Aggiunto filtro per cod_zona.

    san01 23/06/2015 Aggiunta data_ri

    nic01 03/06/2016 Su richiesta di UCIT, dopo aver fatto l'estrazione, il risultato finale
    nic01            deve essere ordinato per via
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_dual_data_calc">
       <querytext>
                   select to_char(add_months(current_date, -to_number(:mesi_sub,'99999990')), 'yyyy-mm-dd') as data_calc
       </querytext>
    </fullquery>

    <fullquery name="sel_cinc">
       <querytext>
                   select descrizione as desc_camp
                     from coimcinc
                    where cod_cinc = :cod_cinc
       </querytext>
    </fullquery>

    <partialquery name="col_random">
       <querytext>
                   random
       </querytext>
    </partialquery>

    <partialquery name="sel_aimp_si_vie">
       <querytext>
            select * -- nic01
              from ( -- nic01
                select a.cod_impianto
                     , a.cod_impianto_est
                     , a.flag_tipo_impianto
                     , vv.matricola
                     , coalesce(b.cognome,'')||' '||
                       coalesce(b.nome, '') as nome_resp
		     , coalesce(d.descr_topo,'')||' '||
                       coalesce(d.descrizione, '')||' '||
                       coalesce(a.numero,'') as via
		     , c.denominazione as comune
                       $sel_desc_estr 
                     , null as data_installaz
                     , random()
                      $sel_date_controllo
                      $sel_matricola
                      $sel_num_cimp
		      $sel_ibrido  --rom03
                     , coalesce((select to_char(max(cimp.data_controllo), 'dd/mm/yyyy')
                                   from coimcimp cimp
                                  where cimp.cod_impianto = a.cod_impianto)
                                , '') as data_ri -- san01
                      , d.descrizione          as viae_descrizione -- nic01
                      , lpad(a.numero, 8, '0') as aimp_numero      -- nic01
                   from coimaimp a
		  $from_inco
                  $from_manc
		  left outer join coimcitt b on b.cod_cittadino  = a.cod_responsabile
                  left outer join coimcomu c on c.cod_comune     = a.cod_comune
	-- san02  left outer join coimviae d
                            $join_coimviae d -- san02
                                             on d.cod_comune     = a.cod_comune
		                            and d.cod_via        = a.cod_via
                                           $and_cod_zona -- san02
                       $from_dimp
                       $from_dipe
                       $from_anom
                 ,coimgend vv
                 where --rom02 a.flag_dpr412 = 'S'
                        1 = 1 --rom02
                $where_dimp
		$where_manu --rom01
                $where_gend --rom03
                $where_dipe
                $where_anom
		$where_dich
		$where_pote
                $where_comb
		$where_comune
		$where_via
		$where_anno
		$where_word
		$where_area
                $where_stato
                $where_tipo_imp
                $where_todo
                $where_cout
                $where_gen15
                   $and_cinc
                   and not exists (select '1'
                                     from coimcimp e
                                    where e.cod_impianto    = a.cod_impianto
                                      and e.data_controllo >=  :data_controllo
                                      and flag_tracciato <> 'MA'
                                  )
                and vv.cod_impianto = a.cod_impianto
                and vv.flag_attivo  = 'S'                -- 31/07/2013
	       $and_gend_gen_prog_uguale_a_dimp_gen_prog -- 31/07/2013
               and a.cod_impianto = (select tt.cod_impianto from coimgend tt where a.cod_impianto = tt.cod_impianto and tt.flag_attivo = 'S' limit 1)
	       $and_manu_present  --ric01
                $order_by
                limit $num_max
            ) result_table     -- nic01
     order by comune           -- nic01
            , viae_descrizione -- nic01              
            , aimp_numero      -- nic01
            , nome_resp        -- nic01
            , cod_impianto_est -- nic01
       </querytext>
    </partialquery>

    <partialquery name="sel_aimp_no_vie">
       <querytext>
            select * -- nic01
              from ( -- nic01
                select a.cod_impianto
                     , a.cod_impianto_est
                     , a.flag_tipo_impianto
                     , vv.matricola
                     , coalesce(b.cognome,'')||' '||
                       coalesce(b.nome, '') as nome_resp
		     , coalesce(a.toponimo,'')||' '||
                       coalesce(a.indirizzo, '')||' '||
                       coalesce(a.numero,'') as via
		     , c.denominazione as comune
                       $sel_desc_estr 
                     , null as data_installaz
                     , random()
                      $sel_date_controllo
                      $sel_matricola
                      $sel_num_cimp
		      $sel_ibrido  --rom03
                     , coalesce((select to_char(max(cimp.data_controllo), 'dd/mm/yyyy')
                                   from coimcimp cimp
                                  where cimp.cod_impianto = a.cod_impianto)
                                , '') as data_ri -- san01
                     , a.indirizzo            as aimp_indirizzo   -- nic01
                     , lpad(a.numero, 8, '0') as aimp_numero      -- nic01
                   from coimaimp a
		  $from_inco
                  $from_manc
		  left outer join coimcitt b on b.cod_cittadino  = a.cod_responsabile
                  left outer join coimcomu c on c.cod_comune     = a.cod_comune
                       $from_dimp
                       $from_dipe
                       $from_anom
                 where a.flag_dpr412 = 'S'
                $where_dimp
                $where_manu --rom01
                $where_gend --rom03
                $where_dipe
                $where_anom
		$where_dich
		$where_pote
                $where_comb
		$where_comune
                $where_via
		$where_anno
		$where_word
		$where_area
              $where_todo
                $where_stato
                 $where_tipo_imp
              $where_cout
              $where_gen15
                   $and_cinc
                   and not exists (select '1'
                                     from coimcimp e
                                    where e.cod_impianto    = a.cod_impianto
                                      and e.data_controllo >=  :data_controllo
                                      and flag_tracciato <> 'MA'
                                  )
                and vv.cod_impianto = a.cod_impianto
                and vv.flag_attivo  = 'S'                -- 31/07/2013
	         $and_gend_gen_prog_uguale_a_dimp_gen_prog -- 31/07/2013
                 and a.cod_impianto = (select tt.cod_impianto from coimgend tt where a.cod_impianto = tt.cod_impianto and tt.flag_attivo = 'S' limit 1)
		 $and_manu_present  --ric01
                $order_by
                limit $num_max
            ) result_table     -- nic01
     order by comune           -- nic01
            , aimp_indirizzo   -- nic01              
            , aimp_numero      -- nic01
            , nome_resp        -- nic01
            , cod_impianto_est -- nic01
       </querytext>
    </partialquery>

    <fullquery name="sel_cmar">
       <querytext>
           select cod_comune
             from coimcmar
            where cod_area = :cod_area
       </querytext>
    </fullquery>

    <fullquery name="sel_area_tipo_01">
       <querytext>
               select tipo_01
                 from coimarea 
                where cod_area = :cod_area
       </querytext>
    </fullquery>

    <partialquery name="count_aimp">
       <querytext>
                select count(*) as num_imp
                  from coimaimp a
                    $from_dimp
                    $from_dipe
                    $from_anom
                 where a.flag_dpr412 = 'S'
                $where_dimp
                $where_manu --rom01
                $where_gend --rom02
                $where_dipe
                $where_anom
		$where_dich
		$where_pote
                $where_comb
		$where_comune
                $where_via
		$where_anno
		$where_word
		$where_area
                $where_stato
		$where_ragr
		$where_peso
		$where_anomalie
               $where_tipo_imp
              $where_cout
              $where_gen15
             $and_cinc
                   and not exists (select '1'
                                     from coimcimp e
                                    where e.cod_impianto    = a.cod_impianto
                                      and e.data_controllo >=  :data_controllo
                                      and flag_tracciato <> 'MA'
                                      )
            $and_manu_present  --ric01
       </querytext>
    </partialquery>

    <fullquery name="sel_tpes">
       <querytext>
                   select descr_tpes
                     from coimtpes
                    where cod_tpes = :tipo_estrazione
		    order by cod_tpes
       </querytext>
    </fullquery>

</queryset>
