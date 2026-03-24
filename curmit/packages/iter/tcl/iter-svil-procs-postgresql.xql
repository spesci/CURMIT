<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="iter_check_login.sel_uten_join">
       <querytext>
               select c.lvl     as lvl1 
                    , e.livello as lvl2
                 from coimfunz a
                    , coimogge b
                    , coimmenu c
                    , coimprof d
                    , coimuten e
                where a.dett_funz = :prog
                  and a.nome_funz = :nome
                  and b.nome_funz = a.nome_funz
                  and e.id_utente = :id_utente
                  and d.settore   = e.id_settore
                  and d.ruolo     = e.id_ruolo
                  and c.livello   = b.livello
                  and c.scelta_1  = b.scelta_1 
                  and c.scelta_2  = b.scelta_2 
                  and c.scelta_3  = b.scelta_3
                  and c.scelta_4  = b.scelta_4
                  and c.nome_menu = d.nome_menu
                group by a.dett_funz, a.nome_funz, c.lvl, e.livello
       </querytext>
    </fullquery>

    <fullquery name="iter_selbox_from_table.sel_lol_2">
       <querytext>
                    select $key_description
                         , $table_key
                      from $table_name
                     order by $key_orderby
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_manu.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_comu.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_comu.sel_cod_comune">
       <querytext>
           select cod_comune
	   from coimcomu
	   where denominazione = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_modh.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_enve.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_opve.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_coop_resp.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_coop_modh.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>

    <fullquery name="iter_check_uten_coop_rappv.check_uten">
       <querytext>
            select a.nome_menu
              from coimprof a
                 , coimuten b 
             where a.settore = b.id_settore 
               and a.ruolo   = b.id_ruolo 
               and b.id_utente = :id_utente
       </querytext>
    </fullquery>


    <fullquery name="iter_selbox_from_table_obblig.sel_lol_2_ob">
       <querytext>
                    select $key_description
                         , $table_key
                      from $table_name
                     order by $key_orderby
       </querytext>
    </fullquery>

    <fullquery name="iter_selbox_from_2table.sel_2lol_2">
       <querytext>
                    select b.$key_description2||' - '||a.$key_description
                         , a.$table_key
                      from $table_name a
                         , $table_name2 b
                     where b.$table_key2 = a.$table_key2
                     order by $key_orderby
       </querytext>
    </fullquery>

    <fullquery name="iter_radio_from_table.sel_lol">
       <querytext>
               select $key_description
                    , $table_key
                 from $table_name a
                order by a.$key_orderby                    
       </querytext>
    </fullquery>

    <fullquery name="iter_selbox_from_comu.sel_lol_comu">
       <querytext>
                    select $key_description
                         , $table_key
                      from $table_name
                     $where_condition
                     order by $key_orderby
       </querytext>
    </fullquery>

    <fullquery name="iter_selbox_from_cqua.sel_lol_cqua">
       <querytext>
                    select $key_description
                         , $table_key
                      from $table_name
                     $where_condition
                     order by $key_orderby
       </querytext>
    </fullquery>

    <fullquery name="iter_selbox_from_curb.sel_lol_curb">
       <querytext>
                    select $key_description
                         , $table_key
                      from $table_name
                     $where_condition
                     order by $key_orderby
       </querytext>
    </fullquery>

    <fullquery name="iter_get_coimtgen.sel_tgen">
       <querytext> 
                    select valid_mod_h
                         , gg_comunic_mod_h
                         , flag_ente
                         , cod_prov
                         , cod_comu
                         , flag_viario
                         , flag_mod_h_b
                         , valid_mod_h_b
                         , gg_comunic_mod_h_b
                         , gg_conferma_inco
                         , gg_scad_pag_mh
                         , gg_scad_pag_rv
                         , (mesi_evidenza_mod * -1) as mesi_evidenza_mod
			 , flag_agg_sogg
                         , flag_dt_scad
			 , flag_agg_da_verif
			 , flag_cod_aimp_auto
                         , flag_gg_modif_mh
                         , flag_gg_modif_rv
                         , gg_adat_anom_oblig
                         , gg_adat_anom_autom
                         , popolaz_citt_tgen
                         , popolaz_aimp_tgen
                         , flag_aimp_citt_estr
                         , flag_stat_estr_calc
			 , flag_cod_via_auto
                         , link_cap
                         , flag_enti_compet
                         , flag_master_ente
                         , gb_x
                         , gb_y
                         , delta
                         , google_key
                         , flag_codifica_reg
			 , flag_pesi
			 , flag_sanzioni
			 , flag_avvisi
			 , cod_imst_annu_manu
			 , max_gg_modimp
                         , flag_stp_presso_terzo_resp
                         , flag_portale                -- 11/12/2013
                         , flag_gest_coimmode          -- 03/03/2014
                         , lun_num_cod_imp_est         -- 04/02/2016
                         , flag_potenza                -- 12/02/2016
                         , flag_portafoglio            -- 07/03/2016
                         , flag_gest_targa             -- 06/09/2016
                         , flag_gest_rcee_legna        -- 20/02/2017
			 , flag_verifica_impianti      -- 30/06/2017
                         , flag_obbligo_dati_catastali -- sim07
			 , flag_controllo_abilitazioni -- 30/11/2020 LUCAR.
                         , login_spid_p                -- 19/03/2021 LUCAR.
			 , flag_firma_manu_stampa_rcee --rom14 23/11/2022
			 , flag_firma_resp_stampa_rcee --rom14 23/11/2022
			 , flag_firma_ispe_stampa_cimp --rom15 12/04/2023
			 , flag_firma_resp_stampa_cimp --rom15 12/04/2023
			 , flag_asse_data              --rom18 18/09/2023
			 , flag_cind                   --rom20 23/05/2024
			 , protocollo_automatico_ente  --rom21 21/03/2025
                      from coimtgen
                     where cod_tgen = '1'
       </querytext>
    </fullquery>

    <fullquery name="iter_get_coimtgen.sel_tgen_prov">
       <querytext>
                    select sigla as sigla_prov
                         , cod_regione
                      from coimprov
                     where cod_provincia = :cod_prov
       </querytext>
    </fullquery>

    <fullquery name="iter_get_coimtgen.sel_tgen_comu">
       <querytext>
                    select denominazione as denom_comu
                      from coimcomu
                     where cod_comune = :cod_comu
       </querytext>
    </fullquery>

    <fullquery name="iter_get_nomefunz.count_nome_funz">
       <querytext>
        select count(*) as conta_nome_funz
          from coimfunz
         where dett_funz = :nome_prog
       </querytext>
    </fullquery>

    <fullquery name="iter_get_nomefunz.get_nome_funz">
       <querytext>
        select nome_funz
          from coimfunz
         where dett_funz = :nome_prog
       </querytext>
    </fullquery>

    <fullquery name="iter_get_pgm.sel_funz">
       <querytext>
                   select azione
                        , dett_funz as det
                        , parametri
                     from coimfunz
                    where nome_funz = :nome_funz
                      and tipo_funz = 'primario'
       </querytext>
    </fullquery>

    <fullquery name="iter_get_coimdesc.sel_desc">
       <querytext> 
                    select nome_ente
                         , tipo_ufficio
                         , assessorato
                         , indirizzo
                         , telefono
                         , resp_uff
                         , uff_info
                         , dirigente
			 , email --rom01
                      from coimdesc
                     where cod_desc = '1'
       </querytext>
    </fullquery>

    <fullquery name="iter_delete_permanenti.sel_esit">
       <querytext>
           select b.cod_batc
                , b.ctr
                , b.pat
             from coimbatc a
                , coimesit b
            where a.dat_fine <  :dat_fine
	      and b.cod_batc = a.cod_batc
       </querytext>
    </fullquery>

    <fullquery name="iter_delete_permanenti.del_esit">
       <querytext>
           delete
             from coimesit
            where cod_batc = :cod_batc
              and ctr      = :ctr
       </querytext>
    </fullquery>

    <fullquery name="iter_delete_permanenti.del_batc">
       <querytext>
           delete
             from coimbatc
            where dat_fine < :dat_fine
       </querytext>
    </fullquery>

    <fullquery name="iter_lancia_batch.sel_batc">
       <querytext> 
            select cod_batc
                 , nom_prog
                 , par
              from coimbatc
             where flg_stat = 'A'
               and (
                       (    dat_prev  = :current_date
                        and ora_prev <= :current_time)

                    or  dat_prev     <  :current_date
                   )
          order by dat_prev
                 , ora_prev
                 , cod_batc
       </querytext>
    </fullquery>

    <fullquery name="iter_lancia_batch.sel_count_batc">
       <querytext> 
           select count(*) as conta_batc
             from coimbatc
            where nom_prog = :nom_prog
              and flg_stat = 'B'
       </querytext> 
    </fullquery>

    <partialquery name="iter_batch_upd_flg_sta.upd_iniz">
       <querytext> 
           update coimbatc 
              set flg_stat = 'B'
                , dat_iniz = :current_date
                , ora_iniz = :current_time
            where cod_batc = :cod_batc
       </querytext> 
    </partialquery>

    <partialquery name="iter_batch_upd_flg_sta.upd_fine">
       <querytext> 
           update coimbatc 
              set flg_stat = 'C'
                , dat_fine = :current_date
                , ora_fine = :current_time
            where cod_batc = :cod_batc
       </querytext> 
    </partialquery>

    <partialquery name="iter_batch_upd_flg_sta.upd_abend">
       <querytext> 
           update coimbatc 
              set flg_stat = 'D'
                , dat_fine = :current_date
                , ora_fine = :current_time
            where cod_batc = :cod_batc
       </querytext> 
    </partialquery>

    <partialquery name="iter_batch_upd_flg_sta.ins_esit">
       <querytext>
            insert
              into coimesit 
                 ( cod_batc
                 , ctr
                 , nom
                 , url
                 , pat
                 )
            values
                 (:cod_batc
                 ,:ctr
                 ,:nom
                 ,:url
                 ,:pat
                 )
       </querytext>
    </partialquery>

    <fullquery name="sel_gend">
       <querytext>
       select case when data_installaz = null then 'f' else 't' end                       as data_installaz
            , coalesce(cod_cost, 'f')                                                     as cod_cost
            , coalesce(modello, 'f')                                                      as modello 
            , coalesce(matricola, 'f')                                                    as matricola 
            , coalesce(cod_combustibile, 'f')                                             as cod_combustibile 
            , case when num_prove_fumi = null or num_prove_fumi = 0 then 'f' else 't' end as num_prove_fumi
            , case when num_circuiti   = null or num_circuiti   = 0 then 'f' else 't' end as num_circuiti 
            , coalesce(mod_funz, 'f')                                                     as mod_funz
            , case when pot_focolare_nom     = null then 'f' else 't' end                 as pot_focolare_nom
            , case when pot_utile_nom        = null then 'f' else 't' end                 as pot_utile_nom
            , case when pot_focolare_lib     = null then 'f' else 't' end                 as pot_focolare_lib 
            , case when pot_utile_lib        = null then 'f' else 't' end                 as pot_utile_lib     
            , case when pot_utile_nom_freddo = null then 'f' else 't' end                 as pot_utile_nom_freddo
            , case when rend_ter_max = null then 'f' else 't' end                         as rend_ter_max 
            , coalesce(marc_effic_energ, 'f')                                             as marc_effic_energ 
            , case when data_costruz_gen = null then 'f' else 't' end                     as data_costruz_gen 
            , coalesce(locale, 'f')                                                       as locale
            , coalesce(tipo_foco, 'f')                                                    as tipo_foco 
            , coalesce(dpr_660_96, 'f')                                                   as dpr_660_96 
            , coalesce(tiraggio, 'f')                                                     as tiraggio 
            , coalesce(tipologia_cogenerazione, 'f')                                      as tipologia_cogenerazione
            , coalesce(flag_prod_acqua_calda, 'f')                                        as flag_prod_acqua_calda 
            , coalesce(flag_clima_invernale, 'f')                                         as flag_clima_invernale
            , coalesce(flag_clim_est, 'f')                                                as flag_clim_est
            , coalesce(tel_alimentazione, 'f')                                            as tel_alimentazione
            , coalesce(cod_flre, 'f')                                                     as cod_flre
            , coalesce(sorgente_lato_esterno, 'f')                                        as sorgente_lato_esterno
            , coalesce(fluido_lato_utenze, 'f')                                           as fluido_lato_utenze
            , coalesce(cod_tpco, 'f')                                                     as cod_tpco
            , case when per = null then 'f' then 't' end                                  as per
            , case when cop = null then 'f' then 't' end                                  as cop
         from coimgend
        where cod_impianto = :cod_impianto
       </querytext> 
    </fullquery>

    <fullquery name="sel_aimp">
       <querytext>
       select case when data_libretto = null then 'f' else 't' end  as data_libretto
            , coalesce(tipologia_intervento, 'f')                   as tipologia_intervento
            , coalesce(tipologia_generatore, 'f')                   as tipologia_generatore
            , coalesce(flag_resp, 'f')                              as flag_responsabile
            , coalesce(cod_proprietario, 'f')                       as cod_proprietario
            , coalesce(cod_occupante, 'f')                          as cod_occupante
            , coalesce(cod_amministratore, 'f')                     as cod_amministratore
            , coalesce(pod, 'f')                                    as pod
            , coalesce(pdr, 'f')                                    as pdr
            , coalesce(cod_tpim, 'f')                               as cod_tpim
            , coalesce (unita_immobiliari_servite, 'f')             as unita_immobiliari_servite
            , case when data_installaz = null then 'f' else 't' end as data_installaz
	    , flag_tipo_impianto
         from coimaimp
        where cod_impianto = :cod_impianto
       </querytext> 
    </fullquery>


</queryset>
