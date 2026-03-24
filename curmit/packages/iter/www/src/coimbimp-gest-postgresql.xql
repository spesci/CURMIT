<?xml version="1.0"?>
<!-- 
     ric01 08/09/2025 Aggiunta update upd_aimp_destinazione per punto 16 MEV regione marche.

     gab01 31/10/2016 Aggiunta bonifica dei dati delle sezioni: 4.3, 4.7, 4.8, 6, 7, 8.1, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 10.1
     gab01            del libretto.
 
     nic01 19/02/2014 Su richiesta di UCIT, vanno copiati anche i record della tab. coimnoveb
     nic01            Inoltre, Sandro vuole aggiungere alle note degli impianti bonificati
     nic01            la dicitura "Bonificato il dd/mm/yyyy; codice dell impianto di
     nic01            destinazione: cod_impianto_est"

     dpr74 21/02/2014 Aggiungo le nuove colonne che sono state aggiunte per il dpr74
     dpr74            Questo xql è identico a coimbimp-gest ed a coimdimp-ins-gest
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_aimp_vie">
       <querytext>
           select a.cod_impianto
                , a.numero
                , c.denominazione       as comune
                , coalesce(d.descr_topo,'')||' '||
                  coalesce(d.descrizione,'')||
                  case
                    when a.numero is null then ''
                    else ', '||a.numero
                  end ||
                  case
                    when a.esponente is null then ''
                    else '/'||a.esponente
                  end ||
                  case
                    when a.scala is null then ''
                    else ' S.'||a.scala
                  end ||
                  case
                    when a.piano is null then ''
                    else ' P.'||a.piano
                  end ||
                  case
                    when a.interno is null then ''
                    else ' In.'||a.interno
                  end
                                        as indir
                , d.descrizione as via
                , coalesce(b.cognome,' ')||' '||coalesce(b.nome,' ')   as resp
                , b.cognome 
                , b.nome
             from coimaimp a
   $citt_join_pos coimcitt b on b.cod_cittadino = a.cod_responsabile
  left outer join coimcomu c on c.cod_comune    = a.cod_comune
  left outer join coimviae d on d.cod_comune    = a.cod_comune
              and d.cod_via      = a.cod_via
            where a.cod_impianto = :cod_impianto
	   $ordinamento
       </querytext>
    </fullquery>


    <fullquery name="sel_aimp_no_vie">
       <querytext>
           select a.cod_impianto
                , a.numero
                , c.denominazione       as comune
                , coalesce(a.toponimo,'')||' '||
                  coalesce(a.indirizzo,'')||
                  case
                    when a.numero is null then ''
                    else ', '||a.numero
                  end ||
                  case
                    when a.esponente is null then ''
                    else '/'||a.esponente
                  end ||
                  case
                    when a.scala is null then ''
                    else ' S.'||a.scala
                  end ||
                  case
                    when a.piano is null then ''
                    else ' P.'||a.piano
                  end ||
                  case
                    when a.interno is null then ''
                    else ' In.'||a.interno
                  end
                              as indir
                , a.indirizzo as via
                , coalesce(b.cognome)||' '||coalesce(b.nome,' ')   as resp
                , b.cognome 
                , b.nome 

             from coimaimp a
   $citt_join_pos coimcitt b on b.cod_cittadino = a.cod_responsabile
  left outer join coimcomu c on c.cod_comune    = a.cod_comune

            where a.cod_impianto = :cod_impianto
           $ordinamento
       </querytext>
    </fullquery>

    <partialquery name="upd_aimp">
       <querytext>
          update coimaimp
	     set stato = 'L'
	       , note  = :note -- nic01
           where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_destinazione">
      <querytext>
        update coimaimp
	   set note  = :note_destinazione 
         where cod_impianto = :destinazione
      </querytext>
    </partialquery>
    
    <fullquery name="sel_cimp_cod_new">
        <querytext>
	  select nextval('coimcimp_s') as cod_cimp_new
        </querytext>
    </fullquery>

    <partialquery name="ins_cimp">
       <querytext>
        insert into coimcimp 
                  (cod_cimp
                 , cod_impianto
                 , cod_documento
                 , gen_prog
                 , cod_inco
                 , data_controllo
                 , ora_inizio
                 , ora_fine
                 , verb_n
                 , data_verb
                 , cod_opve
                 , costo
                 , nominativo_pres
                 , presenza_libretto
                 , libretto_corretto
                 , dich_conformita
                 , libretto_manutenz
                 , mis_port_combust
                 , mis_pot_focolare
                 , stato_coiben
                 , stato_canna_fum
                 , verifica_dispo
                 , verifica_areaz
                 , taratura_dispos
                 , co_fumi_secchi
                 , ppm
                 , eccesso_aria_perc
                 , perdita_ai_fumi
                 , rend_comb_conv
                 , rend_comb_min
                 , temp_fumi_1a
                 , temp_fumi_2a
                 , temp_fumi_3a
                 , temp_fumi_md
                 , t_aria_comb_1a
                 , t_aria_comb_2a
                 , t_aria_comb_3a
                 , t_aria_comb_md
                 , temp_mant_1a
                 , temp_mant_2a
                 , temp_mant_3a
                 , temp_mant_md
                 , temp_h2o_out_1a
                 , temp_h2o_out_2a
                 , temp_h2o_out_3a
                 , temp_h2o_out_md
                 , co2_1a
                 , co2_2a
                 , co2_3a
                 , co2_md
                 , o2_1a
                 , o2_2a
                 , o2_3a
                 , o2_md
                 , co_1a
                 , co_2a
                 , co_3a
                 , co_md
                 , indic_fumosita_1a
                 , indic_fumosita_2a
                 , indic_fumosita_3a
                 , indic_fumosita_md
                 , manutenzione_8a
                 , co_fumi_secchi_8b
                 , indic_fumosita_8c
                 , rend_comb_8d
                 , esito_verifica
                 , strumento
                 , note_verificatore
                 , note_resp
                 , note_conf
                 , tipologia_costo
                 , riferimento_pag
                 , utente
                 , data_ins
                 , data_mod
                 , pot_utile_nom
                 , pot_focolare_nom
                 , cod_combustibile
                 , cod_responsabile
                 , flag_cpi
                 , flag_ispes
                 , flag_pericolosita
                 , flag_tracciato
                 , new1_data_dimp
                 , new1_data_paga_dimp
                 , new1_conf_locale
                 , new1_conf_accesso
                 , new1_pres_intercet
                 , new1_pres_interrut
                 , new1_asse_mate_estr
                 , new1_pres_mezzi
                 , new1_pres_cartell
                 , new1_disp_regolaz
                 , new1_foro_presente
                 , new1_foro_corretto
                 , new1_foro_accessibile
                 , new1_canali_a_norma
                 , new1_lavoro_nom_iniz
                 , new1_lavoro_nom_fine
                 , new1_lavoro_lib_iniz
                 , new1_lavoro_lib_fine
                 , new1_note_manu
                 , new1_dimp_pres
                 , new1_dimp_prescriz
                 , new1_data_ultima_manu
                 , new1_data_ultima_anal
                 , new1_manu_prec_8a
                 , new1_co_rilevato
                 , new1_flag_peri_8p
                 , flag_uso
                 , flag_diffida
                 , eccesso_aria_perc_2a
                 , eccesso_aria_perc_3a
                 , eccesso_aria_perc_md
                 , n_prot
                 , data_prot
                 , sezioni_corr
                 , curve_corr
                 , lungh_corr
                 , riflussi_loc
                 , perdite_cond
                 , disp_funz
                 , assenza_fughe
                 , effic_evac
                 , autodich
                 , dich_conf
                 , manut_prog
                 , marca_strum
                 , modello_strum
                 , matr_strum
                 , dt_tar_strum
                 , indice_aria
                 , perd_cal_sens
                 , doc_ispesl
                 , doc_prev_incendi
                 , libr_manut_bruc
                 , ubic_locale_norma
                 , disp_chius_porta
                 , spazi_norma
                 , apert_soffitto
                 , rubin_manuale_acces
                 , assenza_app_peric
                 , rubin_chiuso
                 , elettrovalv_esterne
                 , tubaz_press
                 , tolta_tensione
                 , termost_esterno
                 , chiusura_foro
                 , accens_funz_gen
                 , pendenza
                 , ventilaz_lib_ostruz
                 , disp_reg_cont_pre
                 , disp_reg_cont_funz
                 , disp_reg_clim_funz
                 , conf_imp_elettrico
                 , volumetria
                 , comsumi_ultima_stag
                 , utente_ins
                 , fl_firma_tecnico
                 , fl_firma_resp
                 , costo_nonreg
                 , f_comunic_cess
                 , stampe_analiz_alleg
                 , fattore_molt
                 , note_strum
                 , prod_h2o_sanit
                 , note_analisi_no_eff
                 , altre_difformita
                 , utente_pres
                 , delegato_ragsoc
                 , delegato_indirizzo
                 , data_arrivo
                 , note_esamevisivo_locale
                 , flag_sbocco_tetto
                 , flag_unicig_7129
                 , new1_data_ultima_manu_2
                 , new1_data_ultima_manu_3
                 , new1_data_ultima_anal_2
                 , new1_data_ultima_anal_3
                 , new1_dimp_pres_2
                 , new1_dimp_pres_3
                 , trasf_centr_aut
                 , igni_progressivo
                 , scarico_tetto
                 , scarico_parete
                 , cod_noin
                 , cod_sanzione_1
                 , cod_sanzione_2
                 , tiraggio
                 , cod_strumento_01 
                 , cod_strumento_02
                 , riferimento_pag_bollini
                 , scarico_dir_esterno
                 , rend_suff_insuff
                 , dichiarato
                 , et
                 , fl_rifiuto_firma
                 , imp_boll_ver
                 , numfatt
                 , data_fatt
                 , data_284      -- dpr74
                 , flag_pres_284 -- dpr74
                 , flag_comp_284 -- dpr74
                 )
           (select :cod_cimp_new
                 , :cod_impianto_new
                 , cod_documento
                 , gen_prog
                 , cod_inco
                 , data_controllo
                 , ora_inizio
                 , ora_fine
                 , verb_n
                 , data_verb
                 , cod_opve
                 , costo
                 , nominativo_pres
                 , presenza_libretto
                 , libretto_corretto
                 , dich_conformita
                 , libretto_manutenz
                 , mis_port_combust
                 , mis_pot_focolare
                 , stato_coiben
                 , stato_canna_fum
                 , verifica_dispo
                 , verifica_areaz
                 , taratura_dispos
                 , co_fumi_secchi
                 , ppm
                 , eccesso_aria_perc
                 , perdita_ai_fumi
                 , rend_comb_conv
                 , rend_comb_min
                 , temp_fumi_1a
                 , temp_fumi_2a
                 , temp_fumi_3a
                 , temp_fumi_md
                 , t_aria_comb_1a
                 , t_aria_comb_2a
                 , t_aria_comb_3a
                 , t_aria_comb_md
                 , temp_mant_1a
                 , temp_mant_2a
                 , temp_mant_3a
                 , temp_mant_md
                 , temp_h2o_out_1a
                 , temp_h2o_out_2a
                 , temp_h2o_out_3a
                 , temp_h2o_out_md
                 , co2_1a
                 , co2_2a
                 , co2_3a
                 , co2_md
                 , o2_1a
                 , o2_2a
                 , o2_3a
                 , o2_md
                 , co_1a
                 , co_2a
                 , co_3a
                 , co_md
                 , indic_fumosita_1a
                 , indic_fumosita_2a
                 , indic_fumosita_3a
                 , indic_fumosita_md
                 , manutenzione_8a
                 , co_fumi_secchi_8b
                 , indic_fumosita_8c
                 , rend_comb_8d
                 , esito_verifica
                 , strumento
                 , note_verificatore
                 , note_resp
                 , note_conf
                 , tipologia_costo
                 , riferimento_pag
                 , utente
                 , current_date
                 , null
                 , pot_utile_nom
                 , pot_focolare_nom
                 , cod_combustibile
                 , cod_responsabile
                 , flag_cpi
                 , flag_ispes
                 , flag_pericolosita
                 , flag_tracciato
                 , new1_data_dimp
                 , new1_data_paga_dimp
                 , new1_conf_locale
                 , new1_conf_accesso
                 , new1_pres_intercet
                 , new1_pres_interrut
                 , new1_asse_mate_estr
                 , new1_pres_mezzi
                 , new1_pres_cartell
                 , new1_disp_regolaz
                 , new1_foro_presente
                 , new1_foro_corretto
                 , new1_foro_accessibile
                 , new1_canali_a_norma
                 , new1_lavoro_nom_iniz
                 , new1_lavoro_nom_fine
                 , new1_lavoro_lib_iniz
                 , new1_lavoro_lib_fine
                 , new1_note_manu
                 , new1_dimp_pres
                 , new1_dimp_prescriz
                 , new1_data_ultima_manu
                 , new1_data_ultima_anal
                 , new1_manu_prec_8a
                 , new1_co_rilevato
                 , new1_flag_peri_8p
                 , flag_uso
                 , flag_diffida
                 , eccesso_aria_perc_2a
                 , eccesso_aria_perc_3a
                 , eccesso_aria_perc_md
                 , n_prot
                 , data_prot
                 , sezioni_corr
                 , curve_corr
                 , lungh_corr
                 , riflussi_loc
                 , perdite_cond
                 , disp_funz
                 , assenza_fughe
                 , effic_evac
                 , autodich
                 , dich_conf
                 , manut_prog
                 , marca_strum
                 , modello_strum
                 , matr_strum
                 , dt_tar_strum
                 , indice_aria
                 , perd_cal_sens
                 , doc_ispesl
                 , doc_prev_incendi
                 , libr_manut_bruc
                 , ubic_locale_norma
                 , disp_chius_porta
                 , spazi_norma
                 , apert_soffitto
                 , rubin_manuale_acces
                 , assenza_app_peric
                 , rubin_chiuso
                 , elettrovalv_esterne
                 , tubaz_press
                 , tolta_tensione
                 , termost_esterno
                 , chiusura_foro
                 , accens_funz_gen
                 , pendenza
                 , ventilaz_lib_ostruz
                 , disp_reg_cont_pre
                 , disp_reg_cont_funz
                 , disp_reg_clim_funz
                 , conf_imp_elettrico
                 , volumetria
                 , comsumi_ultima_stag
                 , utente
                 , fl_firma_tecnico
                 , fl_firma_resp
                 , costo_nonreg
                 , f_comunic_cess
                 , stampe_analiz_alleg
                 , fattore_molt
                 , note_strum
                 , prod_h2o_sanit
                 , note_analisi_no_eff
                 , altre_difformita
                 , utente_pres
                 , delegato_ragsoc
                 , delegato_indirizzo
                 , data_arrivo
                 , note_esamevisivo_locale
                 , flag_sbocco_tetto
                 , flag_unicig_7129
                 , new1_data_ultima_manu_2
                 , new1_data_ultima_manu_3
                 , new1_data_ultima_anal_2
                 , new1_data_ultima_anal_3
                 , new1_dimp_pres_2
                 , new1_dimp_pres_3
                 , trasf_centr_aut
                 , igni_progressivo
                 , scarico_tetto
                 , scarico_parete
                 , cod_noin
                 , cod_sanzione_1
                 , cod_sanzione_2
                 , tiraggio
                 , cod_strumento_01 
                 , cod_strumento_02
                 , riferimento_pag_bollini
                 , scarico_dir_esterno
                 , rend_suff_insuff
                 , dichiarato
                 , et
                 , fl_rifiuto_firma
                 , imp_boll_ver
                 , numfatt
                 , data_fatt
                 , data_284      -- dpr74
                 , flag_pres_284 -- dpr74
                 , flag_comp_284 -- dpr74
              from coimcimp
             where cod_impianto = :cod_impianto
               and cod_cimp     = :cod_cimp)
       </querytext>
    </partialquery>

    <partialquery name="ins_coma">
       <querytext>
           insert into coimcoma 
                ( cod_impianto
                , cod_manutentore
                , data_ini_valid
                , data_fin_valid
                , note
                , data_ins
                , data_mod
                , utente
                )
          (select :cod_impianto_new
                , cod_manutentore
                , data_ini_valid
                , data_fin_valid
                , note
                , current_date
                , null
                , :id_utente
             from coimcoma
            where cod_impianto = :cod_impianto)
       </querytext>
    </partialquery>

    <fullquery name="sel_dimp_cod_new">
        <querytext>
  	    select nextval('coimdimp_s') as cod_dimp_new
        </querytext>
    </fullquery>

    <partialquery name="ins_dimp">
       <querytext>
           insert into coimdimp 
                  ( cod_dimp
                  , cod_impianto
                  , data_controllo
                  , gen_prog
                  , cod_manutentore
                  , cod_responsabile
                  , cod_proprietario
                  , cod_occupante
                  , cod_documento
                  , flag_status
                  , garanzia
                  , conformita
                  , lib_impianto
                  , lib_uso_man
                  , inst_in_out
                  , idoneita_locale
                  , ap_ventilaz
                  , ap_vent_ostruz
                  , pendenza
                  , sezioni
                  , curve
                  , lunghezza
                  , conservazione
                  , scar_ca_si
                  , scar_parete
                  , riflussi_locale
                  , assenza_perdite
                  , pulizia_ugelli
                  , antivento
                  , scambiatore
                  , accens_reg
                  , disp_comando
                  , ass_perdite
                  , valvola_sicur
                  , vaso_esp
                  , disp_sic_manom
                  , organi_integri
                  , circ_aria
                  , guarn_accop
                  , assenza_fughe
                  , coibentazione
                  , eff_evac_fum
                  , cont_rend
                  , pot_focolare_mis
                  , portata_comb_mis
                  , temp_fumi
                  , temp_ambi
                  , o2
                  , co2
                  , bacharach
                  , co
                  , rend_combust
                  , osservazioni
                  , raccomandazioni
                  , prescrizioni
                  , data_utile_inter
                  , n_prot
                  , data_prot
                  , delega_resp
                  , delega_manut
                  , num_bollo
                  , costo
                  , tipologia_costo
                  , riferimento_pag
                  , utente
                  , data_ins
                  , data_mod
                  , potenza
                  , flag_pericolosita
                  , flag_co_perc
                  , flag_tracciato
                  , cod_docu_distinta
                  , scar_can_fu
                  , tiraggio
                  , ora_inizio
                  , ora_fine
                  , rapp_contr
                  , rapp_contr_note
                  , certificaz
                  , certificaz_note
                  , dich_conf
                  , dich_conf_note
                  , libretto_bruc
                  , libretto_bruc_note
                  , prev_incendi
                  , prev_incendi_note
                  , lib_impianto_note
                  , ispesl
                  , ispesl_note
                  , data_scadenza
                  , num_autocert
                  , esame_vis_l_elet
                  , funz_corr_bruc
                  , lib_uso_man_note
                  , volimetria_risc
                  , consumo_annuo
                  , cod_opmanu
                  , utente_ins
                  , data_arrivo_ente
                  , fl_firma_tecnico
                  , fl_firma_resp 
                  , igni_progressivo
                  , cod_opmanu_new
                  , consumo_annuo2
                  , stagione_risc
                  , stagione_risc2
                  , schemi_funz_idr
                  , schemi_funz_ele
                  , schemi_funz_idr_note
                  , schemi_funz_ele_note
                  , cod_distributore
                  , tariffa
                  , importo_tariffa
                  , stato_dich
                  , cod_dimp_stn
                  , motivo_storno
                  , cod_cind
                  , rct_dur_acqua             -- dpr74
                  , rct_tratt_in_risc         -- dpr74
                  , rct_tratt_in_acs          -- dpr74
                  , rct_install_interna       -- dpr74
                  , rct_install_esterna       -- dpr74
                  , rct_canale_fumo_idoneo    -- dpr74
                  , rct_sistema_reg_temp_amb  -- dpr74
                  , rct_assenza_per_comb      -- dpr74
                  , rct_idonea_tenuta         -- dpr74
                  , rct_scambiatore_lato_fumi -- dpr74
                  , rct_riflussi_comb         -- dpr74
                  , rct_uni_10389             -- dpr74
                  , rct_rend_min_legge        -- dpr74
                  , rct_check_list_1          -- dpr74
                  , rct_check_list_2          -- dpr74
                  , rct_check_list_3          -- dpr74
                  , rct_check_list_4          -- dpr74            
                  , rct_gruppo_termico        -- dpr74
                  , rct_valv_sicurezza        -- dpr74
                  , rct_lib_uso_man_comp      -- dpr74
                  , fr_linee_ele              -- dpr74
                  , fr_coibentazione          -- dpr74
                  , fr_assorb_recupero        -- dpr74
                  , fr_assorb_fiamma          -- dpr74
                  , fr_ciclo_compressione     -- dpr74
                  , fr_assenza_perdita_ref    -- dpr74
                  , fr_leak_detector          -- dpr74
                  , fr_pres_ril_fughe         -- dpr74
                  , fr_scambiatore_puliti     -- dpr74
                  , fr_prova_modalita         -- dpr74
                  , fr_surrisc                -- dpr74
                  , fr_sottoraff              -- dpr74
                  , fr_tcondens               -- dpr74
                  , fr_tevapor                -- dpr74
                  , fr_t_ing_lato_est         -- dpr74
                  , fr_t_usc_lato_est         -- dpr74
                  , fr_t_ing_lato_ute         -- dpr74
                  , fr_t_usc_lato_ute         -- dpr74
                  , fr_nr_circuito            -- dpr74
                  , fr_check_list_1           -- dpr74
                  , fr_check_list_2           -- dpr74
                  , fr_check_list_3           -- dpr74
                  , fr_check_list_4           -- dpr74
                  )
           (select :cod_dimp_new
                  ,:cod_impianto_new
                  , data_controllo
                  , gen_prog
                  , cod_manutentore
                  , cod_responsabile
                  , cod_proprietario
                  , cod_occupante
                  , cod_documento
                  , flag_status
                  , garanzia
                  , conformita
                  , lib_impianto
                  , lib_uso_man
                  , inst_in_out
                  , idoneita_locale
                  , ap_ventilaz
                  , ap_vent_ostruz
                  , pendenza
                  , sezioni
                  , curve
                  , lunghezza
                  , conservazione
                  , scar_ca_si
                  , scar_parete
                  , riflussi_locale
                  , assenza_perdite
                  , pulizia_ugelli
                  , antivento
                  , scambiatore
                  , accens_reg
                  , disp_comando
                  , ass_perdite
                  , valvola_sicur
                  , vaso_esp
                  , disp_sic_manom
                  , organi_integri
                  , circ_aria
                  , guarn_accop
                  , assenza_fughe
                  , coibentazione
                  , eff_evac_fum
                  , cont_rend
                  , pot_focolare_mis
                  , portata_comb_mis
                  , temp_fumi
                  , temp_ambi
                  , o2
                  , co2
                  , bacharach
                  , co
                  , rend_combust
                  , osservazioni
                  , raccomandazioni
                  , prescrizioni
                  , data_utile_inter
                  , n_prot
                  , data_prot
                  , delega_resp
                  , delega_manut
                  , num_bollo
                  , costo
                  , tipologia_costo
                  , riferimento_pag
                  , utente
                  , data_ins
                  , data_mod
                  , potenza
                  , flag_pericolosita
                  , flag_co_perc
                  , flag_tracciato
                  , cod_docu_distinta
                  , scar_can_fu
                  , tiraggio
                  , ora_inizio
                  , ora_fine
                  , rapp_contr
                  , rapp_contr_note
                  , certificaz
                  , certificaz_note
                  , dich_conf
                  , dich_conf_note
                  , libretto_bruc
                  , libretto_bruc_note
                  , prev_incendi
                  , prev_incendi_note
                  , lib_impianto_note
                  , ispesl
                  , ispesl_note
                  , data_scadenza
                  , num_autocert
                  , esame_vis_l_elet
                  , funz_corr_bruc
                  , lib_uso_man_note
                  , volimetria_risc
                  , consumo_annuo
                  , cod_opmanu
                  , utente_ins
                  , data_arrivo_ente
                  , fl_firma_tecnico
                  , fl_firma_resp
                  , igni_progressivo
                  , cod_opmanu_new
                  , consumo_annuo2
                  , stagione_risc
                  , stagione_risc2
                  , schemi_funz_idr
                  , schemi_funz_ele
                  , schemi_funz_idr_note
                  , schemi_funz_ele_note
                  , cod_distributore
                  , tariffa
                  , importo_tariffa
                  , stato_dich
                  , cod_dimp_stn
                  , motivo_storno
                  , cod_cind
                  , rct_dur_acqua             -- dpr74
                  , rct_tratt_in_risc         -- dpr74
                  , rct_tratt_in_acs          -- dpr74
                  , rct_install_interna       -- dpr74
                  , rct_install_esterna       -- dpr74
                  , rct_canale_fumo_idoneo    -- dpr74
                  , rct_sistema_reg_temp_amb  -- dpr74
                  , rct_assenza_per_comb      -- dpr74
                  , rct_idonea_tenuta         -- dpr74
                  , rct_scambiatore_lato_fumi -- dpr74
                  , rct_riflussi_comb         -- dpr74
                  , rct_uni_10389             -- dpr74
                  , rct_rend_min_legge        -- dpr74
                  , rct_check_list_1          -- dpr74
                  , rct_check_list_2          -- dpr74
                  , rct_check_list_3          -- dpr74
                  , rct_check_list_4          -- dpr74            
                  , rct_gruppo_termico        -- dpr74
                  , rct_valv_sicurezza        -- dpr74
                  , rct_lib_uso_man_comp      -- dpr74
                  , fr_linee_ele              -- dpr74
                  , fr_coibentazione          -- dpr74
                  , fr_assorb_recupero        -- dpr74
                  , fr_assorb_fiamma          -- dpr74
                  , fr_ciclo_compressione     -- dpr74
                  , fr_assenza_perdita_ref    -- dpr74
                  , fr_leak_detector          -- dpr74
                  , fr_pres_ril_fughe         -- dpr74
                  , fr_scambiatore_puliti     -- dpr74
                  , fr_prova_modalita         -- dpr74
                  , fr_surrisc                -- dpr74
                  , fr_sottoraff              -- dpr74
                  , fr_tcondens               -- dpr74
                  , fr_tevapor                -- dpr74
                  , fr_t_ing_lato_est         -- dpr74
                  , fr_t_usc_lato_est         -- dpr74
                  , fr_t_ing_lato_ute         -- dpr74
                  , fr_t_usc_lato_ute         -- dpr74
                  , fr_nr_circuito            -- dpr74
                  , fr_check_list_1           -- dpr74
                  , fr_check_list_2           -- dpr74
                  , fr_check_list_3           -- dpr74
                  , fr_check_list_4           -- dpr74
               from coimdimp
              where cod_impianto = :cod_impianto
                and cod_dimp     = :cod_dimp)
       </querytext>
    </partialquery>

    <partialquery name="ins_anom">
       <querytext>
           insert into coimanom
                ( cod_cimp_dimp
                , prog_anom
                , tipo_anom
                , cod_tanom
                , dat_utile_inter
                , flag_origine
                , principale
                )
         (select :cod_cimp_dimp_new
                , prog_anom
                , tipo_anom
                , cod_tanom
                , dat_utile_inter
                , flag_origine
                , principale
             from coimanom
            where cod_cimp_dimp = :cod_cimp_dimp)
       </querytext>
    </partialquery>

    <partialquery name="ins_docu">
       <querytext>
           insert into coimdocu
                ( cod_documento
                , tipo_documento
                , tipo_soggetto
                , cod_soggetto
                , cod_impianto
                , data_stampa
                , data_documento
                , data_prot_01
                , protocollo_01
                , data_prot_02
                , protocollo_02
                , flag_notifica
                , data_notifica
                , contenuto
                , tipo_contenuto
                , descrizione
                , note
                , data_ins
                , data_mod
                , utente
                )
          (select nextval('coimdocu_s') as cod_documento
                , tipo_documento
                , tipo_soggetto
                , cod_soggetto
                , :cod_impianto_new
                , data_stampa
                , data_documento
                , data_prot_01
                , protocollo_01
                , data_prot_02
                , protocollo_02
                , flag_notifica
                , data_notifica
                , contenuto
                , tipo_contenuto
                , descrizione
                , note
                , current_date
                , null
                , :id_utente
             from coimdocu
            where cod_impianto = :cod_impianto)
       </querytext>
    </partialquery>

    <partialquery name="upd_gage">
       <querytext>
           update coimgage
              set cod_impianto = :cod_impianto_new
            where cod_impianto = :destinazione
       </querytext>
    </partialquery>

    <partialquery name="ins_gend">
       <querytext>
           insert into coimgend
                ( cod_impianto
                , gen_prog
                , descrizione
                , matricola
                , modello
                , cod_cost
                , matricola_bruc
                , modello_bruc
                , cod_cost_bruc
                , tipo_foco
                , mod_funz
                , cod_utgi
                , tipo_bruciatore
                , tiraggio
                , locale
                , cod_emissione
                , cod_combustibile
                , data_installaz
                , data_rottamaz
                , pot_focolare_lib
                , pot_utile_lib
                , pot_focolare_nom
                , pot_utile_nom
                , flag_attivo
                , note
                , data_ins
                , data_mod
                , utente 
                , gen_prog_est
                , data_costruz_gen
                , data_costruz_bruc
                , data_installaz_bruc
                , data_rottamaz_bruc
                , marc_effic_energ
                , campo_funzion_min
                , campo_funzion_max
                , dpr_660_96
                , utente_ins
                , igni_progressivo
                , portata_comb
                , portata_termica
                , cod_tpco            -- dpr74
                , cod_flre            -- dpr74
                , carica_refrigerante -- dpr74
                , sigillatura_carica  -- dpr74
                , cod_mode
                , cod_mode_bruc
		, cod_grup_term
                )
             (select :cod_impianto_new
                   , gen_prog
                   , descrizione
                   , matricola
                   , modello
                   , cod_cost
                   , matricola_bruc
                   , modello_bruc
                   , cod_cost_bruc
                   , tipo_foco
                   , mod_funz
                   , cod_utgi
                   , tipo_bruciatore
                   , tiraggio
                   , locale
                   , cod_emissione
                   , cod_combustibile
                   , data_installaz
                   , data_rottamaz
                   , pot_focolare_lib
                   , pot_utile_lib
                   , pot_focolare_nom
                   , pot_utile_nom
                   , flag_attivo
                   , note
                   , current_date
                   , null
                   , :id_utente 
                   , gen_prog_est
                   , data_costruz_gen
                   , data_costruz_bruc
                   , data_installaz_bruc
                   , data_rottamaz_bruc
                   , marc_effic_energ
                   , campo_funzion_min
                   , campo_funzion_max
                   , dpr_660_96
                   , :id_utente
                   , igni_progressivo
                   , portata_comb
                   , portata_termica
                   , cod_tpco            -- dpr74
                   , cod_flre            -- dpr74
                   , carica_refrigerante -- dpr74
                   , sigillatura_carica  -- dpr74
                   , cod_mode
                   , cod_mode_bruc
		   , cod_grup_term
                from coimgend
               where cod_impianto = :destinazione)
       </querytext>
    </partialquery>

    <partialquery name="upd_inco">
       <querytext>
          update coiminco
	     set stato = '5'
               , note  = 'Incontro annullato in conseguenza a bonifica'
           where cod_impianto = :cod_impianto
             and stato not in ('5', '8')
       </querytext>
    </partialquery>

    <partialquery name="ins_inco">
       <querytext>
          insert
            into coiminco
               ( cod_inco
               , cod_cinc
               , tipo_estrazione
               , cod_impianto
               , data_estrazione
               , data_assegn
               , cod_opve
               , data_verifica
               , ora_verifica 
               , data_avviso_01
               , cod_documento_01
               , data_avviso_02
               , cod_documento_02
               , stato
               , esito
               , note
               , data_ins
               , data_mod
               , utente
               , tipo_lettera
               , cod_noin
               )
         (select nextval('coiminco_s') as cod_inco
               , cod_cinc
               , tipo_estrazione
               ,:cod_impianto_new
               , data_estrazione
               , data_assegn
               , cod_opve
               , data_verifica
               , ora_verifica 
               , data_avviso_01
               , cod_documento_01
               , data_avviso_02
               , cod_documento_02
               , stato
               , esito
               , note
               , current_date
               , null
               ,:id_utente
               , tipo_lettera
               , cod_noin
            from coiminco
           where cod_impianto = :destinazione)
       </querytext>
    </partialquery>

    <partialquery name="ins_movi">
       <querytext>
          insert into coimmovi
                    ( cod_movi
                    , tipo_movi
                    , cod_impianto
                    , data_scad
                    , importo
                    , importo_pag
                    , data_pag
                    , tipo_pag
                    , data_compet
                    , riferimento
                    , nota
                    , utente
                    , data_ins
                    , data_mod
                    , tipo_soggetto
                    , cod_soggetto
                    , riduzione_importo
                    , cod_sanzione_1
                    , cod_sanzione_2
                    , data_rich_audiz
                    , note_rich_audiz
                    , data_pres_deduz
                    , note_pres_deduz
                    , data_ric_giudice
                    , note_ric_giudice
                    , data_ric_tar
                    , note_ric_tar
                    , data_ric_ulter
                    , note_ric_ulter
                    , data_ruolo
                    , note_ruolo
                    , flag_pagato
                    , contatore
                    , id_caus
                    )
              (select nextval('coimmovi_s') as cod_movi
                    , tipo_movi
                    , :cod_impianto_new
                    , data_scad
                    , importo
                    , importo_pag
                    , data_pag
                    , tipo_pag
                    , data_compet
                    , riferimento
                    , nota
                    , :id_utente
                    , current_date
                    , null
                    , tipo_soggetto
                    , cod_soggetto
                    , riduzione_importo
                    , cod_sanzione_1
                    , cod_sanzione_2
                    , data_rich_audiz
                    , note_rich_audiz
                    , data_pres_deduz
                    , note_pres_deduz
                    , data_ric_giudice
                    , note_ric_giudice
                    , data_ric_tar
                    , note_ric_tar
                    , data_ric_ulter
                    , note_ric_ulter
                    , data_ruolo
                    , note_ruolo
                    , flag_pagato
                    , contatore
                    , id_caus
                 from coimmovi 
                where cod_impianto = :destinazione)
       </querytext>
    </partialquery>

    <partialquery name="ins_prvv">
       <querytext>
          insert into coimprvv
                     ( cod_prvv
                     , causale
                     , cod_impianto
                     , data_provv
                     , cod_documento
                     , nota
                     , utente
                     , data_ins
                     , data_mod
                     )
               (select nextval('coimprvv_s') as cod_prvv
                     , causale
                     , :cod_impianto_new
                     , data_provv
                     , cod_documento
                     , nota
                     , :id_utente
                     , current_date
                     , null   
                  from coimprvv
                 where cod_impianto = :destinazione)
       </querytext>
    </partialquery>

    <partialquery name="ins_rife">
       <querytext>
           insert into coimrife
                    ( cod_impianto
                    , ruolo
                    , data_fin_valid
                    , cod_soggetto
                    , data_ins
                    , data_mod
                    , utente
                    )
              (select :cod_impianto_new
                    , ruolo
                    , data_fin_valid
                    , cod_soggetto
                    , current_date
                    , null
                    , :id_utente  
                 from coimrife 
                where cod_impianto = :destinazione)
       </querytext>
    </partialquery>

    <partialquery name="ins_stub">
       <querytext>
          insert into coimstub
                   ( cod_impianto
                   , data_fin_valid
                   , cod_ubicazione
                   , localita
                   , cod_via
                   , toponimo 
                   , indirizzo
                   , numero
                   , esponente
                   , scala
                   , piano
                   , interno
                   , cod_comune
                   , cod_provincia
                   , cap
                   , cod_catasto
                   , cod_tpdu
                   , cod_qua
                   , cod_urb
                   , data_ins
                   , data_mod
                   , utente
                   )
             (select :cod_impianto_new
                   , data_fin_valid
                   , cod_ubicazione
                   , localita
                   , cod_via
                   , toponimo 
                   , indirizzo
                   , numero
                   , esponente
                   , scala
                   , piano 
                   , interno
                   , cod_comune
                   , cod_provincia
                   , cap
                   , cod_catasto
                   , cod_tpdu
                   , cod_qua
                   , cod_urb
                   , current_date
                   , null
                   , :id_utente 
                from coimstub
               where cod_impianto = :destinazione)
       </querytext>
    </partialquery>


    <partialquery name="ins_todo">
       <querytext>
          insert into coimtodo
                     ( cod_todo
                     , cod_impianto
                     , tipologia
                     , note
                     , cod_cimp_dimp
                     , flag_evasione
                     , data_evasione
                     , data_evento
                     , data_scadenza
                     , data_ins
                     , data_mod
                     , utente
                     )
               (select nextval('coimtodo_s') as cod_todo
                     , :cod_impianto_new
                     , tipologia
                     , note
                     , cod_cimp_dimp
                     , flag_evasione
                     , data_evasione
                     , data_evento
                     , data_scadenza
                     , current_date
                     , null
                     , :id_utente
                  from coimtodo
                 where cod_impianto = :cod_impianto)
       </querytext>
    </partialquery>

    <fullquery name="sel_aimp_stato_cod_est">
        <querytext>
              select stato            as stato_aimp_destinazione
	           , cod_impianto_est as cod_impianto_est_destinazione
                from coimaimp
	       where cod_impianto = :destinazione
        </querytext>
    </fullquery>

    <fullquery name="sel_aimp_cod">
        <querytext>
	  select nextval('coimaimp_s') as cod_impianto_new
        </querytext>
    </fullquery>

    <fullquery name="get_cod_impianto_est_old">
       <querytext>
           select coalesce('ITER25'||lpad((max(to_number(substr(cod_impianto_est, 7, 14), '99999999999999999990') ) + 1), 14, '0'), 'ITER2500000000000001') as cod_impianto_est_new from coimaimp
       </querytext>
    </fullquery>

    <fullquery name="get_cod_impianto_est">
       <querytext>
          select nextval('coimaimp_est_s') as cod_impianto_est_new
       </querytext>
    </fullquery>

    <fullquery name="sel_dati_codifica">
       <querytext>
           select coalesce(progressivo,0) + 1 as progressivo 
                , a.cod_istat
                , b.potenza
                , b.cod_potenza
                , a.cod_comune
             from coimcomu a
                , coimaimp b
            where a.cod_comune   = b.cod_comune
              and b.cod_impianto = :destinazione
       </querytext>
    </fullquery>

   <partialquery name="upd_prog_comu">
       <querytext>
                update coimcomu
                   set progressivo = :progressivo
                 where cod_comune  = :cod_comune
       </querytext>
    </partialquery>

    <partialquery name="ins_aimp">
       <querytext>
        insert into coimaimp 
                 ( cod_impianto
                 , cod_impianto_est
                 , cod_impianto_prov
                 , descrizione
                 , provenienza_dati
                 , cod_combustibile
                 , cod_potenza
                 , potenza
                 , potenza_utile
                 , data_installaz
                 , data_attivaz
                 , data_rottamaz
                 , note
                 , stato
                 , flag_dichiarato
                 , data_prima_dich
                 , data_ultim_dich
                 , cod_tpim
                 , consumo_annuo
                 , n_generatori
                 , stato_conformita
                 , cod_cted
                 , tariffa
                 , cod_responsabile
                 , flag_resp
                 , cod_intestatario
                 , flag_intestatario
                 , cod_proprietario
                 , cod_occupante
                 , cod_amministratore
                 , cod_manutentore
                 , cod_installatore
                 , cod_distributore
                 , cod_progettista
                 , cod_ubicazione
                 , localita
                 , cod_via
                 , toponimo
                 , indirizzo
                 , numero
                 , esponente
                 , scala
                 , piano
                 , interno
                 , cod_comune
                 , cod_provincia
                 , cap
      -- dpr74   , cod_catasto
                 , foglio        -- dpr74
                 , cod_tpdu
                 , cod_qua
                 , cod_urb
                 , data_ins
                 , data_mod
                 , utente
                 , flag_dpr412
                 , cod_impianto_dest
                 , anno_costruzione
                 , marc_effic_energ
                 , volimetria_risc
                 , gb_x
                 , gb_y
                 , data_scad_dich
                 , flag_coordinate
                 , flag_targa_stampata
                 , cod_impianto_old
                 , portata
                 , palazzo
                 , n_unita_immob
                 , cod_tipo_attivita
                 , adibito_a
                 , utente_ins
                 , igni_progressivo
                 , cod_iterman
                 , circuito_primario
		 , distr_calore
                 , n_scambiatori
                 , potenza_scamb_tot
                 , nome_rete
                 , cod_alim
                 , cod_fdc
                 , note_dest
                 , cop
                 , per
                 , cod_amag
                 , dati_scheda
                 , data_scheda
                 , flag_tipo_impianto -- dpr74
                 , mappale            -- dpr74 
                 , denominatore       -- dpr74
                 , subalterno         -- dpr74
                 , cod_distributore_el            -- fer 270614 
                 , pdr                            -- fer 270614
                 , pod                            -- fer 270614
                 , cod_impianto_princ                   
                 , cat_catastale                        
                 , pres_certificazione                  
                 , certificazione                       
                 , tratt_acqua_contenuto                
                 , tratt_acqua_durezza                  
                 , tratt_acqua_clima_tipo               
                 , tratt_acqua_clima_addolc             
                 , tratt_acqua_clima_prot_gelo          
                 , tratt_acqua_clima_prot_gelo_eti      
                 , tratt_acqua_clima_prot_gelo_eti_perc 
                 , tratt_acqua_clima_prot_gelo_pro      
                 , tratt_acqua_clima_prot_gelo_pro_perc 
                 , tratt_acqua_calda_sanit_tipo         
                 , tratt_acqua_calda_sanit_addolc       
                 , tratt_acqua_raff_assente             
                 , tratt_acqua_raff_tipo_circuito       
                 , tratt_acqua_raff_origine             
                 , tratt_acqua_raff_filtraz_flag        
                 , tratt_acqua_raff_filtraz_1           
                 , tratt_acqua_raff_filtraz_2           
                 , tratt_acqua_raff_filtraz_3           
                 , tratt_acqua_raff_filtraz_4           
                 , tratt_acqua_raff_tratt_flag          
                 , tratt_acqua_raff_tratt_1             
                 , tratt_acqua_raff_tratt_2             
                 , tratt_acqua_raff_tratt_3             
                 , tratt_acqua_raff_tratt_4             
                 , tratt_acqua_raff_tratt_5             
                 , tratt_acqua_raff_cond_flag           
                 , tratt_acqua_raff_cond_1              
                 , tratt_acqua_raff_cond_2              
                 , tratt_acqua_raff_cond_3              
                 , tratt_acqua_raff_cond_4              
                 , tratt_acqua_raff_cond_5              
                 , tratt_acqua_raff_cond_6              
                 , tratt_acqua_raff_spurgo_flag         
                 , tratt_acqua_raff_spurgo_cond_ing     
                 , tratt_acqua_raff_spurgo_tara_cond
                 , regol_curva_integrata            
                 , regol_curva_indipendente         
                 , regol_curva_ind_iniz_data_inst   
                 , regol_curva_ind_iniz_data_dism   
                 , regol_curva_ind_iniz_fabbricante 
                 , regol_curva_ind_iniz_modello     
                 , regol_curva_ind_iniz_n_punti_reg 
                 , regol_curva_ind_iniz_n_liv_temp  
                 , regol_valv_regolazione           
                 , regol_valv_ind_iniz_data_inst    
                 , regol_valv_ind_iniz_data_dism    
                 , regol_valv_ind_iniz_fabbricante  
                 , regol_valv_ind_iniz_modello      
                 , regol_valv_ind_iniz_n_vie        
                 , regol_valv_ind_iniz_servo_motore 
                 , regol_sist_multigradino          
                 , regol_sist_inverter              
                 , regol_altri_flag                 
                 , regol_altri_desc_sistema         
                 , regol_cod_tprg                   
                 , regol_valv_termostatiche         
                 , regol_valv_due_vie               
                 , regol_valv_tre_vie               
                 , regol_valv_note                  
                 , regol_telettura                  
                 , regol_telegestione               
                 , regol_desc_sistema_iniz          
                 , regol_data_sost_sistema          
                 , regol_desc_sistema_sost          
                 , contab_si_no                     
                 , contab_tipo_contabiliz           
                 , contab_tipo_sistema              
                 , contab_desc_sistema_iniz         
                 , contab_data_sost_sistema         
                 , contab_desc_sistema_sost
                 , sistem_dist_tipo --gab01
                 , sistem_dist_note_altro --gab01
                 , sistem_dist_coibentazione_flag --gab01
                 , sistem_dist_note --gab01
                 , sistem_emis_tipo --gab01
                 , sistem_emis_note_altro --gab01
                 )
           (select :cod_impianto_new
                 , :cod_impianto_est_new
                 , cod_impianto_prov
                 , descrizione
                 , provenienza_dati
                 , cod_combustibile
                 , cod_potenza
                 , potenza
                 , potenza_utile
                 , data_installaz
                 , data_attivaz
                 , data_rottamaz
                 , note
                 , 'A'
                 , flag_dichiarato
                 , data_prima_dich
                 , data_ultim_dich
                 , cod_tpim
                 , consumo_annuo
                 , n_generatori
                 , stato_conformita
                 , cod_cted
                 , tariffa
                 , cod_responsabile
                 , flag_resp
                 , cod_intestatario
                 , flag_intestatario
                 , cod_proprietario
                 , cod_occupante
                 , cod_amministratore
                 , cod_manutentore
                 , cod_installatore
                 , cod_distributore
                 , cod_progettista
                 , cod_ubicazione
                 , localita
                 , cod_via
                 , toponimo
                 , indirizzo
                 , numero
                 , esponente
                 , scala
                 , piano
                 , interno
                 , cod_comune
                 , cod_provincia
                 , cap
      -- dpr74   , cod_catasto
                 , foglio        -- dpr74
                 , cod_tpdu
                 , cod_qua
                 , cod_urb
                 , current_date
                 , data_mod
                 , :id_utente
                 , flag_dpr412
                 , cod_impianto_dest
                 , anno_costruzione
                 , marc_effic_energ
                 , volimetria_risc
                 , gb_x
                 , gb_y
                 , data_scad_dich
                 , flag_coordinate
                 , flag_targa_stampata
                 , cod_impianto_old
                 , portata
                 , palazzo
                 , n_unita_immob
                 , cod_tipo_attivita
                 , adibito_a
                 , :id_utente
                 , igni_progressivo
                 , cod_iterman
                 , circuito_primario
                 , distr_calore
                 , n_scambiatori
                 , potenza_scamb_tot
                 , nome_rete
                 , cod_alim
                 , cod_fdc
                 , note_dest
                 , cop
                 , per
                 , cod_amag
                 , dati_scheda
                 , data_scheda
                 , flag_tipo_impianto -- dpr74
                 , mappale            -- dpr74 
                 , denominatore       -- dpr74
                 , subalterno         -- dpr74
                 , cod_distributore_el            -- fer 270614 
                 , pdr                            -- fer 270614
                 , pod                            -- fer 270614
                 , cod_impianto_princ                   
                 , cat_catastale                        
                 , pres_certificazione                  
                 , certificazione                       
                 , tratt_acqua_contenuto                
                 , tratt_acqua_durezza                  
                 , tratt_acqua_clima_tipo               
                 , tratt_acqua_clima_addolc             
                 , tratt_acqua_clima_prot_gelo          
                 , tratt_acqua_clima_prot_gelo_eti      
                 , tratt_acqua_clima_prot_gelo_eti_perc 
                 , tratt_acqua_clima_prot_gelo_pro      
                 , tratt_acqua_clima_prot_gelo_pro_perc 
                 , tratt_acqua_calda_sanit_tipo         
                 , tratt_acqua_calda_sanit_addolc       
                 , tratt_acqua_raff_assente             
                 , tratt_acqua_raff_tipo_circuito       
                 , tratt_acqua_raff_origine             
                 , tratt_acqua_raff_filtraz_flag        
                 , tratt_acqua_raff_filtraz_1           
                 , tratt_acqua_raff_filtraz_2           
                 , tratt_acqua_raff_filtraz_3           
                 , tratt_acqua_raff_filtraz_4           
                 , tratt_acqua_raff_tratt_flag          
                 , tratt_acqua_raff_tratt_1             
                 , tratt_acqua_raff_tratt_2             
                 , tratt_acqua_raff_tratt_3             
                 , tratt_acqua_raff_tratt_4             
                 , tratt_acqua_raff_tratt_5             
                 , tratt_acqua_raff_cond_flag           
                 , tratt_acqua_raff_cond_1              
                 , tratt_acqua_raff_cond_2              
                 , tratt_acqua_raff_cond_3              
                 , tratt_acqua_raff_cond_4              
                 , tratt_acqua_raff_cond_5              
                 , tratt_acqua_raff_cond_6              
                 , tratt_acqua_raff_spurgo_flag         
                 , tratt_acqua_raff_spurgo_cond_ing     
                 , tratt_acqua_raff_spurgo_tara_cond
                 , regol_curva_integrata            
                 , regol_curva_indipendente         
                 , regol_curva_ind_iniz_data_inst   
                 , regol_curva_ind_iniz_data_dism   
                 , regol_curva_ind_iniz_fabbricante 
                 , regol_curva_ind_iniz_modello     
                 , regol_curva_ind_iniz_n_punti_reg 
                 , regol_curva_ind_iniz_n_liv_temp  
                 , regol_valv_regolazione           
                 , regol_valv_ind_iniz_data_inst    
                 , regol_valv_ind_iniz_data_dism    
                 , regol_valv_ind_iniz_fabbricante  
                 , regol_valv_ind_iniz_modello      
                 , regol_valv_ind_iniz_n_vie        
                 , regol_valv_ind_iniz_servo_motore 
                 , regol_sist_multigradino          
                 , regol_sist_inverter              
                 , regol_altri_flag                 
                 , regol_altri_desc_sistema         
                 , regol_cod_tprg                   
                 , regol_valv_termostatiche         
                 , regol_valv_due_vie               
                 , regol_valv_tre_vie               
                 , regol_valv_note                  
                 , regol_telettura                  
                 , regol_telegestione               
                 , regol_desc_sistema_iniz          
                 , regol_data_sost_sistema          
                 , regol_desc_sistema_sost          
                 , contab_si_no                     
                 , contab_tipo_contabiliz           
                 , contab_tipo_sistema              
                 , contab_desc_sistema_iniz         
                 , contab_data_sost_sistema         
                 , contab_desc_sistema_sost
                 , sistem_dist_tipo --gab01
                 , sistem_dist_note_altro --gab01
                 , sistem_dist_coibentazione_flag --gab01
                 , sistem_dist_note --gab01
                 , sistem_emis_tipo --gab01
                 , sistem_emis_note_altro --gab01
              from coimaimp
             where cod_impianto = :destinazione)
          </querytext>
       </partialquery>

    <fullquery name="sel_cimp_cod">
        <querytext>
           select cod_cimp 
             from coimcimp 
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_dimp_cod">
        <querytext>
           select cod_dimp 
             from coimdimp 
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_aimp_check_cod_est">
        <querytext>
           select '1'
             from coimaimp 
            where cod_impianto_est = :cod_impianto_est_new
        </querytext>
    </fullquery>

    <fullquery name="sel_noveb_cod"><!-- nic01 -->
        <querytext>
           select cod_noveb
             from coimnoveb
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_noveb_cod_new"><!-- nic01 -->
        <querytext>
           select coalesce(max(to_number(cod_noveb, '99999990') ),0) + 1 as cod_noveb_new
             from coimnoveb
        </querytext>
    </fullquery>

    <partialquery name="ins_noveb"><!-- nic01 -->
      <querytext>
	insert
	  into coimnoveb
             ( cod_noveb
             , cod_impianto
             , cod_manutentore
             , data_consegna        
             , luogo_consegna       
             , flag_art_3           
             , flag_art_11          
             , flag_patente_abil    
             , flag_art_11_comma_3  
             , flag_installatore    
             , flag_responsabile    
             , n_generatori         
             , dich_conformita_nr   
             , data_dich_conform    
             , flag_libretto_centr  
             , firma_dichiarante    
             , data_dichiarazione   
             , firma_responsabile   
             , data_ricevuta        
             , regolamenti_locali   
             , flag_verif_emis_286  
             , data_verif_emiss     
             , risultato_mg_nmc_h   
             , flag_risult_conforme 
             , data_alleg_libretto  
             , combustibili         
             , flag_consegnato      
             , pot_term_tot_mw      
             , n_prot               
             , dat_prot             
             , flag_manutentore     
             , manu_ord_1           
             , manu_ord_2           
             , manu_ord_3           
             , manu_ord_4           
             , manu_ord_5           
             , manu_ord_6           
             , manu_ord_7           
             , manu_ord_8           
             , manu_flag_1          
             , manu_flag_2          
             , manu_flag_3          
             , manu_flag_4          
             , manu_flag_5          
             , manu_flag_6          
             , manu_flag_7          
             , manu_flag_8          
             , manu_stra_1          
             )
       (select :cod_noveb_new
	     , :cod_impianto_new
             , cod_manutentore
             , data_consegna        
             , luogo_consegna       
             , flag_art_3           
             , flag_art_11          
             , flag_patente_abil    
             , flag_art_11_comma_3  
             , flag_installatore    
             , flag_responsabile    
             , n_generatori         
             , dich_conformita_nr   
             , data_dich_conform    
             , flag_libretto_centr  
             , firma_dichiarante    
             , data_dichiarazione   
             , firma_responsabile   
             , data_ricevuta        
             , regolamenti_locali   
             , flag_verif_emis_286  
             , data_verif_emiss     
             , risultato_mg_nmc_h   
             , flag_risult_conforme 
             , data_alleg_libretto  
             , combustibili         
             , flag_consegnato      
             , pot_term_tot_mw      
             , n_prot               
             , dat_prot             
             , flag_manutentore     
             , manu_ord_1           
             , manu_ord_2           
             , manu_ord_3           
             , manu_ord_4           
             , manu_ord_5           
             , manu_ord_6           
             , manu_ord_7           
             , manu_ord_8           
             , manu_flag_1          
             , manu_flag_2          
             , manu_flag_3          
             , manu_flag_4          
             , manu_flag_5          
             , manu_flag_6          
             , manu_flag_7          
             , manu_flag_8          
             , manu_stra_1          
          from coimnoveb
         where cod_impianto = :cod_impianto
           and cod_noveb    = :cod_noveb)
       </querytext>
    </partialquery>
    
    <fullquery name="sel_recu_cond_cod"><!-- gab01 -->
        <querytext>
           select cod_recu_cond_aimp
             from coimrecu_cond_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_recu_cond_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimrecu_cond_aimp_s') as cod_recu_cond_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_recu_cond_rc_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_rc),0) + 1 as num_rc_new
             from coimrecu_cond_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_recu_cond"><!--gab01 -->
      <querytext>
	insert
	  into coimrecu_cond_aimp
             ( cod_recu_cond_aimp
             , cod_impianto
             , num_rc
             , data_installaz        
             , data_dismissione       
             , cod_cost           
             , modello          
             , matricola    
             , portata_term_max  
             , portata_term_min    
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_recu_cond_aimp_new
	     , :cod_impianto_new
             , :num_rc_new
             , data_installaz        
             , data_dismissione       
             , cod_cost           
             , modello          
             , matricola    
             , portata_term_max 
             , portata_term_min    
             , data_ins   
             , utente_ins         
             , data_mod   
             , utente_mod   
          from coimrecu_cond_aimp
         where cod_impianto = :cod_impianto
           and cod_recu_cond_aimp    = :cod_recu_cond_aimp)
       </querytext>
    </partialquery>
    
    <fullquery name="sel_camp_sola_cod"><!-- gab01 -->
        <querytext>
           select cod_camp_sola_aimp
             from coimcamp_sola_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_camp_sola_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimcamp_sola_aimp_s') as cod_camp_sola_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_camp_sola_cs_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_cs),0) + 1 as num_cs_new
             from coimcamp_sola_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_camp_sola"><!--gab01 -->
      <querytext>
	insert
	  into coimcamp_sola_aimp
             ( cod_camp_sola_aimp
             , cod_impianto
             , num_cs
             , data_installaz        
             , cod_cost           
             , collettori          
             , sup_totale    
             , data_ins  
             , utente_ins    
             , data_mod
             , utente_mod
             )
       (select :cod_camp_sola_aimp_new
	     , :cod_impianto_new
             , :num_cs_new
             , data_installaz               
             , cod_cost           
             , collettori          
             , sup_totale    
             , data_ins   
             , utente_ins         
             , data_mod   
             , utente_mod   
          from coimcamp_sola_aimp
         where cod_impianto = :cod_impianto
           and cod_camp_sola_aimp    = :cod_camp_sola_aimp)
       </querytext>
    </partialquery>
    
    <fullquery name="sel_altr_gend_cod"><!-- gab01 -->
        <querytext>
           select cod_altr_gend_aimp
             from coimaltr_gend_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_altr_gend_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimaltr_gend_aimp_s') as cod_altr_gend_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_altr_gend_ag_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_ag),0) + 1 as num_ag_new
             from coimaltr_gend_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_altr_gend"><!--gab01 -->
      <querytext>
	insert
	  into coimaltr_gend_aimp
             ( cod_altr_gend_aimp
             , cod_impianto
             , num_ag
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello          
             , matricola    
             , tipologia  
             , potenza_utile    
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_altr_gend_aimp_new
	     , :cod_impianto_new
             , :num_ag_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello          
             , matricola    
             , tipologia   
             , potenza_utile         
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimaltr_gend_aimp
         where cod_impianto = :cod_impianto
           and cod_altr_gend_aimp    = :cod_altr_gend_aimp)
       </querytext>
    </partialquery>

    <fullquery name="sel_accu_cod"><!-- gab01 -->
        <querytext>
           select cod_accu_aimp
             from coimaccu_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_accu_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimaccu_aimp_s') as cod_accu_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_accu_ac_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_ac),0) + 1 as num_ac_new
             from coimaccu_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_accu"><!--gab01 -->
      <querytext>
	insert
	  into coimaccu_aimp
             ( cod_accu_aimp
             , cod_impianto
             , num_ac
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello          
             , matricola    
             , capacita  
             , utilizzo    
             , coibentazione
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_accu_aimp_new
	     , :cod_impianto_new
             , :num_ac_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello          
             , matricola    
             , capacita   
             , utilizzo
             , coibentazione         
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimaccu_aimp
         where cod_impianto = :cod_impianto
           and cod_accu_aimp    = :cod_accu_aimp)
       </querytext>
    </partialquery>

   <fullquery name="sel_torr_evap_cod"><!-- gab01 -->
        <querytext>
           select cod_torr_evap_aimp
             from coimtorr_evap_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_torr_evap_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimtorr_evap_aimp_s') as cod_torr_evap_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_torr_evap_te_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_te),0) + 1 as num_te_new
             from coimtorr_evap_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_torr_evap"><!--gab01 -->
      <querytext>
	insert
	  into coimtorr_evap_aimp
             ( cod_torr_evap_aimp
             , cod_impianto
             , num_te
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello          
             , matricola    
             , capacita  
             , num_ventilatori
             , tipi_ventilatori    
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_torr_evap_aimp_new
	     , :cod_impianto_new
             , :num_te_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello          
             , matricola    
             , capacita   
             , num_ventilatori
             , tipi_ventilatori         
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimtorr_evap_aimp
         where cod_impianto = :cod_impianto
           and cod_torr_evap_aimp    = :cod_torr_evap_aimp)
       </querytext>
    </partialquery>

    <fullquery name="sel_raff_cod"><!-- gab01 -->
        <querytext>
           select cod_raff_aimp
             from coimraff_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_raff_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimraff_aimp_s') as cod_raff_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_raff_rv_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_rv),0) + 1 as num_rv_new
             from coimraff_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_raff"><!--gab01 -->
      <querytext>
	insert
	  into coimraff_aimp
             ( cod_raff_aimp
             , cod_impianto
             , num_rv
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello          
             , matricola    
             , num_ventilatori  
             , tipi_ventilatori  
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_raff_aimp_new
	     , :cod_impianto_new
             , :num_rv_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello          
             , matricola    
             , num_ventilatori   
             , tipi_ventilatori         
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimraff_aimp
         where cod_impianto = :cod_impianto
           and cod_raff_aimp    = :cod_raff_aimp)
       </querytext>
    </partialquery>

    <fullquery name="sel_scam_calo_cod"><!-- gab01 -->
        <querytext>
           select cod_scam_calo_aimp
             from coimscam_calo_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_scam_calo_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimscam_calo_aimp_s') as cod_scam_calo_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_scam_calo_sc_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_sc),0) + 1 as num_sc_new
             from coimscam_calo_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_scam_calo"><!--gab01 -->
      <querytext>
	insert
	  into coimscam_calo_aimp
             ( cod_scam_calo_aimp
             , cod_impianto
             , num_sc
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello          
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_scam_calo_aimp_new
	     , :cod_impianto_new
             , :num_sc_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello          
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimscam_calo_aimp
         where cod_impianto = :cod_impianto
           and cod_scam_calo_aimp    = :cod_scam_calo_aimp)
       </querytext>
    </partialquery>

    <fullquery name="sel_circ_inte_cod"><!-- gab01 -->
        <querytext>
           select cod_circ_inte_aimp
             from coimcirc_inte_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_circ_inte_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimcirc_inte_aimp_s') as cod_circ_inte_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_circ_inte_ci_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_ci),0) + 1 as num_ci_new
             from coimcirc_inte_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_circ_inte"><!--gab01 -->
      <querytext>
	insert
	  into coimcirc_inte_aimp
             ( cod_circ_inte_aimp
             , cod_impianto
             , num_ci
             , data_installaz
             , data_dismissione        
             , lunghezza           
             , superficie
             , profondita          
             , data_ins
             , utente_ins
             , data_mod
             , utente_mod
             )
       (select :cod_circ_inte_aimp_new
	     , :cod_impianto_new
             , :num_ci_new
             , data_installaz
             , data_dismissione               
             , lunghezza           
             , superficie
             , profondita          
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimcirc_inte_aimp
         where cod_impianto = :cod_impianto
           and cod_circ_inte_aimp    = :cod_circ_inte_aimp)
       </querytext>
    </partialquery>

    <fullquery name="sel_trat_aria_cod"><!-- gab01 -->
        <querytext>
           select cod_trat_aria_aimp
             from coimtrat_aria_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_trat_aria_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimtrat_aria_aimp_s') as cod_trat_aria_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_trat_aria_ut_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_ut),0) + 1 as num_ut_new
             from coimtrat_aria_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_trat_aria"><!--gab01 -->
      <querytext>
	insert
	  into coimtrat_aria_aimp
             ( cod_trat_aria_aimp
             , cod_impianto
             , num_ut
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello
             , matricola          
             , portata_mandata
             , potenza_mandata
             , portata_ripresa
             , potenza_ripresa
             , data_ins
             , utente_ins             
             , data_mod
             , utente_mod
             )
       (select :cod_trat_aria_aimp_new
	     , :cod_impianto_new
             , :num_ut_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello
             , matricola
             , portata_mandata
             , potenza_mandata
             , portata_ripresa
             , potenza_ripresa          
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimtrat_aria_aimp
         where cod_impianto = :cod_impianto
           and cod_trat_aria_aimp    = :cod_trat_aria_aimp)
       </querytext>
    </partialquery>

 <fullquery name="sel_recu_calo_cod"><!-- gab01 -->
        <querytext>
           select cod_recu_calo_aimp
             from coimrecu_calo_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_recu_calo_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimrecu_calo_aimp_s') as cod_recu_calo_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_recu_calo_rc_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_rc),0) + 1 as num_rc_new
             from coimrecu_calo_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_recu_calo"><!--gab01 -->
      <querytext>
	insert
	  into coimrecu_calo_aimp
             ( cod_recu_calo_aimp
             , cod_impianto
             , num_rc
             , data_installaz
             , data_dismissione        
             , tipologia           
             , installato_uta_vmc
             , indipendente          
             , portata_mandata
             , potenza_mandata
             , portata_ripresa
             , potenza_ripresa
             , data_ins
             , utente_ins             
             , data_mod
             , utente_mod
             )
       (select :cod_recu_calo_aimp_new
	     , :cod_impianto_new
             , :num_rc_new
             , data_installaz
             , data_dismissione               
             , tipologia           
             , installato_uta_vmc
             , indipendente
             , portata_mandata
             , potenza_mandata
             , portata_ripresa
             , potenza_ripresa          
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimrecu_calo_aimp
         where cod_impianto = :cod_impianto
           and cod_recu_calo_aimp    = :cod_recu_calo_aimp)
       </querytext>
    </partialquery>
 
    <fullquery name="sel_vent_cod"><!-- gab01 -->
        <querytext>
           select cod_vent_aimp
             from coimvent_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_vent_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimvent_aimp_s') as cod_vent_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_vent_vm_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_vm),0) + 1 as num_vm_new
             from coimvent_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_vent"><!--gab01 -->
      <querytext>
	insert
	  into coimvent_aimp
             ( cod_vent_aimp
             , cod_impianto
             , num_vm
             , data_installaz
             , data_dismissione        
             , cod_cost           
             , modello
             , tipologia          
             , note_tipologia_altro
             , portata_aria
             , rendimento_rec
             , data_ins
             , utente_ins             
             , data_mod
             , utente_mod
             )
       (select :cod_vent_aimp_new
	     , :cod_impianto_new
             , :num_vm_new
             , data_installaz
             , data_dismissione               
             , cod_cost           
             , modello
             , tipologia
             , note_tipologia_altro
             , portata_aria
             , rendimento_rec          
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimvent_aimp
         where cod_impianto = :cod_impianto
           and cod_vent_aimp    = :cod_vent_aimp)
       </querytext>
    </partialquery>
 
    <fullquery name="sel_vasi_espa_cod"><!-- gab01 -->
        <querytext>
           select cod_vasi_espa_aimp
             from coimvasi_espa_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_vasi_espa_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimvasi_espa_aimp_s') as cod_vasi_espa_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_vasi_espa_vx_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_vx),0) + 1 as num_vx_new
             from coimvasi_espa_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_vasi_espa"><!--gab01 -->
      <querytext>
	insert
	  into coimvasi_espa_aimp
             ( cod_vasi_espa_aimp
             , cod_impianto
             , num_vx
             , capacita
             , flag_aperto        
             , pressione           
             , data_ins
             , utente_ins             
             , data_mod
             , utente_mod
             )
       (select :cod_vasi_espa_aimp_new
	     , :cod_impianto_new
             , :num_vx_new
             , capacita
             , flag_aperto
             , pressione
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimvasi_espa_aimp
         where cod_impianto = :cod_impianto
           and cod_vasi_espa_aimp    = :cod_vasi_espa_aimp)
       </querytext>
    </partialquery>

    <fullquery name="sel_pomp_circ_cod"><!-- gab01 -->
        <querytext>
           select cod_pomp_circ_aimp
             from coimpomp_circ_aimp
            where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_pomp_circ_cod_new"><!-- gab01 -->
        <querytext>
           select nextval('coimpomp_circ_aimp_s') as cod_pomp_circ_aimp_new
        </querytext>
    </fullquery>
   
    <fullquery name="sel_pomp_circ_po_new"><!-- gab01 -->
        <querytext>
           select coalesce(max(num_po),0) + 1 as num_po_new
             from coimpomp_circ_aimp
            where cod_impianto = :cod_impianto_new
        </querytext>
    </fullquery>

    <partialquery name="ins_pomp_circ"><!--gab01 -->
      <querytext>
	insert
	  into coimpomp_circ_aimp
             ( cod_pomp_circ_aimp
             , cod_impianto
             , num_po
             , data_installaz
             , data_dismissione        
             , cod_cost
             , modello
             , flag_giri_variabili
             , pot_nom           
             , data_ins
             , utente_ins             
             , data_mod
             , utente_mod
             )
       (select :cod_pomp_circ_aimp_new
	     , :cod_impianto_new
             , :num_po_new
             , data_installaz
             , data_dismissione
             , cod_cost
             , modello
             , flag_giri_variabili
             , pot_nom
             , data_ins   
             , utente_ins
             , data_mod
             , utente_mod   
          from coimpomp_circ_aimp
         where cod_impianto = :cod_impianto
           and cod_pomp_circ_aimp    = :cod_pomp_circ_aimp)
       </querytext>
    </partialquery>
             
          
</queryset>

