<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom01 04/04/2022 MAC Regione Marche 9. Colonna N. di telefono su RCEE/DAM:
    rom01            Aggiunta colonna telefono, puo andare su tutti gli enti.

    san01 28/10/2020 Aggiunta colonna costo, puo andare su tutti gli enti.

-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_stat_dich">
       <querytext>
     select g.cod_manutentore                as codice
          , g.cognome                        as cog_manu
          , f.descr_potenza                  as fascia_potenza
          , e.descr_comb                     as combustibile
          , d.denominazione                  as comune
          , b.cod_impianto_est
          , a.cod_impianto
          , a.data_controllo                 as data_con
          , a.flag_tracciato
          , a.n_prot
          , iter_edit_data(a.data_prot)      as data_protocollo
          , iter_edit_data(a.data_controllo) as data_controllo
          , riferimento_pag
          , a.utente_ins
          , b.stato
          , a.costo
          , a.cod_dimp
          , coalesce(h.cognome,' ')||' '||coalesce(h.nome,' ') as resp
	  , 'Tel.'||coalesce(h.telefono, ' ')|| ' - Cel.'||coalesce(h.cellulare,' ') as resp_tel --rom01
      from coimdimp a
 left join coimcitt h on a.cod_responsabile = h.cod_cittadino
         , coimaimp b 
         , coimcomu d
         , coimcomb e
         , coimpote f
         , coimmanu g
     where b.cod_impianto     = a.cod_impianto
       and d.cod_comune       = b.cod_comune
       and g.cod_manutentore  = a.cod_manutentore
       and e.cod_combustibile = b.cod_combustibile
       and f.cod_potenza      = b.cod_potenza
    $where_manu
    $where_data
    $where_data_controllo
    $where_cod_potenza
    $where_comune
    $where_combustibile
    $where_utente
    $where_utente_admin
  order by data_controllo
        </querytext>
    </fullquery>

    <fullquery name="count_all">
        <querytext>
    select count(*) as num_dich
      from coimdimp a
 left join coimcitt h on a.cod_responsabile = h.cod_cittadino
         , coimaimp b
         , coimcomu d
         , coimcomb e
         , coimpote f
         , coimmanu g
     where b.cod_impianto     = a.cod_impianto
       and d.cod_comune       = b.cod_comune
       and g.cod_manutentore  = a.cod_manutentore
       and e.cod_combustibile = b.cod_combustibile
       and f.cod_potenza      = b.cod_potenza
    $where_manu
    $where_data
    $where_data_controllo
    $where_cod_potenza
    $where_comune
    $where_combustibile
    $where_utente
    $where_utente_admin
        </querytext>
    </fullquery>

    <fullquery name="edit_date_dual">
       <querytext>
        select iter_edit_data(:f_data_da) as data_da_e
             , iter_edit_data(:f_data_a) as data_a_e
       </querytext>
    </fullquery>

</queryset>
