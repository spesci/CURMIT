ad_page_contract {
    Lista tabella "coimboll"

    @author                  Katia Coazzoli Adhoc
    @creation-date           08/03/2004

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

    @cvs-id coimboll-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
     but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"
    rom02 02/12/2020 Modifico le if sulle Provincie di UCIT mettendo la condizione sulla Regione
    rom02            Friuli  perche' il Comune di Trieste passera' sotto UCIT da inizio 2021.

    rom01 17/03/2020 Aggiunto il parametro call_manu. Se il parameto vale f allora devo
    rom01            escludere dalla lista i record che sono associati al manutenore fittizio.
    rom01            Al contrario, se il parametro vale t allora devo visualizzare solo i record
    rom01            associati al manutentore fittizio. Tutto viene fatto solo per UCIT.

} { 
    {search_word       ""}
    {rows_per_page     ""}
    {caller       "index"}
    {nome_funz         ""}
    {receiving_element ""}
    {last_order        ""}
    {nome_funz_caller  ""}

    {url_manu          ""}
    {cod_bollini       ""}
    {call_manu        "f"}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

set last_order ""
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

iter_get_coimtgen ;#rom01

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# leggo bollini
db_1row sel_boll ""

if {[string equal $call_manu "t"]} {#rom01 aggiunta if e suo contenuto, aggiunta else ma non contenuto
    set page_title "Bollini resi di $manutentore, da $matricola_da a $matricola_a, consegnati il $data_consegna_edit"
} else {
    set page_title "Trasferimento Bollini di $manutentore, da $matricola_da a $matricola_a, consegnati il $data_consegna_edit"
}


if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimboap-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
set extra_par       [list rows_per_page     $rows_per_page \
			 receiving_element $receiving_element]

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set rows_per_page 999999
#rom01set link_aggiungi  "<a href=\"$gest_prog?funzione=I&[export_url_vars cod_bollini caller nome_funz extra_par nome_funz_caller]\">Aggiungi trasferimento</a>"
if {[string equal $call_manu "t"]} {#rom01 aggiunte if, else e loro contenuto
    set link_aggiungi_title "Aggiungi Bollini Resi"
} else {
    set link_aggiungi_title "Aggiungi trasferimento"
}
set link_aggiungi  "<a href=\"$gest_prog?funzione=I&[export_url_vars cod_bollini caller nome_funz extra_par nome_funz_caller call_manu]\">$link_aggiungi_title</a>";#rom01

set link_righe      [iter_rows_per_page     $rows_per_page]

if {$caller == "index"} {
    set link    "\[export_url_vars cod_boap cod_bollini nome_funz extra_par nome_funz_caller\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link&call_manu=$call_manu\" class=\" link-button-2\">Selez.</a></td>"
    set js_function ""
} else { 
    set actions [iter_select [list column_name .... ]]
    set receiving_element [split $receiving_element |]
    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_boap [lindex $receiving_element 1]]]
}

set link_scar       [export_url_vars nome_funz nome_funz_caller f_cod_manu f_data_ril_da f_data_ril_a]
set link_stp        [export_url_vars nome_funz nome_funz_caller f_cod_manu f_data_ril_da f_data_ril_a]
set link_filter     [export_url_vars nome_funz nome_funz_caller]

# imposto la struttura della tabella
set table_def [list \
    [list actions              "Azioni"                 no_sort $actions] \
    [list cod_boap             "Cod."                   no_sort {l}] \
    [list manutentore_a        "Al Manutentore"         no_sort {l}] \
    [list nr_bollini_edit      "Nr."                    no_sort {r}] \
    [list matr_da              "Matr. inizio"           no_sort {l}] \
    [list matr_a               "Matr. fine"             no_sort {l}] \
    [list note                 "Note"                   no_sort {l}] \

]


# imposto la condizione per la prossima pagina
if {![string is space $last_order]} {
    set data_consegna [lindex $last_order 0]
    set cod_bollini   [lindex $last_order 1]
    set where_last " and ((data_consegna     = :data_consegna   and
                           cod_bollini      >= :cod_bollini)
                      or   data_consegna    >  :data_consegna)"
} else {
    set where_last ""
}

set where_a_cod_manutentore "";#rom01
#rom02if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PTS" || $coimtgen(ente) eq "PGO" || $coimtgen(ente) eq "PPN"} {}#rom01 aggiunta if e suo contenuto
if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom02 Aggiunta if ma non il contenuto
    if {[string equal $call_manu "t"]} {
	set where_a_cod_manutentore "and a.cod_manutentore_a = 'MAXXXXXX'"
    } else {
	set where_a_cod_manutentore "and a.cod_manutentore_a != 'MAXXXXXX'"
    }
}

set sql_query [db_map sel_boap]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_bollini last_order nome_funz nome_funz_caller extra_par} go $sql_query $table_def]

# preparo url escludendo last_order che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_order]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"
set link_altre_pagine ""

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    # assegna l'order by per la lista
    set last_order [list  $data_consegna $cod_bollini]
    append url_vars "&[export_url_vars  last_order]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
