ad_page_contract {
    Lista tabella "coimmovi"

    @author                  Paolo Formizzi Adhoc
    @creation-date           07/05/2004

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

    @cvs-id coimmovi-list.tcl 
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
    {last_cod_movi     ""}
    {cod_impianto      ""}
    {url_aimp          ""}
    {url_list_aimp     ""}
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

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set page_title      "Lista Pagamenti"

#if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar [iter_context_bar \
#                    [list "javascript:window.close()" "Torna alla Gestione"] \
#                    "$page_title"]
#}

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog "coimmovi-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cod."
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]

set link_aggiungi   "Aggiungi un <a href=\"coimmovi-gest?funzione=I&flag_pag=P&[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_movi caller nome_funz extra_par nome_funz_caller]\">Pagamento</a>
<br>o aggiungi una <a href=\"coimmovi-gest?funzione=I&flag_pag=S&[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_movi call\
er nome_funz extra_par nome_funz_caller]\">Sanzione</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link    "\[export_url_vars cod_movi cod_impianto url_aimp url_list_aimp last_cod_movi nome_funz nome_funz_caller extra_par\]"
#but01
set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
    set js_function ""

# imposto la struttura della tabella
set table_def [list \
        [list actions          "Azioni"            no_sort $actions] \
    	[list cod_movi         "Cod."              no_sort      {r}] \
 	[list desc_movi        "Causale pagamento" no_sort      {l}] \
	[list desc_pag         "Tipo pagamento"    no_sort      {l}] \
	[list data_scad_edit   "Data scadenza"     no_sort      {c}] \
	[list importo_edit     "Importo"           no_sort      {r}] \
	[list data_pag_edit    "Pagato"            no_sort      {c}] \
]


# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(cod_movi) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_movi]} {
    set where_last " and cod_movi >= :last_cod_movi"
} else {
    set where_last ""
}

set sel_movi [db_map sel_movi]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_movi cod_impianto url_aimp url_list_aimp last_cod_movi nome_funz nome_funz_caller extra_par} go $sel_movi $table_def]

# preparo url escludendo last_cod_movi che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_movi]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_movi $cod_movi
    append url_vars "&[export_url_vars last_cod_movi]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
