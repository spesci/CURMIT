<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom02 14/06/2023 Su indicazione di Sandro e Belluzzo si e' deciso di valorizzare data_prox_manut
    rom02            con quanto indicato in data_utile_inter del file csv del caricamento.

    rom01 19/12/2022 Aggiunto campo idoneita_locale nell'inserimento dell'rcee.

    sim01 27/06/2016 Se flag_tariffa_impianti_vecchi eq "t" e il combustibile e' Gas o Metano
    sim01            devo verificare se l'impianto e' vecchio e quindi usare un'altra tariffa.
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="iter_cari_rcee_tipo_1.sel_tari_contributo">
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


    <fullquery name="iter_cari_rcee_tipo_1.sel_cod_potenza">
        <querytext>
	select cod_potenza as cod_potenza_tari
          from coimpote
         where :pot_focolare_nom_check between potenza_min and potenza_max
	   and flag_tipo_impianto = 'R'
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.sel_dimp_check_data_controllo">
       <querytext>
       select '1' 
         from coimdimp
        where cod_impianto   = :cod_impianto_catasto
          and data_controllo = :data_controllo
          and gen_prog       = :gen_prog
         limit 1
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.sel_dual_cod_citt">
       <querytext>
          select nextval('coimcitt_s') as cod_citt
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.ins_citt">
       <querytext>
           insert into coimcitt
	                ( cod_cittadino
			, nome
			, cognome
			, indirizzo
			, comune
			, provincia
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
			, :provincia_citt_chk
			, :natura_citt_chk
			, :data_corrente
			, :id_utente
                        , :cap_chk
                        , :cod_fiscale_chk
                        , :telefono_chk
			)
       </querytext>
    </fullquery>


    <fullquery name="iter_cari_rcee_tipo_1.sel_dual_cod_impianto">
       <querytext>
                   select nextval('coimaimp_s') as cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.sel_dual_cod_impianto_est">
       <querytext>
                   select nextval('coimaimp_est_s') as cod_impianto_est
       </querytext>
    </fullquery>


    <fullquery name="iter_cari_rcee_tipo_1.ins_aimp">
       <querytext>
                   insert
                     into coimaimp 
                        ( cod_impianto
                        , cod_impianto_est
                        , potenza
                        , potenza_utile
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
			, esponente
                        , scala
                        , piano
                        , interno
                        , cod_comune
                        , cod_provincia
                        , cap
                        , data_ins
                        , utente_ins
			, volimetria_risc
			, cod_combustibile
			, flag_dpr412
			, data_installaz
                        , n_generatori
                        , provenienza_dati
                        , cod_tpim
                        , cod_potenza
			, pdr
			, pod
			, anno_costruzione
                        , flag_tipo_impianto
                        , targa
			)
                   values 
                        (:cod_impianto
                        ,:cod_impianto_est
                        ,:potenza_foc_nom
                        ,:potenza_utile_nom
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
                        ,:esponente
                        ,:scala
                        ,:piano
                        ,substring(:interno,1,3)
                        ,:cod_comune
                        ,:cod_prov
                        ,:cap_occu
                        ,:data_corrente
                        ,:id_utente
			,:volimetria_risc
			,:cod_comb
			, 'S'
			,:data_installazione_aimp
                        ,'1'
                        ,'7'
                        ,:cod_tpim
                        ,:cod_potenza
			,:pdr
                        ,:pod
			,:anno_costruzione_aimp
                        ,'R' -- flag_tipo_impianto
                        ,:targa
                        )
       </querytext>
    </fullquery>



    <fullquery name="iter_cari_rcee_tipo_1.ins_gend">
       <querytext>
                   insert
                     into coimgend
                        ( cod_impianto
                        , gen_prog
                        , matricola
                        , modello
                        , cod_combustibile
                        , pot_focolare_nom
                        , pot_utile_nom
                        , data_ins
                        , utente_ins
			, gen_prog_est
			, tiraggio
			, mod_funz
			, cod_emissione
			, data_costruz_gen
			, marc_effic_energ
			, cod_utgi
			, tipo_foco
			, locale
                        , cod_cost
                        , data_installaz
                        
			)
                   values 
                        (:cod_impianto
                        ,:gen_prog
                        ,:matricola
                        ,:modello
                        ,:cod_comb
                        ,:potenza_foc_nom
                        ,:potenza_utile_nom
			,:data_corrente
                        ,:id_utente
                        ,:gen_prog
			,:tiraggio_gend
			,:fluido_termovettore_gend
			,:scarico_fumi_gend
			,:data_costruzione_gend
			,:marc_effic_energ
			,:cod_utgi
			,:tipo_foco
			,:locale
                        ,:cod_cost
                        ,:data_installaz_gend
                        
                        )
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.upd_gend">
       <querytext>
                   update coimgend
                      set matricola = :matricola
                        , modello = :modello
                        , cod_combustibile = :cod_comb
                        , pot_focolare_nom = :potenza_foc_nom
                        , pot_utile_nom = :potenza_utile_nom
			, data_mod = :data_corrente
                        , utente = :id_utente
			, tiraggio = :tiraggio_gend
			, mod_funz = :fluido_termovettore_gend
			, cod_emissione = :scarico_fumi_gend
			, data_costruz_gen = :data_costruzione_gend
			, marc_effic_energ = :marc_effic_energ
			, cod_utgi = :cod_utgi
			, tipo_foco = :tipo_foco
			, locale = :locale
                        , cod_cost = :cod_cost
                        , data_installaz = :data_installaz_gend
                        
                    where cod_impianto = :cod_impianto
                      and gen_prog = :gen_prog
       </querytext>
    </fullquery>


    <fullquery name="iter_cari_rcee_tipo_1.upd_aimp">
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
             , potenza            = :tot_potenza_aimp
             , potenza_utile      = :tot_potenza_utile_aimp
	     , pdr                = :pdr
	     , pod                = :pod
             , anno_costruzione   = :anno_costruzione_aimp
	     , targa              = :targa 
	 where cod_impianto       = :cod_impianto_catasto
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.upd_gen_rott">
       <querytext>
	update coimgend
	   set flag_attivo       = 'N'
	 where cod_impianto      = :cod_impianto_catasto
	   and gen_prog          = :gen_prog_catasto
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.ins_dimp">
       <querytext>
                insert
                  into coimdimp 
                     ( cod_dimp
                     , cod_impianto
                     , data_controllo
                     , gen_prog
                     , cod_manutentore
                     , cod_responsabile
                     , cod_proprietario
                     , cod_occupante
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
                     , co
                     , rend_combust
                     , osservazioni
                     , raccomandazioni
                     , prescrizioni
                     , data_utile_inter
		     , data_prox_manut --rom02
                     , n_prot
                     , data_prot
                     , delega_resp
                     , utente_ins
                     , data_ins
                     , costo
                     , tipologia_costo
                     , riferimento_pag
                     , potenza
                     , tiraggio
                     , ora_inizio
                     , ora_fine
		     , data_scadenza
                     , num_autocert
                     , volimetria_risc
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
                     , rct_gruppo_termico
                     , rct_idonea_tenuta
		     , idoneita_locale --rom01
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
                     )
                values 
                     (:cod_dimp
                     ,:cod_impianto
                     ,:data_controllo
                     ,:gen_prog
                     ,:cod_manutentore
                     ,:cod_responsabile
                     ,:cod_proprietario
                     ,:cod_occupante
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
                     ,:co
                     ,:rend_combust
                     ,:osservazioni
                     ,:raccomandazioni
                     ,:prescrizioni
                     ,:data_utile_inter
		     ,:data_utile_inter --rom02
                     ,:n_prot
                     ,:data_prot
                     ,:delega_resp
                     ,:id_utente
                     ,current_date
                     ,:costo
                     ,upper(:tipologia_costo)
                     ,:riferimento_pag
		     ,:potenza_utile_nom
                     ,:tiraggio
                     ,:ora_inizio
                     ,:ora_fine
                     ,:data_scadenza_autocert
                     ,:num_autocert
                     ,:volimetria_risc
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
                     ,:rct_gruppo_termico
                     ,:rct_idonea_tenuta
		     ,:idoneita_locale --rom01
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
                     )
       </querytext>
    </fullquery>

    <fullquery name="iter_cari_rcee_tipo_1.sel_dual_cod_dimp">
       <querytext>
        select nextval('coimdimp_s') as cod_dimp
       </querytext>
    </fullquery>

    <partialquery name="iter_cari_rcee_tipo_1.ins_anomalie_di_merda">
       <querytext>
                insert
                  into coimanom 
                     ( cod_cimp_dimp
                     , prog_anom
                     , tipo_anom
                     , cod_tanom
		     , flag_origine)
                values 
                     (:cod_dimp
                     ,:prog_anom
                     ,'1'
                     ,:anomalia
		     ,'MH')
       </querytext>
    </partialquery>

    <partialquery name="iter_cari_rcee_tipo_1.ins_trans">
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
