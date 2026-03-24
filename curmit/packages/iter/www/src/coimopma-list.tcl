ad_page_contract {
    Lista tabella "coimopma"

    @author                  Adhoc
    @creation-date           29/04/2004

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

    @cvs-id coimopma-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    but01 01/10/2024 Aggiunto il campo email_operator nella lista.
    
    sim01 11/10/2019 Tolto la possibilità di aggiungere gli operatori perchè deve essere fatto dal portale

} { 
    {search_word       ""}
    {rows_per_page     ""}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""} 
    {receiving_element ""}
    {cod_manutentore   ""}
    {last_cod_opma     ""}
    {fstato            ""}
    {url_manu          ""}
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

set page_title      "Lista manutentori"

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Ritorna"] \
                    "$page_title"]
}

if {[db_0or1row sel_manu ""] == 0} {
    if {$caller != "index"} {
	iter_return_complaint "Ditta manutentrice non selezionato, <a href=\"javascript:window.close()\">Ritorna</a>"
    } else {
	iter_return_complaint "Ditta manutentrice non trovato"
    }
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimopma-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars cod_manutentore last_cod_opma caller nome_funz extra_par nome_funz_caller url_manu]\">Aggiungi</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link_aggiungi "";#sim01

if {$caller == "index"} {
    set link    "\[export_url_vars extra_par cod_manutentore cod_opma last_cod_opma nome_funz nome_funz_caller url_manu\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\">Selez.</a></td>"
    set js_function ""
} else { 
    set actions [iter_select [list cod_manutentore cod_opma nome cognome]]
    set receiving_element [split $receiving_element |]
    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_manutentore [lindex $receiving_element 1] cod_opma [lindex $receiving_element 2] nome [lindex $receiving_element 3] cognome ]]
}

# imposto la struttura della tabella
#but01 aggiunto il campo email_operator nella lista.

set table_def [list \
        [list actions    "Azioni"    no_sort $actions] \
    	[list cod_opma   "Cod."      no_sort      {r}] \
	[list cognome    "Cognome"   no_sort      {l}] \
	[list nome       "Nome"      no_sort      {l}] \
	[list matricola  "Matricola" no_sort      {l}] \
	[list email_operator  "Email" no_sort     {l}] \
	[list desc_stato "Stato"     no_sort      {l}] \
]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(cognome) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_opma]} {
    set where_last " and cod_opma >= :last_cod_opma"
} else {
    set where_last ""
}

# imposto la condizione per stato sf17112016
if {![string is space $fstato]} {
    set where_stato " and coalesce(stato,'0') = :fstato"
} else {
    set where_stato ""
}

set sel_opma [db_map sel_opma]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_manutentore cod_opma last_cod_opma nome_funz nome_funz_caller extra_par url_manu} go $sel_opma $table_def]

# preparo url escludendo last_cod_opma che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_opma]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_opma $cod_opma
    append url_vars "&[export_url_vars last_cod_opma]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
