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
    ===== ========== =======================================================================
     but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
    {search_word       ""}
    {rows_per_page     ""}
    {caller       "index"}
    {nome_funz         ""}
    {receiving_element ""}
    {last_order        ""}
    {nome_funz_caller  ""}

    {url_manu          ""}
    {cod_manutentore   ""}
    {f_cod_manu        ""}
    {f_data_ril_da     ""}
    {f_data_ril_a      ""}
    {totali_flag       ""}
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
    set id_utente [ad_get_cookie iter_login_[ns_conn location]]
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

# cod_manutentore viene passato solo da coimmanu-gest
# solo in questo caso va fatto vedere nel titolo e
# passato al programma di inserimento
# negli altri casi va valorizzato con null perche' viene 'erroneamente'
# valorizzato dal programma di gestione durante la gestione della form
if {$nome_funz_caller == $nome_funz} {
    set cod_manutentore ""
}

if {![string equal $cod_manutentore ""]} {
    if {[db_0or1row sel_manu ""] == 0} {
	iter_return_complaint "Manutentore non trovato"
    } else {
	set where_manu "and a.cod_manutentore = :cod_manutentore"
	if {$flag_attivo == "N"} {
	    set flag_manu  "N"
	} else {
	    set flag_manu  "S"
	}
    }
} else {
    set cognome    ""
    set nome       ""
    set where_manu ""
    set flag_manu  ""
}

set page_title "Lista Bollini $cognome $nome"

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimboll-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element \
                          url_manu          $url_manu \
                          f_cod_manu        $f_cod_manu \
                          f_data_ril_da     $f_data_ril_a \
                          totali_flag       $totali_flag]

if {$totali_flag != "t"} {
    set link_totali    "<a href=\"coimboll-list?[export_url_vars last_order caller nome_funz extra_par nome_funz_caller f_cod_manu f_data_ril_da f_data_ril_a]&totali_flag=t\">Totali</a>"
} else {
    set link_totali ""
}

if {$flag_manu == "S"} {
    set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars cod_manutentore last_order caller nome_funz nome_funz_caller extra_par ]\">Aggiungi</a>"
} else {
    set link_aggiungi ""
}

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

if {$caller == "index"} {
    set link    "\[export_url_vars cod_manutentore cod_bollini last_order nome_funz extra_par nome_funz_caller\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\" link-button-2\">Selez.</a></td>"
    set js_function ""
} else { 
    set actions [iter_select [list column_name .... ]]
    set receiving_element [split $receiving_element |]
    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_bollini [lindex $receiving_element 1]]]
}

set link_scar       [export_url_vars nome_funz nome_funz_caller f_cod_manu f_data_ril_da f_data_ril_a]
set link_stp        [export_url_vars nome_funz nome_funz_caller f_cod_manu f_data_ril_da f_data_ril_a]
set link_filter     [export_url_vars nome_funz nome_funz_caller]

# imposto la struttura della tabella
set table_def [list \
    [list actions              "Azioni"                 no_sort $actions] \
    [list cod_bollini          "Cod."                   no_sort {l}] \
    [list manutentore          "Manutentore"            no_sort {l}] \
    [list data_consegna_edit   "Data Consegna"          no_sort {c}] \
    [list tipologia            "Tipologia"              no_sort {c}] \
    [list nr_bollini_edit      "Nr."                    no_sort {r}] \
    [list nr_bollini_resi_edit "Resi"                   no_sort {r}] \
    [list matricola_da         "Matr. inizio"           no_sort {l}] \
    [list matricola_a          "Matr. fine"             no_sort {l}] \
    [list descr_tpbo           "Tipo"                   no_sort {l}] \
    [list costo_unitario       "Costo Un."              no_sort {r}] \
    [list pagati               "Pagati"                 no_sort {c}] \
    [list importo              "Importo Dovuto"         no_sort {r}] \
    [list imp_pagato           "Importo Pagato"         no_sort {r}] \
    [list num_fatt             "Fatt"                   no_sort {r}] \

]

# imposto la query SQL 
if {![string equal $f_cod_manu ""]} {
    set where_f_manu     "and a.cod_manutentore = :f_cod_manu"
    set where_manu_count "and cod_manutentore = :f_cod_manu"
} else {
    set where_f_manu     ""
    set where_manu_count ""
}

if {![string equal $f_data_ril_da ""]} {
    set where_data_da       "and a.data_consegna >= :f_data_ril_da"
    set where_data_da_count "and data_consegna >= :f_data_ril_da"
} else {
    set where_data_da       ""
    set where_data_da_count ""
}

if {![string equal $f_data_ril_a ""]} {
    set where_data_a        "and a.data_consegna <= :f_data_ril_a"
    set where_data_a_count  "and data_consegna <= :f_data_ril_a"
} else {
    set where_data_a        ""
    set where_data_a_count  ""
}

# imposto la condizione per la prossima pagina
if {![string is space $last_order]} {
    set data_consegna [lindex $last_order 0]
    set cod_bollini   [lindex $last_order 1]
    set where_last " and ((data_consegna     = :data_consegna   and
                           cod_bollini      <= :cod_bollini)
                      or   data_consegna    <  :data_consegna)"
} else {
    set where_last ""
}

if {$totali_flag == "t"} {
    # estraggo il numero dei record estratti
    db_1row sel_boll_sum ""
    set link_totali "
    <table>
    <tr><td align=left>Blocchetti selezionati:</td>
        <td align=right><b>$conta_records</b></td>
    </tr>
    <tr><td align=left>Importo totale dovuto:</td>
        <td align=right><b>$tot_imp_boll</b></td>
    </tr>
    <tr><td align=left>Importo totale pagato:</td>
        <td align=right><b>$tot_imp_pagato</b></td>
    </tr>
    </table>"
}

set sql_query [db_map sel_boll]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_bollini last_order nome_funz nome_funz_caller extra_par cod_manutentore data_consegna} go $sql_query $table_def]

# preparo url escludendo last_order che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_order]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    # assegna l'order by per la lista
    set last_order [list  $data_consegna $cod_bollini]
    append url_vars "&[export_url_vars  last_order]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

if {$flag_manu == "S"} {
    # creo testata della lista
    set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
                  $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]
} else {
    # creo testata della lista
    set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
                  $link_totali $link_altre_pagine $link_righe "Righe per pagina"]
}

db_release_unused_handles
ad_return_template 
