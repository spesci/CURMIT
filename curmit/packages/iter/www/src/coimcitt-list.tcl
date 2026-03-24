ad_page_contract {
    Lista tabella "coimcitt"

    @author                  Giulio Laurenzi
    @creation-date           26/02/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  

    @param caller            se diverso da index rappresenta il nome del form da cui e' partita
    @                        la ricerca ed in questo caso imposta solo azione "sel"

    @param nome_funz         identifica l'entrata di menu, serve per le autorizzazioni

    @param receiving_element nomi dei campi di form che riceveranno gli argomenti restituiti
    @                        dallo script di zoom, separati da '|' ed impostarli come segue:

    @cvs-id coimcitt-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

    rom01 01/02/2023 Aggiunta colonna per cod_piva.

    sim02 16/05/2017 Tolto il codice soggetto dalla lista. Richiesto da Reggio calabria ma va
    sim02            bene per tutti.

    sim01 21/11/2014 Se la form è chiamata da un cerca, se necessario deve restituire anche 
    sim01            il codice fiscale.

} {
   {last_concat_key   ""}
   {f_cod_cittadino   ""}
   {f_cognome         ""}
   {f_nome            ""}
   {f_cod_fiscale     ""}
   {f_cod_piva        ""}
   {f_comune          ""}
   {f_stato_citt      ""}
   {flag_ammi         ""}
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {receiving_element ""}
   {conta_flag        ""}
   {flag_ins_manu     ""}
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
#   set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
        return 0
    }
}

# preparo link per ritorna al filtro:
set link_filter [export_url_vars caller nome_funz receiving_element f_cognome f_nome f_cod_fiscale f_cod_cittadino flag_ammi]
set page_title  "Lista Soggetti"

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz]                   
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimcitt-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome"
set extra_par       [list rows_per_page         $rows_per_page \
		 	 receiving_element 	$receiving_element \
			 f_cod_cittadino   	$f_cod_cittadino \
			 f_cognome         	$f_cognome \
			 f_nome            	$f_nome \
			 f_cod_fiscale     	$f_cod_fiscale \
			 f_cod_piva        	$f_cod_piva \
			 f_comune          	$f_comune \
			 f_stato_citt      	$f_stato_citt \
			 flag_ammi		$flag_ammi
		    ]

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

if {$conta_flag != "t"} {
    set link_conta      "<a href=\"$curr_prog?conta_flag=t&[export_ns_set_vars url]\">Conta</a>"
} else {
    set link_conta ""
}

set cod_tecn   [iter_check_uten_opve $id_utente]
#but01 aggiunta class"link-button-2" nel actions"Selez" 
if {$caller == "index"
    && [string equal $flag_ins_manu ""]} {
    set link_aggiungi "<a href=\"$gest_prog?funzione=I&[export_url_vars caller nome_funz last_concat_key extra_par]\">Aggiungi</a>"
    set link    "\[export_url_vars cod_cittadino nome_funz last_concat_key extra_par\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\"link-button-2\">Selez.</a></td>"
    set js_function ""
} else {
    if {$caller == "index"} {
	set caller "coimaimp"
    }
    set link_aggiungi ""
    set link    "\[export_url_vars cod_cittadino nome_funz last_concat_key extra_par\]&flag_ins_manu=S"

    #sim01: Per non dover modificare tutti i programmi che fanno il Cerca, restituisco il
    #       codice fiscale solo se receving_element ha 4 elementi
    set receiving_element [split $receiving_element |]

    if {[llength $receiving_element] eq 4} {#sim01
	set actions "[iter_select [list cod_cittadino cognome nome cod_fiscale]]|<a href=\"$gest_prog?funzione=M&$link\" class=\"link-button-2\">Mod.</a>";#sim01
	set js_function [iter_selected $caller [list \
						    [lindex $receiving_element 0] cod_cittadino \
						    [lindex $receiving_element 1] cognome \
						    [lindex $receiving_element 2] nome \
						    [lindex $receiving_element 3] cod_fiscale] \
			];#sim01
    } else {#sim01
	set actions "[iter_select [list cod_cittadino cognome nome]]|<a href=\"$gest_prog?funzione=M&$link\" class=\"link-button-2\">Mod.</a>"
	set js_function [iter_selected $caller [list \
						    [lindex $receiving_element 0] cod_cittadino \
						    [lindex $receiving_element 1] cognome \
						    [lindex $receiving_element 2] nome]
			]
    };#sim01
}

# imposto la struttura della tabella
#sim02 tolto         [list cod_cittadino "Codice"             no_sort {r}] 
#rom01 Aggiunto cod_piva
set table_def [list \
        [list actions       "Azioni"             no_sort $actions] \
    	[list nominativo    "Nominativo"         no_sort {l}] \
	[list indirizzo     "Indirizzo"          no_sort {l}] \
	[list comune        "Comune"             no_sort {l}] \
	[list cod_fiscale   "Cod.Fisc."          no_sort {l}] \
        [list cod_piva      "P.Iva"              no_sort {l}] \
        [list stato_citt    "Stato"              no_sort {l}] \
]

# imposto la query SQL 
if {$last_concat_key != ""} {
    set cognome       [lindex $last_concat_key 0]
    set nome          [lindex $last_concat_key 1]
    set cod_cittadino [lindex $last_concat_key 2]

    if {[string equal $cognome ""]} {
	set cognome_eq  "is null"
        set or_cognome ""
    } else {
	set cognome_eq  "= :cognome"
        set or_cognome  "or (cognome > :cognome)"
    }

    if {[string equal $nome ""]} {
	set nome_eq     "is null"
	set or_nome     ""
    } else {
	set nome_eq     "= :nome"
	set or_nome     " or (     cognome $cognome_eq
                              and  nome    > :nome)"
    }
    set where_key "and (
                           (    cognome $cognome_eq
                            and nome    $nome_eq
                            and cod_cittadino >= :cod_cittadino)
                           $or_nome
                           $or_cognome
                       )"
} else {
    set where_key ""
}

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
    set where_word  " and cognome like upper(:search_word_1)"
}

if {[string equal $f_nome ""]} {
    set where_nome ""
} else {
    set f_nome_1    [iter_search_word $f_nome]
    set where_nome  " and nome like upper(:f_nome_1)"
}

if {[string equal $f_cod_cittadino ""]} {
    set where_cod_cittadino ""
} else {
    set where_cod_cittadino " and cod_cittadino = :f_cod_cittadino"
}

if {$flag_ammi == "S"} {
	set where_ammi " and cod_cittadino like 'AM%'"
} else {
	set where_ammi ""
}

if {[string equal $f_cod_fiscale ""]} {
    set where_cod_fiscale   ""
} else {
    set where_cod_fiscale   " and cod_fiscale = upper(:f_cod_fiscale) "
}

if {[string equal $f_cod_piva ""]} {
    set where_cod_piva      ""
} else {
    set where_cod_piva      " and cod_piva = upper(:f_cod_piva) "
}

if {[string equal $f_comune ""]} {
    set where_comune        ""
} else {
    set where_comune        " and comune = upper(:f_comune) "
}

if {[string equal $f_stato_citt ""]} {
    set where_stato_citt    ""
} else {
    set where_stato_citt    " and stato_citt = :f_stato_citt "
}

set sql_query [db_map sql_query]

if {$conta_flag == "t"} {
    # estraggo il numero dei record estratti
    db_1row sel_conta_citt ""
    set link_conta "Soggetti selezionati: <b>$conta_num</b>"
}

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {nome_funz last_concat_key extra_par cognome nome cod_cittadino conta_num} go $sql_query $table_def]

# preparo url escludendo last_concat_key che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" "last_concat_key last_concat_key1"]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
#    set last_cod_cittadino $cod_cittadino
     if {[info exists cognome]
     &&  [info exists nome]
     &&  [info exists cod_cittadino]
     } {
	    set last_concat_key [list $cognome $nome $cod_cittadino]
     } else {
	 set last_concat_key ""
     }
     
     append url_vars "&[export_url_vars last_concat_key last_concat_key1]"
     append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista

set list_head [iter_list_head $form_di_ricerca $col_di_ricerca \
	       "$link_aggiungi<br>$link_conta" $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles

ad_return_template 
