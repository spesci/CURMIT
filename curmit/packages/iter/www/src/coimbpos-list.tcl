ad_page_contract {
    Lista tabella "coimbpos"

    @author                  Simone Pesci
    @creation-date           07/07/2014

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  

    @param caller            se diverso da index rappresenta il nome del form da cui e' partita
    @                        la ricerca ed in questo caso imposta solo azione "sel"

    @param nome_funz         identifica l'entrata di menu, serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu, serve per la navigation bar

    @param receiving_element nomi dei campi di form che riceveranno gli argomenti restituiti
    @                        dallo script di zoom, separati da '|'.

    @cvs-id coimbpos-list.tcl 
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 19/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} {
    {search_word             ""}
    {rows_per_page           ""}
    {caller             "index"}
    {nome_funz               ""}
    {nome_funz_caller        ""} 
    {receiving_element       ""}
    {last_cod_bpos           ""}

    {f_data_controllo_da     ""}
    {f_data_controllo_a      ""}
    {f_data_emissione_da     ""}
    {f_data_emissione_a      ""}
    {f_data_scarico_da       ""}
    {f_data_scarico_a        ""}
    {f_data_pagamento_da     ""}
    {f_data_pagamento_a      ""}
    {f_flag_pagati           ""}
    {f_quinto_campo          ""} 
    {f_resp_cogn             ""}
    {f_resp_nome             ""}
    {f_cod_impianto_est      ""}
    {f_stato                 ""}

    {flag_totali            ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# Controlla lo user
#if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#} else {
    # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
#   Per ora, non contemplo questo caso.
#    set id_utente [iter_get_id_utente]
#    if {$id_utente  == ""} {
#	set login [ad_conn package_url]
#	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    }
#}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set page_title  "Lista Bollettini Postali"
set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimbpos-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome Responsabile"
set extra_par       [list search_word         $search_word \
			  rows_per_page       $rows_per_page \
			  f_data_controllo_da $f_data_controllo_da \
			  f_data_controllo_a  $f_data_controllo_a \
			  f_data_emissione_da $f_data_emissione_da \
			  f_data_emissione_a  $f_data_emissione_a \
		          f_data_scarico_da   $f_data_scarico_da \
			  f_data_scarico_a    $f_data_scarico_a \
                          f_data_pagamento_da $f_data_pagamento_da \
                          f_data_pagamento_a  $f_data_pagamento_a \
                          f_flag_pagati       $f_flag_pagati \
                          f_quinto_campo      $f_quinto_campo \
                          f_resp_cogn         $f_resp_cogn \
                          f_resp_nome         $f_resp_nome \
                          f_cod_impianto_est  $f_cod_impianto_est \
                          f_stato             $f_stato \
			  flag_totali         $flag_totali \
		          receiving_element   $receiving_element
		    ]

if {$flag_totali != "t"} {
    set link_totali    "<a href=\"$curr_prog?flag_totali=t&[export_ns_set_vars url flag_totali]\">Totali</a>"
} else {
    set link_totali ""
}

set link_scarica    [export_ns_set_vars url]
set link_stampa     $link_scarica
set link_filter     $link_scarica
set link_aggiungi   ""
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link    "\[export_url_vars cod_bpos last_cod_bpos nome_funz nome_funz_caller extra_par\]"
set actions "<td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\" link-button-2\">Selez.</a></td>"
set js_function ""

# imposto la struttura della tabella
set table_def [list \
		   [list actions             "Azioni"            no_sort $actions] \
		   [list data_emissione_edit "Data estraz."      no_sort      {c}] \
		   [list quinto_campo        "5&deg; campo"      no_sort      {l}] \
		   [list cod_impianto_est    "Cod.Imp."          no_sort      {l}] \
		   [list nominativo_resp     "Responsabile"      no_sort      {l}] \
		   [list data_verifica_edit  "Data appunt."      no_sort      {c}] \
		   [list importo_emesso_edit "Imp. da pagare"    no_sort      {r}] \
		   [list importo_pagato_edit "Imp. pagato"       no_sort      {r}] \
		   [list data_pagamento_edit "Data pag."         no_sort      {c}] \
		   [list stato               "Stato"             no_sort      {l}] \
		  ]

# imposto la query SQL 
if {![string equal $search_word ""]} {
    set f_resp_nome ""
} else {
    if {![string equal $f_resp_cogn ""]} {
        set search_word $f_resp_cogn
    }
}

if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and coimcitt.cognome like upper(:search_word_1)"
}

if {[string equal $f_resp_nome ""]} {
    set where_nome ""
} else {
    set f_resp_nome_1 [iter_search_word $f_resp_nome]
    set where_nome  " and coimcitt.nome    like upper(:f_resp_nome_1)"
}

# imposto filtro per le date
if {![string equal $f_data_controllo_da ""] || ![string equal $f_data_controllo_a ""]} {
    if {[string equal $f_data_controllo_da ""]} {
	set f_data_controllo_da "18000101"
    }
    if {[string equal $f_data_controllo_a  ""]} {
	set f_data_controllo_a  "21001231"
    }
    set where_data_controllo    " and coiminco.data_verifica between :f_data_controllo_da
                                                                 and :f_data_controllo_a"
} else {
    set where_data_controllo ""
}

if {![string equal $f_data_emissione_da ""] || ![string equal $f_data_emissione_a ""]} {
    if {[string equal $f_data_emissione_da ""]} {
	set f_data_emissione_da "18000101"
    }
    if {[string equal $f_data_emissione_a ""]} {
	set f_data_emissione_a  "21001231"
    }
    set where_data_emissione    " and coimbpos.data_emissione between :f_data_emissione_da
                                                                  and :f_data_emissione_a"
} else {
    set where_data_emissione    ""
}

if {![string equal $f_data_scarico_da ""] || ![string equal $f_data_scarico_a ""]} {
    if {[string equal $f_data_scarico_da ""]} {
	set f_data_scarico_da "18000101"
    }
    if {[string equal $f_data_scarico_a ""]} {
	set f_data_scarico_a  "21001231"
    }
    set where_data_scarico    " and coimbpos.data_scarico between :f_data_scarico_da
                                                           and :f_data_scarico_a"
} else {
    set where_data_scarico    ""
}

if {![string equal $f_data_pagamento_da ""] || ![string equal $f_data_pagamento_a ""]} {
    if {[string equal $f_data_pagamento_da ""]} {
	set f_data_pagamento_da "18000101"
    }
    if {[string equal $f_data_pagamento_a ""]} {
	set f_data_pagamento_a  "21001231"
    }
    set where_data_pagamento    " and coimbpos.data_pagamento between :f_data_pagamento_da
                                                                  and :f_data_pagamento_a"
} else {
    set where_data_pagamento    ""
}

if {![string equal $f_flag_pagati ""]} {
    if {[string equal $f_flag_pagati "S"]} {
	set where_pagati " and coimbpos.importo_pagato  > 0"
    }
    if {[string equal $f_flag_pagati "N"]} {
	set where_pagati " and coimbpos.importo_pagato <= 0"
    }
} else {
    set where_pagati ""
}

if {![string equal $f_quinto_campo ""]} {
    set where_quinto_campo "and coimbpos.quinto_campo = :f_quinto_campo"
} else {
    set where_quinto_campo ""
}

# I filtri su f_resp_cogn e f_resp_nome sono gia' stati impostati prima

if {![string equal $f_cod_impianto_est ""]} {
    set where_codimp_est " and coimaimp.cod_impianto_est = upper(:f_cod_impianto_est)"
} else {
    set where_codimp_est ""
}

if {![string equal $f_stato ""]} {
    set where_stato      " and coimbpos.stato = :f_stato"
} else {
    set where_stato      ""
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_bpos]} {
    set last_data_emissione [lindex $last_cod_bpos 0]
    set last_quinto_campo   [lindex $last_cod_bpos 1]
    # l'ordinamento e' descending e quindi uso < al posto di >
    set where_last " and (   (    coimbpos.data_emissione  = :last_data_emissione
                              and coimbpos.quinto_campo   <= :last_quinto_campo)
                          or      coimbpos.data_emissione <  :last_data_emissione
                         )"
} else {
    set where_last ""
}

if {$flag_totali == "t"} {
    # estraggo il numero dei record estratti
    db_1row sel_bpos_sum ""
    set link_totali "
    <table>
      <tr><td>Bollettini selezionati:</td><td align=right><b>$num_bpos</b></td></tr>
      <tr><td>Tot. imp. da pagare:   </td><td align=right><b>$tot_importo_emesso</b></td></tr>
      <tr><td>Tot. imp. pagato:      </td><td align=right><b>$tot_importo_pagato</b></td></tr>
    </table>"
}

set sel_bpos [db_map sel_bpos]
set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_bpos last_cod_bpos nome_funz nome_funz_caller extra_par data_emissione quinto_campo} go $sel_bpos $table_def]

# preparo url escludendo last_cod_bpos che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars          [export_ns_set_vars "url" last_cod_bpos]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_bpos [list $data_emissione $quinto_campo]
    append url_vars          "&[export_url_vars last_cod_bpos]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head \
		   $form_di_ricerca $col_di_ricerca \
		   $link_totali     $link_altre_pagine \
		   $link_righe      "Righe per pagina"]

db_release_unused_handles
ad_return_template 
