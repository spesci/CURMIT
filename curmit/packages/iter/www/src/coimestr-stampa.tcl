ad_page_contract {
   Stampa estrazione impianti per controlli

    @author                  Romitti Luca
    @creation-date           13/06/2019

    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu,
                             serve per la navigation bar

    @cvs-id coimestr-stampa.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 16/01/2023 Riportate modifiche gia' fatte per coimestr-list.tcl

    sim01 05/05/2020 La query non deve tenere contro delle DAM ma solo dei rapporti di ispezione

} { 
    {caller            "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {tipo_estrazione    ""}
    {cod_combustibile   ""}
    {cod_cind           ""}
    {anno_inst_da       ""}
    {anno_inst_a        ""}
    {cod_comune         ""}
    {cod_via            ""}
    {descr_topo         ""}
    {descr_via          ""}
    {cod_cinc           ""}
    {cod_area           ""}
    {flag_scaduto       ""}
    {flag_oss           ""}
    {flag_racc          ""}
    {flag_pres          ""}
    {flag_status        ""}
    {cod_raggruppamento ""}
    {peso_min           ""}
    {n_anomalie         ""}
    {bacharach          ""}
    {co                 ""}
    {rend_combust       ""}
    {cod_anom           ""}
    {cod_noin           ""}
    {tiraggio           ""}
    {data_scad_chk      ""}
    {flag_tipo_impianto ""}
    {cod_zona           ""}
    {tipo_locale        ""}
    {tipo_generatore    ""}
    {sistema_areazione  ""} 
    {extra_par          ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
}

#ns_log notice "prova rom 1"

# Controlla lo user
set lvl        1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# valorizzo cod_manutentore se l'utente è un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

#rom01 Gestita la potenza con il relativo parametro come in coimaimp-list.tcl
if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#rom01 Aggiunte if, else e il loro contenuto.
    set colonna_potenza "a.potenza_utile"
} else {
    set colonna_potenza "a.potenza"
}


##########################inizio condizioni per query
#rom01 non bisogna estrarre gli impianti < 35 kW gia' controllati negli ultimi
#rom01 2 anni e gli impianti > 35 kW gia' controllati nell'ultimo anno
if {$tipo_estrazione == "3" || $tipo_estrazione == "12" } {#rom01 Aggiunta if, else e il loro contenuto
    set mesi_sub 24
} else {
    set mesi_sub 60
    
    if {$coimtgen(regione) ne "MARCHE" && $tipo_estrazione == "4"} {
	#Per gli impianti > di 100 Kw senza RCEE devo considerare gli ultimi 2 anni.
	set mesi_sub 24
    }

}

if {($coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN") && $tipo_estrazione != "9"} {#rom01 if e suo contenuto
    set mesi_sub 0
}

if {$tipo_estrazione == "9"} {#rom01 if e contenuto
    set mesi_sub 2
}

#rom01 calcola la data entro cui considerare l'esistenza dei rapporti di verifica
#rom01 come la data odierna - il numero di mesi sopra indicati.
db_1row sel_dual_data_calc ""
set data_controllo $data_calc

set data_odierna [iter_set_sysdate]
set current_date [iter_set_sysdate]
set sel_desc_estr ""
set sel_date_controllo ""
set sel_matricola ""
set sel_num_cimp ""
set where_dich ""
set from_dimp ""
set from_dipe ""
set where_dimp ""
set and_gend_gen_prog_uguale_a_dimp_gen_prog "";#31/07/2013 ucit
set where_dipe ""
set from_anom ""
set where_anom ""
set from_inco ""
set where_todo ""
set from_manc ""
set where_gen15 ""
set where_pote ""
set where_stato ""
#dpr74
set where_tipo_imp ""
#dpr74


# sf 11112013 comune utente

db_0or1row sel_cout_check " select count(*) as conta_cout
                              from coimcout
                             where id_utente = :id_utente
                          "

if {$conta_cout > 0} {
    set where_cout "and a.cod_comune in (select ll.cod_comune from coimcout ll where ll.id_utente = :id_utente)"
} else {
    set where_cout ""
}

# sf fine

# 13022014
set and_cinc "and not exists (select '1'
                                from coiminco d
                               where d.cod_impianto = a.cod_impianto
                                 and d.cod_cinc     =  :cod_cinc)"
#13022012

if {$cod_zona ne ""} {#san02: aggiunta if e suo contenuto
    set join_coimviae "     inner join coimviae"
    set and_cod_zona  "            and d.cod_zona = :cod_zona"
} else {
    set join_coimviae "left outer join coimviae"
    set and_cod_zona  ""
}

switch $tipo_estrazione {
    "1" {
	set tipo_estrazione_edit "Impianti > 1 0 e < 100 Kw dichiarati"
	
	set where_stato " and a.stato = 'A'"

#rom01	if {$coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN"} {
	    #06/08/2018 Sandro ha detto che per ora mettiamo 100 solo Ancona ma che in futuro andrà su tutti
	    set where_pote " and a.potenza < 100"
#rom01	} else {
#rom01	     set where_pote " and a.potenza < 35"
#rom01	}
	#set order_by " order by [db_map col_random]"
	set order_by " order by  d.descrizione,a.numero, b.cognome"
	set where_dich " and a.flag_dichiarato = 'S'"
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    &&  [string equal $flag_racc "S"]
	    &&  [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    &&  [string equal $flag_racc "S"]
	    &&  [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                     or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    &&  [string equal $flag_pres "S"]
	    &&  [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                     or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    &&  [string equal $flag_pres "S"]
	    &&  [string equal $flag_oss "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                         or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    &&  [string equal $flag_racc "N"]
	    &&  [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
            set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default ""
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	
	if {![string equal $tiraggio ""]} {
	    append where_dimp " and e.tiraggio is not null
                                and abs(e.tiraggio) > :tiraggio "
	}
	
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}
	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                       when e.prescrizioni    is not null then 'Prescrizioni'
                       when e.raccomandazioni is not null then 'Raccomandazioni'
                       when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
                     "
	
	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"

	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
	set and_gend_gen_prog_uguale_a_dimp_gen_prog "and vv.gen_prog = e.gen_prog";#31/07/2013
    	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}

	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine
	#ucit 191013
	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "

    }
    "3" {
	set tipo_estrazione_edit "Impianti > 100 Kw  dichiarati"
	set where_stato " and a.stato = 'A'"
	#set order_by " order by [db_map col_random]"
	set order_by " order by  d.descrizione, b.cognome"
	set where_dich " and a.flag_dichiarato = 'S'"
	set where_pote " and a.potenza >= 35"
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
              "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
        set and_gend_gen_prog_uguale_a_dimp_gen_prog "and vv.gen_prog = e.gen_prog";#31/07/2013

	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}

	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine
	#ucit sandro 191013
	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "
    }
    "18" {#dpr 74
	set tipo_estrazione_edit "Impianti < 100 Kw dichiarati"
      	set where_stato " and a.stato = 'A'"
	set order_by " order by [db_map col_random]"
	set where_dich " and a.flag_dichiarato = 'S'"
	set where_pote " and a.potenza < 100"
    	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss  "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
                     "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}

	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine
	#ucit sandro 191013
	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as num_ri "

	#dpr 74 11 fine
    }
    "12" {#dpr 74 12 inizio
	set tipo_estrazione_edit "Impianti >= 100 kW dichiarati"
	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "

	set where_stato " and a.stato = 'A'"
	set order_by " order by [db_map col_random]"
	set where_dich " and a.flag_dichiarato = 'S'"
	set where_pote " and a.potenza >= 100"
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74

	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
              "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
        set and_gend_gen_prog_uguale_a_dimp_gen_prog "and vv.gen_prog = e.gen_prog";#nic02

	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}

	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
#fine
    }

    "13" {#dpr 74 13 inizio
	set tipo_estrazione_edit "Impianti con Gen > 15 anni e < 100 Kw"
	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "
	#fine

	set where_stato " and a.stato = 'A'"
	set order_by " order by [db_map col_random]"
	set where_dich " and a.flag_dichiarato = 'S'"
	set where_pote " and a.potenza < 100"
	#inizio dpr74
	set where_tipo_imp ""
	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
	# sandro 270214
	set where_gen15 "
            and a.cod_impianto = (select hh.cod_impianto
                                    from coimgend hh
                                   where hh.cod_impianto = a.cod_impianto
                                     and hh.flag_attivo  = 'S' -- san01
                                     and to_char(add_months(hh.data_installaz,181),'yyyy-mm-dd') < :current_date
                                   limit 1
                                 )"


	# sandro
	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
              "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}

	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "

	set sel_gen15 "
                     , (select count(*) 
                          from coimgend gend15
                             , coimaimp aimp15
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp15.cod_impianto = gend15.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "

	#fine
    }
    "14" {#dpr 74 13 inizio
	set tipo_estrazione_edit "Impianti con Gen > 15 anni e > 100 Kw"
	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "
	#fine

	set where_stato " and a.stato = 'A'"
	set order_by " order by [db_map col_random]"
	set where_dich " and a.flag_dichiarato = 'S'"
	set where_pote " and a.potenza > 100"
	#inizio dpr74
	set where_tipo_imp ""
	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
	# sandro 270214
	set where_gen15 "
            and a.cod_impianto = (select hh.cod_impianto
                                    from coimgend hh
                                   where hh.cod_impianto = a.cod_impianto
                                     and hh.flag_attivo  = 'S' -- san01
                                     and to_char(add_months(hh.data_installaz,181),'yyyy-mm-dd') < :current_date
                                   limit 1
                                 )"
	# sandro
	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
              "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}

	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "

	set sel_gen15 "
                     , (select count(*) 
                          from coimgend gend15
                             , coimaimp aimp15
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp15.cod_impianto = gend15.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "

	#fine
    }
    "4" {
	set tipo_estrazione_edit "Impianti senza REE"
	set where_stato " and a.stato = 'A'"

	if {$coimtgen(regione) ne "MARCHE"} {#rom01 Aggiunta if e il suo contenuto
	    set where_pote "and $colonna_potenza > 100"
	} else {#rom01 Aggiunta else ma non il suo contenuto
	    set where_pote ""
	};#rom01

	#set order_by   " order by [db_map col_random]"
	set order_by   " order by  d.descrizione, b.cognome"
	#rom01set where_dich " and a.flag_dichiarato <> 'S'"
	set where_dich " and ( not exists (select '1'
                                           from coimdimp dimp
                                          where dimp.cod_impianto = a.cod_impianto)
                          or a.flag_dichiarato <> 'S' )";#rom01
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
    }
    "5" {
	set tipo_estrazione_edit "Impianti da accatastare"
	set where_stato " and a.stato = 'D'"
	set where_pote ""
	#set order_by   " order by [db_map col_random]"
       set order_by   " order by  d.descrizione,a.numero, b.cognome"
        set where_dich ""
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
    }


    "15" {
	set tipo_estrazione_edit "Impianti <100 Kw comb. Non Gassosi"

	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss  "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
                     "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}


	set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine


	set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "

	set where_stato " and a.stato = 'A'"
	set where_pote " and a.potenza < 100 and (a.cod_combustibile = '3' or a.cod_combustibile = '1')"
	set order_by   " order by [db_map col_random]"
        set where_dich ""
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
    }

    "11" {
	set tipo_estrazione_edit "Globale"
	set where_stato " and a.stato not in ('L', 'R', 'N', 'U')"
	set where_pote ""
	set order_by   " order by  d.descrizione,a.numero, b.cognome"
        set where_dich ""
	set sel_date_controllo "
                     , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

                       coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

                       coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                           from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"

#ucit sandro 130613
set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine
	#ucit sandro 191013
        set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "
	#fine

	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74

    }

    "16" {
	set tipo_estrazione_edit "Impianti >100 Kw comb. Non Gassosi"

	set where_dimp ""
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.raccomandazioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and (   e.osservazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_oss  "N"]} {
	    set where_dimp "and (   e.raccomandazioni is not null
                                 or e.prescrizioni is not null)"
	}
	if {[string equal $flag_oss "S"]
	    && [string equal $flag_racc "N"]
	    && [string equal $flag_pres "N"]} {
	    set where_dimp "and  e.osservazioni is not null"
	}
	if {[string equal $flag_oss "N"]
	    && [string equal $flag_pres "S"]
	    && [string equal $flag_racc "N"]} {
	    set where_dimp "and e.prescrizioni is not null"
	}
	if {[string equal $flag_racc "S"]
	    && [string equal $flag_pres "N"]
	    && [string equal $flag_oss "N"]} {
	    set where_dimp "and e.raccomandazioni is not null"
	}
	switch $flag_status {
	    "N" {append where_dimp " and e.flag_status = 'N'"}
	    "S" {append where_dimp " and e.flag_status = 'S'"}
	    default {}
	}
	
	if {![string equal $bacharach ""]} {
	    append where_dimp " and e.bacharach is not null
                                and e.bacharach > :bacharach "
	}
	if {![string equal $co ""]} {
	    append where_dimp " and e.co is not null
                                and e.co > :co "
	}
	if {![string equal $rend_combust ""]} {
	    append where_dimp " and e.rend_combust is not null
                                and e.rend_combust < :rend_combust "
	}

	if {![string equal $cod_cind ""]} {
	    append where_dimp " and (e.cod_cind is null or e.cod_cind <> :cod_cind)"
	}
	
	set sel_desc_estr "
                     , case
                         when e.prescrizioni    is not null then 'Prescrizioni'
                         when e.raccomandazioni is not null then 'Raccomandazioni'
                         when e.osservazioni    is not null then 'Osservazioni'
                       end as desc_estr
                     "
	set from_dimp " , coimdimp e"
	set where_dimp "and e.cod_impianto = a.cod_impianto
                        and e.data_controllo = (select max(f.data_controllo)
                                                  from coimdimp f
                                                 where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)
                        $where_dimp"
	if {![string equal $cod_anom ""]} {
	    set from_anom  " , coimanom u"
	    set where_anom " and u.cod_tanom = :cod_anom
                             and u.cod_cimp_dimp = e.cod_dimp
                             and flag_origine = 'MH'"
	}


    set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine
        set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "

	set where_stato " and a.stato = 'A'"
	set where_pote " and a.potenza > 100 and (a.cod_combustibile = '3' or a.cod_combustibile = '1')"
	set order_by   " order by [db_map col_random]"
        set where_dich ""
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
    }
    
    "17" {
	set tipo_estrazione_edit "Impianti >100 Kw comb. Gassosi"

      set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo"
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine

        set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "

	set where_stato " and a.stato = 'A'"
	set where_pote " and a.potenza > 100 and (a.cod_combustibile = '4' or a.cod_combustibile = '5')"
	set order_by   " order by [db_map col_random]"
        set where_dich ""
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
    }
    "7" {
	set where_stato ""
	set where_pote ""
	set order_by   " order by [db_map col_random]"
        set where_dich ""
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
	set from_dimp " , coimdimp e"
	set where_dimp " and e.cod_impianto = a.cod_impianto
                         and e.data_controllo = (select max(f.data_controllo)
                                                   from coimdimp f
                                                  where f.cod_impianto = a.cod_impianto
                                                   and f.flag_tracciato !='DA' --sim01
)"
        set and_gend_gen_prog_uguale_a_dimp_gen_prog "and vv.gen_prog = e.gen_prog";#31/07/2013

	set from_dipe " , coimpesi t
                        , coimdipe s"
	set where_dipe " and s.cod_dimp   = e.cod_dimp
                         and t.nome_campo = s.nome_campo
                         and t.tipo_peso  = s.tipo_peso"
	if {![string equal $cod_raggruppamento ""]} {
	    append where_dipe " and t.cod_raggruppamento = :cod_raggruppamento"
	}
	if {![string equal $peso_min ""]} {
	    append where_dipe " and s.peso_totale > :peso_min"
	}
	if {![string equal $n_anomalie ""]} {
	    append where_dipe " and s.n_anomalie > :n_anomalie"
	}
    }
    "8" {
	set tipo_estrazione_edit "Rispedizione"
        set from_inco "inner join coiminco z on
                             a.cod_impianto = z.cod_impianto and
                             z.cod_noin = :cod_noin"
        set where_pote ""
        set where_stato ""
        #inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
        set order_by " order by [db_map col_random]"
    }
    "10" {
	set tipo_estrazione_edit "Mancate Ispezioni"

        set from_manc "inner join coimcimp h on
                             a.cod_impianto = h.cod_impianto and
                             h.cod_noin = :cod_noin
                             and flag_tracciato = 'MA'"
        set where_pote ""
        set where_stato ""
        set and_cinc ""
        #inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74

        set order_by " order by [db_map col_random]"
    }
    "9" {
	set tipo_estrazione_edit "Controlli impianti con anom. non sanate"

        set sel_date_controllo "
            , coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy') 
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp1.data_controllo) from coimdimp dimp1 where dimp1.cod_impianto = a.cod_impianto )
                       ), '') ||' '||

              coalesce((select to_char(max(dimp.data_controllo), 'dd/mm/yyyy')
                          from coimdimp dimp
                         where dimp.cod_impianto = a.cod_impianto
                           and dimp.data_controllo < (select max(dimp2.data_controllo)
                                                        from coimdimp dimp2
                                                       where dimp2.cod_impianto = a.cod_impianto
                                                         and dimp2.data_controllo < (select max(dimp3.data_controllo)
                                                                                       from coimdimp dimp3
                                                                                      where dimp3.cod_impianto = a.cod_impianto )
                                                      )
                       ), '') as date_controllo";#san01
    
	#ucit sandro 130613
	set sel_matricola "
                     , (select count(*) 
                          from coimgend gend
                             , coimaimp aimp
                         where gend.matricola    = vv.matricola
                           and gend.flag_attivo  = 'S' -- 31/07/2013
                           and aimp.cod_impianto = gend.cod_impianto) ||' '|| 
                       coalesce((select gend.matricola
                                   from coimgend gend
                                      , coimaimp aimp
                                  where gend.matricola    = vv.matricola
                                    and gend.flag_attivo  = 'S' -- 31/07/2013
                                    and aimp.cod_impianto = gend.cod_impianto
                                  limit 1), '')
                          as  num_matri "
	#fine

        set sel_num_cimp "
                     , coalesce ((select count(*)
                                    from coimcimp jj
                                   where a.cod_impianto = jj.cod_impianto)
                                , 0) as  num_ri "

        set where_pote ""
        set where_stato ""
        set where_dich ""
        #inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
        set order_by " order by [db_map col_random]"
	
	set where_todo "and exists (select * 
                                      from coimtodo z
                                         , coimcimp e
                                         , coimanom anom -- san01
                                         , coimtano tano -- san01
                                     where e.cod_impianto  = a.cod_impianto
                                       and z.cod_cimp_dimp = e.cod_cimp
                                       and z.cod_impianto  = a.cod_impianto
                                       and z.cod_cimp_dimp = anom.cod_cimp_dimp -- san01
                                       and anom.cod_tanom  = tano.cod_tano      -- san01
                                       and tano.flag_tipo_ispezione = 'C'       -- san01
                                       and z.data_evasione is null)"
    }
    "19" {
	set tipo_estrazione_edit "Impianti senza DAM"
	#rom02
	set where_stato " and a.stato = 'A'"
	set where_pote  " and a.potenza < 100"

	set where_dimp "and not exists (select '1'
                                          from coimdimp d
                                          where d.cod_impianto = a.cod_impianto
                                            and flag_tracciato = 'DA'
                                         ) 
                        and a.flag_tipo_impianto !='T'";#Sandro ha detto che il teleriscaldamento non ha le DAM
	set order_by   " order by  d.descrizione, b.cognome"
	set where_dich " and a.flag_dichiarato <> 'S'"
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}

    }
    "20" {
	set tipo_estrazione_edit "Impianti > 10 o > 12 Kw senza RCEE"
	set where_stato " and a.stato = 'A'"
	if {[string equal $flag_tipo_impianto "F"]} {
	    set where_pote " and a.potenza > 12"
	} else {
	    set where_pote " and a.potenza > 10"
	}
	
	set order_by   " order by  d.descrizione, b.cognome"
	#rom01set where_dich " and a.flag_dichiarato <> 'S'"
	set where_dich " and ( not exists (select '1'
                                           from coimdimp dimp
                                          where dimp.cod_impianto = a.cod_impianto)
                          or a.flag_dichiarato <> 'S' )";#rom01
	
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
    }
}

set where_gend "";#rom03
set and_tipo_generatore "";#rom03
set and_sistema_areazione "";#rom03
set and_tipo_locale "";#rom03
if {![string equal $tipo_generatore ""]} {#rom03 aggiunta if e suo contenuto
    set and_tipo_generatore "and gend.tipo_foco    = :tipo_generatore"
}
if {![string equal $sistema_areazione  ""]} {#rom03 aggiunta if suo contenuto
    set and_sistema_areazione "and gend.tiraggio    = :sistema_areazione"
}
if {![string equal $tipo_locale ""]} {#rom03 aggiunta if e suo contenuto
    set and_tipo_locale "and gend.locale       = :tipo_locale"
}
if {$and_tipo_locale ne "" || $and_sistema_areazione ne "" || $and_tipo_generatore ne ""} {#rom03 aggiunta if suo contenuto
        append where_gend "and exists ( select 1 
                                        from coimgend gend
                                       where gend.cod_impianto = a.cod_impianto
                                         and flag_attivo = 'S'
                                             $and_tipo_locale
                                             $and_sistema_areazione
                                             $and_tipo_generatore 
                                             ) "
}


# inizio sa 070115
if {![string equal $data_scad_chk ""]} {
    set data_odierna $data_scad_chk 
} else {
    set data_odierna [iter_set_sysdate]
}
#fine sa 070115

switch $flag_scaduto {
    "S" {
	#nic03 append where_dich "  and (   a.data_scad_dich <= :data_odierna
        #nic03                           or a.data_scad_dich is null)"
	append where_dich " and     a.data_scad_dich <= :data_odierna";#nic02
    }
    "N" {
	#nic03 append where_dich " and a.data_scad_dich > :data_odierna"
	append where_dich " and (   a.data_scad_dich > :data_odierna
                                 or a.data_scad_dich is null)";#nic03
    }
    default {}
}

if {![string equal $cod_combustibile ""]} {
    set where_comb " and a.cod_combustibile = :cod_combustibile"
} else {
    set where_comb ""
}

if {[string equal $anno_inst_da ""]} {
    set data_installaz_da ""
} else {
    set data_installaz_da "${anno_inst_da}0101"
}
if {[string equal $anno_inst_a ""]} {
    set data_installaz_a  ""
} else {
    set data_installaz_a  "${anno_inst_a}1231"
}
if {![string equal $data_installaz_a ""]} {
    if {![string equal $data_installaz_da ""]} {
	set where_anno   " and a.data_installaz  between :data_installaz_da
                                                     and :data_installaz_a"
    } else {
	set where_anno   " and a.data_installaz  <= :data_installaz_a"
    }
} else {
    if {![string equal $data_installaz_da ""]} {
	set where_anno   " and a.data_installaz  >= :data_installaz_da"
    } else {
	set where_anno   ""
    }
}

if {![string equal $cod_comune ""]} {
    set where_comune " and a.cod_comune = :cod_comune"
} else {
    set where_comune ""
}


set where_manu ""




# imposto filtro per area. ricordo che per questa estrazione si considerano
# solo le aree come raggruppamenti di comuni percha' attualmente ci sono anche
# i ragruppamenti per urbanizzazione e via.
if {![string equal $cod_area ""]} {
    if {[db_0or1row sel_area_tipo_01 ""] == 0} {
	set tipo_01 ""
    }
    
    set lista_comu "("
    set conta_comu 0
    db_foreach sel_cmar "" {
	incr conta_comu
	append lista_comu "$cod_comune,"
    }
    if {$conta_comu > 0} {
	set lung_lista_comu [string length $lista_comu]
	set lista_comu [string range $lista_comu 0 [expr $lung_lista_comu -2]]
	append lista_comu ")"
	
	set where_area "and a.cod_comune in $lista_comu"
    } else {
	set where_area ""
    }
} else {
    set where_area ""
}


# imposto filtro per via
if {![string equal $cod_via ""]
&&  $flag_viario == "T"
} {
    set where_via " and a.cod_via = :cod_via"
} else {
    if {(![string equal $descr_via ""]
    ||   ![string equal $descr_topo ""])
    &&  $flag_viario == "F"
    } {
	set descr_via1  [iter_search_word $descr_via]
	set descr_topo1 [iter_search_word $descr_topo]
	set where_via " and a.indirizzo like upper(:descr_via1)
                        and a.toponimo  like upper(:descr_topo1)"
    } else {
	set where_via ""
    }
}
set where_word ""
##########################fine condizioni per query

set button_label "Stampa"


set page_title      "Elenco Impianti inseriti"
set context_bar     [iter_context_bar -nome_funz $nome_funz_caller]

# preparo link per ritorno alla lista distinte:
set link_filter [export_ns_set_vars url]

# imposto la directory degli spool ed il loro nome.
set spool_dir       [iter_set_spool_dir]
set spool_dir_url   [iter_set_spool_dir_url]

# imposto il nome dei file
set nome_file       "Stampa Estrazione impianti per controlli"
set nome_file       [iter_temp_file_name $nome_file]
set file_html       "$spool_dir/$nome_file.html"
set file_pdf        "$spool_dir/$nome_file.pdf"
set file_pdf_url    "$spool_dir_url/$nome_file.pdf"

# apro il file html temporaneo
set file_id [open $file_html w]
fconfigure $file_id -encoding iso8859-1

set righe_stampa ""

# imposto la query SQL 

# scrivo due query diverse a seconda se c'e' o meno il viario

if {$coimtgen(flag_viario) == "T"} {
    set nome_col_toponimo  "e.descr_topo"
    set nome_col_via       "e.descrizione"
} else {
    set nome_col_toponimo  "b.toponimo"
    set nome_col_via       "b.indirizzo"
}


set sysdate       [iter_set_sysdate];
set sysdate_edit  [iter_edit_date $sysdate]
append righe_stampa "
<!-- FOOTER LEFT   \"$sysdate_edit\"-->
<!-- FOOTER CENTER \"ELENCO IMPIANTI ESTRATTI\"-->
<!-- FOOTER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\"-->"

iter_get_coimdesc

set nome_ente    $coimdesc(nome_ente)
set tipo_ufficio $coimdesc(tipo_ufficio)
set assessorato  $coimdesc(assessorato)
set indirizzo    $coimdesc(indirizzo)
set telefono     $coimdesc(telefono)

set flag_tipo_impianto_edit ""
if {$flag_tipo_impianto ne ""} {
    switch $flag_tipo_impianto {
	"R" { set flag_tipo_impianto_edit "Riscaldamento"     }
	"F" { set flag_tipo_impianto_edit "Raffreddamento"    }
	"T" { set flag_tipo_impianto_edit "Teleriscaldamento" }
	"C" { set flag_tipo_impianto_edit "Cogenerazione"     }
    }
}
if {$cod_combustibile ne ""} {
    set descr_comb [db_string q "select coalesce(descr_comb, '') 
                                      from coimcomb
                                     where cod_combustibile = :cod_combustibile"]
} else {
    set descr_comb ""
}
if {$descr_via ne "" || $descr_topo ne ""} {
    set strada_edit "$descr_topo $descr_via"
} else {
    set strada_edit ""
}
if {$anno_inst_da ne ""} {
    set anno_inst_da_edit "$anno_inst_da"
} else {
    set anno_inst_da_edit ""
}
if {$anno_inst_a ne ""} {
    set anno_inst_a_edit "$anno_inst_a"
} else {
    set anno_inst_a_edit ""
}

if {$flag_scaduto eq "S"} {
    set flag_scaduto_edit "S&igrave;"
} elseif { $flag_scaduto eq "N"} {
    set flag_scaduto_edit "No"
} else {
    set flag_scaduto_edit ""
}
if {$data_scad_chk ne ""} {
    set data_scad_edit [iter_edit_date $data_scad_chk]
} else {
    set data_scad_edit ""
}
if {$cod_zona ne ""} {
    set cod_zona_edit $cod_zona
} else {
    set cod_zona_edit ""
}

append righe_stampa "
<table width=100% align=center>
      <tr>
         <td align=center>$nome_ente</td>
      </tr>
      <tr>
         <td align=center>$tipo_ufficio</td>
      </tr>
      <tr>
         <td align=center>$assessorato</td>
      </tr>
      <tr>
         <td align=center><small>$indirizzo</small></td>
      </tr>
      <tr>
         <td align=center><small>$telefono</small></td>
      </tr>
</table>
<br>
<table width=100% border=0A Anno installazione: align=center>
      <tr>
         <td align=center colspan=4><b>Impianti estratti con i seguenti criteri:</b></td>
      </tr>
      <tr>
        <td align=right>Tipologia impianti:</td>
        <td align=left colspan=3><b>$flag_tipo_impianto_edit</b></td>
      </tr>
      <tr>
        <td align=right>Tipo estrazione:</td>
        <td align=left colspan=3><b>$tipo_estrazione_edit</b></td>
      </tr>
      <tr>
        <td align=right width=25%>Con dichiarazione scaduta:</td>
        <td align=left><b>$flag_scaduto_edit</b></td>
        <td align=right>Fino al:</td>
        <td align=left><b>$data_scad_edit</b></td>
      </tr>
      <tr>
        <td align=right >Da Anno installazione:</td>
        <td align=left width=30%><b>$anno_inst_da_edit</b></td>
        <td align=right nowrap>A Anno installazione:</td>
        <td align=left width=30%><b>$anno_inst_a_edit</b></td>
      </tr>
      <tr>
        <td align=right >Combustibile:</td>
        <td align=left colspan=3><b>$descr_comb</b></td>
      </tr>
      <tr>
        <td align=right >Zona::</td>
        <td align=left colspan=3><b>$cod_zona_edit</b></td>
      </tr>
      <tr>
        <td align=right >Indirizzo:</td>
        <td align=left colspan=3><b>$strada_edit</b></td>
      </tr>
<br><br>"

if {[db_0or1row q "select 1 
                    where :tipo_estrazione in ('1','3','11','12','15','16','18')"]} {

    set cod_anom_edit [db_string q "select coalesce(cod_tano||' - '||descr_breve, ' ')
                                      from coimtano
                                     where cod_tano = :cod_anom" -default ""]
    if {$flag_oss eq "S"} {
	set flag_oss_edit "S&igrave;"
    } elseif { $flag_oss eq "N"} {
	set flag_oss_edit "No"
    } else {
	set flag_oss_edit ""
    }

    if {$flag_racc eq "S"} {
	set flag_racc_edit "S&igrave;"
    } elseif { $flag_racc eq "N"} {
	set flag_racc_edit "No"
    } else {
	set flag_racc_edit ""
    }

    if {$flag_pres eq "S"} {
	set flag_pres_edit "S&igrave;"
    } elseif { $flag_pres eq "N"} {
	set flag_pres_edit "No"
    } else {
	set flag_pres_edit ""
    }

    if {$flag_status eq "S"} {
	set flag_status_edit "S&igrave;"
    } elseif {$flag_status eq "N"} {
	set flag_status_edit "No"
    } else {
	set flag_status_edit ""
    }

    if {$tipo_generatore eq "A"} {
	set tipo_generatore_edit "Aperta"
    } elseif {$tipo_generatore eq "S"} {
	set tipo_generatore_edit "Stagna"
    } else {
	set tipo_generatore_edit ""
    }

    if {$sistema_areazione eq "F"} {
	set sistema_areazione_edit "Forzato"
    } elseif {$sistema_areazione eq "N"} {
	set sistema_areazione_edit "Naturale"
    } else {
	set sistema_areazione_edit ""
    }

    if {$tipo_locale eq "T"} {
	set tipo_locale_edit "Locale ad uso esclusivo"
    } elseif {$tipo_locale eq "I"} {
	set tipo_locale_edit "Interno"
    } elseif {$tipo_locale eq "E"} {
	set tipo_locale_edit "Esterno"
    } else {
	set tipo_locale_edit ""
    }
    
    append righe_stampa "

      <tr>
        <td align=right >Anomalia:</td>
        <td align=left colspan=3><b>$cod_anom_edit</b></td>
      </tr>
      <tr>
        <td align=right >Con osservazioni:</td>
        <td align=left colspan=3><b>$flag_oss_edit</b></td>
      </tr>
      <tr>
        <td align=right >Con raccomandazioni:</td>
        <td align=left colspan=3><b>$flag_racc_edit</b></td>
      </tr>
      <tr>
        <td align=right >Con prescrizioni:</td>
        <td align=left colspan=3><b>$flag_pres_edit</b></td>
      </tr>
      <tr>
        <td align=right >L'impianto pu&ograve; funzionare:</td>
        <td align=left colspan=3><b>$flag_status_edit</b></td>
      </tr>
      <tr>
        <td align=right >Bacharach &gt; di:</td>
        <td align=left colspan=3><b>$bacharach</b></td>
      </tr>
      <tr>
        <td align=right >Co &gt; di:</td>
        <td align=left colspan=3><b>$co</b></td>
      </tr>
      <tr>
        <td align=right >Rend. combust. &lt; di:</td>
        <td align=left colspan=3><b>$rend_combust</b></td>
      </tr>
      <tr>
        <td align=right >Tiraggio &gt; di:</td>
        <td align=left colspan=3><b>$tiraggio</b></td>
      </tr>
      <tr>
        <td align=right >Camera di combustione:</td>
        <td align=left colspan=3><b>$tipo_generatore_edit</b></td>
      </tr>
      <tr>
        <td align=right >Evacuazione fumi:</td>
        <td align=left colspan=3><b>$sistema_areazione_edit</b></td>
      </tr>
      <tr>
        <td align=right >Tipo locale</td>
        <td align=left colspan=3><b>$tipo_locale_edit</b></td>
      </tr>"

} elseif {[db_0or1row q "select 1
                          where :tipo_estrazione in ('8','10')"]} {
    switch $cod_noin {
	"3"  { set cod_noin_edit "ISP. IMPIANTO GIÀ VERIFICATO"               }
	"5"  { set cod_noin_edit "APP. ERRORE DI ESTRAZIONE"                  }
	"6"  { set cod_noin_edit "APP. IMPIANTO BONIFICATO"                   }
	"7"  { set cod_noin_edit "APP. AVVISO NON RECAPITATO"                 }
	"4"  { set cod_noin_edit "APP. ISPEZIONE NON ESEGUITA DALL'ISPETTORE" }
	"2"  { set cod_noin_edit "ISP. IMPIANTO NON VERIFICABILE"             }
	"13" { set cod_noin_edit "APP. DA RIPIANIFICARE"                      }
	"15" { set cod_noin_edit "ISP. STABILE IN RESTRUTTURAZIONE"           }
	"8"  { set cod_noin_edit "ISP. *IMPIANTO NON SOGGETTO AL CONTROLLO"   }
	"14" { set cod_noin_edit "ISP. *IMPIANTO INESISTENTE"                 }
	"9"  { set cod_noin_edit "ISP. *IMPIANTO DISATTIVATO"                 }
	"12" { set cod_noin_edit "APP. INDIRIZZO ERRATO"                      }
	"1"  { set cod_noin_edit "ISP. UTENTE ASSENTE"                        }
	""   { set cod_noin_edit ""                                           }
    }
    append righe_stampa "
      <tr>
        <td align=right >Annullamento:</td>
        <td align=left colspan=3><b>$cod_noin_edit</b></td>
      </tr>"
} else {
    #i tipi estrazione 4,5,6,9,13,14,17,19 non hanno filtri aggiuntivi
}

append righe_stampa "</table><br><br>"
     
db_foreach sel_aimp "" {
    append righe_stampa "

<table width=100% border=0>
    <tr>
      <td align=center>Comune di <b>$nome_comune</b> N° Impianti estratti: <b>$numero_impianti</b></td> 
    </tr>
</table><br><br>
"
} else {
    append righe_stampa ""
}
db_1row sel_tot_imp ""
append righe_stampa "
<br>
<h2>Elenco impianti estratti</h2>
Numero impianti estratti: $tot_imp <br>"

puts $file_id $righe_stampa
close $file_id

# creo il file pdf
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --fontsize 10 --headfootfont arial --headfootsize 10 --top 1.5cm --bottom 2cm --left 2cm --right 2cm -f $file_pdf $file_html]
	
	# cancello il file temporaneo creato
	#ns_unlink     $file_html
	
#db_release_unused_handles
ad_return_template 
