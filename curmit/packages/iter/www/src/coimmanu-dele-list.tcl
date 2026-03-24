ad_page_contract {
    Lista tabella "coimmanu"

    @author                  Riccardo Vesentini
    @creation-date           25/09/2025

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

    @cvs-id coimmanu-dele-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 27/01/2026 Corretto where_last e aggiunto campi cognome e cod_manu_dele per gestire la
    ric01            paginazione, andava in errore se il numero di righe era maggiore del numero
    ric01            di righe impostato per l'utente.
    
} {
    {cod_manu_dele ""}
    {rag_sociale_delegato ""}
    {search_word       ""}
    {rows_per_page     ""}
    {caller            "index"}
    {nome_funz         ""}
    {receiving_element ""}
    {last_cognome      ""}
    {nome_funz_caller  ""}
    {cod_manutentore   ""}
    {flag_valor_cod ""}
    {f_cognome ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}


#set receiving_element "rag_sociale_delegato|cod_manu_dele|cod_manutentore"
set javascript_sel "";#gac01

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

# reperisco i dati generali
iter_get_coimtgen

db_1row sel_tgen_portafoglio "select flag_portafoglio
                                   , flag_visualizza_ec --gab01 
                                from coimtgen"

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_filter [export_url_vars caller nome_funz receiving_element ]
set link_scar   [export_url_vars nome_funz nome_funz_caller ]
set page_title      "Lista ditte installazione"


if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimmanu-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome"
set extra_par       [list rows_per_page     $rows_per_page \
			 receiving_element  receiving_element]
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link "\[export_url_vars cod_manutentore cod_manu_dele rag_sociale_delegato nome_funz extra_par receiving_element \]"
set actions "<td nowrap><a href=\"coimmanu-dele-list?$link&caller=$caller\"class=\"link-button-2\">Selez.</a></td>"
set receiving_element [split $receiving_element |]

set js_function [iter_selected $caller [list [lindex $receiving_element 0]  rag_sociale_delegato [lindex $receiving_element 1] cod_manu_dele]]
set javascript_sel "
 window.opener.document.coimdimp.submit.click();"

set actions [iter_select [list rag_sociale_delegato cod_manu_dele]]

    # imposto la struttura della tabella
    set table_def [list \
		       [list actions                      "Azioni"                 no_sort $actions] \
		       [list cod_manu_dele              "Cod."                   no_sort {l}] \
		       [list rag_sociale_delegato         "Ditta installazione"    no_sort {l}] \
		      ]

    # imposto la query SQL 
    if {![string equal $search_word ""]} {
	set f_nome ""
    } else {
	if {![string equal $f_cognome ""]} {
	    set search_word $f_cognome
	}
    }
    
    if {[string equal $search_word ""]} {
	set where_word ""
    } else {
	set search_word_1 [iter_search_word $search_word]
	set where_word  " and upper(a.cognome) like upper(:search_word_1)"
    }
    
  
    # imposto la condizione per la prossima pagina
    if {![string is space $last_cognome]} {
	set cognome         [lindex $last_cognome 0]
	set cod_manu        [lindex $last_cognome 1]
	#ric01 corretto parentesi 
	set where_last "and (  upper(a.cognome) > upper(:cognome)
                            or upper(a.cognome) = upper(:cognome))
                           and  a.cod_manutentore >= :cod_manu"
    } else {
	set where_last ""
    }   
    
    set sql_query [db_map sel_manu]

#ric01 aggiunto cognome cod_manu_dele a Textra_vars
set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_manutentore cognome cod_manu_dele extra_par} go $sql_query $table_def]

    # preparo url escludendo last_cognome che viene passato esplicitamente
    # per poi preparare il link alla prima ed eventualmente alla prossima pagina
    set url_vars [export_ns_set_vars "url" last_cognome]
    set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"
    
# preparo link a pagina successiva
    set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
    if {$ctr_rec == $rows_per_page} {
	#ric01  set last_cognome [list  $cognome $cod_manutentore]
	set last_cognome [list  $cognome $cod_manu_dele];#ric01 
	append url_vars "&[export_url_vars last_cognome]"
	append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
    }
    
    # creo testata della lista
    set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
		      "" $link_altre_pagine $link_righe "Righe per pagina"]

    set link_gest [export_url_vars f_cod_manutentore f_cognome f_nome f_ruolo f_convenzionato f_stato nome_funz nome_funz_caller]
    set return_url "coimfatt-csv?$link_gest"    


db_release_unused_handles
ad_return_template 
