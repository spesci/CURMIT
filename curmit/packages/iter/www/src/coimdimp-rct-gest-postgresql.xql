<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mat01 28/11/2025 Aggiunto sel_aimp_old_marche

    ric02 03/10/2025 Punto 4 MEV Marche: aggiunto lettura data per gestione storico ditta manutenzione.

    ric01 29/09/2025 Aggiunto nuovi campi per ditta e operatori delegati (Punto 40 MEV regione Marche).

    rom09 31/03/2025 Modifiche sui campi n_prot e data_prot in base al parametro protocollo_automatico_ente.

    rom08 18/01/2023 Salerno ha richiesto che la tariffa sia calcolata non in base alla data in cui ci si trova ma
    rom08            in base alla data dell'rcee (come gia' fatto per Ucit). Sandro ha detto che questo va bene per tutti
    rom08            gli altri enti tranne che Regione Marche.

    rom07 01/08/2022 Aggiunta query sel_tari_ucit per passaggio enti di ucit da vecchio a nuovo cvs.

    rom06 26/11/2021 Gestito nuovo campo cod_combustibile per tabella coimdimp.

    rom05 22/12/2020 Su richiesta di Regione Marche e' stata data la possibilita' agli Installatori 
    rom05            di poter inserire gli RCEE se viene scelto come motivo di compilazione: 
    rom05            Prima messa in servizio, Sostituzione del generatore e Ristrutturazione dell'impianto.

    gac08 11/12/2018 Aggiunto nuovo campo flag_pagato_dimp

    gac07 11/12/2018 Aggiunta nuova query sel_dimp_old_gen per prendere i valori inseriti nel 
    gac07            record precedente e valorizzare i campi del record attuale. Modifica 
    gac07            che varrà solo per regione marche.

    gac06 05/12/2018 Aggiunti alcuni campi da far vedere in sola visualizzazione per regione
    gac06            Marche, estratto con un case when il controllo rendimento

    gac05 08/11/2018 Aggiunto campi flag_clima_invernale, flag_prod_acqua_calda e data_ultima_manu

    gac04 23/08/2018 Aggiunto campi strumenti

    rom04 08/06/2018 Aggiunto campo co_fumi_secchi_ppm 

    gac03 07/06/2018 Aggiunto campi elettricità

    gac02 10/05/2018 aggiunto campo portata_termica_effettiva

    gac01 02/05/2018 aggiunti campi acquisti, acquisti2, scorta_o_lett_iniz, scorta_o_lett_iniz2, scorta_o_lett_fin, 
    gac01            scorta_o_lett_fin2

    gac01 06/03/2018 Corretta anomalia portafoglio

    sim27 17/11/2016 Gestito la potenza in base al flag_tipo_impianto

    sim08 27/06/2016 Gestito le tariffe per i vecchi impianti per la Regione Calabria

    nic03 24/05/2014 Devo esporre ed aggiornare le potenze del generatore e non dell'impianto

    nic02 23/05/2014 Ora il generatore viene scelto dall'utente in fase di inserimento

    nic01 15/05/2014 Gestito il nuovo campo coimgend.cod_mode
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="ins_dipe">
       <querytext>
                insert
                  into coimdipe
                     ( cod_impianto
                     , cod_dimp
                     , nome_campo
                     , tipo_peso)
                values
                     ( :cod_impianto
                     , :cod_dimp
                     , :nome_campo
                     , :tipo_peso)
       </querytext>
    </partialquery>

    <partialquery name="ins_trans">
       <querytext>
                insert
                  into coimtrans_manu
                     ( id_transazione
                     , cod_dimp
                     , num_gen
                     , rimborso_reg
                     , costo_bollino
                     , azione
                     , data_ora
                     , utente)
                values
                     (nextval('coimtrans_manu_s')
                     ,:cod_dimp
                     ,:gen_prog
                     ,:importo_tariffa
                     ,:costo
                     ,:azione
                     ,current_timestamp
                     ,:id_utente)
       </querytext>
    </partialquery>

    <fullquery name="sel_tgen">
       <querytext>
        select flag_pesi from coimtgen
       </querytext>
    </fullquery>

    <fullquery name="sel_tot_pesi">
       <querytext>
	select coalesce(sum(b.peso), 0) as peso_totale
	     , count(*) as n_anomalie
	  from coimdipe a
             , coimpesi b
         where a.nome_campo = b.nome_campo
           and a.tipo_peso = b.tipo_peso
           and a.cod_impianto = :cod_impianto
           and a.cod_dimp = :cod_dimp
       </querytext>
    </fullquery>

    <partialquery name="upd_dipe">
       <querytext>
                update coimdipe
                   set peso_totale  = :peso_totale
                     , n_anomalie   = :n_anomalie
                 where cod_impianto = :cod_impianto
                   and cod_dimp     = :cod_dimp
       </querytext>
    </partialquery>

    <partialquery name="del_dipe">
       <querytext>
                delete from coimdipe
                 where cod_impianto = :cod_impianto
                   and cod_dimp     = :cod_dimp
       </querytext>
    </partialquery>

    <partialquery name="ins_dimp">
       <querytext>
                insert
                  into coimdimp$stn 
                     ( cod_dimp
                     , cod_impianto
                     , data_controllo
		     , data_ultima_manu --gac05
                     , gen_prog
                     , cod_manutentore
                     , cod_responsabile
                     , cod_proprietario
                     , cod_occupante
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
                     , co_fumi_secchi_ppm --rom04
                     , rend_combust
                     , osservazioni
                     , raccomandazioni
                     , prescrizioni
                     , data_utile_inter
                     , n_prot
                     , data_prot
                     , delega_resp
                     , delega_manut
                     , utente
                     , data_ins
                     , num_bollo
                     , costo
                     , tipologia_costo
                     , riferimento_pag
                     , potenza
                     , flag_co_perc
                     , flag_tracciato
                     , scar_can_fu
                     , tiraggio
                     , ora_inizio
                     , ora_fine
                     , data_scadenza
                     , num_autocert
                     , volimetria_risc
                     , consumo_annuo
                     , consumo_annuo2
                     , stagione_risc
                     , stagione_risc2
		     , acquisti
		     , acquisti2
                     , scorta_o_lett_iniz
                     , scorta_o_lett_iniz2
		     , scorta_o_lett_fin
                     , scorta_o_lett_fin2
		     , utente_ins
		     , data_arrivo_ente
                     , cod_opmanu_new
                     , tariffa
                     , importo_tariffa
                     , cod_cind
                     , rct_dur_acqua    
                     , rct_tratt_in_risc       
                     , rct_tratt_in_acs       
                     , rct_install_interna      
                     , rct_install_esterna     
                     , rct_canale_fumo_idoneo  
                     , rct_sistema_reg_temp_amb 
                     , rct_assenza_per_comb     
                     , rct_idonea_tenuta         
                     , rct_valv_sicurezza      
                     , rct_scambiatore_lato_fumi 
                     , rct_riflussi_comb         
                     , rct_uni_10389             
                     , rct_rend_min_legge   
                     , rct_modulo_termico
                     , rct_check_list_1          
                     , rct_check_list_2          
                     , rct_check_list_3         
                     , rct_check_list_4          
                     , rct_gruppo_termico  
                     , rct_lib_uso_man_comp
                     , data_prox_manut
                     , cod_tprc   --sim58  
                     , bacharach2                  --gac01
                     , bacharach3                  --gac01
                     , portata_comb                --gac01
                     , rispetta_indice_bacharach   --gac01
                     , co_fumi_secchi              --gac01
                     , rend_magg_o_ugua_rend_min   --gac01
                     , portata_termica_effettiva   --gac02
		     , elet_esercizio_1            --gac03
		     , elet_esercizio_2            --gac03
		     , elet_esercizio_3            --gac03
		     , elet_esercizio_4            --gac03
		     , elet_lettura_iniziale       --gac03
		     , elet_lettura_finale         --gac03
		     , elet_consumo_totale         --gac03
		     , elet_lettura_iniziale_2     --gac03
		     , elet_lettura_finale_2       --gac03
		     , elet_consumo_totale_2       --gac03
		     , cod_strumento_01            --gac04
		     , cod_strumento_02            --gac04
		     , flag_pagato                 --gac08
		     , cod_combustibile            --rom06
		     , cod_manu_dele               --ric01
		     , cod_opma_dele               --ric01
		     )		     
                values 
                     (:cod_dimp
                     ,:cod_impianto
                     ,:data_controllo
		     ,:data_ultima_manu --gac05
                     ,:gen_prog
                     ,:cod_manutentore
                     ,:cod_responsabile
                     ,:cod_proprietario
                     ,:cod_occupante
                     ,:flag_status
                     ,:garanzia
                     ,:conformita
                     ,:lib_impianto
                     ,:lib_uso_man
                     ,:inst_in_out
                     ,:idoneita_locale
                     ,:ap_ventilaz
                     ,:ap_vent_ostruz
                     ,:pendenza
                     ,:sezioni
                     ,:curve
                     ,:lunghezza
                     ,:conservazione
                     ,:scar_ca_si
                     ,:scar_parete
                     ,:riflussi_locale
                     ,:assenza_perdite
                     ,:pulizia_ugelli
                     ,:antivento
                     ,:scambiatore
                     ,:accens_reg
                     ,:disp_comando
                     ,:ass_perdite
                     ,:valvola_sicur
                     ,:vaso_esp
                     ,:disp_sic_manom
                     ,:organi_integri
                     ,:circ_aria
                     ,:guarn_accop
                     ,:assenza_fughe
                     ,:coibentazione
                     ,:eff_evac_fum
                     ,:cont_rend
                     ,:pot_focolare_mis
                     ,:portata_comb_mis
                     ,:temp_fumi
                     ,:temp_ambi
                     ,:o2
                     ,:co2
                     ,:bacharach
                     ,:co
                     ,:co_fumi_secchi_ppm --rom04
                     ,:rend_combust
                     ,:osservazioni
                     ,:raccomandazioni
                     ,:prescrizioni
                     ,:data_utile_inter
                     ,:n_prot
                     ,:data_prot --rom09 current_date
                     ,:delega_resp
                     ,:delega_manut
                     ,:id_utente
                     ,current_date
                     ,:num_bollo
                     ,:costo
                     ,:tipologia_costo
                     ,:riferimento_pag
		     ,:potenza
		     ,:flag_co_perc
                     ,'R1'
                     ,:scar_can_fu
                     ,:tiraggio_fumi
                     ,:ora_inizio
                     ,:ora_fine
                     ,:data_scadenza_autocert
                     ,:num_autocert
                     ,:volimetria_risc
                     ,:consumo_annuo
                     ,:consumo_annuo2
                     ,:stagione_risc
                     ,:stagione_risc2
                     ,:acquisti
		     ,:acquisti2
                     ,:scorta_o_lett_iniz
		     ,:scorta_o_lett_iniz2
                     ,:scorta_o_lett_fin
		     ,:scorta_o_lett_fin2
		     ,:id_utente
		     ,:data_arrivo_ente
                     ,:cod_opmanu_new
                     ,:tariffa_reg
                     ,:importo_tariffa
                     ,:cod_cind
                     ,:rct_dur_acqua    
                     ,:rct_tratt_in_risc       
                     ,:rct_tratt_in_acs       
                     ,:rct_install_interna      
                     ,:rct_install_esterna     
                     ,:rct_canale_fumo_idoneo  
                     ,:rct_sistema_reg_temp_amb 
                     ,:rct_assenza_per_comb     
                     ,:rct_idonea_tenuta         
                     ,:rct_valv_sicurezza      
                     ,:rct_scambiatore_lato_fumi 
                     ,:rct_riflussi_comb         
                     ,:rct_uni_10389             
                     ,:rct_rend_min_legge   
                     ,:rct_modulo_termico
                     ,:rct_check_list_1          
                     ,:rct_check_list_2          
                     ,:rct_check_list_3         
                     ,:rct_check_list_4          
                     ,:rct_gruppo_termico  
                     ,:rct_lib_uso_man_comp 
                     ,:data_prox_manut 
                     ,:cod_tprc    --sim58
		     ,:bacharach2                  --gac01
                     ,:bacharach3                  --gac01
                     ,:portata_comb                --gac01
                     ,:rispetta_indice_bacharach   --gac01
                     ,:co_fumi_secchi              --gac01
                     ,:rend_magg_o_ugua_rend_min   --gac01
		     ,:portata_termica_effettiva   --gac02
		     ,:elet_esercizio_1            --gac03
                     ,:elet_esercizio_2            --gac03
                     ,:elet_esercizio_3            --gac03
                     ,:elet_esercizio_4            --gac03
                     ,:elet_lettura_iniziale       --gac03
                     ,:elet_lettura_finale         --gac03
                     ,:elet_consumo_totale         --gac03
                     ,:elet_lettura_iniziale_2     --gac03
                     ,:elet_lettura_finale_2       --gac03
                     ,:elet_consumo_totale_2       --gac03
                     ,:cod_strumento_01            --gac04
                     ,:cod_strumento_02            --gac04
		     ,:flag_pagato                 --gac08
		     ,:combustibile_dimp           --rom06
		     , :cod_manu_dele               --ric01
		     , :cod_opma_dele               --ric01
                     )
       </querytext>
    </partialquery>

    <partialquery name="upd_dimp">
       <querytext>
                update coimdimp$stn
                   set cod_impianto       = :cod_impianto
                     , data_controllo     = :data_controllo
		     , data_ultima_manu   = :data_ultima_manu --gac05
                     , gen_prog           = :gen_prog
                     , cod_manutentore    = :cod_manutentore
                     , cod_responsabile   = :cod_responsabile
                     , cod_proprietario   = :cod_proprietario
                     , cod_occupante      = :cod_occupante
                     , flag_status        = :flag_status
                     , garanzia           = :garanzia
                     , conformita         = :conformita
                     , lib_impianto       = :lib_impianto
                     , lib_uso_man        = :lib_uso_man
                     , inst_in_out        = :inst_in_out
                     , idoneita_locale    = :idoneita_locale
                     , ap_ventilaz        = :ap_ventilaz
                     , ap_vent_ostruz     = :ap_vent_ostruz
                     , pendenza           = :pendenza
                     , sezioni            = :sezioni
                     , curve              = :curve
                     , lunghezza          = :lunghezza
                     , conservazione      = :conservazione
                     , scar_ca_si         = :scar_ca_si
                     , scar_parete        = :scar_parete
                     , riflussi_locale    = :riflussi_locale
                     , assenza_perdite    = :assenza_perdite
                     , pulizia_ugelli     = :pulizia_ugelli
                     , antivento          = :antivento
                     , scambiatore        = :scambiatore
                     , accens_reg         = :accens_reg
                     , disp_comando       = :disp_comando
                     , ass_perdite        = :ass_perdite
                     , valvola_sicur      = :valvola_sicur
                     , vaso_esp           = :vaso_esp
                     , disp_sic_manom     = :disp_sic_manom
                     , organi_integri     = :organi_integri
                     , circ_aria          = :circ_aria
                     , guarn_accop        = :guarn_accop
                     , assenza_fughe      = :assenza_fughe
                     , coibentazione      = :coibentazione
                     , eff_evac_fum       = :eff_evac_fum
                     , cont_rend          = :cont_rend
                     , pot_focolare_mis   = :pot_focolare_mis
                     , portata_comb_mis   = :portata_comb_mis
                     , temp_fumi          = :temp_fumi
                     , temp_ambi          = :temp_ambi
                     , o2                 = :o2
                     , co2                = :co2
                     , bacharach          = :bacharach
                     , co                 = :co
                     , co_fumi_secchi_ppm = :co_fumi_secchi_ppm   --rom04
                     , rend_combust       = :rend_combust
                     , osservazioni       = :osservazioni
                     , raccomandazioni    = :raccomandazioni
                     , prescrizioni       = :prescrizioni
                     , data_utile_inter   = :data_utile_inter
                     , delega_resp        = :delega_resp
                     , delega_manut       = :delega_manut
                     , utente             = :id_utente
                     , data_mod           = current_date
                     , num_bollo          = :num_bollo
                     , costo              = :costo
                     , tipologia_costo    = :tipologia_costo
                     , riferimento_pag    = :riferimento_pag
		     , potenza            = :potenza
                     , flag_co_perc       = :flag_co_perc
                     , scar_can_fu        = :scar_can_fu
                     , tiraggio           = :tiraggio_fumi
                     , ora_inizio         = :ora_inizio
                     , ora_fine           = :ora_fine
                     , num_autocert       = :num_autocert
                     , volimetria_risc    = :volimetria_risc
                     , consumo_annuo      = :consumo_annuo
		     , consumo_annuo2	  = :consumo_annuo2
                     , stagione_risc	  = :stagione_risc
                     , stagione_risc2	  = :stagione_risc2
		     , acquisti           = :acquisti
		     , acquisti2          = :acquisti2
                     , scorta_o_lett_iniz = :scorta_o_lett_iniz
		     , scorta_o_lett_iniz2 = :scorta_o_lett_iniz2
		     , scorta_o_lett_fin  = :scorta_o_lett_fin
		     , scorta_o_lett_fin2 = :scorta_o_lett_fin2
		     , data_arrivo_ente   = :data_arrivo_ente
                     , cod_opmanu_new     = :cod_opmanu_new
                     , cod_cind           = :cod_cind
                     , rct_dur_acqua        = :rct_dur_acqua
                     , rct_tratt_in_risc    = :rct_tratt_in_risc    
                     , rct_tratt_in_acs     = :rct_tratt_in_acs  
                     , rct_install_interna  = :rct_install_interna   
                     , rct_install_esterna  = :rct_install_esterna
                     , rct_canale_fumo_idoneo   = :rct_canale_fumo_idoneo
                     , rct_sistema_reg_temp_amb  = :rct_sistema_reg_temp_amb
                     , rct_assenza_per_comb      = :rct_assenza_per_comb  
                     , rct_idonea_tenuta    = :rct_idonea_tenuta      
                     , rct_valv_sicurezza   = :rct_valv_sicurezza    
                     , rct_scambiatore_lato_fumi = :rct_scambiatore_lato_fumi
                     , rct_riflussi_comb    = :rct_riflussi_comb      
                     , rct_uni_10389        = :rct_uni_10389            
                     , rct_rend_min_legge   = :rct_rend_min_legge 
                     , rct_modulo_termico   = :rct_modulo_termico
                     , rct_check_list_1     = :rct_check_list_1        
                     , rct_check_list_2     = :rct_check_list_2         
                     , rct_check_list_3     = :rct_check_list_3       
                     , rct_check_list_4     = :rct_check_list_4       
                     , rct_gruppo_termico   = :rct_gruppo_termico     
                     , rct_lib_uso_man_comp = :rct_lib_uso_man_comp 
                     , data_prox_manut      = :data_prox_manut
                     , cod_tprc             = :cod_tprc  --sim58
		     , bacharach2                  = :bacharach2                 --gac01
                     , bacharach3                  = :bacharach3                 --gac01
                     , portata_comb                = :portata_comb               --gac01
                     , rispetta_indice_bacharach   = :rispetta_indice_bacharach  --gac01
                     , co_fumi_secchi              = :co_fumi_secchi             --gac01
                     , rend_magg_o_ugua_rend_min   = :rend_magg_o_ugua_rend_min  --gac01
		     , portata_termica_effettiva   = :portata_termica_effettiva  --gac02
                     , elet_esercizio_1        = :elet_esercizio_1            --gac03
                     , elet_esercizio_2        = :elet_esercizio_2            --gac03
                     , elet_esercizio_3        = :elet_esercizio_3            --gac03
                     , elet_esercizio_4        = :elet_esercizio_4            --gac03
                     , elet_lettura_iniziale   = :elet_lettura_iniziale       --gac03
                     , elet_lettura_finale     = :elet_lettura_finale         --gac03
                     , elet_consumo_totale     = :elet_consumo_totale         --gac03
                     , elet_lettura_iniziale_2 = :elet_lettura_iniziale_2     --gac03
                     , elet_lettura_finale_2   = :elet_lettura_finale_2       --gac03
                     , elet_consumo_totale_2   = :elet_consumo_totale_2       --gac03
                     , cod_strumento_01        = :cod_strumento_01            --gac04
                     , cod_strumento_02        = :cod_strumento_02            --gac04
		     , flag_pagato             = :flag_pagato                 --gac08
		     , cod_combustibile        = :combustibile_dimp           --rom06
		     , cod_manu_dele           = :cod_manu_dele               --ric01
		     , cod_opma_dele           = :cod_opma_dele               --ric01
		 where cod_dimp           = :cod_dimp
       </querytext>
    </partialquery>

    <partialquery name="del_dimp">
       <querytext>
                delete
                  from coimdimp$stn
                 where cod_dimp = :cod_dimp
       </querytext>
    </partialquery>

    <fullquery name="sel_dimp">
       <querytext>
             select a.cod_dimp
                  , a.cod_impianto
                  , iter_edit_data(a.data_controllo) as data_controllo
		  , iter_edit_data(a.data_ultima_manu) as data_ultima_manu --gac05
                  , a.gen_prog
                  , a.cod_manutentore
                  , a.cod_opmanu_new
                  , a.cod_responsabile
                  , a.cod_proprietario
                  , a.cod_occupante
                  , a.flag_status
                  , a.garanzia
                  , a.conformita
                  , a.lib_impianto
                  , a.lib_uso_man
                  , a.inst_in_out
                  , a.idoneita_locale
                  , a.ap_ventilaz
                  , a.ap_vent_ostruz
                  , a.pendenza
                  , a.sezioni
                  , a.curve
                  , a.lunghezza
                  , a.conservazione
                  , a.scar_ca_si
                  , a.scar_parete
                  , a.riflussi_locale
                  , a.assenza_perdite
                  , a.pulizia_ugelli
                  , a.antivento
                  , a.scambiatore
                  , a.accens_reg
                  , a.disp_comando
                  , a.ass_perdite
                  , a.valvola_sicur
                  , a.vaso_esp
                  , a.disp_sic_manom
                  , a.organi_integri
                  , a.circ_aria
                  , a.guarn_accop
                  , a.assenza_fughe
                  , a.coibentazione
                  , a.eff_evac_fum
                  , a.cont_rend
		  , case when a.cont_rend = 'S' then 'Effettuato'      --gac06
		         when a.cont_rend = 'N' then 'Non effettuato'  --gac06
			 end as cont_rend_gen                          --gac06
		  , iter_edit_num(a.rct_dur_acqua,2) as rct_dur_acqua
                  , a.rct_tratt_in_risc       
                  , a.rct_tratt_in_acs       
                  , a.rct_install_interna      
                  , a.rct_install_esterna     
                  , a.rct_canale_fumo_idoneo  
                  , a.rct_sistema_reg_temp_amb 
                  , a.rct_assenza_per_comb     
                  , a.rct_idonea_tenuta         
                  , a.rct_valv_sicurezza      
                  , a.rct_scambiatore_lato_fumi 
                  , a.rct_riflussi_comb         
                  , a.rct_uni_10389             
                  , iter_edit_num(a.rct_rend_min_legge, 2) as rct_rend_min_legge
                  , a.rct_modulo_termico
                  , a.rct_check_list_1
                  , a.rct_check_list_2
                  , a.rct_check_list_3
                  , a.rct_check_list_4
                  , a.rct_gruppo_termico
                  , a.rct_lib_uso_man_comp   
                  , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
                  , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
                  , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2          
                  , stagione_risc             
                  , stagione_risc2               
		  , iter_edit_num(a.acquisti, 2) as acquisti
		  , iter_edit_num(a.acquisti2, 2) as acquisti2
		  , iter_edit_num(a.scorta_o_lett_iniz, 2) as scorta_o_lett_iniz
		  , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2
                  , iter_edit_num(a.scorta_o_lett_fin, 2) as scorta_o_lett_fin
		  , iter_edit_num(a.scorta_o_lett_fin2, 2) as scorta_o_lett_fin2		  
                  , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
                  , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
                  , iter_edit_num(a.temp_fumi, 2) as temp_fumi
                  , iter_edit_num(a.temp_ambi, 2) as temp_ambi
                  , iter_edit_num(a.o2, 2) as o2
                  , iter_edit_num(a.co2, 2) as co2
                  , iter_edit_num(a.bacharach, 0) as bacharach
                  , a.co
                  , iter_edit_num(a.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm --rom04
                  , iter_edit_num(a.rend_combust, 2) as rend_combust
                  , a.osservazioni
                  , a.raccomandazioni
                  , a.prescrizioni
                  , iter_edit_data(a.data_utile_inter) as data_utile_inter
                  , a.n_prot
                  , iter_edit_data(a.data_prot) as data_prot
                  , a.delega_resp
                  , a.delega_manut
                  , a.num_bollo
                  , b.cognome   as cognome_manu
                  , b.nome      as nome_manu
                  , c.cognome   as cognome_resp
                  , c.nome      as nome_resp
                  , c.cod_fiscale as cod_fiscale_resp
                  , d.cognome   as cognome_prop
                  , d.nome      as nome_prop
                  , e.cognome   as cognome_occu
                  , e.nome      as nome_occu
                  , i.nome      as nome_opma
                  , i.cognome   as cognome_opma
                  , g.cod_intestatario   as cod_int_contr	
                  , h.cognome            as cognome_contr
                  , h.nome               as nome_contr
                  , iter_edit_num(a.costo, 2) as costo
                  , costo as costo_old --gac01
                  , a.tipologia_costo
                  , riferimento_pag

                  , (select iter_edit_data(f.data_scad) as data_scad
                       from coimmovi f
                      where f.riferimento  = a.cod_dimp
                        and f.cod_impianto = a.cod_impianto
                        and f.tipo_movi    = 'MH'
                   order by cod_movi desc
                      limit 1) as data_scad

		  , (select case
                            when importo_pag is null
                             and data_pag    is null
                            then 'N'
                            else 'S'
                            end as flag_pagato 
                       from coimmovi f
                      where f.riferimento  = a.cod_dimp
                        and f.cod_impianto = a.cod_impianto
                        and f.tipo_movi    = 'MH'
                   order by cod_movi desc
                      limit 1) as flag_pagato

		  , iter_edit_num(a.potenza, 2) as potenza
                  , a.data_ins
                  , a.flag_co_perc
                  , a.scar_can_fu
                  , iter_edit_num(a.tiraggio,2)     as tiraggio_fumi
                  , iter_edit_time(a.ora_inizio)    as ora_inizio
                  , iter_edit_time(a.ora_fine)      as ora_fine
                  , iter_edit_data(a.data_scadenza) as data_scadenza_autocert
                  , a.num_autocert
		  , a.utente_ins
		  , iter_edit_data(a.data_arrivo_ente) as data_arrivo_ente
                  , cod_docu_distinta
                  , iter_edit_num(a.importo_tariffa,2) as importo_tariffa
                  , a.tariffa as tariffa_reg
                  , a.cod_cind
                  , iter_edit_data(a.data_prox_manut) as data_prox_manut
                  , g.cod_potenza --sim08
                  , a.cod_tprc    --sim58
		  , iter_edit_num(a.bacharach2, 0) as bacharach2        --gac01
                  , iter_edit_num(a.bacharach3, 0) as bacharach3        --gac01
		  , iter_edit_num(a.portata_comb, 2) as portata_comb    --gac01
		  , a.rispetta_indice_bacharach                         --gac01
		  , a.co_fumi_secchi                                    --gac01
		  , a.rend_magg_o_ugua_rend_min                         --gac01
		  , iter_edit_num(a.portata_termica_effettiva, 2) as portata_termica_effettiva --gac02
		  , a.elet_esercizio_1         --gac03
                  , a.elet_esercizio_2         --gac03
                  , a.elet_esercizio_3         --gac03
                  , a.elet_esercizio_4         --gac03
                  , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac03
                  , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac03
                  , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac03
                  , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac03
                  , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac03
                  , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac03
		  , a.cod_strumento_01   --gac04
		  , a.cod_strumento_02   --gac04
		  , a.flag_pagato as flag_pagato_dimp --gac08
		  , a.cod_combustibile as combustibile_dimp --rom06
		  , comb.um as unita_misura_consumi         --rom06
		  , a.cod_manu_dele  --ric01
		  , coalesce(man.cognome,'')||' '||coalesce(man.nome,'') as rag_sociale_delegato   --ric01
		  , a.cod_opma_dele  --ric01
		  , coalesce(opm.cognome,'')||' '||coalesce(opm.nome,'') as nome_opma_delegato     --ric01
		  , data_controllo as data_controllo_st   --ric02
               from coimdimp$stn a
               left outer join coimmanu b on b.cod_manutentore  = a.cod_manutentore
	       left outer join coimcitt c on c.cod_cittadino    = a.cod_responsabile
	       left outer join coimcitt d on d.cod_cittadino    = a.cod_proprietario
               left outer join coimcitt e on e.cod_cittadino    = a.cod_occupante
               left outer join coimopma i on i.cod_opma         = a.cod_opmanu_new
                    inner join coimaimp g on g.cod_impianto     = a.cod_impianto
               left outer join coimcitt h on h.cod_cittadino    = g.cod_intestatario
               left outer join coimcomb comb on comb.cod_combustibile = a.cod_combustibile --rom06
	       left outer join coimmanu man on man.cod_manutentore  = a.cod_manu_dele --ric01
	       left outer join coimopma opm on opm.cod_opma         = a.cod_opma_dele --ric01
              where a.cod_dimp = :cod_dimp
       </querytext>
    </fullquery>


    <fullquery name="sel_dimp_new">
       <querytext>
             select a.cod_dimp
                  , a.cod_impianto
                  , iter_edit_data(a.data_controllo) as data_controllo
		  , iter_edit_data(a.data_ultima_manu) as data_ultima_manu --gac05
                  , a.gen_prog
                  , a.cod_manutentore
                  , a.cod_opmanu_new
                  , a.cod_responsabile
                  , a.cod_proprietario
                  , a.cod_occupante
                  , a.flag_status
                  , a.garanzia
                  , a.conformita
                  , a.lib_impianto
                  , a.lib_uso_man
                  , a.inst_in_out
                  , a.idoneita_locale
                  , a.ap_ventilaz
                  , a.ap_vent_ostruz
                  , a.pendenza
                  , a.sezioni
                  , a.curve
                  , a.lunghezza
                  , a.conservazione
                  , a.scar_ca_si
                  , a.scar_parete
                  , a.riflussi_locale
                  , a.assenza_perdite
                  , a.pulizia_ugelli
                  , a.antivento
                  , a.scambiatore
                  , a.accens_reg
                  , a.disp_comando
                  , a.ass_perdite
                  , a.valvola_sicur
                  , a.vaso_esp
                  , a.disp_sic_manom
                  , a.organi_integri
                  , a.circ_aria
                  , a.guarn_accop
                  , a.assenza_fughe
                  , a.coibentazione
                  , a.eff_evac_fum
                  , a.cont_rend
                  , case when a.cont_rend = 'S' then 'Effettuato'      --gac06
                         when a.cont_rend = 'N' then 'Non effettuato'  --gac06
                         end as cont_rend_gen                          --gac06
                  , iter_edit_num(a.rct_dur_acqua,2) as rct_dur_acqua   
                  , a.rct_tratt_in_risc       
                  , a.rct_tratt_in_acs       
                  , a.rct_install_interna      
                  , a.rct_install_esterna     
                  , a.rct_canale_fumo_idoneo  
                  , a.rct_sistema_reg_temp_amb 
                  , a.rct_assenza_per_comb     
                  , a.rct_idonea_tenuta         
                  , a.rct_valv_sicurezza      
                  , a.rct_scambiatore_lato_fumi 
                  , a.rct_riflussi_comb         
                  , a.rct_uni_10389             
                  , iter_edit_num(a.rct_rend_min_legge, 2) as rct_rend_min_legge
                  , a.rct_modulo_termico
                  , a.rct_check_list_1          
                  , a.rct_check_list_2          
                  , a.rct_check_list_3         
                  , a.rct_check_list_4          
                  , a.rct_gruppo_termico
                  , a.rct_lib_uso_man_comp   
                  , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
                  , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
                  , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2                
                  , stagione_risc             
                  , stagione_risc2       
                  , iter_edit_num(a.acquisti, 2) as acquisti
		  , iter_edit_num(a.acquisti2, 2) as acquisti2
                  , iter_edit_num(a.scorta_o_lett_iniz, 2) as scorta_o_lett_iniz
		  , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2
                  , iter_edit_num(a.scorta_o_lett_fin, 2) as scorta_o_lett_fin
		  , iter_edit_num(a.scorta_o_lett_fin2, 2) as scorta_o_lett_fin2
                  , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
                  , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
                  , iter_edit_num(a.temp_fumi, 2) as temp_fumi
                  , iter_edit_num(a.temp_ambi, 2) as temp_ambi
                  , iter_edit_num(a.o2, 2) as o2
                  , iter_edit_num(a.co2, 2) as co2
                  , iter_edit_num(a.bacharach, 2) as bacharach
                  , a.co
                  , iter_edit_num(a.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm
                  , iter_edit_num(a.rend_combust, 2) as rend_combust
                  , a.osservazioni
                  , a.raccomandazioni
                  , a.prescrizioni
                  , iter_edit_data(a.data_utile_inter) as data_utile_inter
                  , a.n_prot
                  , iter_edit_data(a.data_prot) as data_prot
                  , a.delega_resp
                  , a.delega_manut
                  , a.num_bollo
                  , b.cognome   as cognome_manu
                  , b.nome      as nome_manu
                  , c.cognome   as cognome_resp
                  , c.nome      as nome_resp
                  , c.cod_fiscale as cod_fiscale_resp
                  , d.cognome   as cognome_prop
                  , d.nome      as nome_prop
                  , e.cognome   as cognome_occu
                  , e.nome      as nome_occu
                  , i.nome      as nome_opma
                  , i.cognome   as cognome_opma
                  , g.cod_intestatario   as cod_int_contr	
                  , h.cognome            as cognome_contr
                  , h.nome               as nome_contr
                  , iter_edit_num(a.costo, 2) as costo
                  , a.tipologia_costo
                  , riferimento_pag

                  , (select iter_edit_data(f.data_scad) as data_scad
                       from coimmovi f
                      where f.riferimento  = a.cod_dimp
                        and f.cod_impianto = a.cod_impianto
                        and f.tipo_movi    = 'MH'
                   order by cod_movi desc
                      limit 1) as data_scad

                  , (select case
                            when importo_pag is null
                             and data_pag    is null
                            then 'N'
                            else 'S'
                            end as flag_pagato
                       from coimmovi f
                      where f.riferimento  = a.cod_dimp
                        and f.cod_impianto = a.cod_impianto
                        and f.tipo_movi    = 'MH'
                   order by cod_movi desc
                      limit 1) as flag_pagato

		  , iter_edit_num(a.potenza, 2) as potenza
                  , a.data_ins
                  , a.flag_co_perc
                  , a.scar_can_fu
                  , iter_edit_num(a.tiraggio,2)     as tiraggio_fumi
                  , iter_edit_time(a.ora_inizio)    as ora_inizio
                  , iter_edit_time(a.ora_fine)      as ora_fine
                  , iter_edit_data(a.data_scadenza) as data_scadenza_autocert
                  , a.num_autocert
		  , a.utente_ins
		  , iter_edit_data(a.data_arrivo_ente) as data_arrivo_ente
                  , cod_docu_distinta
                  , iter_edit_num(a.importo_tariffa,2) as importo_tariffa
                  , a.tariffa as tariffa_reg
                  , a.cod_cind
                  , iter_edit_data(a.data_prox_manut) as data_prox_manut
                  , a.cod_tprc  --sim58
		  , iter_edit_num(a.bacharach2, 2) as bacharach2        --gac01
                  , iter_edit_num(a.bacharach3, 2) as bacharach3        --gac01
                  , iter_edit_num(a.portata_comb, 2) as portata_comb  --gac01
                  , a.rispetta_indice_bacharach                         --gac01
                  , a.co_fumi_secchi                                    --gac01
                  , a.rend_magg_o_ugua_rend_min                         --gac01
		  , iter_edit_num(a.portata_termica_effettiva, 2) as portata_termica_effettiva --gac02
                  , a.elet_esercizio_1         --gac03
                  , a.elet_esercizio_2         --gac03
                  , a.elet_esercizio_3         --gac03
                  , a.elet_esercizio_4         --gac03
                  , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac03
                  , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac03
                  , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac03
                  , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac03
                  , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac03
                  , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac03
		  , a.cod_strumento_01  --gac04
		  , a.cod_strumento_02  --gac04
		  , a.flag_pagato as flag_pagato_dimp --gac08
		  , a.cod_combustibile as combustibile_dimp    --rom06
		  , comb.um            as unita_misura_consumi --rom06
	       from coimdimp$stn a
               left outer join coimmanu b on b.cod_manutentore  = a.cod_manutentore
               left outer join coimcitt c on c.cod_cittadino    = a.cod_responsabile
	       left outer join coimcitt d on d.cod_cittadino    = a.cod_proprietario
               left outer join coimcitt e on e.cod_cittadino    = a.cod_occupante
               left outer join coimopma i on i.cod_opma         = a.cod_opmanu_new
                    inner join coimaimp g on g.cod_impianto     = a.cod_impianto
               left outer join coimcitt h on h.cod_cittadino    = g.cod_intestatario
               left outer join coimcomb comb on comb.cod_combustibile = a.cod_combustibile --rom06
              where a.cod_dimp = :cod_dimp
       </querytext>
    </fullquery>
 
    <fullquery name="sel_dual_cod_dimp">
       <querytext>
        select nextval('coimdimp_s') as cod_dimp
       </querytext>
    </fullquery>

    <fullquery name="sel_manu">
       <querytext>
             select cod_manutentore
               from coimmanu
              where upper(trim(cognome))   $eq_cognome --sim
	      --sim upper(cognome)   $eq_cognome
                and nome      $eq_nome
       </querytext>
    </fullquery>

    <fullquery name="sel_opma">
       <querytext>
             select cod_opma as cod_opma
               from coimopma
              where upper(cognome)   $eq_cognome
                and upper(nome)      $eq_nome
                and cod_manutentore = :cod_manutentore
                and coalesce(stato,'0') <> '1'
       </querytext>
    </fullquery>

    <fullquery name="sel_citt">
       <querytext>
             select cod_cittadino
               from coimcitt
              where cognome   $eq_cognome
                and nome      $eq_nome
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_old_marche"> 
       <querytext>
       select b.cod_manutentore    as cod_manutentore_old --rom05
    --rom05 , a.cod_manutentore    as cod_manutentore_old
            , a.cod_responsabile   as cod_responsabile_old
            , a.cod_occupante      as cod_occupante_old
            , a.cod_proprietario   as cod_proprietario_old
            , a.cod_intestatario   as cod_int_contr_old
            , a.cod_intestatario   as cod_intestatario_old
            , a.cod_amministratore as cod_amministratore_old
	    , a.flag_resp          as flag_resp_old
	    , a.cod_potenza        as cod_potenza_old
            , a.$nome_col_aimp_potenza  as potenza_old
            , a.flag_dichiarato
            , a.data_installaz
            , a.note               as note_aimp
            , b.cognome            as cognome_manu_old
            , b.nome               as nome_manu_old
            , c.cognome            as cognome_resp_old
            , c.nome               as nome_resp_old
            , d.cognome            as cognome_occu_old
            , d.nome               as nome_occu_old
            , e.cognome            as cognome_prop_old
            , e.nome               as nome_prop_old
            , f.cognome            as cognome_contr_old
            , f.nome               as nome_contr_old
            , c.cod_fiscale        as cod_fiscale_resp_old
            , a.data_prima_dich    as dt_prima_dich
            from coimaimp a
	    left join coimmanu b on b.cod_manutentore = case when :cod_manu is null then a.cod_manutentore
	                                                     else :cod_manu end
	 left outer join coimcitt c on c.cod_cittadino   = a.cod_responsabile
	 left outer join coimcitt d on d.cod_cittadino   = a.cod_occupante
	 left outer join coimcitt e on e.cod_cittadino   = a.cod_proprietario
	 left outer join coimcitt f on f.cod_cittadino   = a.cod_intestatario
         where a.cod_impianto = :cod_impianto
	 limit 1
       </querytext>
    </fullquery>

    
    <fullquery name="sel_aimp_old">
       <querytext>
       select b.cod_manutentore    as cod_manutentore_old --rom05
    --rom05 , a.cod_manutentore    as cod_manutentore_old
            , a.cod_responsabile   as cod_responsabile_old
            , a.cod_occupante      as cod_occupante_old
            , a.cod_proprietario   as cod_proprietario_old
            , a.cod_intestatario   as cod_int_contr_old
            , a.cod_intestatario   as cod_intestatario_old
            , a.cod_amministratore as cod_amministratore_old
	    , a.flag_resp          as flag_resp_old
	    , a.cod_potenza        as cod_potenza_old
            , a.$nome_col_aimp_potenza  as potenza_old
            , a.flag_dichiarato
            , a.data_installaz
            , a.note               as note_aimp
            , b.cognome            as cognome_manu_old
            , b.nome               as nome_manu_old
            , c.cognome            as cognome_resp_old
            , c.nome               as nome_resp_old
            , d.cognome            as cognome_occu_old
            , d.nome               as nome_occu_old
            , e.cognome            as cognome_prop_old
            , e.nome               as nome_prop_old
            , f.cognome            as cognome_contr_old
            , f.nome               as nome_contr_old
            , c.cod_fiscale        as cod_fiscale_resp_old
            , a.data_prima_dich    as dt_prima_dich
         from coimaimp a
	 left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore
                                    or (b.cod_manutentore  = a.cod_installatore
              	                    and a.cod_installatore = :cod_manu) --rom05
	 left outer join coimcitt c on c.cod_cittadino   = a.cod_responsabile
	 left outer join coimcitt d on d.cod_cittadino   = a.cod_occupante
	 left outer join coimcitt e on e.cod_cittadino   = a.cod_proprietario
	 left outer join coimcitt f on f.cod_cittadino   = a.cod_intestatario
         where a.cod_impianto = :cod_impianto
	 limit 1
       </querytext>
    </fullquery>
    
    <fullquery name="sel_dimp_check_data_controllo">
       <querytext>
       select '1' 
         from coimdimp$stn
        where cod_impianto   = :cod_impianto
          and data_controllo = :data_controllo
          $where_gen_prog
         limit 1
       </querytext>
    </fullquery>

    <fullquery name="sel_manu_flag_convenzionato">
       <querytext>
        select flag_convenzionato
          from coimmanu
         where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp_check_riferimento_pag">
       <querytext>
        select count(*) as count_riferimento_pag
          from coimdimp$stn
         where riferimento_pag = :riferimento_pag
           and tipologia_costo = :tipologia_costo
        $where_codice
       </querytext>
    </fullquery>

    <fullquery name="sel_boll_manu">
       <querytext>
           select upper(matricola_da) as matricola_da
                , upper(matricola_a)  as matricola_a
                , cod_tpbo
                , pagati
             from coimboll 
            where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>

    <fullquery name="sel_boll_boap">
       <querytext>
           select upper(matr_da) as matr_da
                , upper(matr_a)  as matr_a
             from coimboap
            where cod_manutentore_a = :cod_manutentore
       </querytext>
    </fullquery>

    <fullquery name="sel_dual_cod_movi">
        <querytext>
           select nextval('coimmovi_s') as cod_movi
       </querytext>
    </fullquery>

    <partialquery name="ins_movi">
       <querytext>
                insert
                  into coimmovi 
                     ( cod_movi
                     , tipo_movi
                     , cod_impianto
                     , data_scad
                     , data_compet
                     , importo
                     , importo_pag
                     , riferimento
                     , data_pag
                     , tipo_pag
                     , data_ins
                     , utente
                     )
                values 
                     (:cod_movi
                     ,'MH'
                     ,:cod_impianto
                     ,:data_scad_pagamento
                     ,:data_controllo
                     ,:costo
                     ,:importo_pag
                     ,:cod_dimp
                     ,:data_pag
                     ,:tipologia_costo
                     , current_date
                     ,:id_utente
                     )
       </querytext>
    </partialquery>

    <partialquery name="ins_movi_new">
       <querytext>
                insert
                  into coimmovi 
                     ( cod_movi
                     , tipo_movi
                     , cod_impianto
                     , data_scad
                     , data_compet
                     , importo
                     , importo_pag
                     , riferimento
                     , data_pag
                     , tipo_pag
                     , data_ins
                     , utente
                     , id_caus)
                values 
                     (:cod_movi
                     ,'MH'
                     ,:cod_impianto
                     ,:data_scad_pagamento
                     ,:data_controllo
                     ,:costo
                     ,:importo_pag
                     ,:cod_dimp
                     ,:data_pag
                     ,:tipologia_costo
                     , current_date
                     ,:id_utente
                     ,(select s.id_caus from coimcaus s where s.codice = 'MH'))
       </querytext>
    </partialquery>

    <partialquery name="upd_movi">
       <querytext>
                update coimmovi
                   set data_scad    = :data_scad_pagamento
                     , data_compet  = :data_controllo
                     , importo      = :costo
                     , importo_pag  = :importo_pag
                     , data_pag     = :data_pag
                     , tipo_pag     = :tipologia_costo
                     , data_mod     =  current_date
                     , utente       = :id_utente
                 where cod_movi     = :cod_movi                 
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_sogg">
       <querytext>
          update coimaimp
             set cod_manutentore  = :cod_manutentore
               , cod_responsabile = :cod_responsabile_new
               , cod_occupante    = :cod_occupante
               , cod_proprietario = :cod_proprietario
	       , flag_resp        = :flag_resp
               , data_mod         =  current_date
               , utente           = :id_utente
           where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <fullquery name="sel_rife_check">
       <querytext>
	 select '1'
           from coimrife
          where cod_impianto   = :cod_impianto
            and ruolo          = :ruolo
            and data_fin_valid = (current_date - 1)
       </querytext>
    </fullquery>

    <partialquery name="ins_rife">
       <querytext>
         insert
           into coimrife
              ( cod_impianto
              , ruolo
              , data_fin_valid 
              , cod_soggetto
              , data_ins
              , utente
     ) values (
               :cod_impianto
              ,:ruolo
              ,(current_date - 1)
              ,:cod_soggetto_old
              , current_date
              ,:id_utente
              )
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_flag_dich_data_inst">
       <querytext>
        update coimaimp
           set flag_dichiarato = :flag_dichiarato
             , data_installaz  = :data_installaz
             , note            = :note
             , data_mod        =  current_date
             , utente          = :id_utente 
         where cod_impianto    = :cod_impianto        
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_stato">
       <querytext>
          update coimaimp
             set stato_conformita = :stato_conformita
           where cod_impianto     = :cod_impianto
       </querytext>
    </partialquery>

    <fullquery name="sel_movi_check">
       <querytext>
       select cod_movi 
         from coimmovi
        where riferimento  = :cod_dimp
          and cod_impianto = :cod_impianto
          and tipo_movi    = 'MH' 
        limit 1
       </querytext>
    </fullquery>

  <fullquery name="sel_movi_check_new">
       <querytext>
       select cod_movi 
         from coimmovi
        where riferimento  = :cod_dimp
          and cod_impianto = :cod_impianto
          and id_caus      = (select s.id_caus from coimcaus s where s.codice = 'MH') 
        limit 1
       </querytext>
    </fullquery>


    <partialquery name="del_movi">
       <querytext>
          delete from coimmovi
           where tipo_movi   = 'MH'
             and riferimento = :cod_dimp
       </querytext>
    </partialquery>

    <partialquery name="del_movi_new">
       <querytext>
          delete from coimmovi
           where id_caus = (select s.id_caus from coimcaus s where s.codice = 'MH')
             and riferimento = :cod_dimp
       </querytext>
    </partialquery>

    <fullquery name="sel_dimp_count">
        <querytext>
        select count(*) as conta_dimp
          from coimdimp$stn
         where cod_impianto = :cod_impianto 
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp_last">
        <querytext>
	select max(data_controllo) as data_controllo
          from coimdimp$stn
         where cod_impianto  = :cod_impianto
           and cod_dimp     <> :cod_dimp
        </querytext>
    </fullquery>    

    <fullquery name="sel_tari">
        <querytext>
	select iter_edit_num(a.importo,2) as tariffa
             , a.flag_tariffa_impianti_vecchi                                        --sim08
	     , a.anni_fine_tariffa_base                                              --sim08
             , iter_edit_num(a.tariffa_impianti_vecchi,2) as tariffa_impianti_vecchi --sim08 
          from coimtari a
         where a.cod_potenza = :cod_potenza_old
           and a.tipo_costo  = '1' 
           and a.cod_listino = :cod_listino 
           and a.data_inizio = (select max(d.data_inizio) 
                                  from coimtari d 
                                 where d.cod_potenza = :cod_potenza_old
                                   and d.cod_listino  = :cod_listino
                                   and d.tipo_costo  = '1'
                                   and d.data_inizio <= :data_controllo_tariffa)
       </querytext>
    </fullquery>

    <fullquery name="sel_tari_ucit">
        <querytext>
        select iter_edit_num(a.importo,2) as tariffa
             , a.flag_tariffa_impianti_vecchi                                        
             , a.anni_fine_tariffa_base                                              
             , iter_edit_num(a.tariffa_impianti_vecchi,2) as tariffa_impianti_vecchi 
          from coimtari a
         where a.cod_potenza = :cod_potenza_old
           and a.tipo_costo  = '1'
           and a.cod_listino = :cod_listino
           and a.data_inizio = (select max(d.data_inizio)
                                  from coimtari d
                                 where d.cod_potenza = :cod_potenza_old
                                   and d.cod_listino  = :cod_listino
                                   and d.tipo_costo  = '1'
                                   and d.data_inizio <= :data_controllo_tariffa_ucit)
        </querytext>
    </fullquery>


    <fullquery name="sel_tari_contributo">
        <querytext>
	select iter_edit_num(a.importo,2) as importo_tariffa
          from coimtari a
         where a.cod_potenza = :cod_potenza_old
           and a.tipo_costo  = '7' 
           and a.cod_listino = '0'
       </querytext>
    </fullquery>

    <fullquery name="sel_old_dimp">
        <querytext>
	select '1'
          from coimdimp$stn
         where cod_impianto = :cod_impianto
        limit 1
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_count">
       <querytext>
        select count(*) as conta_gend
          from coimgend
         where cod_impianto = :cod_impianto
           and flag_attivo  = 'S'
       </querytext>
    </fullquery>

    <partialquery name="upd_gend_pote">
       <querytext>
           update coimgend
	      set pot_focolare_lib = :pot_focolare_nom
	        , pot_utile_lib    = :potenza
                , pot_focolare_nom = :pot_focolare_nom
                , pot_utile_nom    = :potenza
		, data_mod         =  current_date
		, utente           = :id_utente
            where cod_impianto     = :cod_impianto
              and flag_attivo      = 'S'
              and gen_prog         = :gen_prog -- nic02
       </querytext>
    </partialquery>

    <fullquery name="sel_pote_fascia">
       <querytext>
          select cod_potenza
            from coimpote 
           where potenza_min <= :potenza_chk
             and potenza_max >= :potenza_chk
	     and flag_tipo_impianto = :flag_tipo_impianto --sim27
       </querytext>
    </fullquery>

    <partialquery name="upd_aimp_pote">
       <querytext>
           update coimaimp
	      set cod_potenza    = :cod_potenza
                , potenza        = :pot_focolare_nom
                , potenza_utile  = :potenza
		, data_mod       =  current_date
		, utente         = :id_utente
            where cod_impianto   = :cod_impianto
       </querytext>
    </partialquery>


    <partialquery name="ins_anom">
       <querytext>
                insert
                  into coimanom 
                     ( cod_cimp_dimp
                     , prog_anom
                     , tipo_anom
                     , cod_tanom
                     , dat_utile_inter
		     , flag_origine)
                values 
                     (:cod_dimp
                     ,:prog_anom_db
                     ,'1'
                     ,:cod_anom_db
                     ,:data_ut_int_db
		     ,'MH')
       </querytext>
    </partialquery>

    <fullquery name="sel_tano">
       <querytext>
             select cod_tano||' '||coalesce(descr_tano,'') as note
               from coimtano
              where cod_tano = :cod_anom_db
       </querytext>
    </fullquery>

    <fullquery name="sel_dual_cod_todo">
       <querytext>
        select nextval('coimtodo_s') as cod_todo
       </querytext>
    </fullquery>

    <partialquery name="ins_todo">
        <querytext>
	    insert into 
            coimtodo ( cod_todo
                     , cod_impianto
                     , tipologia
                     , note
                     , cod_cimp_dimp
                     , flag_evasione
		     , data_evasione
                     , data_evento
                     , data_scadenza
                     , data_ins
                     , utente
                     ) values (
		      :cod_todo
		     ,:cod_impianto
		     ,:tipologia
		     ,:note
		     ,:cod_dimp
                     ,:flag_evasione
		     ,:data_evasione
                     ,:data_evento
                     ,:data_scadenza
                     , current_date
                     ,:id_utente
		     )
        </querytext>
    </partialquery>

    <fullquery name="sel_anom">
       <querytext>
           select prog_anom
	        , cod_tanom 
		, iter_edit_data(dat_utile_inter) as dat_utile_inter
             from coimanom 
            where cod_cimp_dimp = :cod_dimp
	      and flag_origine  = 'MH'
         order by to_number(prog_anom,'99999999')
            limit 5
       </querytext>
    </fullquery>

    <fullquery name="sel_anom_count">
       <querytext>
        select count(*) as conta_anom
          from coimanom
         where cod_cimp_dimp = :cod_dimp
           and cod_tanom     = :cod_anom_db
	   and flag_origine  = 'MH'
	   and prog_anom     > :prog_anom_max
	   and prog_anom    <> :prog_anom_db
       </querytext>
    </fullquery>

    <partialquery name="del_todo_anom">
       <querytext>
           delete 
             from coimtodo
            where cod_impianto     = :cod_impianto
              and tipologia        = '1'
              and cod_cimp_dimp    = :cod_dimp
	      and substr(note,1,3) = (select cod_tanom
                                        from coimanom
                                       where cod_cimp_dimp =  :cod_dimp
                                         and flag_origine  =  'MH'
                                         and prog_anom     =  :prog_anom_db)
       </querytext>
    </partialquery>

    <partialquery name="del_anom">
       <querytext>
                delete
                  from coimanom
                 where cod_cimp_dimp = :cod_dimp
		   and flag_origine  = 'MH'
                   and prog_anom     = :prog_anom_db
       </querytext>
    </partialquery>

    <partialquery name="del_todo_boll">
       <querytext>
           delete 
             from coimtodo
            where cod_impianto     = :cod_impianto
              and tipologia        = '1'
              and cod_cimp_dimp    = :cod_dimp
	      and note          like :note
       </querytext>
    </partialquery>

    <partialquery name="del_todo_all">
       <querytext>
        delete
          from coimtodo
         where cod_impianto  = :cod_impianto
           and tipologia    in ('1', '5')
           and cod_cimp_dimp = :cod_dimp
       </querytext>
    </partialquery>

    <partialquery name="del_anom_all">
       <querytext>
           delete
             from coimanom
            where cod_cimp_dimp = :cod_dimp
	      and flag_origine  = 'MH'
       </querytext>
    </partialquery>

    <fullquery name="sel_dimp_esito">
       <querytext>
           select flag_status
                , flag_pericolosita 
             from coimdimp$stn
            where cod_dimp = :cod_dimp
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_mod">
       <querytext>
           select b.cod_cost as costruttore
                , b.descr_cost --gac06
                , a.modello
                , a.cod_mode   -- nic01
		, a.matricola
		, c.cod_combustibile as combustibile
		, iter_edit_data(a.data_installaz) as data_insta
		, a.tiraggio
		, case when a.tiraggio = 'N' then 'Naturale' --gac06
		       when a.tiraggio = 'F' then 'Forzato'  --gac06
		       end as tiraggio_gen                   --gac06
		, d.cod_utgi as destinazione
		, a.tipo_foco as tipo_a_c
		, case when a.tipo_foco = 'A' then 'Aperto'  --gac06
		       when a.tipo_foco = 'C' then 'Chiuso'  --gac06
		       end as tipo_a_c_gen                   --gac06
  -- nic02 , a.gen_prog
                , a.locale
                , iter_edit_data(a.data_costruz_gen) as data_costruz_gen
                , a.marc_effic_energ  
                , iter_edit_num(e.volimetria_risc,2) as volimetria_risc
                , iter_edit_num(e.consumo_annuo,2) as consumo_annuo
                , iter_edit_num(a.pot_focolare_nom,2) as pot_focolare_nom
                , iter_edit_num(a.pot_utile_nom,2) as pot_utile_nom -- nic03
		, num_prove_fumi --rom01
                , c.tipo as tipo_combustibile
		, a.flag_clima_invernale
		, case when a.flag_clima_invernale = 'S' then 'Sì' --gac05
		       when a.flag_clima_invernale = 'N' then 'No' --gac05
		       end as flag_clima_invernale_gen --gac05
		, a.flag_prod_acqua_calda
		, case when a.flag_prod_acqua_calda = 'S' then 'Sì' --gac05
		       when a.flag_prod_acqua_calda = 'N' then 'No' --gac05
                       end as flag_prod_acqua_calda_gen --gac05
		, a.cod_grup_term --gac06
		, c.descr_comb
                , f.desc_grup_term --gac06
	     from coimaimp e
       inner join coimgend a on a.cod_impianto = e.cod_impianto
  left outer join coimcost b on b.cod_cost = a.cod_cost
  left outer join coimcomb c on c.cod_combustibile = a.cod_combustibile
  left outer join coimutgi d on d.cod_utgi = a.cod_utgi
  left outer join coimtipo_grup_termico f on a.cod_grup_term = f.cod_grup_term --gac06
            where e.cod_impianto = :cod_impianto
-- nic02    where_gen
              and a.gen_prog     = :gen_prog -- nic02
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_no_mod">
       <querytext>
           select b.descr_cost as costruttore
                , b.descr_cost --gac06
		, a.modello
                , a.cod_mode   -- nic01
		, a.matricola
		, c.descr_comb as combustibile
		, iter_edit_data(a.data_installaz) as data_insta
		, a.tiraggio
		, case when a.tiraggio = 'N' then 'Naturale' --gac06
		       when a.tiraggio = 'F' then 'Forzato'  --gac06
		       end as tiraggio_gen                   --gac06
		, d.cod_utgi as destinazione
		, a.tipo_foco as tipo_a_c
		, case when a.tipo_foco = 'A' then 'Aperto'  --gac06
		       when a.tipo_foco = 'C' then 'Chiuso'  --gac06
		       end as tipo_a_c_gen                   --gac06
 -- nic02  , a.gen_prog
                , a.locale
                , iter_edit_data(a.data_costruz_gen) as data_costruz_gen
                , a.marc_effic_energ  
                , iter_edit_num(e.volimetria_risc,2) as volimetria_risc
                , iter_edit_num(e.consumo_annuo,2) as consumo_annuo
                , iter_edit_num(a.pot_focolare_nom,2) as pot_focolare_nom
                , iter_edit_num(a.pot_utile_nom,2) as pot_utile_nom -- nic03
                , num_prove_fumi --rom01
                , c.tipo as tipo_combustibile
		, a.flag_clima_invernale
                , case when a.flag_clima_invernale = 'S' then 'Sì' --gac05
		       when a.flag_clima_invernale = 'N' then 'No' --gac05
		       end as flag_clima_invernale_gen --gac05
		, a.flag_prod_acqua_calda
		, case when a.flag_prod_acqua_calda = 'S' then 'Sì' --gac05
		       when a.flag_prod_acqua_calda = 'N' then 'No' --gac05
		       end as flag_prod_acqua_calda_gen --gac05
                , a.cod_grup_term --gac06
		, f.desc_grup_term --gac06
             from coimaimp e
       inner join coimgend a on a.cod_impianto = e.cod_impianto
  left outer join coimcost b on b.cod_cost = a.cod_cost
  left outer join coimcomb c on c.cod_combustibile = e.cod_combustibile
  left outer join coimutgi d on d.cod_utgi = a.cod_utgi
  left outer join coimtipo_grup_termico f on a.cod_grup_term = f.cod_grup_term --gac06
            where e.cod_impianto = :cod_impianto
 -- nic02   where_gen
              and a.gen_prog     = :gen_prog -- nic02
       </querytext>
    </fullquery>

    <fullquery name="sel_tano_scatenante">
       <querytext>
           select flag_scatenante
             from coimtano 
            where cod_tano = :cod_anomalia
       </querytext>
    </fullquery>

    <fullquery name="sel_tano_anom">
        <querytext>
           select a.cod_tanom       as cod_tanom_check 
                , b.flag_scatenante as flag_scatenante_check
             from coimanom a
                , coimtano b
            where a.cod_cimp_dimp = :cod_dimp
	      and a.flag_origine  = 'MH'
	      and b.cod_tano      = a.cod_tanom
        </querytext>
    </fullquery>

    <fullquery name="sel_anom_count2">
       <querytext>
        select count(*) as conta_anom_2
          from coimanom
         where cod_cimp_dimp = :cod_dimp
	   and flag_origine  = 'MH'
       </querytext>
    </fullquery>

    <partialquery name="sel_gage">
        <querytext>
            select iter_edit_data(data_prevista)   as data_prevista
              from coimgage
             where cod_opma     = :cod_opma
               and cod_impianto = :cod_impianto
               and data_ins     = :data_ins
        </querytext>
    </partialquery>

    <partialquery name="upd_gage">
        <querytext>
            update coimgage
               set data_esecuzione = :data_esecuzione
                 , stato           = :stato
             where cod_opma     = :cod_opma
               and cod_impianto = :cod_impianto
               and data_ins     = :data_ins
        </querytext>
    </partialquery>

    <fullquery name="sel_aimp_comu">
        <querytext>
              select cod_comune
                from coimaimp
	       where cod_impianto = :cod_impianto
        </querytext>
    </fullquery>

    <fullquery name="sel_tano_gg_adattamento">
        <querytext>
              select gg_adattamento
                from coimtano
	       where cod_tano = :cod_anomalia
        </querytext>
    </fullquery>


    <fullquery name="upd_aimp">
       <querytext>
            update coimaimp
               set cod_intestatario = :cod_int_contr
             where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="upd_tppt">
       <querytext>
            update coimtppt
               set progressivo = progressivo + 1
             where cod_tppt = 'UC'
       </querytext>
    </fullquery>


    <fullquery name="check_modh_old">
       <querytext>
           select to_char(max(data_controllo), 'yyyymmdd') as data_ultimo_modh
             from coimdimp$stn
            where cod_impianto = :cod_impianto              
       </querytext>
    </fullquery>

    <fullquery name="add_months">
       <querytext>
	   select to_char(add_months(:data_controllo, :valid_mod_h_b),'yyyy-mm-dd') as data_scadenza_autocert
       </querytext>
    </fullquery>

    <fullquery name="sel_tgen">
       <querytext>
	   select *
             from coimtgen
       </querytext>
    </fullquery>

    <fullquery name="sel_min_data_controllo">
       <querytext>
	   select min(data_controllo) as min_data_controllo
             from coimdimp$stn
            where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_max_data_controllo">
       <querytext>
	   select max(data_controllo) as max_data_controllo
             from coimdimp$stn
            where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <partialquery name="upd_aimp_prima_dich">
       <querytext>
        update coimaimp
           set data_prima_dich  = :data_controllo
             , data_mod        =  current_date
             , utente          = :id_utente 
         where cod_impianto    = :cod_impianto        
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_ultim_dich">
       <querytext>
        update coimaimp
           set data_ultim_dich = :data_controllo
             , data_scad_dich  = :data_scadenza_autocert
             , data_mod        =  current_date
             , utente          = :id_utente 
         where cod_impianto    = :cod_impianto        
       </querytext>
    </partialquery>
    
    <fullquery name="sel_utente_ins">
       <querytext>
          select coalesce(cognome,'')||' '||coalesce(nome,'') as nome_utente_ins
	  from coimuten
	  where id_utente=:utente_ins
       </querytext>
    </fullquery>

    <partialquery name="upd_gend">
       <querytext>
           update coimgend
	      set cod_cost         = :costruttore
                , modello          = :modello
                , cod_mode         = :cod_mode -- nic01
                , matricola        = :matricola
                , cod_combustibile = :combustibile
                , tiraggio         = :tiraggio
                , tipo_foco        = :tipo_a_c
                , data_installaz   = :data_insta
                , cod_utgi         = :destinazione
                , locale           = :locale
                , data_costruz_gen = :data_costruz_gen
                , marc_effic_energ = :marc_effic_energ
                , pot_focolare_nom = :pot_focolare_nom
                , pot_utile_nom    = :potenza
		, flag_clima_invernale  = :flag_clima_invernale   --gac05
		, flag_prod_acqua_calda = :flag_prod_acqua_calda --gac05
	    where cod_impianto     = :cod_impianto
              and flag_attivo      = 'S'
              and gen_prog         = :gen_prog -- nic02
       </querytext>
    </partialquery>

    <fullquery name="upd_aimp_mod">
       <querytext>
            update coimaimp
               set cod_combustibile = :combustibile
                 , data_installaz   = :data_insta
                 , consumo_annuo    = :consumo_annuo
                 , anno_costruzione = :data_costruz_gen
                 , marc_effic_energ = :marc_effic_energ
                 , volimetria_risc  = :volimetria_risc
    -- nic03     , potenza          = :pot_focolare_nom
    -- nic03     , potenza_utile    = :potenza
                   $aggiorna_potenze_impianto -- nic03
             where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_list"><!-- nic02 -->
       <querytext>
           select gen_prog
             from coimgend
            where cod_impianto = :cod_impianto
	      and flag_attivo  = 'S'
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp_old_gen">
       <querytext>
             select a.cod_manutentore as cod_manutentore_precedente_dimp
                  , a.cod_opmanu_new as cod_opmanu_new_precedente_dimp
                  , a.cod_responsabile as cod_responsabile_precedente_dimp
                  , a.conformita as conformita_precedente_dimp
                  , a.lib_impianto as lib_impianto_precedente_dimp
                  , a.lib_uso_man as lib_uso_man_precedente_dimp
                  , a.idoneita_locale as idoneita_locale_precedente_dimp
                  , a.ap_ventilaz as ap_ventilaz_precedente_dimp
                  , a.ap_vent_ostruz as ap_vent_ostruz_precedente_dimp
                  , iter_edit_num(a.rct_dur_acqua,2) as rct_dur_acqua_precedente_dimp
                  , a.rct_tratt_in_risc as rct_tratt_in_risc_precedente_dimp       
                  , a.rct_tratt_in_acs as rct_tratt_in_acs_precedente_dimp       
                  , a.rct_install_interna as rct_install_interna_precedente_dimp      
                  , a.rct_canale_fumo_idoneo as rct_canale_fumo_idoneo_precedente_dimp 
                  , a.rct_sistema_reg_temp_amb as rct_sistema_reg_temp_amb_precedente_dimp
                  , a.rct_assenza_per_comb as rct_assenza_per_comb_precedente_dimp    
                  , a.rct_idonea_tenuta as rct_idonea_tenuta_precedente_dimp        
                  , a.rct_lib_uso_man_comp as rct_lib_uso_man_comp_precedente_dimp
                  , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc_precedente_dimp
                  , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo_precedente_dimp
                  , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2_precedente_dimp
                  , stagione_risc  as stagione_risc_precedente_dimp            
                  , stagione_risc2 as stagione_risc2_precedente_dimp
		  , iter_edit_num(a.acquisti, 2) as acquisti_precedente_dimp
		  , iter_edit_num(a.acquisti2, 2) as acquisti2_precedente_dimp
		  , iter_edit_num(a.scorta_o_lett_iniz, 2) as scorta_o_lett_iniz_precedente_dimp
		  , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2_precedente_dimp
                  , iter_edit_num(a.scorta_o_lett_fin, 2) as scorta_o_lett_fin_precedente_dimp
		  , iter_edit_num(a.scorta_o_lett_fin2, 2) as scorta_o_lett_fin2_precedente_dimp	  
                  , b.cognome   as cognome_manu_precedente_dimp
                  , b.nome      as nome_manu_precedente_dimp
                  , c.cognome   as cognome_resp_precedente_dimp
                  , c.nome      as nome_resp_precedente_dimp
                  , c.cod_fiscale as cod_fiscale_resp_precedente_dimp
                  , i.nome      as nome_opma_precedente_dimp
                  , i.cognome   as cognome_opma_precedente_dimp
		  , iter_edit_num(a.potenza, 2) as potenza_precedente_dimp
                  , g.cod_potenza  as cod_potenza_precedente_dimp
                  , a.elet_esercizio_1 as elet_esercizio_1_precedente_dimp
                  , a.elet_esercizio_2 as elet_esercizio_2_precedente_dimp
                  , a.elet_esercizio_3 as elet_esercizio_3_precedente_dimp
                  , a.elet_esercizio_4 as elet_esercizio_4_precedente_dimp
                  , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale_precedente_dimp  
                  , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale_precedente_dimp
                  , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale_precedente_dimp
                  , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2_precedente_dimp
                  , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2_precedente_dimp
                  , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2_precedente_dimp
                  , iter_edit_data(a.data_controllo)            as data_controllo_precedente_dimp
		  , iter_edit_data(a.data_ultima_manu)          as data_ultima_manu_precedente_dimp
                  , iter_edit_data(a.data_prox_manut)           as data_prox_manut_precedente_dimp
                  , iter_edit_time(a.ora_inizio)                as ora_inizio_precedente_dimp
                  , iter_edit_time(a.ora_fine)                  as ora_fine_precedente_dimp
		  , a.cod_strumento_01                          as cod_strumento_01_precedente_dimp --rom12
		  , a.cod_strumento_02                          as cod_strumento_02_precedente_dimp --rom12
               from coimdimp$stn a
               left outer join coimmanu b on b.cod_manutentore  = a.cod_manutentore
               left outer join coimcitt c on c.cod_cittadino    = a.cod_responsabile
	       left outer join coimcitt d on d.cod_cittadino    = a.cod_proprietario
               left outer join coimcitt e on e.cod_cittadino    = a.cod_occupante
               left outer join coimopma i on i.cod_opma         = a.cod_opmanu_new
                    inner join coimaimp g on g.cod_impianto     = a.cod_impianto
               left outer join coimcitt h on h.cod_cittadino    = g.cod_intestatario
              where a.cod_dimp = :cod_dimp_precedente
       </querytext>
    </fullquery>

</queryset>
