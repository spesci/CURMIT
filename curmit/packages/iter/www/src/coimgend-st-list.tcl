ad_page_contract {
    Lista tabella "coimgend"

    @author                  Katia Coazzoli Adhoc
    @creation-date           02/04/2004

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

    @cvs-id coimgend-list.tcl

     USER  DATA       MODIFICHE
    ===== ========== =======================================================================
     but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"
} { 
    {search_word       ""}
    {rows_per_page     ""}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""} 
    {receiving_element ""}
    {cod_impianto      ""}
    {st_progressivo    ""} 
    {st_data_validita  ""} 
    {last_gen_prog     ""}
    {url_list_aimp     ""}
    {url_aimp          ""}
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
    set id_utente [ad_get_cookie iter_login_[ns_conn location]]
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


set page_title      "Lista Generatori"


#if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar [iter_context_bar \
#                    [list "javascript:window.close()" "Torna alla Gestione"] \
#                    "$page_title"]
#}

#proc per la navigazione 
set link_tab [iter_links_st_form $cod_impianto $st_progressivo $nome_funz_caller $url_list_aimp $url_aimp $st_data_validita]
set dett_tab [iter_tab_st_form $cod_impianto $st_progressivo]


# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimgend-st-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   ""
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]


#if {$caller == "index"} {
set link    "\[export_url_vars cod_impianto gen_prog st_progressivo st_data_validita last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par\]"
set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\" link-button-2\">Selez.</a></td>"
set js_function ""
#} else { 
#    set actions [iter_select [list column_name .... ]]
#    set receiving_element [split $receiving_element |]
#    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  column_name1 [lindex $receiving_element 1]  column_name2 .... .... ]]
#}


# imposto la struttura della tabella
set table_def [list \
        [list actions             "Azioni"         no_sort $actions] \
    	[list gen_prog_est        "Num"            no_sort {r}] \
	[list descrizione         "Descrizione"    no_sort {l}] \
	[list matricola           "Matricola"      no_sort {l}] \
	[list modello             "Modello"        no_sort {l}] \
	[list descr_cost          "Costruttore"    no_sort {l}] \
	[list descr_comb          "Combustibile"   no_sort {l}] \
	[list data_installaz_edit "Data install"   no_sort {c}] \
	[list flag_attivo         "Attivo"         no_sort {c}] \
]


# imposto la query SQL 

# imposto la condizione per la prossima pagina
if {![string is space $last_gen_prog]} {
    set where_last " and gen_prog_est >= :last_gen_prog"
} else {
    set where_last ""
}

set sel_gend [db_map sel_gend]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_impianto gen_prog st_progressivo st_data_validita gen_prog_est last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par} go $sel_gend $table_def]

# preparo url escludendo last_gen_prog che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_gen_prog]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_gen_prog $gen_prog_est
    append url_vars "&[export_url_vars last_gen_prog]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
