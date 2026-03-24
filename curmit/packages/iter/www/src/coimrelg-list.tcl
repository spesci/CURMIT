ad_page_contract {
    Lista tabella "coimrelg" Scheda generale relazione biennale

    @author                  Adhoc
    @creation-date           26/01/2005

    @param search_word       parola da ricercare con una query
    @param rows_per_page     righe per pagina
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

    @cvs-id coimrelg-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""} 
   {receiving_element ""}
   {last_data_rel     ""}
   {last_ente_istat   ""}
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

set page_title      "Lista relazioni biennali"
set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimrelg-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   "<a href=\"$gest_prog?funzione=P&[export_url_vars last_data_rel last_ente_istat caller nome_funz extra_par nome_funz_caller]\">Aggiungi</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link    "\[export_url_vars cod_relg last_data_rel last_ente_istat nome_funz nome_funz_caller extra_par\]"
#but01
set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
set js_function ""

# imposto la struttura della tabella
set table_def [list \
        [list actions            "Azioni"                   no_sort $actions] \
	[list data_rel_edit      "Data relazione"            no_sort {c}] \
	[list ente_istat         "Ente"                      no_sort {l}] \
	[list resp_proc          "Responsabile"              no_sort {l}] \
	[list nimp_tot_stim_ente "N. Imp.<br>stimati"        no_sort {r}] \
	[list ntot_autodic_perv  "N. Auto-<br>dichiarazioni" no_sort {r}] \
	[list nimp_verificati    "N. Imp.<br>verificati"     no_sort {r}] \
	[list nimp_verificati_nc "N. Imp.<br>verificati<br>non conf."  no_sort {r}] \
]

# imposto la query SQL 
# imposto la condizione per la prossima pagina
if {![string is space $last_data_rel]
&&  ![string is space $last_ente_istat]
} {
    set where_last "and (   (     data_rel    = :last_data_rel
                              and ente_istat >= :last_ente_istat)
                         or       data_rel   >  :last_data_rel
                        )"
} else {
    set where_last ""
}

set sel_relg [db_map sel_relg]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Non trovata nessuna relazione biennale." -Textra_vars {data_rel ente_istat last_data_rel last_ente_istat nome_funz nome_funz_caller extra_par} go $sel_relg $table_def]

# preparo url escludendo last_data_rel e last_ente_istat che vengono
# passati esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" "last_data_rel last_ente_istat"]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_data_rel   $data_rel
    set last_ente_istat $ente_istat
    append url_vars "&[export_url_vars last_data_rel last_ente_istat]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
