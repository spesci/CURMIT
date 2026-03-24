ad_page_contract {
    Lista tabella "coimgage"

    @author                  Giulio Laurenzi
    @creation-date           07/07/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  
    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu,
                             serve per la navigation bar
    @param receiving_element nomi dei campi di form che riceveranno gli
                             argomenti restituiti dallo script di zoom,
                             separati da '|' ed impostarli come segue:

    @cvs-id coimgage-list.tcl 

     USER  DATA       MODIFICHE
    ===== ========== =======================================================================
     but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
   {search_word          ""}
   {rows_per_page        ""}
   {caller          "index"}
   {nome_funz            ""}
   {nome_funz_caller     ""} 
   {receiving_element    ""}
   {last_key             ""}
   {f_stato              ""}
   {f_data_iniz          ""}
   {f_data_fine          ""}
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
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

set link_filter [export_url_vars caller nome_funz f_stato f_data_iniz f_data_fine]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_ente       $coimtgen(flag_ente)
set flag_viario     $coimtgen(flag_viario)

set cod_manutentore [iter_check_uten_manu $id_utente]
set page_title      "Lista Agenda Manutentore"
set context_bar     [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimgage-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cod. impianto"
set extra_par       [list search_word       $search_word \
                          rows_per_page     $rows_per_page \
                          receiving_element $receiving_element \
                          f_stato           $f_stato \
		          f_data_iniz       $f_data_iniz \
                          f_data_fine       $f_data_fine]
set link_aggiungi  ""

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link    "\[export_url_vars cod_opma cod_impianto data_ins last_key nome_funz nome_funz_caller extra_par\]"
set actions "
<td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\" link-button-2\">Selez.</a></td>"
set js_function ""

# imposto la struttura della tabella
if {$flag_ente == "C"} {
    set table_def [list \
            [list actions              "Azioni"          no_sort $actions] \
    	    [list cod_impianto_est     "Cod.imp."        no_sort {l}] \
	    [list stato_ed             "Stato"           no_sort {<td nowrap>$stato_ed</td>}] \
	    [list data_prevista_edit   "Data prev."      no_sort {c}] \
	    [list data_esecuzione_edit "Data esec."      no_sort {c}] \
    	    [list indir                "Indirizzo"       no_sort {l}] \
    	    [list resp                 "Responsabile"    no_sort {l}] \
            [list tel                  "Telefono/Cell."  no_sort {l}] \
            [list not                  "Note"            no_sort {l}] \

    ]
} else {
    set table_def [list \
            [list actions              "Azioni"          no_sort $actions] \
    	    [list cod_impianto_est     "Cod.imp."        no_sort {l}] \
	    [list stato_ed             "Stato"           no_sort {<td nowrap>$stato_ed</td>}] \
	    [list data_prevista_edit   "Data prev."      no_sort {c}] \
	    [list data_esecuzione_edit "Data esec."      no_sort {c}] \
    	    [list comune               "Comune"          no_sort {l}] \
    	    [list indir                "Indirizzo"       no_sort {l}] \
	    [list resp                 "Responsabile"    no_sort {l}] \
            [list tel                  "Telefono/Cell."  no_sort {l}] \
            [list not                  "Note"            no_sort {l}] \

    ]
}

# preparo l'ordinamento
if {$f_stato != "2"} {
    set col_data "a.data_prevista"
} else {
    set col_data "a.data_esecuzione"
}

switch $flag_viario {
    "T" {set col_via "d.descrizione"}
    "F" {set col_via "b.indirizzo" }
}
#set col_numero  "to_number(b.numero,'99999999')"
set col_numero  "lpad(b.numero, 8, '0')"

set ordinamento "order by $col_data desc
                        , c.denominazione
                        , $col_via
                        , $col_numero
                        , b.cod_impianto_est"

if {![string equal $last_key ""]} {
    set data             [lindex $last_key 0]
    set comune           [lindex $last_key 1]
    set via              [lindex $last_key 2]
    set numero           [lindex $last_key 3]
    set cod_impianto_est [lindex $last_key 4]

    if {[string equal $comune ""]} {
	set eq_comune    "is null"
	set or_comune    ""
    } else {
	set eq_comune    "= :comune"
	set or_comune    "or (    $col_data           = :data
                              and (   c.denominazione > :comune
                                   or c.denominazione is null))"
    }

    if {[string equal $via ""]} {
	set eq_via       "is null"
	set or_via       ""
    } else {
	set eq_via       "= :via"
	set or_via       "or (    $col_data        = :data
                              and c.denominazione $eq_comune
                              and (   $col_via     > :via
                                   or $col_via     is null))"
    }

    if {[string equal $numero ""]} {
	set eq_numero    "is null"
	set or_numero    ""
    } else {
	set eq_numero    "= :numero"
	set or_numero    "or (    $col_data        = :data
                              and c.denominazione $eq_comune
                              and $col_via        $eq_via
                              and (   $col_numero  > :numero
                                   or $col_numero  is null))"
    }

    set where_last "and (
                             (    $col_data        = :data
                              and c.denominazione $eq_comune
                              and $col_via        $eq_via
                              and $col_numero     $eq_numero
                              and b.cod_impianto_est > :cod_impianto_est)
                         $or_numero
                         $or_via
                         $or_comune
                          or $col_data            < :data
                        )"
} else {
    set where_last ""
}

# aggiungo le where condition richieste dal filtro
if {![string is space $f_stato]} {
    set where_stato "and a.stato = :f_stato"
} else {
    set where_stato ""
}

if {![string equal $f_data_iniz ""]} {
    if {$f_stato != "2"} {
	set where_data_iniz "and a.data_prevista   >= :f_data_iniz"
    } else {
	set where_data_iniz "and a.data_esecuzione >= :f_data_iniz"
    }
} else {
    set where_data_iniz ""
}

if {![string equal $f_data_fine ""]} {
    if {$f_stato != "2"} {
	set where_data_fine "and a.data_prevista   <= :f_data_fine"
    } else {
	set where_data_fine "and a.data_esecuzione <= :f_data_fine"
    }
} else {
    set where_data_fine ""
}

if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(cod_impianto_est) like upper(:search_word_1)"
}

switch $flag_viario {
    "T" {set sel_gage "sel_gage_si_vie" }
    "F" {set sel_gage "sel_gage_no_vie" }
}

set sel_gage     [db_map $sel_gage]
set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_opma cod_impianto data_ins last_key nome_funz nome_funz_caller extra_par data_prevista data_esecuzione comune via numero cod_impianto_est} go $sel_gage $table_def]

# preparo url escludendo last_gage che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" "last_key"]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    if {$f_stato != "2"} {
	set last_key $data_prevista
    } else {
	set last_key $data_esecuzione
    }

    lappend last_key $comune
    lappend last_key $via
    lappend last_key $numero
    lappend last_key $cod_impianto_est

    append url_vars "&[export_url_vars last_key]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
