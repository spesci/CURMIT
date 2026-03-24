ad_page_contract {
    Lista tabella ""

    @author                  Paolo Formizzi Adhoc
    @creation-date           23/04/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  
    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param receiving_element nomi dei campi di form che riceveranno gli
                             argomenti restituiti dallo script di zoom,
                             separati da '|' ed impostarli come segue:

    @cvs-id coimestr-list.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 29/09/2025 Aggiunto filtro ditta di manutenzione presente/assente (puinto 33 MEV regione Marche 2025).
    
    rom07 23/11/2022 Tutti gli enti tranne Regione Marche hanno cambiato il tipo estrazione 4:
    rom07            devono tenere in considerazione solo gli impianti con potenza maggiore di 100 Kw.

    rom06 05/04/2022 Su indicazione di Regione Marche e Giuliodori aggiunta colonna per indicare
    rom06            se l'impianto e' ibrido.

    rom05 09/03/2022 L'estrazione degli impianti > 10 o > 12 Kw non dichiarati andava ad estrarre
    rom05            semplicemente gli impianti con flag_dichiarato <>'S'. In realta' ci sono casi
    rom05            sporchi in cui vengono estratti impianti con rcee ma col flag_dichiarato <>'S'.
    rom05            Per risolvere ho fatto in modo che non vengano estratti anche gli impianti che
    rom05            non hanno dimp.

    rom04 17/01/2022 Aggiunto il tipo estrazione per impianti > 10 o > 12 Kw non dichiarati
    rom04            su richiesta di Regione Marche.

    sim02 16/03/2021 Il tipo estrazione 1 deve sempre considerate la potenza <100 e non <35.

    sim01 05/05/2020 La query non deve tenere contro delle DAM ma solo dei rapporti di ispezione

    rom03 19/03/2019 Riveco e passo i filtri tipo_generatore, sistema_areazione e tipo_locale.

    rom02 11/03/2019 Aggiunto il tipo_estrazione per impianti senza DAM su richiesta della
    rom02            Regione Marche. 

    san03 06/08/2018 In data 06/08/2018 Copparo chiedere di mettere a 0 i mesi per il calcolo della
    san03            data da cui controllare i rapporti di verifica in modo da non escluderne nessuno

    rom01 12/07/2018 Passo il filtro f_cod_manu e f_invio_comune.

    gab01 29/06/2018 Passo i filtri flag_racc e flag_pres.

    san02 19/07/2016 Aggiunto filtro per cod_zona.

    nic03 02/05/2016 Segnalazione di UCIT (Belluzzo) avallata da Sandro.
    nic03            Se data_scad_dichiarazione e' null, significa che non e' scaduto.

    nic02 27/04/2016 Ho dovuto apportare la correzione 31/07/2013 anche sul tipo estrazione
    nic02            "12" (iterprud = 'Impianti >= 100 kW dichiarati').

    san01 23/06/2015 Aggiunta data_ri ed altri piccoli interventi.

    nic01 31/07/2013 Vanno estratti solo i generatori attivi e bisogna andare in join 
    nic01            sulla coimdimp anche col gen_prog altrimenti vengono duplicate le righe

    sandr 21/02/2014 aggiunte nuove estrazioni dpr 74

    sandr 13/10/2013 aggiunto num_ri sulla list

    sandr 13/02/2014 mancata ispezione indipendente dalla campagna
} { 
    {search_word       ""}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {tipo_estrazione   ""}
    {cod_combustibile  ""}
    {anno_inst_da      ""}
    {anno_inst_a       ""}
    {cod_comune        ""}
    {cod_via           ""}
    {num_max           ""}
     cod_cinc
    {flag_sel         "N"}
    {descr_topo        ""}
    {descr_via         ""}
    {cod_area          ""}
    {flag_scaduto      ""}
    {data_scad_chk     ""}
    {flag_oss          ""}
    {flag_racc         ""}
    {flag_pres         ""}
    {flag_status       ""}
    {cod_raggruppamento ""}
    {peso_min         ""}
    {n_anomalie       ""}
    {bacharach        ""}
    {co               ""}
    {rend_combust     ""}
    {tiraggio         ""}
    {cod_anom         ""}
    {cod_noin         ""}
    {cod_cind         ""}
    {flag_tipo_impianto  ""}
    {cod_zona            ""}
    {f_cod_manu      ""}
    {f_invio_comune  ""}
    {tipo_generatore ""}
    {sistema_areazione ""}
    {tipo_locale ""}
    {f_manu_present_p   ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    # se la lista viene chiamata da un cerca, nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

db_1row sel_date "select to_char(current_date, 'yyyy-mm-dd') as current_date"

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set valid_mod_h $coimtgen(valid_mod_h)
set flag_ente $coimtgen(flag_ente)
set sigla_prov $coimtgen(sigla_prov)

#rom07 Gestita la potenza con il relativo parametro come in coimaimp-list.tcl
if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#rom07 Aggiunte if, else e il loro contenuto.
    set colonna_potenza "a.potenza_utile"
} else {
    set colonna_potenza "a.potenza"
}


if {[db_0or1row sel_cinc ""] == 0} {
    iter_return_complaint "Campagna non trovata"
}

set page_title "Estrazione "
db_1row sel_tpes ""
append page_title $descr_tpes

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

if {[string equal $flag_oss ""]} {
    set flag_oss "N"
}
if {[string equal $flag_racc ""]} {
    set flag_racc "N"
}
if {[string equal $flag_pres ""]} {
    set flag_pres "N"
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimestr-gest"
set list_prog       "coimestr-list"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Codice impianto"

set link_righe      ""
set link_aggiungi   ""
set link_filter     [export_ns_set_vars url]
set extra_par       [list   tipo_estrazione   $tipo_estrazione \
                            cod_combustibile  $cod_combustibile \
                            cod_cind          $cod_cind \
                            flag_scaduto      $flag_scaduto \
                            anno_inst_da      $anno_inst_da \
                            anno_inst_a       $anno_inst_a \
                            cod_comune        $cod_comune \
                            cod_via           $cod_via \
                            num_max           $num_max \
                            cod_cinc          $cod_cinc \
                            flag_sel          $flag_sel \
                            descr_topo        $descr_topo \
                            descr_via         $descr_via \
                            bacharach         $bacharach \
                            co                $co \
                            rend_combust      $rend_combust\
                            flag_tipo_impianto $flag_tipo_impianto\
                            cod_zona          $cod_zona]

set form_name              "coimestr"
set value_caller           [ad_quotehtml $caller]
set value_nome_funz        [ad_quotehtml $nome_funz]
set value_nome_funz_caller [ad_quotehtml $nome_funz_caller]
set value_tipo_estrazione  [ad_quotehtml $tipo_estrazione]
set value_cod_cinc         [ad_quotehtml $cod_cinc]
set value_extra_par        [ad_quotehtml $extra_par]
set value_flag_racc        [ad_quotehtml $flag_racc];#gab01
set value_flag_pres        [ad_quotehtml $flag_pres];#gab01
set value_invio_comune     [ad_quotehtml $f_invio_comune];#rom01

set actions     ""
set js_function ""

set date_controllo ""


#inizio dpr74
set stato_imp {
   [set coloretipo "AZURE"
    set tipoimp "nd"
    if {$flag_tipo_impianto == "R"} {
	set coloretipo "MAGENTA"
	set tipoimp "Ri"
    }
    if {$flag_tipo_impianto == "F"} {
	set coloretipo "LIGHTSKYBLUE"
	set tipoimp "Fr"
    }
    if {$flag_tipo_impianto == "C"} {
	set coloretipo "BEIGE"
	set tipoimp "Co"
    }
    if {$flag_tipo_impianto == "T"} {
	set coloretipo "ORANGE"
	set tipoimp "Te"
    }
    
    return "<td nowrap align=centre bgcolor=$coloretipo>$tipoimp</font></td>"]
}

#fine dpr74

# imposto la struttura della tabella
if {$tipo_estrazione eq "1" || $tipo_estrazione eq "3" || $tipo_estrazione eq "9" || $tipo_estrazione eq "13" || $tipo_estrazione eq "14" || $tipo_estrazione eq "11" || $tipo_estrazione eq "12" || $tipo_estrazione eq "15" || $tipo_estrazione eq "16" || $tipo_estrazione eq "17" || $tipo_estrazione eq "18" } {
    if {$coimtgen(regione) ne "MARCHE"} {#rom06 Aggiunta if ma non il suo contenuto 
    set table_def [list \
		       [list action           "Conf."        no_sort {<td align=center><input type=checkbox name=conferma value="$cod_impianto"></td>}] \
		       [list cod_impianto_est "Codice"       no_sort      {l}] \
		       [list nome_resp        "Responsabile" no_sort      {l}] \
		       [list comune           "Comune"       no_sort      {l}] \
		       [list via              "Indirizzo"    no_sort      {l}] \
		       [list date_controllo   "Date controllo" no_sort      {l}] \
		       [list num_matri        "N./Matricola"   no_sort      {l}]\
		       [list num_ri           "N.RI"           no_sort      {l}] \
                       [list data_ri          "Ultimo R.I"     no_sort      {l}] \
		       [list flag_tipo_impianto  "TI"               no_sort  $stato_imp] \
		      ]
    } else {
	set table_def [list \
			   [list action           "Conf."        no_sort {<td align=center><input type=checkbox name=conferma value="$cod_impianto"></td>}] \
			   [list cod_impianto_est "Codice"       no_sort      {l}] \
			   [list nome_resp        "Responsabile" no_sort      {l}] \
			   [list comune           "Comune"       no_sort      {l}] \
			   [list via              "Indirizzo"    no_sort      {l}] \
			   [list date_controllo   "Date controllo" no_sort      {l}] \
			   [list num_matri        "N./Matricola"   no_sort      {l}]\
			   [list num_ri           "N.RI"           no_sort      {l}] \
			   [list data_ri          "Ultimo R.I"     no_sort      {l}] \
			   [list flag_ibrido      "Ibrido/Policomb./Gen.misti" no_sort {l}] \
			   [list flag_tipo_impianto  "TI"               no_sort  $stato_imp] \
			  ]
    }
	
} else {
    if {$coimtgen(regione) ne "MARCHE"} {#rom06 Aggiunta if ma non il suo contenuto 
    set table_def [list \
		       [list action           "Conf."          no_sort {<td align=center><input type=checkbox name=conferma value="$cod_impianto"></td>}] \
		       [list cod_impianto_est "Codice"         no_sort      {l}] \
		       [list nome_resp        "Responsabile"   no_sort      {l}] \
		       [list comune           "Comune"         no_sort      {l}] \
		       [list via              "Indirizzo"      no_sort      {l}] \
		       [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \
		       
		  ]
    } else {#rom06 Aggiunta else e il suo contenuto
	set table_def [list \
			   [list action           "Conf."          no_sort {<td align=center><input type=checkbox name=conferma value="$cod_impianto"></td>}] \
			   [list cod_impianto_est "Codice"         no_sort      {l}] \
			   [list nome_resp        "Responsabile"   no_sort      {l}] \
			   [list comune           "Comune"         no_sort      {l}] \
			   [list via              "Indirizzo"      no_sort      {l}] \
			   [list flag_ibrido      "Ibrido/Policomb./Gen.misti" no_sort {l}] \
			   [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \

		      ]
	
    }
}

# imposto la query SQL
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and cod_impianto_est like upper(:search_word_1)"
}

# non bisogna estrarre gli impianti < 35 kW gia' controllati negli ultimi
# 2 anni e gli impianti > 35 kW gia' controllati nell'ultimo anno
if {$tipo_estrazione == "3" || $tipo_estrazione == "12" } {
    set mesi_sub 24
} else {
    set mesi_sub 60
    
    if {$coimtgen(regione) ne "MARCHE" && $tipo_estrazione == "4"} {#rom07 Aggiunta if e il suo contenuto
	#Per gli impianti > di 100 Kw senza RCEE devo considerare gli ultimi 2 anni.
	set mesi_sub 24
    }

}

if {($coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN") && $tipo_estrazione != "9"} {#san03 if e suo contenuto
    set mesi_sub 0
}

if {$tipo_estrazione == "9"} {
    set mesi_sub 2
}

# calcola la data entro cui considerare l'esistenza dei rapporti di verifica
# come la data odierna - il numero di mesi sopra indicati.
db_1row sel_dual_data_calc ""
set data_controllo $data_calc

# calcola la data limite validita' modelli h calcolata come 
# la data odierna - il numero di mesi indicati nel parametro valid_mod_h
#set mesi_sub $valid_mod_h
#db_1row sel_dual_data_calc ""
#set data_limite $data_calc

set data_odierna [iter_set_sysdate]
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
#dpr74
set where_tipo_imp ""
#dpr74

if {$coimtgen(regione) eq "MARCHE"} {#rom06 Aggiunta if, else e il loro contenuto
        set sel_ibrido ", case a.flag_ibrido
                      when 'S' then 'Ibrido'
                      when 'M' then 'Generatore misto'
                      when 'P' then 'Unico generatore policombustibile'
                      else ' ' end as flag_ibrido"
} else {
    set sel_ibrido ", null as flag_ibrido"
}

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
	set where_stato " and a.stato = 'A'"

#sim02	if {$coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN"} {
	    #06/08/2018 Sandro ha detto che per ora mettiamo 100 solo Ancona ma che in futuro andrà su tutti
	    set where_pote " and a.potenza < 100"
#sim02	} else {
#sim02	     set where_pote " and a.potenza < 35"
#sim02	}
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
	set where_stato " and a.stato = 'A'"

	if {$coimtgen(regione) ne "MARCHE"} {#rom07 Aggiunta if e il suo contenuto
	    set where_pote "and $colonna_potenza > 100"
	} else {#rom07 Aggiunta else ma non il suo contenuto
	    set where_pote ""
	};#rom07

	#set order_by   " order by [db_map col_random]"
	set order_by   " order by  d.descrizione, b.cognome"
	#rom07set where_dich " and a.flag_dichiarato <> 'S'"
	set where_dich " and ( not exists (select '1'
                                           from coimdimp dimp
                                          where dimp.cod_impianto = a.cod_impianto)
                          or a.flag_dichiarato <> 'S' )";#rom07
	#inizio dpr74
	set where_tipo_imp ""
      	if {![string equal $flag_tipo_impianto ""]} {
	    append where_tipo_imp " and a.flag_tipo_impianto = :flag_tipo_impianto"
	}
	#fine dpr74
	
    }
    "5" {
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
	set where_stato " and a.stato = 'A'"
	if {[string equal $flag_tipo_impianto "F"]} {
	    set where_pote " and a.potenza > 12"
	} else {
	    set where_pote " and a.potenza > 10"
	}
	
	set order_by   " order by  d.descrizione, b.cognome"
	#rom05set where_dich " and a.flag_dichiarato <> 'S'"
	set where_dich " and ( not exists (select '1'
                                           from coimdimp dimp
                                          where dimp.cod_impianto = a.cod_impianto)
                          or a.flag_dichiarato <> 'S' )";#rom05
	
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

if {$f_manu_present_p eq "t"} {#ric01 aggiunta if, elseif ed else e contenuto
    set and_manu_present " and a.cod_manutentore is not null"
} elseif {$f_manu_present_p eq "f"} {
    set and_manu_present " and a.cod_manutentore is null"
} else {
    set and_manu_present ""
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
if {![string equal $f_cod_manu ""]} {#rom01 if, else e loro contenuto
    set where_manu " and a.cod_manutentore = :f_cod_manu"
} else {
    set where_manu ""
}



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

if {[string equal $num_max ""]} {
     set num_max 2000
}

if {$flag_viario == "T"} {
    set sql_query [db_map sel_aimp_si_vie]
} else {
    set sql_query [db_map sel_aimp_no_vie]
}


ns_log notice "prova dob comune $cod_comune"
ns_log notice "prova dob cinc   $cod_cinc"
ns_log notice "prova dob data_controllo $data_controllo"
ns_log notice "prova dob $sql_query"


set table_result [ad_table -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {} go $sql_query $table_def]

# dato che non c'e' la paginazione, e' sufficiente ctr_rec per capire
# quanti impianti sono stati estratti
set ctr_rec      [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec <= 0} {
    set ctr_rec 0
    set link_sel "<br>"
} else {
    set link_sel {
    <input type="checkbox" name="checkall_input" onclick="javascript:checkall();">
    Seleziona/Deseleziona tutti
    }
}

set ctr_rec_edit [iter_edit_num $ctr_rec 0]
set rec_estratti "Impianti estratti: <b>$ctr_rec_edit</b>"



set link_altre_pagine ""

# creo testata della lista
set list_head [iter_list_head $form_di_ricerca   $col_di_ricerca \
	       $rec_estratti  $link_altre_pagine $link_righe ""]

db_release_unused_handles
ad_return_template 
