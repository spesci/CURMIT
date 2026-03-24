<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom03 19/01/2023 Riportate modifiche gia' fatte per coimestr-list.tcl

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

    <partialquery name="sel_aimp">
       <querytext>
         select distinct(c.denominazione) as nome_comune
	      , count(a.cod_impianto)     as numero_impianti
           from coimaimp a
  	        $from_inco
                $from_manc
           left outer join coimcitt b on b.cod_cittadino  = a.cod_responsabile
           left outer join coimcomu c on c.cod_comune     = a.cod_comune
                $join_coimviae d -- san02
             on d.cod_comune     = a.cod_comune
	    and d.cod_via        = a.cod_via
                $and_cod_zona -- san02
                $from_dimp
                $from_dipe
                $from_anom
              , coimgend vv
          where 1 = 1 --rom02
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
                                  ) --rom03
                and vv.cod_impianto = a.cod_impianto
                and vv.flag_attivo  = 'S'                -- 31/07/2013
	        $and_gend_gen_prog_uguale_a_dimp_gen_prog -- 31/07/2013
                and a.cod_impianto = (select tt.cod_impianto from coimgend tt where a.cod_impianto = tt.cod_impianto and tt.flag_attivo = 'S' limit 1)
                group by c.denominazione
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
    <partialquery name="sel_tot_imp">
       <querytext>
         select count(a.cod_impianto)     as tot_imp
           from coimaimp a
  	        $from_inco
                $from_manc
           left outer join coimcitt b on b.cod_cittadino  = a.cod_responsabile
           left outer join coimcomu c on c.cod_comune     = a.cod_comune
                $join_coimviae d -- san02
             on d.cod_comune     = a.cod_comune
	    and d.cod_via        = a.cod_via
                $and_cod_zona -- san02
                $from_dimp
                $from_dipe
                $from_anom
              , coimgend vv
          where 1 = 1 --rom02
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
                                  ) --rom03
                and vv.cod_impianto = a.cod_impianto
                and vv.flag_attivo  = 'S'                -- 31/07/2013
	        $and_gend_gen_prog_uguale_a_dimp_gen_prog -- 31/07/2013
                and a.cod_impianto = (select tt.cod_impianto from coimgend tt where a.cod_impianto = tt.cod_impianto and tt.flag_attivo = 'S' limit 1)
       </querytext>
    </partialquery>

    
</queryset>
