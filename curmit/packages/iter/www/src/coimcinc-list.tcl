ad_page_contract {
    Lista tabella "coimcinc"

    @author                  Giulio Laurenzi
    @creation-date           10/02/2004

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

    @cvs-id coimcinc-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez"
    rom01 21/10/2020 Su segnalazione di Salerno modificato page_title per renderlo
    rom01            uguale al nome del menu', Sandro ha detto che va bene per tutti.

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {receiving_element ""}
   {last_cod_cinc ""}
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

#rom01set page_title      "Lista Campagne appuntamenti"
set page_title "Gestione campagne per controllo";#rom01

set context_bar [iter_context_bar -nome_funz $nome_funz]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimcinc-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "descrizione"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cinc caller nome_funz extra_par]\">Aggiungi</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link    "\[export_url_vars cod_cinc last_cod_cinc nome_funz extra_par\]"
set actions "
<td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\"link-button-2\">Selez.</a></td>"
set js_function ""

# imposto la struttura della tabella
set table_def [list \
        [list actions          "Azioni"      no_sort $actions] \
	[list cod_cinc         "Cod."        no_sort {r}] \
	[list descrizione      "Descrizione" no_sort {l}] \
	[list data_inizio_edit "Data inizio" no_sort {c}] \
	[list data_fine_edit   "Data fine"   no_sort {c}] \
	[list desc_stato       "Stato"       no_sort {l}] \
]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(descrizione) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_cinc]} {
    set data_inizio [lindex $last_cod_cinc 0]
    set cod_cinc    [lindex $last_cod_cinc 1]
    set where_last " and(   data_inizio <= :data_inizio
                      or (  data_inizio  = :data_inizio
                        and cod_cinc    >= :cod_cinc)
                     )"
} else {
    set where_last ""
}

set sel_cinc [db_map sel_cinc]


set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_cinc last_cod_cinc nome_funz extra_par data_inizio} go $sel_cinc $table_def]

# preparo url escludendo last_cod_cinc che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_cinc]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_cinc [list $data_inizio $cod_cinc]
    append url_vars "&[export_url_vars last_cod_cinc]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
