<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
	<partialquery name="sel_imp_anom">
		<querytext>
        	select a.id_riga 
        			,a.cod_impianto_est
            		,a.matricola
		            ,a.modello
                            $sel_pote
		            ,a.toponimo
                            ,a.indirizzo
		            ,a.civico
		            ,a.comune
		            ,d.cod_comune
			    $sel_comb --gac01
		            ,a.marca
		            ,c.cod_cost
		            ,a.numero_anomalie
        	from $nome_tab_cari a
		     $where_comb      --gac01
        	left join coimcost c on c.descr_cost = a.marca
        	left join coimcomu d on d.denominazione = a.comune
        	where a.flag_stato = 'P'
        	$where_last
        	order by id_riga
        	limit :rows_per_page
       	</querytext>
	</partialquery>
	
	<fullquery name="sel_riftab">
       	<querytext>
       		select desc_errore 
       		from $nome_tab_anom 
       		where id_riga = :id_riga 
       		and nome_colonna = :riftab
		limit 1
		</querytext>
	</fullquery>
		
	<fullquery name="sel_value_anom">
       	<querytext>
        	select $nome_colonna as value
        	from $nome_tab_cari a
        	where a.id_riga = :id_riga
    	</querytext>
	</fullquery>
	
	<fullquery name="upd_imp_cari_ok">
		<querytext>
        	update $nome_tab_cari
            set cod_impianto_est = btrim(:cod_impianto_est,' ')
            	,matricola = btrim(:matricola,' ')
            	,modello = upper(btrim(:modello,' '))
		$upd_pote
            	,toponimo = :descr_topo
            	,indirizzo = upper(btrim(:descr_via,' '))
--gac01            	,combustibile = (select descr_comb from coimcomb where cod_combustibile = :cod_combustibile)
            	,marca = (select descr_cost from coimcost where cod_cost = :cod_cost)
           	where id_riga = :id_riga
		</querytext>
	</fullquery>

 	<fullquery name="sel_batc_next">
       <querytext>
             select nextval('coimbatc_s') as cod_batc
       </querytext>
    </fullquery>

    <partialquery name="ins_batc">
       <querytext>
                insert
                  into coimbatc 
                     ( cod_batc
                     , nom
                     , flg_stat
                     , dat_prev
                     , ora_prev
                     , cod_uten_sch
                     , nom_prog
                     , par
                     , note)
                values
                     (:cod_batc
                     ,:nom
                     ,:flg_stat
                     ,:dat_prev
                     ,:ora_prev
                     ,:cod_uten_sch
                     ,:nom_prog
                     ,:par
                     ,:note)
       </querytext>
    </partialquery>
    
	<fullquery name="sel_esit">
       <querytext>
           select nom
                , url
                , pat
             from coimesit
            where cod_batc = :cod_batc
              and ctr      = :ctr
       </querytext>
    </fullquery>

    <fullquery name="sel_esit_count">
       <querytext>
           select count(*) as ctr_esit
             from coimesit
            where cod_batc = :cod_batc
       </querytext>
    </fullquery>

    <fullquery name="del_esit">
       <querytext>
           delete
             from coimesit
            where cod_batc = :cod_batc
              and ctr      = :ctr
       </querytext>
    </fullquery>

    <fullquery name="del_batc">
       <querytext>
           delete
             from coimbatc
            where cod_batc = :cod_batc
       </querytext>
    </fullquery>
    
    <fullquery name="upd_imp_anom_scarta">
		<querytext>
        	update $nome_tab_cari
            set flag_stato = 'S'
			where id_riga = :id_riga
		</querytext>
	</fullquery>
	
	
</queryset>
