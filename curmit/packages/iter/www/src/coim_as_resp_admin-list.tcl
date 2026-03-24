ad_page_contract {
    Lista tabella "coim_as_resp"

    @author                  Valentina Catte
    @creation-date           05/06/2008

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

    @cvs-id coim_as_resp-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 19/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""} 
   {receiving_element ""}
   {last_cod_as_resp  ""}
   {cod_impianto      ""}
   {url_aimp          ""}
   {url_list_aimp     ""}
   {f_cognome         ""}
   {f_nome            ""}
   {f_data_inizio     ""}
   {f_data_fine       ""}
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
  # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
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

set page_title      "Lista Modelli H"

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coim_as_resp-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Responsabile"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   ""

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]


set link    "\[export_url_vars cod_as_resp cod_impianto url_list_aimp url_aimp last_cod_as_resp nome_funz_caller extra_par \]"
set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&nome_funz=[iter_get_nomefunz coim_as_resp-gest]&$link\" class=\" link-button-2\">Selez.</a>|<a href=\"coimdimp-ins-list?funzione=V&nome_funz=$nome_funz&$link\">Ricerca</a></td>"
set js_function ""

# imposto la struttura della tabella
set table_def [list \
        [list actions             "Azioni"                  no_sort $actions] \
	[list data_inizio_edit    "Data inizio"             no_sort {c}] \
	[list data_fine_edit      "Data fine"               no_sort {c}] \
	[list desc_manutentore    "Manutentore"             no_sort {l}] \
	[list desc_responsabile   "Terzo Responsabile"      no_sort {l}] \
	[list desc_proprietario   "Proprietario"            no_sort {l}] \
	[list potenza             "Potenza"                 no_sort {c}] \
]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(c.cognome) like upper(:search_word_1)"
    set where_cogn ""
    set where_nome ""
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_as_resp]} {
    set data_controllo [lindex $last_cod_as_resp 0]
    set cod_as_resp       [lindex $last_cod_as_resp 1]
    set where_last " and a.cod_as_resp      >= :cod_as_resp"
} else {
    set where_last ""
}

# imposto filtro per impianto
if {![string is space $cod_impianto]} {
    set where_aimp "and a.cod_impianto = :cod_impianto"
} else {
    set where_aimp "and a.cod_impianto is null"
}

if {![string is space $f_cognome]} {
    set where_cogn "and c.cognome = upper(:f_cognome)"
} else {
    set where_cogn ""
}
if {![string is space $f_nome]} {
    set where_nome "and c.nome = upper(:f_nome)"
} else {
    set where_nome ""
}
if {![string is space $f_data_inizio]} {
    set where_inizio "and a.data_inizio >= :f_data_inizio"
} else {
    set where_inizio ""
}
if {![string is space $f_data_fine]} {
    set where_fine "and a.data_fine >= :f_data_fine"
} else {
    set where_fine ""
}

set sel_as_resp [db_map sel_as_resp]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_as_resp cod_impianto last_cod_as_resp nome_funz nome_funz_caller extra_par url_list_aimp url_aimp flag_tracciato} go $sel_as_resp $table_def]

# preparo url escludendo last_cod_as_resp che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_as_resp]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_as_resp [list data_controllo cod_as_resp]
    append url_vars "&[export_url_vars last_cod_as_resp]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
