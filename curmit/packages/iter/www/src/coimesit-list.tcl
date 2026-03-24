ad_page_contract {
    Lista tabella "coimesit"

    @author                  Adhoc
    @creation-date           11/08/2004

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

    @cvs-id coimesit-list.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""} 
   {receiving_element ""}
   {last_key          ""}
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

# controllo se l'utente e' un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {$nome_funz == $nome_funz_caller} {
    set link_head ""
} else {
    # preparo i link di testata della pagina per consultazione coda lavori
    set link_head [iter_links_batc $nome_funz $nome_funz_caller $search_word]
}

set page_title      "Consultazione lavori terminati"

#if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar [iter_context_bar \
#                    [list "javascript:window.close()" "Torna alla Gestione"] \
#                    "$page_title"]
#}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog        [file tail [ns_conn url]]
set gest_prog        "coimesit-gest"
set form_di_ricerca  [iter_search_form $curr_prog $search_word]
set col_di_ricerca   "Lavoro"
set extra_par        [list rows_per_page     $rows_per_page \
                           search_word       $search_word \
                           receiving_element $receiving_element]
set current_datetime "[iter_edit_date [iter_set_sysdate]] [iter_set_systime -second]"
set link_aggiorna    "$current_datetime <a href=\"$curr_prog?[export_ns_set_vars url]\">Aggiorna pagina</a>"
set rows_per_page    [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe       [iter_rows_per_page     $rows_per_page]

#if {$caller == "index"} {
    set link    "\[export_url_vars cod_batc ctr last_key nome_funz nome_funz_caller extra_par\]"
    set msg_alert "Confermi la cancellazione?"
    set cmd_conf  [list "javascript:return(confirm('$msg_alert'))"]

    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=D&$link\" onclick=\"$cmd_conf\" class=\"link-button-2\">Canc.</a></td>"
    set js_function ""
#} else { 
#    set actions [iter_select [list column_name .... ]]
#    set receiving_element [split $receiving_element |]
#    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  column_name1 [lindex $receiving_element 1]  column_name2 .... .... ]]
#}

set link_scar {
    [if {![string equal $esit_url ""]
     &&  ![string equal $esit_nom ""]
     } {
	return "<td><a target=\"$esit_nom\" href=\"$esit_url\">$esit_nom</a></td>"
    } else {
	return "<td>$esit_nom</td>"
    }]
}

# imposto la struttura della tabella
set table_def [list \
        [list actions       "Azioni"          no_sort $actions] \
	[list nom           "Lavoro"          no_sort {l}] \
	[list link_scar     "File"            no_sort $link_scar] \
	[list flg_stat_edit "Stato"           no_sort {l}] \
	[list tim_iniz_edit "Data/Ora inizio" no_sort {c}] \
	[list tim_fine_edit "Data/Ora fine"   no_sort {c}] \
    	[list cod_batc      "Codice"          no_sort {r}] \
	[list cod_uten_sch  "Utente"          no_sort {l}] \
]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(a.nom) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_key]} {
    set dat_fine [lindex $last_key 0]
    set ora_fine [lindex $last_key 1]
    set cod_batc [lindex $last_key 2]
    set ctr      [lindex $last_key 3]

    if {![string equal $ctr ""]} {
	set ge_ctr ">= :ctr"
    } else {
	set ge_ctr "is null"
    }

    set where_last " and (
                             (    a.dat_fine  = :dat_fine
                              and a.ora_fine  = :ora_fine
                              and a.cod_batc  = :cod_batc
                              and b.ctr     $ge_ctr
                             )
                          or   
                             (    a.dat_fine  = :dat_fine
                              and a.ora_fine  = :ora_fine
                              and a.cod_batc  < :cod_batc
                             )
                          or (    a.dat_fine  = :dat_fine
                              and a.ora_fine  < :ora_fine
                             )
                          or      a.dat_fine  < :dat_fine
                         )"
} else {
    set where_last ""
}

set where_man ""
if {![string equal $cod_manutentore ""]} {
    set where_man "and a.cod_uten_sch = :id_utente"
}

set sel_batc     [db_map sel_batc]
set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun lavoro trovato." -Textra_vars {cod_batc dat_fine ora_fine ctr last_key nome_funz nome_funz_caller extra_par} go $sel_batc $table_def]

# preparo url escludendo last_key che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_key]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_key [list $dat_fine $ora_fine $cod_batc $ctr]
    append url_vars "&[export_url_vars last_key]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head $form_di_ricerca $col_di_ricerca \
              $link_aggiorna  $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
