ad_page_contract {
    Lista tabella "coimfatt"

    @author                  Adhoc
    @creation-date           27/10/2005

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

    @cvs-id coimfatt-list.tcl 

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
   {last_cod_fatt      ""}
   {last_data_fatt     ""}
   {f_cognome          ""}
   {f_nome             ""}
   {f_num_fatt         ""}
   {f_da_data_fatt     ""}
   {f_a_data_fatt      ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# TODO: Aggiungere il/i parametro/i necessari a filtrare la query

# Controlla lo user
# TODO: controllare il livello richiesto (5 per programmi dell'amministratore)
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

# TODO: controllare la context bar
set page_title      "Lista fatture"

# TODO: se questo e' un pgm di zoom attivare la seguente if
#if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar [iter_context_bar \
#                    [list "javascript:window.close()" "Torna alla Gestione"] \
#                    "$page_title"]
#}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimfatt-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "cognome"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi  "<a href=\"$gest_prog?funzione=I&tipo_sogg=M&[export_url_vars last_data_fatt last_cod_fatt caller nome_funz extra_par nome_funz_caller]\">Aggiungi fattura manutentore</a><br><a href=\"$gest_prog?funzione=I&tipo_sogg=C&[export_url_vars last_data_fatt last_cod_fatt caller nome_funz extra_par nome_funz_caller]\">Aggiungi fattura cittadino</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

# TODO: se questo e' un pgm di zoom personalizzare opportunamente le chiamate 
# alle proc 'iter_select' e 'iter_selected' e attivare la seguente 'if'
#if {$caller == "index"} {
    set link    "\[export_url_vars data_fatt cod_fatt tipo_sogg last_data_fatt last_cod_fatt nome_funz nome_funz_caller extra_par\]"
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
        [list actions         "Azioni"           no_sort $actions] \
    	[list num_fatt        "Numero fattura"   no_sort {l}] \
    	[list nominativo      "Nominativo"       no_sort {l}] \
	[list imponibile_edit "Imponibile"       no_sort {l}] \
	[list data_fatt_edit  "Data fattura"     no_sort {l}] \
]

# imposto la query SQL 
# TODO: preparare qui eventuali 'where_clause' da inserire nella query

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
    set where_word  " and ( b.cognome  like upper(:search_word_1) or c.cognome like upper(:search_word_1))"
}

if {[string equal $f_nome ""]} {
    set where_nome ""
} else {
    set f_nome_1    [iter_search_word $f_nome]
    set where_nome  " and (b.nome like upper(:f_nome_1) or c.nome like upper(:f_nome_1))"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_fatt]
&&  ![string is space $last_data_fatt]
} {
    set where_last " and (   (     data_fatt = :last_data_fatt
                              and  to_number(cod_fatt, '99999999') >= :last_cod_fatt)
                          or (     data_fatt > :last_data_fatt))"
} else {
    set where_last ""
}

if {![string equal $f_num_fatt ""]} {
    set where_num_fatt "and num_fatt = :f_num_fatt"
} else {
    set where_num_fatt ""
}

if {![string equal $f_da_data_fatt ""]} {
    set where_da_data "and to_char(data_fatt,'yyyymmdd') >= :f_da_data_fatt"
} else {
    set where_da_data ""
}

if {![string equal $f_a_data_fatt ""]} {
    set where_a_data  "and to_char(data_fatt,'yyyymmdd') <= :f_a_data_fatt"
} else {
    set where_a_data  ""
}

set sel_fatt [db_map sel_fatt]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_fatt last_cod_fatt last_data_fatt nome_funz nome_funz_caller extra_par data_fatt} go $sel_fatt $table_def]

# preparo url escludendo last_cod_fatt che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" "last_data_fatt last_cod_fatt"]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"


# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_fatt $cod_fatt
    set last_data_fatt $data_fatt
    append url_vars "&[export_url_vars last_data_fatt last_cod_fatt]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
