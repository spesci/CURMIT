<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="iter_inco_cari3.sel_cinc_count">
       <querytext>
                   select count(*) as conta
                     from coimcinc
                    where stato = '1'
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_cinc">
       <querytext>
                   select cod_cinc
                        , descrizione as desc_camp
                     from coimcinc
                    where stato = '1'
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_comu_check">
       <querytext>
                   select count(*)        as ctr_comu
                        , max(cod_comune) as cod_comune
                     from coimcomu
                    where upper(denominazione) = upper(:denominazione)
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_comu">
       <querytext>
                   select a.cod_provincia
                        , b.sigla as provincia
                     from coimcomu a
                        , coimprov b
                    where a.cod_comune    =  :cod_comune
                      and b.cod_provincia = a.cod_provincia
       </querytext>
    </fullquery>

   <partialquery name="iter_inco_cari3.upd_prog_comu">
       <querytext>
                update coimcomu
                   set progressivo = :progressivo
                 where cod_comune  = :cod_comune
       </querytext>
    </partialquery>


    <fullquery name="iter_inco_cari3.sel_viae_check">
       <querytext>
                   select count(*)     as ctr_viae
                        , max(cod_via) as cod_via 
                     from coimviae
                    where cod_comune  = :cod_comune
                      and descrizione = upper(:descrizione)
                      and descr_topo  = upper(:descr_topo)
                      and cod_via_new is null
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_citt_check">
       <querytext>
                   select count(*)           as ctr_citt
                        , max(cod_cittadino) as cod_cittadino
                     from coimcitt
                    where cognome   = :cognome
                   $where_nome
                      and indirizzo = :indirizzo
                   $where_numero
                      and comune    = :comune
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_dual_cod_cittadino">
       <querytext>
                   select nextval('coimcitt_s') as cod_cittadino
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.ins_citt">
       <querytext>
                   insert
                     into coimcitt 
                        ( cod_cittadino
                        , natura_giuridica
                        , cognome
                        , nome
                        , indirizzo
                        , numero
                        , cap
                        , localita
                        , comune
                        , provincia
                        , cod_fiscale
                        , cod_piva
                        , telefono
                        , cellulare
                        , fax
                        , email
                        , data_nas
                        , comune_nas
                        , utente
                        , data_ins
                        , data_mod
                        , utente_ult
                        , note
			)
                   values 
                        (:cod_cittadino
                        ,:natura_giuridica
                        ,upper(:cognome)
                        ,upper(:nome)
                        ,upper(:indirizzo)
                        ,:numero
                        ,:cap
                        ,upper(:localita)
                        ,upper(:comune)
                        ,upper(:provincia)
                        ,upper(:cod_fiscale)
                        ,:cod_piva
                        ,:telefono
                        ,:cellulare
                        ,:fax
                        ,:email
                        ,:data_nas
                        ,:comune_nas
                        ,:utente
                        ,:data_ins
                        ,:data_mod
                        ,:utente_ult
                        ,:note
			)
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_aimp_check">
       <querytext>
                   select count(*)              as ctr_aimp
                        , max(cod_impianto_est) as cod_impianto_es
                     from coimaimp
                    where cod_responsabile = :cod_responsabile
                   $where_indirizzo
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_dual_cod_impianto">
       <querytext>
                   select nextval('coimaimp_s') as cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_dual_cod_impianto_est">
       <querytext>
                   select nextval('coimaimp_est_s') as cod_impianto_est
       </querytext>
    </fullquery>


    <fullquery name="iter_inco_cari3.sel_aimp_max_cod_impianto_est">
       <querytext>
                   select coalesce(max(
                          to_number(cod_impianto_est, '9999999990')
                          ),0) as max_cod_impianto_est
                     from coimaimp
                    where cod_impianto_est < 'A'
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.ins_aimp">
       <querytext>
                   insert
                     into coimaimp 
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
                        , cod_amag
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
                        , foglio
                        , cod_tpdu
                        , cod_qua
                        , cod_urb
                        , data_ins
                        , data_mod
                        , utente
                        , flag_dpr412
                        , flag_tipo_impianto
			)
                   values 
                        (:cod_impianto
                        ,:cod_impianto_est
                        ,:cod_impianto_prov
                        ,:descrizione
                        ,:provenienza_dati
                        ,:cod_combustibile
                        ,:cod_potenza
                        ,:potenza
                        ,:potenza_utile
                        ,:data_installaz
                        ,:data_attivaz
                        ,:data_rottamaz
                        ,:note
                        ,:stato
                        ,:flag_dichiarato
                        ,:data_prima_dich
                        ,:data_ultim_dich
                        ,:cod_tpim
                        ,:consumo_annuo
                        ,:n_generatori
                        ,:stato_conformita
                        ,:cod_cted
                        ,:tariffa
                        ,:cod_responsabile
                        ,:flag_resp
                        ,:cod_intestatario
                        ,:flag_intestatario
                        ,:cod_proprietario
                        ,:cod_occupante
                        ,:cod_amministratore
                        ,:cod_manutentore
                        ,:cod_installatore
                        ,:cod_distributore
                        ,:cod_progettista
                        ,:cod_amag
                        ,:cod_ubicazione
                        ,:localita
                        ,:cod_via
                        ,:toponimo
                        ,:indirizzo
                        ,:numero
                        ,:esponente
                        ,:scala
                        ,:piano
                        ,:interno
                        ,:cod_comune
                        ,:cod_provincia
                        ,:cap
                        ,:foglio
                        ,:cod_tpdu
                        ,:cod_qua
                        ,:cod_urb
                        ,:data_ins
                        ,:data_mod
                        ,:utente
                        ,:flag_dpr412
                        ,'R'
                        )
       </querytext>
    </fullquery>



    <fullquery name="iter_inco_cari3.ins_gend">
       <querytext>
                   insert
                     into coimgend
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
			)
                   values 
                        (:cod_impianto
                        ,:gen_prog
                        ,:descrizione
                        ,:matricola
                        ,:modello
                        ,:cod_cost
                        ,:matricola_bruc
                        ,:modello_bruc
                        ,:cod_cost_bruc
                        ,:tipo_foco
                        ,:mod_funz
                        ,:cod_utgi
                        ,:tipo_bruciatore
                        ,:tiraggio
                        ,:locale
                        ,:cod_emissione
                        ,:cod_combustibile
                        ,:data_installaz
                        ,:data_rottamaz
                        ,:pot_focolare_lib
                        ,:pot_utile_lib
                        ,:pot_focolare_nom
                        ,:pot_utile_nom
                        ,:flag_attivo
                        ,:note
                        ,:data_ins
                        ,:data_mod
                        ,:utente
                        ,:gen_prog_est
                        )
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_citt">
       <querytext>
                   select telefono
                     from coimcitt
                    where cod_cittadino = :cod_cittadino
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.sel_dual_cod_inco">
       <querytext>
                   select nextval('coiminco_s') as cod_inco
       </querytext>
    </fullquery>

    <fullquery name="iter_inco_cari3.ins_inco">
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
			)
                   values 
                        (:cod_inco
                        ,:cod_cinc
                        ,:tipo_estrazione
                        ,:cod_impianto
                        ,:data_estrazione
                        ,:data_assegn
                        ,:cod_opve
                        ,:data_verifica
                        ,:ora_verifica
                        ,:data_avviso_01
                        ,:cod_documento_01
                        ,:data_avviso_02
                        ,:cod_documento_02
                        ,:stato
                        ,:esito
                        ,:note
                        ,:data_ins
                        ,:data_mod
                        ,:utente
                        ,:tipo_lettera
                        )
       </querytext>
    </fullquery>

</queryset>
