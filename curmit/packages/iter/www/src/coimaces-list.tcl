ad_page_contract {
    Lista tabella "coimaces"

    @author                  Adhoc
    @creation-date           Katia Coazzoli 11/05/2004

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

    @cvs-id coimaces-list.tcl 
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 19/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
   {search_word        ""}
   {rows_per_page      ""}
   {caller        "index"}
   {nome_funz          ""}
   {nome_funz_caller   ""} 
   {receiving_element  ""}
   {last_cod_aces      ""}
   {f_cod_aces_est     ""}
   {f_cod_acts         ""}
   {f_natura_giuridica ""}
   {f_cognome          ""}
   {f_cod_combustibile ""}
   {f_stato            ""}
   {f_comune           ""}
   {f_indirizzo        ""}
   {f_desc_topo        ""}
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
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


set url_coimaces_list    [list [ad_conn url]?[export_ns_set_vars url]]


# preparo link per ritorna al filtro:
set link_filter [export_url_vars caller nome_funz receiving_element]


set page_title      "Lista impianti acquisiti esternamente"
set context_bar     [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   ""
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set url_list_aimp   [list [ad_conn url]?[export_ns_set_vars url]]
set flag_call      "uten"
set link           "\[export_url_vars cod_aces last_cod_aces nome_funz nome_funz_caller url_coimaces_list flag_call stato_01\]"
#but01
set actions        "<td nowrap><a href=\"coimaimp-aces-list?$link\" class=\" link-button-2\">Selez.</a></td>"
set js_function     ""

# imposto la struttura della tabella
set table_def [list \
        [list actions            "Azioni"           no_sort $actions] \
	[list cod_aces_est       "utenza"           no_sort {l}] \
	[list nominativo         "Nominativo"       no_sort {l}] \
	[list indirizzo_num      "Indirizzo"        no_sort {l}] \
	[list comune             "Comune"           no_sort {l}] \
	[list provincia          "Prov"             no_sort {l}] \
	[list descr_comb         "Combustibile"     no_sort {l}] \
	[list stato              "Stato"            no_sort {l}] \
]

# imposto la query SQL 

if {![string equal $f_cod_aces_est ""]} {
    set where_cod_aces " and a.cod_aces_est = :f_cod_aces_est"
} else {
    set where_cod_aces ""
}

if {![string equal $f_cod_acts ""]} {
    set where_cod_acts " and a.cod_acts = :f_cod_acts"
} else {
    set where_cod_acts ""
}

if {![string equal $f_natura_giuridica ""]} {
    set where_nat_giur " and upper(a.natura_giuridica) = upper(:f_natura_giuridica)"
} else {
    set where_nat_giur ""
}

if {![string equal $f_cod_combustibile ""]} {
    set where_cod_comb " and b.cod_combustibile = :f_cod_combustibile"
} else {
    set where_cod_comb ""
}

if {![string equal $f_indirizzo ""]} {
    set where_via " and a.indirizzo like :f_indirizzo"
} else {
    set where_via ""
}

if {![string equal $f_comune ""]} {
    db_0or1row sel_comu ""
    set where_comune " and a.comune = :denom_comune"
} else {
    set where_comune ""
}

if {![string equal $f_stato ""]} {
    set where_stato " and upper(a.stato_01) = upper(:f_stato)"
} else {
    set where_stato ""
}
if {![string equal $f_cognome ""]} {
    set  f_cognome_1 [iter_search_word $f_cognome]
    set where_cognome " and a.cognome like upper(:f_cognome_1)"
 } else {
    set where_cognome ""
}

if { [string equal $search_word ""]
&&  ![string equal $f_cognome ""]
} {
    set search_word $f_cognome 
}

if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(cognome) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_aces]} {
    set comune          [lindex $last_cod_aces 0]
    set indirizzo       [lindex $last_cod_aces 1]
    set cognome         [lindex $last_cod_aces 2]
    set cod_aces        [lindex $last_cod_aces 3]
    set where_last " and ((upper(comune)     = upper(:comune)     and
                           upper(indirizzo)  = upper(:indirizzo)  and
                           upper(cognome)    = upper(:cognome)    and
                           cod_aces         >= :cod_aces) 
                       or (upper(comune)     = upper(:comune)     and
                           upper(indirizzo)  = upper(:indirizzo)  and
                           upper(cognome)   >  upper(:cognome))
                       or (upper(comune)     = upper(:comune)     and
                           upper(indirizzo) >  upper(:indirizzo)) 
                       or  upper(comune)    >  upper(:comune))"
} else {
    set where_last ""
} 

set stato_acts "E"

#ns_return 200 text/html "$stato_acts $f_cod_acts $where_last $f_stato $denom_comune
#$where_word
#$where_cod_aces
#$where_cod_acts
#$where_nat_giur
#$where_cod_comb
#$where_stato
#$where_via
#$where_comune
#$where_cognome "; return
set sel_aces [db_map sel_aces]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_aces cod_acts last_cod_aces f_cod_aces_est f_cod_acts f_natura_giuridica f_cognome f_cod_combustibile f_stato comune indirizzo cognome flag_call url_coimaces_list nome_funz nome_funz_caller extra_par} go $sel_aces $table_def]

# preparo url escludendo last_cod_aces che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_aces]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_aces [list  $comune $indirizzo $cognome $cod_aces]
    append url_vars "&[export_url_vars last_cod_aces]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
