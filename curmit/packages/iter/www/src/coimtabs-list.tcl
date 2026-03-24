ad_page_contract {
    Lista tabella coimtabs (dob 2013)

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"


} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {receiving_element ""}
   {last_cod_cost ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}
#if {![string is space $nome_funz]} {
#    set lvl        1
#    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#} else {
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
     set id_utente [iter_get_id_utente]
#}

set page_title      "Tabella COIMTABS"

set context_bar [iter_context_bar -nome_funz $nome_funz]


# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimtabs-gest"

set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "nome_tabella"
set extra_par       [list rows_per_page     $rows_per_page]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars caller nome_funz extra_par]\">Aggiungi</a>"

set link    "\[export_url_vars nome_tabella nome_colonna nome_funz extra_par\]"
set actions "
<td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
set js_function ""

# imposto la struttura della tabella
set table_def [list \
        [list actions    "Azioni" no_sort $actions] \
    	[list nome_tabella "Nome tabella"      no_sort {l}] \
	[list nome_colonna "Nome colonna"      no_sort {l}] \
	[list tipo_dato    "Tipo dato"         no_sort {l}] \
	[list dimensione   "Dimensione"        no_sort {l}] \
	[list obbligatorio "Obbligatorio"      no_sort {l}] \
	[list ordinamento  "Ordinamento"       no_sort {l}] \
]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(nome_tabella) like upper(:search_word_1)"
}

set sql_query "
        select nome_tabella,
               nome_colonna,
               tipo_dato,
               dimensione,
               obbligatorio,
               ordinamento
        from   coimtabs
        where  1 = 1 
               $where_word
      order by nome_tabella,ordinamento
"

set table_result [ad_table -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {nome_funz extra_par} go $sql_query $table_def]

# preparo url escludendo last_cod_cost che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url"]
set link_altre_pagine ""

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca $link_aggiungi "" "" ""]

db_release_unused_handles
ad_return_template 

