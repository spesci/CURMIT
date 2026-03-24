<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom02 08/07/2021 Aggiunto campo potenza preso dal generatore nell'inserimento del dimp.

    rom01 06/07/2021 Aggiunta query upd_aimp_date e aggiunto idoneita_locale nell'inserimento del dimp.

    sim01 27/06/2016 Se flag_tariffa_impianti_vecchi eq "t" e il combustibile e' Gas o Metano
    sim01            devo verificare se l'impianto e' vecchio e quindi usare un'altra tariffa.
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="iter_cari_rce_tipo_1.sel_tari_contributo">
        <querytext>
	select a.importo as importo_contr
          from coimtari a
         where a.cod_potenza = :cod_potenza_tari
           and a.tipo_costo  = '7' 
           and a.cod_listino = '0'
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.sel_tari">
        <querytext>
        select iter_edit_num(a.importo,2) as tariffa  --sim07 aggiunta query
             , a.flag_tariffa_impianti_vecchi                                        
             , a.anni_fine_tariffa_base                                               
             , iter_edit_num(a.tariffa_impianti_vecchi,2) as tariffa_impianti_vecchi 
          from coimtari a
         where a.cod_potenza = :cod_potenza_tari
           and a.tipo_costo  = '1'
           and a.cod_listino = :cod_listino
           and a.data_inizio = (select max(d.data_inizio)
                                  from coimtari d
                                 where d.cod_potenza = :cod_potenza_tari
                                   and d.cod_listino  = :cod_listino
                                   and d.tipo_costo  = '1'
                                   and d.data_inizio <= current_date)
       </querytext>
    </fullquery>


    <fullquery name="iter_cari_rce_tipo_1.sel_dimp_check_data_controllo">
       <querytext>
       select '1' 
         from coimdimp
        where cod_impianto   = :cod_impianto_catasto
          and data_controllo = :data_controllo
         limit 1
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.sel_dual_cod_citt">
       <querytext>
          select nextval('coimcitt_s') as cod_citt
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.ins_citt">
       <querytext>
           insert into coimcitt
	                ( cod_cittadino
			, nome
			, cognome
			, indirizzo
			, comune
			, natura_giuridica
			, data_ins
			, utente
                        , cap
                        , cod_fiscale
                        , telefono
			)
		 values ( :cod_citt
			, :nome_citt_chk
			, :cognome_citt_chk
			, :indirizzo_citt_chk
			, :comune_citt_chk
			, :natura_citt_chk
			, :data_corrente
			, :id_utente
                        , :cap_chk
                        , :cod_fiscale_chk
                        , :telefono_chk
			)
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.sel_dual_cod_impianto">
       <querytext>
                   select nextval('coimaimp_s') as cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.sel_dual_cod_impianto_est">
       <querytext>
                   select nextval('coimaimp_est_s') as cod_impianto_est
       </querytext>
    </fullquery>


    <fullquery name="iter_cari_rce_tipo_1.ins_aimp">
       <querytext>
                   insert
                     into coimaimp 
                        ( cod_impianto
                        , cod_impianto_est
                        , stato
                        , flag_dichiarato
                        , data_prima_dich
                        , data_ultim_dich
                        , data_scad_dich
                        , consumo_annuo
                        , stato_conformita
                        , cod_responsabile
                        , flag_resp
                        , cod_intestatario
                        , cod_proprietario
                        , cod_occupante
                        , cod_amministratore
                        , cod_manutentore
                        , cod_via
                        , toponimo
                        , indirizzo
                        , numero
--gac01			, esponente
--gac01                        , scala
--gac01                        , piano
--gac01                        , interno
                        , cod_comune
                        , cap
                        , data_ins
                        , utente_ins
--gac01			, volimetria_risc
			, cod_combustibile
			, flag_dpr412
                        , n_generatori
                        , provenienza_dati
--                        , cod_tpim
			, pdr
			, pod
--			, anno_costruzione
                        , flag_tipo_impianto
                        , targa
			)
                   values 
                        (:cod_impianto
                        ,:cod_impianto_est
                        ,:stato
                        ,'S'
                        ,:data_controllo
                        ,:data_controllo
                        ,:data_scadenza_autocert
                        ,:consumo_annuo
                        ,'S'
                        ,:cod_responsabile
                        ,:flag_responsabile
                        ,:cod_intestatario
                        ,:cod_proprietario
                        ,:cod_occupante
                        ,:cod_amministratore
                        ,:cod_manutentore
                        ,:cod_via
                        ,:toponimo
                        ,:indirizzo
                        ,:civico
--gac01                        ,:esponente
--gac01                        ,:scala
--gac01                        ,:piano
--gac01                        ,substring(:interno,1,3)
                        ,:cod_comune
                        ,:cap_occu
                        ,:data_corrente
                        ,:id_utente
--gac01			,:volimetria_risc
			,:cod_comb
			, 'S'
                        ,'1'
                        ,'7'
--                        ,:cod_tpim
			,:pdr
                        ,:pod
--			,:anno_costruzione_aimp
                        ,'R' -- flag_tipo_impianto
                        ,:targa
                        )
       </querytext>
    </fullquery>



    <fullquery name="iter_cari_rce_tipo_1.ins_gend">
       <querytext>
                   insert
                     into coimgend
                        ( cod_impianto
                        , gen_prog
                        , matricola
                        , modello
                        , cod_combustibile
                        , data_ins
                        , utente_ins
			, gen_prog_est
			, tiraggio
--gac01			, mod_funz
--gac01			, cod_emissione
--gac01			, data_costruz_gen
--gac01			, marc_effic_energ
--gac01			, cod_utgi
--gac01			, tipo_foco
--gac01			, locale
                        , cod_cost
                        
			)
                   values 
                        (:cod_impianto
                        ,:gen_prog
                        ,:matricola
                        ,:modello
                        ,:cod_comb
			,:data_corrente
                        ,:id_utente
                        ,:gen_prog
			,:tiraggio_gend
--gac01			,:fluido_termovettore_gend
--gac01			,:scarico_fumi_gend
--gac01			,:data_costruzione_gend
--gac01			,:marc_effic_energ
--gac01			,:cod_utgi
--gac01			,:tipo_foco
--gac01			,:locale
                        ,:cod_cost
                        
                        )
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.upd_gend">
       <querytext>
                   update coimgend
                      set matricola = :matricola
                        , modello = :modello
                        , cod_combustibile = :cod_comb
			, data_mod = :data_corrente
                        , utente = :id_utente
			, tiraggio = :tiraggio_gend
--gac01			, mod_funz = :fluido_termovettore_gend
--gac01			, cod_emissione = :scarico_fumi_gend
--gac01			, data_costruz_gen = :data_costruzione_gend
--gac01			, marc_effic_energ = :marc_effic_energ
--gac01			, cod_utgi = :cod_utgi
--gac01			, tipo_foco = :tipo_foco
--gac01			, locale = :locale
                        , cod_cost = :cod_cost
--gac01                 , data_installaz = :data_installaz_gend
                        
                    where cod_impianto = :cod_impianto
                      and gen_prog = :gen_prog
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.upd_aimp_date">
       <querytext>
	update coimaimp
	   set data_ultim_dich    = :data_controllo 
	     , data_scad_dich     = :data_scadenza_autocert
	 where cod_impianto       = :cod_impianto_catasto
       </querytext>
    </fullquery>


    <fullquery name="iter_cari_rce_tipo_1.upd_aimp">
       <querytext>
	update coimaimp
	   set stato_conformita   = 'S'
             , cod_manutentore    = :cod_manutentore
             , data_ultim_dich    = :data_controllo 
	     , data_scad_dich     = :data_scadenza_autocert
             , flag_resp          = :flag_responsabile
             , cod_responsabile   = :cod_responsabile
             , cod_proprietario   = :cod_proprietario
             , cod_occupante      = :cod_occupante
             , cod_intestatario   = :cod_intestatario
             , cod_amministratore = :cod_amministratore
	     , pdr                = :pdr
	     , pod                = :pod
--             , anno_costruzione   = :anno_costruzione_aimp
	     , targa              = :targa 
	 where cod_impianto       = :cod_impianto_catasto
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.upd_gen_rott">
       <querytext>
	update coimgend
	   set flag_attivo       = 'N'
	 where cod_impianto      = :cod_impianto_catasto
	   and gen_prog          = :gen_prog_catasto
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.ins_dimp">
       <querytext>
                insert
                  into coimdimp 
                     ( cod_dimp
                     , cod_impianto
                     , data_controllo
                     , gen_prog
                     , cod_manutentore
                     , cod_responsabile
                     , flag_status
                     , lib_impianto
                     , lib_uso_man
                     , ap_ventilaz
                     , ap_vent_ostruz
                     , disp_comando
                     , disp_sic_manom
                     , cont_rend
                     , temp_fumi
                     , temp_ambi
                     , o2
                     , co2
                     , bacharach
		     , bacharach2 --gac01
		     , bacharach3 --gac01
		     , co
                     , rend_combust
                     , osservazioni
                     , raccomandazioni
                     , prescrizioni
                     , utente_ins
                     , data_ins
                     , costo
                     , tipologia_costo
                     , tiraggio
                     , ora_inizio
                     , ora_fine
		     , data_scadenza
                     , num_autocert
                     , consumo_annuo
		     , cod_opmanu_new
                     , consumo_annuo2
                     , stagione_risc
                     , stagione_risc2
                     , conformita
                     , tariffa
                     , importo_tariffa
		     , rct_assenza_per_comb
                     , rct_canale_fumo_idoneo
                     , rct_check_list_1
                     , rct_check_list_2
                     , rct_idonea_tenuta
                     , rct_install_interna
                     , rct_lib_uso_man_comp
                     , rct_modulo_termico
                     , rct_rend_min_legge
                     , rct_riflussi_comb
                     , rct_scambiatore_lato_fumi
                     , rct_sistema_reg_temp_amb
                     , rct_tratt_in_acs
                     , rct_tratt_in_risc
                     , rct_uni_10389
                     , rct_valv_sicurezza
		     , flag_tracciato
                     , rct_dur_acqua
                     , rct_install_esterna
                     , rct_check_list_3
                     , rct_check_list_4
		     , cod_strumento_01 --gac01
		     , cod_strumento_02 --gac01
		     , cod_tprc         --gac01
		     , co_fumi_secchi   --gac01
		     , co_fumi_secchi_ppm --gac01
		     , data_prox_manut  --gac01
		     , data_ultima_manu --gac01
                     , flag_pagato      --gac01
		     , portata_comb     --gac01
		     , portata_termica_effettiva --gac01
		     , rend_magg_o_ugua_rend_min --gac01
		     , rispetta_indice_bacharach --gac01
		     , idoneita_locale --rom01
		     , potenza         --rom02
                     )
                values 
                     (:cod_dimp
                     ,:cod_impianto
                     ,:data_controllo
                     ,:gen_prog
                     ,:cod_manutentore
                     ,:cod_responsabile
                     ,:flag_status
                     ,:lib_impianto
                     ,:lib_uso_man
                     ,:ap_ventilaz
                     ,:ap_vent_ostruz
                     ,:disp_comando
                     ,:disp_sic_manom
                     ,:cont_rend
                     ,:temp_fumi
                     ,:temp_ambi
                     ,:o2
                     ,:co2
                     ,:bacharach
		     ,:bacharach2 --gac01
		     ,:bacharach3 --gac01
                     ,:co
                     ,:rend_combust
                     ,:osservazioni
                     ,:raccomandazioni
                     ,:prescrizioni
                     ,:id_utente
                     ,current_date
                     ,:costo
		     ,upper(:tipologia_costo)
		     ,:tiraggio
                     ,:ora_inizio
                     ,:ora_fine
                     ,:data_scadenza_autocert
                     ,:num_autocert
                     ,:consumo_annuo
		     ,:cod_opmanu_new
                     ,:consumo_annuo2
                     ,:stagione_risc
                     ,:stagione_risc2
                     ,:conformita
                     ,:tariffa_reg
                     ,:importo_contr
		     ,:rct_assenza_per_comb
                     ,:rct_canale_fumo_idoneo
                     ,:rct_check_list_1
                     ,:rct_check_list_2
                     ,:rct_idonea_tenuta
                     ,:rct_install_interna
                     ,:rct_lib_uso_man_comp
                     ,:rct_modulo_termico
                     ,:rct_rend_min_legge
                     ,:rct_riflussi_comb
                     ,:rct_scambiatore_lato_fumi
                     ,:rct_sistema_reg_temp_amb
                     ,:rct_tratt_in_acs
                     ,:rct_tratt_in_risc
                     ,:rct_uni_10389
                     ,:rct_valv_sicurezza
		     ,'R1'
                     ,:rct_dur_acqua
                     ,:rct_install_esterna
                     ,:rct_check_list_3
                     ,:rct_check_list_4
		     ,:cod_strumento_01_dimp --gac01
		     ,:cod_strumento_02_dimp --gac01
		     ,:val_cod_tprc          --rom10 cod_tprc         --gac01
		     ,:co_fumi_secchi   --gac01
		     ,:co_fumi_secchi_ppm --gac01
                     ,:data_prox_manut  --gac01
            	     ,:data_ultima_manu --gac01
		     ,:flag_pagato      --gac01
		     ,:portata_comb     --gac01
                     ,:portata_termica_effettiva --gac01
                     ,:rend_magg_o_ugua_rend_min --gac01
		     ,:rispetta_indice_bacharach --gac01
		     ,:idoneita_locale --rom01
		     ,:potenza         --rom02
		     )
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rce_tipo_1.sel_dual_cod_dimp">
       <querytext>
        select nextval('coimdimp_s') as cod_dimp
       </querytext>
    </fullquery>


    <partialquery name="iter_cari_rce_tipo_1.ins_trans">
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
                     ,:importo_contr
                     ,:costo
                     ,:azione
                     ,current_timestamp
                     ,:id_utente)
       </querytext>
    </partialquery>

</queryset>
