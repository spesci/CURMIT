<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_tgen_sanz">
       <querytext>
           select flag_sanzioni
             from coimtgen
       </querytext>
    </fullquery>

    <fullquery name="sel_imp_1">
       <querytext>
           select coalesce(importo_min, '0') as importo_min1
                , tipo_soggetto as tipo_soggetto_1
             from coimsanz
            where cod_sanzione = :cod_sanzione_1
       </querytext>
    </fullquery>

    <fullquery name="sel_imp_2">
       <querytext>
           select coalesce(importo_min, '0') as importo_min2
                , tipo_soggetto as tipo_soggetto_2
             from coimsanz
            where cod_sanzione = :cod_sanzione_2
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_cod_impianto">
       <querytext>
           select cod_impianto
             from coimcimp
            where cod_cimp = :cod_cimp
       </querytext>
    </fullquery>

    <fullquery name="sel_enve_opve">
       <querytext>
           select coalesce(o.cognome,'')
               || ' '
               || coalesce(o.nome,'') 
               || ' - '
               || coalesce(e.ragione_01,'') as des_opve
                , o.cod_opve
             from coimopve o
                , coimenve e
            where e.cod_enve = o.cod_enve
           $where_enve_opve
         order by e.ragione_01
                , o.cognome
                , o.nome
                , o.cod_opve
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_esito_negativo">
       <querytext>
           select '1'
             from coimcimp
            where cod_cimp = :cod_cimp
              and (   manutenzione_8a   = 'N'
                   or co_fumi_secchi_8b = 'N'
                   or indic_fumosita_8c = 'N'
                   or rend_comb_8d      = 'N')
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_list">
       <querytext>
           select gen_prog
             from coimgend
            where cod_impianto = :cod_impianto
	      and flag_attivo  = 'S'
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp">
       <querytext>
           select iter_edit_data(a.data_installaz) as aimp_data_installaz_v
                --, a.potenza            as aimp_pot_focolare_nom
		--, a.potenza_utile      as aimp_pot_utile_nom
		, a.cod_combustibile   as aimp_cod_combustibile
		, a.cod_responsabile   as aimp_cod_responsabile
		, a.flag_resp          as aimp_flag_resp
                , a.cod_occupante      as aimp_cod_occupante
                , a.cod_proprietario   as aimp_cod_proprietario
                , a.cod_intestatario   as aimp_cod_intestatario
                , a.cod_amministratore as aimp_cod_amministratore
		, b.cognome            as aimp_cogn_resp
		, b.nome               as aimp_nome_resp
                , case a.flag_resp
                      when 'P' then 'il Proprietario'
                      when 'O' then 'l''Occupante'
                      when 'A' then 'l''Amministratore'
                      when 'I' then 'l''Intestatario'
                      when 'T' then 'un Terzo'
                      else 'Non noto'
                  end                  as aimp_flag_resp_desc
                , case a.cod_tpim
                      when 'A' then 'Singola unit&agrave; immobiliare'
                      when 'C' then 'Pi&ugrave; unit&agrave; immobiliari'
                      when '0' then 'Non noto'
                      else 'Non Noto;'
                  end                  as aimp_tipologia
                , a.cod_tpim
                , c.descr_cted         as aimp_categoria_edificio
                , d.descr_tpdu         as aimp_dest_uso
                , a.cod_tpdu
                , iter_edit_num(a.volimetria_risc,2) as aimp_volumetria_risc
                , iter_edit_num(a.consumo_annuo,2) as aimp_consumo_annuo
                , cod_manutentore
                , n_generatori
	        , a.cod_cted
             from coimaimp a
  left outer join coimcitt b
               on b.cod_cittadino = a.cod_responsabile
  left outer join coimcted c
               on c.cod_cted      = a.cod_cted
  left outer join coimtpdu d
               on d.cod_tpdu      = a.cod_tpdu
            where a.cod_impianto  =  :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_gend">
       <querytext>
           select a.gen_prog_est       as gend_gen_prog_est
                --, a.pot_focolare_nom   as gend_pot_focolare_nom
                --, a.pot_utile_nom      as gend_pot_utile_nom
                , a.matricola          as gend_matricola
                , a.modello            as gend_modello
                , a.matricola_bruc     as gend_matricola_bruc
                , a.modello_bruc       as gend_modello_bruc
                , a.cod_cost_bruc      as gend_cod_cost_bruc
                , a.cod_combustibile   as gend_cod_combustibile
                , h.descr_comb         as gend_descr_comb  
                , b.descr_utgi         as gend_descr_utgi
                , c.descr_fuge         as gend_descr_fuge
                --, d.descr_cost         as gend_descr_cost
                , a.locale             as locale
                , a.tiraggio           as gend_tiraggio 
                , a.tipo_bruciatore    as gend_tipo_bruciatore
                , iter_edit_data(a.data_installaz) as gend_data_installaz_v
                --, e.descr_cost         as gend_descr_cost_bruc
                , iter_edit_num(a.pot_focolare_lib, 2) as gend_pot_focolare_lib_edit
                , iter_edit_num(a.pot_utile_lib, 2)    as gend_pot_utile_lib_edit
                , f.descr_utgi         as gend_destinazione_uso
                , a.cod_utgi
                , g.descr_fuge         as gend_fluido_termovettore
                , a.cod_emissione      as gend_cod_emissione
                , case a.cod_emissione 
                     when '0' then 'Canna fumaria non verificabile'
                     when 'C' then 'Canna fumaria collettiva al tetto'
                     when 'I' then 'Canna fumaria singola al tetto'
                     when 'P' then 'Scarico direttamente all''''esterno'
                     else 'Non Noto'
                  end                  as gend_tipologia_emissione 
                , a.dpr_660_96         as dpr_660_96
                , iter_edit_num(a.campo_funzion_min, 2) as gend_campo_funzion_min_edit
                , iter_edit_num(a.campo_funzion_max, 2) as gend_campo_funzion_max_edit
                , cod_grup_term
             from coimgend a
  left outer join coimutgi b
               on b.cod_utgi     = a.cod_utgi
  left outer join coimfuge c
               on c.cod_fuge     = a.mod_funz
  left outer join coimcost d
              on d.cod_cost     = a.cod_cost
  left outer join coimcost e
               on e.cod_cost     = a.cod_cost_bruc
  left outer join coimutgi f
               on f.cod_utgi     = a.cod_utgi
  left outer join coimfuge g
               on g.cod_fuge     = a.mod_funz
  left outer join coimcomb h
               on h.cod_combustibile = a.cod_combustibile
            where a.cod_impianto = :cod_impianto
              and a.gen_prog     = :gen_prog
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_min">
       <querytext>
           select min(gen_prog_est)
             from coimgend
            where cod_impianto = :cod_impianto
	      and flag_attivo  = 'S'
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_esito">
       <querytext>
           select esito_verifica    as cimp_esito_verifica
                , flag_pericolosita as cimp_flag_pericolosita
             from coimcimp
            where cod_cimp = :cod_cimp
       </querytext>
    </fullquery>

    <fullquery name="sel_pote_cod_potenza">
       <querytext>
           select cod_potenza
             from coimpote
            where potenza_min <= :h_potenza
              and potenza_max >= :h_potenza
              and flag_tipo_impianto = :flag_tipo_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_tari">
       <querytext>
           select a.importo
             from coimtari a
            where a.cod_potenza = :cod_potenza
              and a.tipo_costo  = :tipo_costo
              and a.cod_listino = :cod_listino
              and a.data_inizio = (select max(d.data_inizio) 
                                     from coimtari d 
                                    where d.cod_potenza  = :cod_potenza
                                      and d.tipo_costo   = :tipo_costo
                                      and d.cod_listino  = :cod_listino
                                      and d.data_inizio <=  current_date)
       </querytext>
    </fullquery>

    <fullquery name="sel_inco_default">
       <querytext>
           select a.cod_inco
                , a.data_verifica
             from coiminco a
                , coimcinc b
            where a.cod_impianto =  :cod_impianto
              and b.cod_cinc     = a.cod_cinc
              and b.stato        =  '1'
         order by a.data_verifica desc
                , a.cod_inco      desc
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_inco_count">
       <querytext>
           select count(*)
             from coimcimp
            where cod_inco = :cod_inco
       </querytext>
    </fullquery>

    <fullquery name="sel_inco">
       <querytext>
           select data_assegn
                , cod_cinc
                , cod_impianto  as inco_cod_impianto
                , iter_edit_data(data_verifica) as inco_data_verifica
                , cod_opve      as inco_cod_opve
             from coiminco
            where cod_inco = :cod_inco
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp_data_controllo_max">
       <querytext>
           select iter_edit_data(max(data_controllo)) as dimp_data_controllo_max
             from coimdimp
            where cod_impianto = :cod_impianto limit 1
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

    <fullquery name="sel_cinc">
       <querytext>
           select to_char(data_inizio,'yyyymmdd') as cinc_data_inizio
                , to_char(data_fine,'yyyymmdd')   as cinc_data_fine
             from coimcinc
            where cod_cinc = :cod_cinc
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_count_dup">
       <querytext>
           select count(*)
             from coimcimp
            where cod_impianto   = :cod_impianto
              and gen_prog       = :gen_prog
              and data_controllo = :data_controllo
           $where_cod_cimp
        </querytext>
    </fullquery>

    <fullquery name="sel_anom_count_dup">
       <querytext>
           select count(*)
             from coimanom
            where cod_cimp_dimp = :cod_cimp
              and cod_tanom     = :cod_anom_db
	      and flag_origine  = 'RV'
	      and prog_anom     > :prog_anom_max
	      and prog_anom    <> :prog_anom_db
       </querytext>
    </fullquery>

    <fullquery name="sel_tano">
       <querytext>
           select cod_tano||' '||coalesce(descr_tano, '') as note
             from coimtano
            where cod_tano = :cod_anom_db
       </querytext>
    </fullquery>

    <fullquery name="sel_tano_scatenante">
       <querytext>
           select flag_scatenante
             from coimtano 
            where cod_tano = :cod_anomalia
       </querytext>
    </fullquery>

    <fullquery name="sel_comb">
       <querytext>
           select descr_comb 
             from coimcomb
            where cod_combustibile = :cod_combustibile
       </querytext>
    </fullquery>

    <fullquery name="sel_dual_cod_cimp">
       <querytext>
           select nextval('coimcimp_s') as cod_cimp
       </querytext>
    </fullquery>

    <partialquery name="ins_cimp">
       <querytext>
           insert
             into coimcimp 
                ( cod_cimp
                , cod_impianto
                , gen_prog
                , cod_inco
                , data_controllo
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
                , verifica_areaz
                , rend_comb_conv
                , rend_comb_min
                , temp_fumi_md
                , t_aria_comb_md
                , temp_mant_md
                , temp_h2o_out_md
                , co2_md
                , o2_md
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
                , note_verificatore
                , note_resp
                , note_conf
                , riferimento_pag
                , cod_combustibile
                , cod_responsabile
                , flag_pericolosita
                , data_ins
                , utente
                , flag_tracciato
                , new1_data_dimp
                , new1_data_paga_dimp
                , new1_conf_locale
                , new1_disp_regolaz
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
                , new1_foro_presente
                , new1_foro_corretto
                , new1_foro_accessibile
                , n_prot
                , data_prot
                , verb_n
                , data_verb
                , pendenza
                , ventilaz_lib_ostruz
                , disp_reg_cont_pre
                , disp_reg_cont_funz
                , disp_reg_clim_funz
                , volumetria
                , comsumi_ultima_stag
                , temp_h2o_out_1a
                , temp_h2o_out_2a
                , temp_h2o_out_3a
                , t_aria_comb_1a
                , t_aria_comb_2a
                , t_aria_comb_3a
                , temp_fumi_1a
                , temp_fumi_2a
                , temp_fumi_3a
                , co_1a
                , co_2a
                , co_3a
                , co2_1a
                , co2_2a
                , co2_3a
                , o2_1a
                , o2_2a
                , o2_3a
                , cod_sanzione_1
                , cod_sanzione_2
                , tiraggio
                , cod_strumento_01
                , cod_strumento_02
                , riferimento_pag_bollini
                , canale_fumo_idoneo
                , rend_suff_insuff
                , dichiarato
                , et
                , fl_firma_tecnico
		, fl_firma_resp
 	        , fl_rifiuto_firma
                , imp_boll_ver
                , numfatt
                , data_fatt
                , potenza_effettiva_util
                , potenza_effettiva_nom 
                , esterna_generatore_idoneo
                , ventilazione_locali  
                , areazione_locali  
                , ventilazione_locali_mis 
                , verifica_disp_regolazione
                , doc_ispesl
                , doc_prev_incendi
                , new1_pres_cartell
                , new1_pres_mezzi
                , new1_pres_interrut
                , new1_pres_intercet
                , frequenza_manut
                , frequenza_manut_altro
                , rcee_inviato
                , rcee_osservazioni
                , rcee_raccomandazioni
                , misurazione_rendimento
                , check_valvole
                , check_isolamento
                , check_trattamento
                , check_regolazione
                , dimensionamento_gen
                , esito_periodicita
                , mod_verde
                , mod_rosa
	        , ora_inizio
	        , potenza_nom_tot_foc
	        , potenza_nom_tot_util
                , tratt_in_risc
                , tratt_in_acs
                , dich_152_presente
                , docu_152
	        , auto_adeg_152
                , eccesso_aria_perc
                , perdita_ai_fumi
                , delega_pres
                , controllo_cucina 
                , norm_7a
                , norm_9a
                , norm_9b
                , norm_9c
                , deve_non_messa_norma
                , deve_non_rcee 
                , rimanere_funzione
                , pagamento_effettuato
                , check_sostituzione
                , check_scambiatori
                , check_eccesso_aria
                , check_altro
                , ass_perdite_comb)
           values 
                (:cod_cimp
                ,:cod_impianto
                ,:gen_prog
                ,:cod_inco
                ,:data_controllo
                ,:cod_opve
                ,:costo
                ,:nominativo_pres
                ,:presenza_libretto
                ,:libretto_corretto
                ,:dich_conformita
                ,:libretto_manutenz
                ,:mis_port_combust
                ,:mis_pot_focolare
                ,:stato_coiben
                ,:verifica_areaz
                ,:rend_comb_conv
                ,:rend_comb_min
                ,:temp_fumi_md
                ,:t_aria_comb_md
                ,:temp_mant_md
                ,:temp_h2o_out_md
                ,:co2_md
                ,:o2_md
                ,:co_md
                ,:indic_fumosita_1a
                ,:indic_fumosita_2a
                ,:indic_fumosita_3a
                ,:indic_fumosita_md
                ,:manutenzione_8a
                ,:co_fumi_secchi_8b
                ,:indic_fumosita_8c
                ,:rend_comb_8d
                ,:esito_verifica
                ,:note_verificatore
                ,:note_resp
                ,:note_conf
                ,:riferimento_pag
                ,:cod_combustibile
                ,:cod_responsabile
                ,:flag_pericolosita
                , current_date
                ,:id_utente
                ,'AC'
                ,:new1_data_dimp
                ,:new1_data_paga_dimp
                ,:new1_conf_locale
                ,:new1_disp_regolaz
                ,:new1_lavoro_nom_iniz
                ,:new1_lavoro_nom_fine
                ,:new1_lavoro_lib_iniz
                ,:new1_lavoro_lib_fine
                ,:new1_note_manu
                ,:new1_dimp_pres
                ,:new1_dimp_prescriz
                ,:new1_data_ultima_manu
                ,:new1_data_ultima_anal
                ,:new1_manu_prec_8a
                ,:new1_co_rilevato
                ,:new1_flag_peri_8p
                ,:new1_foro_presente
                ,:new1_foro_corretto
                ,:new1_foro_accessibile
                ,:n_prot
                ,:data_prot
                ,:verb_n
                ,:data_verb
                ,:pendenza
                ,:ventilaz_lib_ostruz
                ,:disp_reg_cont_pre
                ,:disp_reg_cont_funz
                ,:disp_reg_clim_funz
                ,:volumetria
                ,:comsumi_ultima_stag
                ,:temp_h2o_out_1a
                ,:temp_h2o_out_2a
                ,:temp_h2o_out_3a
                ,:t_aria_comb_1a
                ,:t_aria_comb_2a
                ,:t_aria_comb_3a
                ,:temp_fumi_1a
                ,:temp_fumi_2a
                ,:temp_fumi_3a
                ,:co_1a
                ,:co_2a
                ,:co_3a
                ,:co2_1a
                ,:co2_2a
                ,:co2_3a
                ,:o2_1a
                ,:o2_2a
                ,:o2_3a
                ,:cod_sanzione_1
                ,:cod_sanzione_2
                ,:tiraggio
                ,:cod_strumento_01
                ,:cod_strumento_02
                ,:riferimento_pag_bollini
                ,:canale_fumo_idoneo
                ,:rend_suff_insuff
                ,:dichiarato
                ,:et
                ,:fl_firma_tecnico
		,:fl_firma_resp
		,:fl_rifiuto_firma
                ,:imp_boll_ver
                ,:numfatt
                ,:data_fatt 
                ,:potenza_effettiva_util
                ,:potenza_effettiva_nom
                ,:esterna_generatore_idoneo
                ,:ventilazione_locali  
                ,:areazione_locali  
                ,:ventilazione_locali_mis 
                ,:verifica_disp_regolazione
                ,:doc_ispesl
                ,:doc_prev_incendi
                ,:new1_pres_cartell
                ,:new1_pres_mezzi
                ,:new1_pres_interrut
                ,:new1_pres_intercet
                ,:frequenza_manut
                ,:frequenza_manut_altro
                ,:rcee_inviato
                ,:rcee_osservazioni
                ,:rcee_raccomandazioni
                ,:misurazione_rendimento
                ,:check_valvole
                ,:check_isolamento
                ,:check_trattamento
                ,:check_regolazione
                ,:dimensionamento_gen
                ,:esito_periodicita
                ,:mod_verde
                ,:mod_rosa
	        ,:ora_inizio
	        ,:potenza_nom_tot_foc
	        ,:potenza_nom_tot_util
	        ,:tratt_in_risc
                ,:tratt_in_acs
                ,:dich_152_presente
                ,:docu_152
	        ,:auto_adeg_152
                ,:eccesso_aria_perc
                ,:perdita_ai_fumi
                ,:delega_pres
                ,:controllo_cucina 
                ,:norm_7a
                ,:norm_9a
                ,:norm_9b
                ,:norm_9c
                ,:deve_non_messa_norma
                ,:deve_non_rcee 
                ,:rimanere_funzione
                ,:pagamento_effettuato
                ,:check_sostituzione
                ,:check_scambiatori
                ,:check_eccesso_aria
                ,:check_altro
                ,:ass_perdite_comb)
        </querytext>
    </partialquery>

    <partialquery name="upd_aimp_utente">
       <querytext>
           update coimaimp
              set data_mod     =  current_date
                , utente       = :id_utente
            where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_resp">
       <querytext>
           update coimaimp
              set flag_resp        = :flag_resp
                  $set_clause
                , data_mod         =  current_date
                , utente           = :id_utente
            where cod_impianto     = :cod_impianto
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
                , utente)
           values
                (:cod_impianto
                ,:ruolo
                ,(current_date - 1)
                ,:cod_soggetto_old
                , current_date
                ,:id_utente
                )
       </querytext>
    </partialquery>

    <fullquery name="sel_gend_count">
       <querytext>
           select count(*)
	     from coimgend
	    where cod_impianto = :cod_impianto
              and flag_attivo  = 'S'
       </querytext>
    </fullquery>

    
    <partialquery name="upd_aimp_pote">
       <querytext>
           update coimaimp set
	          cod_potenza      = :cod_potenza
                , data_mod         =  current_date
                , utente           = :id_utente
            where cod_impianto     = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_comb">
       <querytext>
           update coimaimp
	      set cod_combustibile = :cod_combustibile
            where cod_impianto     = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_gend">
       <querytext>
	   update coimgend 
	      set cod_combustibile = :cod_combustibile_upd
                , modello          = :modello
                , matricola        = :matricola
                , locale           = :locale
                , dpr_660_96       = :dpr_660_96
                , data_installaz   = :gend_data_installaz
                , cod_utgi         = :cod_utgi 
                , cod_emissione    = :gend_cod_emissione
                , cod_cost_bruc    = :cod_cost_bruc
                , modello_bruc     = :modello_bruc
                , matricola_bruc   = :matricola_bruc
                , tipo_bruciatore  = :tipo_bruciatore
                , campo_funzion_min   = :campo_funzion_min
                , campo_funzion_max   = :campo_funzion_max
                , tiraggio            = :gend_tiraggio
            where cod_impianto     = :cod_impianto
	      and gen_prog         = :gen_prog
       </querytext>
    </partialquery>

    <fullquery name="sel_dual_cod_todo">
       <querytext>
           select nextval('coimtodo_s') as cod_todo
       </querytext>
    </fullquery>

    <partialquery name="ins_todo">
       <querytext>
           insert
             into coimtodo
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
                , utente)
           values
		(:cod_todo
		,:cod_impianto
		,:tipologia
		,:note
		,:cod_cimp
                ,:flag_evasione
                ,:data_evasione
                ,:data_evento
                ,:data_scadenza
                , current_date
                ,:id_utente
                )
       </querytext>
    </partialquery>

    <fullquery name="sel_tano_anom">
        <querytext>
           select a.cod_tanom       as cod_tanom_check 
                , b.flag_scatenante as flag_scatenante_check
             from coimanom a
                , coimtano b
            where a.cod_cimp_dimp = :cod_cimp
	      and a.flag_origine  = 'RV'
	      and b.cod_tano      = a.cod_tanom
        </querytext>
    </fullquery>

    <partialquery name="upd_aimp_stato">
       <querytext>
           update coimaimp
              set stato_conformita = :stato_conformita
            where cod_impianto     = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_volumetria">
       <querytext>
           update coimaimp
              set volimetria_risc = :volumetria
            where cod_impianto     = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_installaz">
       <querytext>
           update coimaimp
              set data_installaz = :aimp_data_installaz_v
                 ,cod_tpdu       = :cod_tpdu
                 ,cod_tpim       = :cod_tpim
                 ,cod_cted     = :cod_cted
            where cod_impianto   = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="upd_aimp_consumi">
       <querytext>
           update coimaimp
              set consumo_annuo = :comsumi_ultima_stag
            where cod_impianto     = :cod_impianto
       </querytext>
    </partialquery>

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
                , id_caus)
           values 
                (:cod_movi
                ,'VC'
                ,:cod_impianto
                ,:data_scad_pagamento
                ,:data_controllo
                ,:costo
                ,:importo_pag
                ,:cod_cimp
                ,:data_pag
                , current_date
                ,:id_utente
                ,(select id_caus from coimcaus where codice = 'VC') )
       </querytext>
    </partialquery>

    <partialquery name="ins_movi_sanz1">
       <querytext>
           insert
             into coimmovi 
                ( cod_movi
                , tipo_movi
                , cod_impianto
                , data_scad
                , data_compet
                , importo
                , riferimento
                , data_ins
                , utente
                , cod_sanzione_1
                , cod_soggetto
                , tipo_soggetto
                , id_caus)
           values 
                (:cod_movi1
                ,'SA'
                ,:cod_impianto
                ,:data_scad_pagamento
                ,:data_controllo
                ,:importo_min1
                ,:cod_cimp
                ,current_date
                ,:id_utente
                ,:cod_sanzione_1
                ,:cod_soggetto_1
                ,:tipo_soggetto_1
                ,(select id_caus from coimcaus where codice = 'SA') )
       </querytext>
    </partialquery>

    <partialquery name="ins_movi_sanz2">
       <querytext>
           insert
             into coimmovi 
                ( cod_movi
                , tipo_movi
                , cod_impianto
                , data_scad
                , data_compet
                , importo
                , riferimento
                , data_ins
                , utente
                , cod_sanzione_2
                , cod_soggetto
                , tipo_soggetto
                , id_caus)
           values 
                (:cod_movi2
                ,'SA'
                ,:cod_impianto
                ,:data_scad_pagamento
                ,:data_controllo
                ,:importo_min2
                ,:cod_cimp
                ,current_date
                ,:id_utente
                ,:cod_sanzione_2
                ,:cod_soggetto_2
                ,:tipo_soggetto_2
                ,(select id_caus from coimcaus where codice = 'SA') )
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
                , data_mod     =  current_date
                , utente       = :id_utente
            where cod_movi     = :cod_movi                 
       </querytext>
    </partialquery>

    <fullquery name="sel_movi_check">
       <querytext>
           select cod_movi, data_pag, importo_pag
             from coimmovi
            where riferimento  = :cod_cimp
              and cod_impianto = :cod_impianto
              and tipo_movi =  'VC'
       </querytext>
    </fullquery>

    <fullquery name="sel_sanz_check1">
       <querytext>
           select '1'
             from coimmovi
            where riferimento    = :cod_cimp
              and cod_impianto   = :cod_impianto
              and tipo_movi =  'SA'
              and cod_sanzione_1 = :cod_sanzione_1
       </querytext>
    </fullquery>

    <fullquery name="sel_sanz_check2">
       <querytext>
           select '1'
             from coimmovi
            where riferimento    = :cod_cimp
              and cod_impianto   = :cod_impianto
             and tipo_movi =  'SA'
              and cod_sanzione_1 = :cod_sanzione_2
       </querytext>
    </fullquery>

    <fullquery name="sel_sanz_check">
       <querytext>
           select cod_sanzione_1 as cod_sanz_movi1
                , cod_sanzione_2 as cod_sanz_movi2
             from coimmovi a
            where a.riferimento  = :cod_cimp
              and a.cod_impianto = :cod_impianto
              and tipo_movi =  'SA'
       </querytext>
    </fullquery>

    <partialquery name="upd_inco">
       <querytext>
           update coiminco
              set cod_opve      = :cod_opve
                , data_verifica = :data_controllo
                , esito         = :esito_verifica
                , stato         = '8'
                , data_assegn   = :data_assegn
            where cod_inco      = :cod_inco                 
       </querytext>
    </partialquery>

    <partialquery name="upd_inco_noconf">
      <querytext>
	update coiminco
	set cod_opve      = :cod_opve
	, data_verifica = :data_controllo
	, esito         = :esito_verifica
	, data_assegn   = :data_assegn
	where cod_inco      = :cod_inco
      </querytext>
    </partialquery>
    
    <partialquery name="upd_inco_old">
       <querytext>
           update coiminco
              set esito         =  null
            where cod_inco      = :cod_inco_old                 
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
                , flag_origine
                , principale)
           values 
                (:cod_cimp
                ,:prog_anom_db
                ,'2'
                ,:cod_anom_db
                ,:data_ut_int_db
                ,'RV'
                ,:principale)
       </querytext>
    </partialquery>

    <partialquery name="del_todo_anom">
       <querytext>
           delete 
             from coimtodo
            where cod_impianto     = :cod_impianto
              and tipologia        = '2'
              and cod_cimp_dimp    = :cod_cimp
	      and substr(note,1,3) = (select substr(cod_tanom,1,3)
                                        from coimanom
                                       where cod_cimp_dimp = :cod_cimp
                                         and flag_origine  = 'RV'
                                         and prog_anom     = :prog_anom_db)
       </querytext>
    </partialquery>

    <partialquery name="del_anom">
       <querytext>
           delete
             from coimanom
            where cod_cimp_dimp = :cod_cimp
              and flag_origine  = 'RV'
              and prog_anom     = :prog_anom_db
       </querytext>
    </partialquery>

    <partialquery name="upd_cimp">
       <querytext>
           update coimcimp
              set cod_inco                  = :cod_inco
                , data_controllo            = :data_controllo
                , cod_opve                  = :cod_opve
                , costo                     = :costo
                , nominativo_pres           = :nominativo_pres
                , presenza_libretto         = :presenza_libretto
                , libretto_corretto         = :libretto_corretto
                , dich_conformita           = :dich_conformita
                , libretto_manutenz         = :libretto_manutenz
                , mis_port_combust          = :mis_port_combust
                , mis_pot_focolare          = :mis_pot_focolare
                , stato_coiben              = :stato_coiben
                , verifica_areaz            = :verifica_areaz
                , rend_comb_conv            = :rend_comb_conv
                , rend_comb_min             = :rend_comb_min
                , temp_fumi_md              = :temp_fumi_md
                , t_aria_comb_md            = :t_aria_comb_md
                , temp_mant_md              = :temp_mant_md
                , temp_h2o_out_md           = :temp_h2o_out_md
                , co2_md                    = :co2_md
                , o2_md                     = :o2_md
                , co_md                     = :co_md
                , indic_fumosita_1a         = :indic_fumosita_1a
                , indic_fumosita_2a         = :indic_fumosita_2a
                , indic_fumosita_3a         = :indic_fumosita_3a
                , indic_fumosita_md         = :indic_fumosita_md
                , manutenzione_8a           = :manutenzione_8a
                , co_fumi_secchi_8b         = :co_fumi_secchi_8b
                , indic_fumosita_8c         = :indic_fumosita_8c
                , rend_comb_8d              = :rend_comb_8d
                , esito_verifica            = :esito_verifica
                , note_verificatore         = :note_verificatore
                , note_resp                 = :note_resp
                , note_conf                 = :note_conf
                , riferimento_pag           = :riferimento_pag
                , cod_combustibile          = :cod_combustibile
                , cod_responsabile          = :cod_responsabile
                , flag_pericolosita         = :flag_pericolosita
                , data_mod                  = current_date
                , utente                    = :id_utente
                , new1_data_dimp            = :new1_data_dimp
                , new1_data_paga_dimp       = :new1_data_paga_dimp
                , new1_conf_locale          = :new1_conf_locale
                , new1_disp_regolaz         = :new1_disp_regolaz
                , new1_lavoro_nom_iniz      = :new1_lavoro_nom_iniz
                , new1_lavoro_nom_fine      = :new1_lavoro_nom_fine
                , new1_lavoro_lib_iniz      = :new1_lavoro_lib_iniz
                , new1_lavoro_lib_fine      = :new1_lavoro_lib_fine
                , new1_note_manu            = :new1_note_manu
                , new1_dimp_pres            = :new1_dimp_pres
                , new1_dimp_prescriz        = :new1_dimp_prescriz
                , new1_data_ultima_manu     = :new1_data_ultima_manu
                , new1_data_ultima_anal     = :new1_data_ultima_anal
                , new1_manu_prec_8a         = :new1_manu_prec_8a
                , new1_co_rilevato          = :new1_co_rilevato
                , new1_flag_peri_8p         = :new1_flag_peri_8p
                , new1_foro_presente        = :new1_foro_presente
                , new1_foro_corretto        = :new1_foro_corretto
                , new1_foro_accessibile     = :new1_foro_accessibile
                , n_prot                    = :n_prot
                , data_prot                 = :data_prot
                , verb_n                    = :verb_n
                , data_verb                 = :data_verb
                , pendenza                  = :pendenza
                , ventilaz_lib_ostruz       = :ventilaz_lib_ostruz
                , disp_reg_cont_pre         = :disp_reg_cont_pre
                , disp_reg_cont_funz        = :disp_reg_cont_funz
                , disp_reg_clim_funz        = :disp_reg_clim_funz
                , volumetria                = :volumetria
                , comsumi_ultima_stag       = :comsumi_ultima_stag
                , temp_h2o_out_1a           = :temp_h2o_out_1a
                , temp_h2o_out_2a           = :temp_h2o_out_2a
                , temp_h2o_out_3a           = :temp_h2o_out_3a
                , t_aria_comb_1a            = :t_aria_comb_1a
                , t_aria_comb_2a            = :t_aria_comb_2a
                , t_aria_comb_3a            = :t_aria_comb_3a
                , temp_fumi_1a              = :temp_fumi_1a
                , temp_fumi_2a              = :temp_fumi_2a
                , temp_fumi_3a              = :temp_fumi_3a
                , co_1a                     = :co_1a
                , co_2a                     = :co_2a
                , co_3a                     = :co_3a
                , co2_1a                    = :co2_1a
                , co2_2a                    = :co2_2a
                , co2_3a                    = :co2_3a
                , o2_1a                     = :o2_1a
                , o2_2a                     = :o2_2a
                , o2_3a                     = :o2_3a
                , cod_sanzione_1            = :cod_sanzione_1
                , cod_sanzione_2            = :cod_sanzione_2
                , tiraggio                  = :tiraggio
                , cod_strumento_01          = :cod_strumento_01
                , cod_strumento_02          = :cod_strumento_02
                , riferimento_pag_bollini   = :riferimento_pag_bollini
                , canale_fumo_idoneo       = :canale_fumo_idoneo
                , rend_suff_insuff          = :rend_suff_insuff
                , dichiarato                = :dichiarato
                , et                        = :et
                , fl_firma_tecnico          = :fl_firma_tecnico
		, fl_firma_resp             = :fl_firma_resp
		, fl_rifiuto_firma          = :fl_rifiuto_firma    
                , imp_boll_ver              = :imp_boll_ver
                , numfatt                   = :numfatt
                , data_fatt                 = :data_fatt
                , potenza_effettiva_nom     = :potenza_effettiva_nom
                , potenza_effettiva_util    = :potenza_effettiva_util
                , esterna_generatore_idoneo = :esterna_generatore_idoneo
                , ventilazione_locali        = :ventilazione_locali  
                , areazione_locali           = :areazione_locali  
                , ventilazione_locali_mis    = :ventilazione_locali_mis 
                , verifica_disp_regolazione  = :verifica_disp_regolazione
                , doc_ispesl                 = :doc_ispesl
                , doc_prev_incendi           = :doc_prev_incendi
                , new1_pres_cartell          = :new1_pres_cartell
                , new1_pres_mezzi            = :new1_pres_mezzi
                , new1_pres_interrut         = :new1_pres_interrut
                , new1_pres_intercet         = :new1_pres_intercet
                , frequenza_manut            = :frequenza_manut
                , frequenza_manut_altro      = :frequenza_manut_altro
                , rcee_inviato               = :rcee_inviato
                , rcee_osservazioni          = :rcee_osservazioni
                , rcee_raccomandazioni       = :rcee_raccomandazioni
                , misurazione_rendimento     = :misurazione_rendimento
                , check_valvole              = :check_valvole
                , check_isolamento           = :check_isolamento
                , check_trattamento          = :check_trattamento
                , check_regolazione          = :check_regolazione
                , dimensionamento_gen        = :dimensionamento_gen
                , esito_periodicita          = :esito_periodicita
                , mod_verde                  = :mod_verde
                , mod_rosa                   = :mod_rosa
	        , ora_inizio                 = :ora_inizio
	        , potenza_nom_tot_foc        = :potenza_nom_tot_foc
	        , potenza_nom_tot_util       = :potenza_nom_tot_util
	        , tratt_in_risc              = :tratt_in_risc
	        , tratt_in_acs               = :tratt_in_acs
	        , dich_152_presente          = :dich_152_presente
	        , docu_152                   = :docu_152
	        , auto_adeg_152              = :auto_adeg_152
                , eccesso_aria_perc          = :eccesso_aria_perc
                , perdita_ai_fumi            = :perdita_ai_fumi
                , delega_pres                = :delega_pres
                , controllo_cucina           = :controllo_cucina 
                , norm_7a                    = :norm_7a
                , norm_9a                    = :norm_9a
                , norm_9b                    = :norm_9b
                , norm_9c                    = :norm_9c
                , deve_non_messa_norma       = :deve_non_messa_norma
                , deve_non_rcee              = :deve_non_rcee 
                , rimanere_funzione          = :rimanere_funzione
                , pagamento_effettuato       = :pagamento_effettuato
                , check_sostituzione         = :check_sostituzione
                , check_scambiatori          = :check_scambiatori
                , check_eccesso_aria         = :check_eccesso_aria
                , check_altro                = :check_altro
                , ass_perdite_comb           = :ass_perdite_comb
            where cod_cimp                   = :cod_cimp
       </querytext>
    </partialquery>

    <partialquery name="del_cimp">
       <querytext>
           delete
             from coimcimp
            where cod_cimp = :cod_cimp
       </querytext>
    </partialquery>

    <partialquery name="del_movi">
       <querytext>
          delete from coimmovi
           where tipo_movi = 'VC'
             and riferimento = :cod_cimp
       </querytext>
    </partialquery>

    <partialquery name="del_todo_all">
       <querytext>
           delete
             from coimtodo
            where cod_impianto  = :cod_impianto
              and tipologia    in ('2', '6')
              and cod_cimp_dimp = :cod_cimp
       </querytext>
    </partialquery>

    <partialquery name="del_anom_all">
       <querytext>
           delete
             from coimanom
            where cod_cimp_dimp = :cod_cimp
	      and flag_origine  = 'RV'
       </querytext>
    </partialquery>

    <fullquery name="sel_cimp">
       <querytext>
           select a.gen_prog
                , a.cod_inco
                , iter_edit_data(a.data_controllo) as data_controllo
                , a.cod_opve
                , iter_edit_num(a.costo, 2) as costo
                , a.nominativo_pres
                , a.presenza_libretto
                , a.libretto_corretto
                , a.dich_conformita
                , a.libretto_manutenz
                , iter_edit_num(a.mis_port_combust, 2) as mis_port_combust
                , iter_edit_num(a.mis_pot_focolare, 2) as mis_pot_focolare
                , a.stato_coiben
                , a.verifica_areaz
                , iter_edit_num(a.rend_comb_conv, 2) as rend_comb_conv
                , iter_edit_num(a.rend_comb_min, 2) as rend_comb_min
                , iter_edit_num(a.temp_fumi_md, 2) as temp_fumi_md
                , iter_edit_num(a.t_aria_comb_md, 2) as t_aria_comb_md
                , iter_edit_num(a.temp_mant_md, 2) as temp_mant_md
                , iter_edit_num(a.temp_h2o_out_md, 2) as temp_h2o_out_md
                , iter_edit_num(a.co2_md, 2) as co2_md
                , iter_edit_num(a.o2_md, 2) as o2_md
                , iter_edit_num(a.co_md, 2) as co_md
                , iter_edit_num(a.indic_fumosita_1a, 2) as indic_fumosita_1a
                , iter_edit_num(a.indic_fumosita_2a, 2) as indic_fumosita_2a
                , iter_edit_num(a.indic_fumosita_3a, 2) as indic_fumosita_3a
                , iter_edit_num(a.indic_fumosita_md, 2) as indic_fumosita_md
                , a.manutenzione_8a
                , a.co_fumi_secchi_8b
                , a.indic_fumosita_8c
                , a.rend_comb_8d
                , a.esito_verifica
                , a.note_verificatore
                , a.note_resp
                , a.note_conf
                , a.riferimento_pag
                , iter_edit_data(b.data_scad) as data_scad
                , case
                      when importo_pag is null
                       and data_pag    is null
                      then 'N'
                      else 'S'
                  end         as flag_pagato
                , a.cod_combustibile		
                , a.cod_responsabile
                , c.nome    as nome_responsabile
                , c.cognome as cogn_responsabile
                , a.flag_pericolosita
                , a.data_ins
                , iter_edit_data(a.new1_data_dimp) as new1_data_dimp
                , iter_edit_data(a.new1_data_paga_dimp) as new1_data_paga_dimp
                , a.new1_conf_locale
                , a.new1_disp_regolaz
                , iter_edit_num(a.new1_lavoro_nom_iniz ,2) as new1_lavoro_nom_iniz
                , iter_edit_num(a.new1_lavoro_nom_fine ,2) as new1_lavoro_nom_fine
                , iter_edit_num(a.new1_lavoro_lib_iniz ,2) as new1_lavoro_lib_iniz
                , iter_edit_num(a.new1_lavoro_lib_fine ,2) as new1_lavoro_lib_fine
                , a.new1_note_manu
                , a.new1_dimp_pres
                , a.new1_dimp_prescriz
                , iter_edit_data(a.new1_data_ultima_manu) as new1_data_ultima_manu
                , iter_edit_data(a.new1_data_ultima_anal) as new1_data_ultima_anal
                , a.new1_manu_prec_8a
                , iter_edit_num(a.new1_co_rilevato, 2) as new1_co_rilevato
                , a.new1_flag_peri_8p
                , a.new1_foro_presente
                , a.new1_foro_corretto
                , a.new1_foro_accessibile
                , a.n_prot
                , iter_edit_data(a.data_prot) as data_prot
                , a.verb_n
                , iter_edit_data(a.data_verb) as data_verb
                , a.pendenza
                , a.ventilaz_lib_ostruz
                , a.disp_reg_cont_pre
                , a.disp_reg_cont_funz
                , a.disp_reg_clim_funz
                , iter_edit_num(a.volumetria,2) as volumetria
                , iter_edit_num(a.comsumi_ultima_stag,2) as comsumi_ultima_stag
                , iter_edit_num(a.temp_h2o_out_1a, 2) as temp_h2o_out_1a
                , iter_edit_num(a.temp_h2o_out_2a, 2) as temp_h2o_out_2a
                , iter_edit_num(a.temp_h2o_out_3a, 2) as temp_h2o_out_3a
                , iter_edit_num(a.t_aria_comb_1a, 2) as t_aria_comb_1a
                , iter_edit_num(a.t_aria_comb_2a, 2) as t_aria_comb_2a
                , iter_edit_num(a.t_aria_comb_3a, 2) as t_aria_comb_3a
                , iter_edit_num(a.temp_fumi_1a, 2) as temp_fumi_1a
                , iter_edit_num(a.temp_fumi_2a, 2) as temp_fumi_2a
                , iter_edit_num(a.temp_fumi_3a, 2) as temp_fumi_3a
                , iter_edit_num(a.co_1a, 2) as co_1a
                , iter_edit_num(a.co_2a, 2) as co_2a
                , iter_edit_num(a.co_3a, 2) as co_3a
                , iter_edit_num(a.co2_1a, 2) as co2_1a
                , iter_edit_num(a.co2_2a, 2) as co2_2a
                , iter_edit_num(a.co2_3a, 2) as co2_3a
                , iter_edit_num(a.o2_1a, 2) as o2_1a
                , iter_edit_num(a.o2_2a, 2) as o2_2a
                , iter_edit_num(a.o2_3a, 2) as o2_3a
                , a.cod_sanzione_1
                , a.cod_sanzione_2
                , iter_edit_num(a.tiraggio, 4) as tiraggio
                , cod_strumento_01
                , cod_strumento_02
                , a.riferimento_pag_bollini
                , a.canale_fumo_idoneo
                , a.rend_suff_insuff
                , a.dichiarato
                , iter_edit_num(a.et,2) as et  
                , fl_firma_tecnico         
		, fl_firma_resp     
		, fl_rifiuto_firma 
                , iter_edit_num(a.imp_boll_ver, 2) as imp_boll_ver  
                , numfatt
                , iter_edit_data(a.data_fatt) as data_fatt
                , iter_edit_num(a.potenza_effettiva_nom, 2) as potenza_effettiva_nom
                , iter_edit_num(a.potenza_effettiva_util, 2) as potenza_effettiva_util
                , esterna_generatore_idoneo
                , ventilazione_locali  
                , areazione_locali  
                , iter_edit_num(ventilazione_locali_mis,2) as ventilazione_locali_mis 
                , verifica_disp_regolazione
                , doc_ispesl
                , doc_prev_incendi
                , new1_pres_cartell
                , new1_pres_mezzi
                , new1_pres_interrut
                , new1_pres_intercet
                , frequenza_manut
                , frequenza_manut_altro
                , rcee_inviato
                , rcee_osservazioni
                , rcee_raccomandazioni
                , misurazione_rendimento
                , check_valvole
                , check_isolamento
                , check_trattamento
                , check_regolazione
                , dimensionamento_gen
                , esito_periodicita
                , mod_verde
                , mod_rosa
	        , a.ora_inizio
	        , iter_edit_num(a.potenza_nom_tot_foc,2) as potenza_nom_tot_foc
	        , iter_edit_num(a.potenza_nom_tot_util,2) as potenza_nom_tot_util
	        , trim(a.tratt_in_risc) as tratt_in_risc
                , trim(a.tratt_in_acs) as tratt_in_acs
                , a.dich_152_presente
	        , a.docu_152
	        , a.auto_adeg_152
                , iter_edit_num(a.eccesso_aria_perc, 2) as eccesso_aria_perc
                , iter_edit_num(a.perdita_ai_fumi, 2) as perdita_ai_fumi
                , delega_pres
                , controllo_cucina 
                , norm_7a
                , norm_9a
                , norm_9b
                , norm_9c
                , deve_non_messa_norma
                , deve_non_rcee 
                , rimanere_funzione
                , pagamento_effettuato
                , check_sostituzione
                , check_scambiatori
                , check_eccesso_aria
                , check_altro
                , ass_perdite_comb
             from coimcimp a
 $join_movi
  left outer join coimcitt c  on c.cod_cittadino = a.cod_responsabile
            where a.cod_cimp = :cod_cimp
       </querytext>
    </fullquery>

    <fullquery name="sel_anom">
       <querytext>
           select prog_anom
	        , cod_tanom 
		, iter_edit_data(dat_utile_inter) as dat_utile_inter
              , principale
             from coimanom 
            where cod_cimp_dimp = :cod_cimp
	      and flag_origine  = 'RV'
         order by to_number(prog_anom,'99999999')
            limit 10
       </querytext>
    </fullquery>

    <fullquery name="check_dimp">
       <querytext>
           select cod_dimp
             from coimdimp a 
            where a.cod_impianto    = :cod_impianto
              and a.data_controllo  = (select max(b.data_controllo)
                                         from coimdimp b
                                        where b.cod_impianto = :cod_impianto 
                                        $where_data_controllo )
              and (   a.osservazioni    <> 'NO'
                   or a.raccomandazioni <> 'NO'
                   or a.prescrizioni    <> 'NO'
                   or exists (select '1'
                                from coimanom c
                               where c.cod_cimp_dimp = a.cod_dimp
                                 and c.flag_origine  = 'MH')
                  ) limit 1
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_data">
       <querytext>
           select data_controllo
             from coimcimp
            where cod_cimp = :cod_cimp
       </querytext>
    </fullquery>

    <fullquery name="check_cimp_old">
       <querytext>
           select max(data_controllo) as data_ultimo_cimp
             from coimcimp
            where cod_impianto = :cod_impianto              
       </querytext>
    </fullquery>

</queryset>

