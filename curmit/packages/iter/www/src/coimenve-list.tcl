ad_page_contract {
    Lista tabella "coimenve"

    @author                  Paolo Formizzi Adhoc
    @creation-date           29/04/2004

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

    @cvs-id coimenve-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} {
    {search_word       ""}
    {rows_per_page     ""}
    {caller            "index"}
    {nome_funz         ""}
    {receiving_element ""}
    {last_cod_enve ""}
    {f_ragione_01 ""}
    {nome_funz_caller ""}
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

set page_title      "Lista Enti Verificatori"

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimenve-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_enve caller nome_funz extra_par]\">Aggiungi</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

if {$caller == "index"} {
    set link    "\[export_url_vars cod_enve last_cod_enve nome_funz extra_par\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\"link-button-2\">Selez.</a></td>"
    set js_function ""
} else { 
    set actions [iter_select [list cod_enve ragione_01 ]]
    set receiving_element [split $receiving_element |]
    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_enve [lindex $receiving_element 1]  ragione_01 ]]
}

# imposto la struttura della tabella
set table_def [list \
        [list actions    "Azioni"    no_sort $actions] \
    	[list cod_enve   "Cod."      no_sort {l}] \
	[list ragione_01 "Cognome"   no_sort {l}] \
	[list indirizzo  "Indirizzo" no_sort {l}] \
	[list provincia  "Provincia" no_sort {l}] \
	[list telefono   "Telefono"  no_sort {l}] \
]

# imposto la query SQL 

if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(ragione_01) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_enve]} {
    set where_last " and cod_enve >= :last_cod_enve"
} else {
    set where_last ""
}

if {![string is space $f_ragione_01]} {
    set f_ragione_01_1 [iter_search_word $f_ragione_01]
    set where_ragione_01 " and upper(ragione_01) like upper(:f_ragione_01_1)"
} else {
    set where_ragione_01 ""
}

set sql_query [db_map sel_enve]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_enve last_cod_enve nome_funz extra_par} go $sql_query $table_def]

# preparo url escludendo last_cod_enve che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_enve]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_enve $cod_enve
    append url_vars "&[export_url_vars last_cod_enve]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
