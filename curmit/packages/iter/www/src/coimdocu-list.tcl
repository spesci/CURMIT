ad_page_contract {
    Lista tabella "coimdocu"

    @author                  Paolo Formizzi Adhoc
    @creation-date           11/05/2004

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

    @cvs-id coimdocu-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"
    nic01 28/09/2016 Sistemata paginazione in modo coerente con l'ordinamento

} {
    {search_word        ""}
    {rows_per_page      ""}
    {caller        "index"}
    {nome_funz          ""}
    {nome_funz_caller   ""} 
    {receiving_element  ""}
    {last_cod_documento ""}
    {cod_impianto       ""}
    {url_aimp           ""}
    {url_list_aimp      ""}
    {f_da_dat_prot      ""}
    {f_a_dat_prot       ""}
    {f_da_dat_prot2     ""}
    {f_a_dat_prot2      ""}
    {f_da_data_stp      ""}
    {f_a_data_stp       ""}
    {f_da_num_prot      ""}
    {f_a_num_prot       ""}
    {f_da_num_prot2     ""}
    {f_a_num_prot2      ""}
    {f_cod_sogg         ""}
    {f_tipo_doc         ""}
    {f_cod_impianto_est ""}
    {cod_manutentore    ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DOCULIST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-DOCULIST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#   } else {
#	ns_log Notice "********AUTH-CHECK-DOCULIST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

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

set page_title      "Lista Documenti"

switch $nome_funz_caller {
    "docu"        {set context_bar [iter_context_bar -nome_funz $nome_funz_caller]}
    "manutentori" {set context_bar [iter_context_bar \
					[list "javascript:window.close()" "Chiudi finestra"] \
					"$page_title"]
    }
    "impianti"    {set context_bar [iter_context_bar \
			   	   [list "javascript:window.close()" "Chiudi finestra"] \
				   "$page_title"]
    }
    default       {set context_bar [iter_context_bar \
			   	   [list "javascript:window.close()" "Chiudi finestra"] \
				   "$page_title"]
    }
}
switch $nome_funz_caller {
    "docu" {set link_tab ""
            set dett_tab ""
    }
    "manutentori" {set link_tab ""
                   set dett_tab ""
    }
    "impianti" {set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
	        set dett_tab [iter_tab_form $cod_impianto]
    }
    default    {set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
	        set dett_tab [iter_tab_form $cod_impianto]
    }
}


# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimdocu-gest"
set gest_stpm       "coimstpm-menu"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
if {$caller != "coimdocu-filter"} {
    set col_di_ricerca  "Data documento."
} else {
    set col_di_ricerca  "Cogn. resp."
}
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element \
			  f_da_dat_prot     $f_da_dat_prot     \
                          f_a_dat_prot      $f_a_dat_prot      \
                          f_da_dat_prot2    $f_da_dat_prot2    \
                          f_a_dat_prot2     $f_a_dat_prot2     \
                          f_da_data_stp     $f_da_data_stp     \
                          f_a_data_stp      $f_a_data_stp      \
                          f_da_num_prot     $f_da_num_prot     \
                          f_a_num_prot      $f_a_num_prot      \
                          f_da_num_prot2    $f_da_num_prot2    \
                          f_a_num_prot2     $f_a_num_prot2     \
                          f_cod_sogg        $f_cod_sogg        \
                          f_tipo_doc        $f_tipo_doc        \
                          cod_manutentore   $cod_manutentore
		    ]

if {[string equal $cod_impianto ""]} {
    set link_aggiungi ""
} else {
    set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_documento caller nome_funz extra_par nome_funz_caller]\">Aggiungi Documento Esterno</a>
<br> o <a href=\"$gest_stpm?funzione=V&[export_url_vars cod_impianto url_aimp url_list_aimp caller extra_par nome_funz_caller]&nome_funz=[iter_get_nomefunz coimstpm-menu]\">Seleziona Modello Stampa</a>"
}

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link    "\[export_url_vars cod_documento cod_impianto url_aimp url_list_aimp last_cod_documento nome_funz nome_funz_caller caller extra_par\]"
#but01
set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"
set js_function ""
set link_filter [export_ns_set_vars "url"]

# imposto la struttura della tabella

    set table_def [list \
            [list actions             "Azioni"         no_sort $actions] \
            [list cod_documento       "Cod. Docu"      no_sort      {l}] \
	    [list descr_tipo          "Tipo documento" no_sort      {l}] \
	    [list data_documento_edit "Data documento" no_sort      {c}] \
	    [list cod_impianto_est    "Impianto"       no_sort      {r}] \
	    [list nominativo_resp     "Responsabile"   no_sort      {l}] \
	    [list denom_comune        "Comune Ubic."   no_sort      {l}] \
	    [list descrizione         "Descrizione"    no_sort      {l}] \
            [list data_notifica_edit  "Data Not./Con." no_sort      {l}] \

    ]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    if {$caller != "coimdocu-filter"} {
	set search_word [iter_check_date $search_word]
	if {$search_word == 0} {
	    iter_return_complaint "La data di ricerca inserita non &egrave; correta"
	}
	set where_word  "and a.data_documento = :search_word"
    } else {
	set search_word_1 [iter_search_word $search_word]
	set where_word  " and upper(d.cognome) like upper(:search_word_1)"
    }
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_documento]} {
    #nic01 set where_last " and cod_documento >= :last_cod_documento"
    set where_last " and to_number(cod_documento,'99999999') <= :last_cod_documento";#nic01
} else {
    set where_last ""
}

if {![string equal $cod_impianto ""]} {
    set where_cod_impianto " and a.cod_impianto   = :cod_impianto"
} else {
    set where_cod_impianto ""
}

if {![string equal $f_cod_impianto_est ""]} {
    set where_cod_impianto_est "and c.cod_impianto_est   = :f_cod_impianto_est"
} else {
    set where_cod_impianto_est ""
}


##
set where_dat_prot ""
if {![string equal $f_da_dat_prot ""]
&&   [string equal $f_a_dat_prot ""]
} {
    set where_dat_prot "and a.data_prot_01  >= :f_da_dat_prot"
}  

if { [string equal $f_da_dat_prot ""]
&&  ![string equal $f_a_dat_prot ""]
} {
    set where_dat_prot "and a.data_prot_01  <= :f_a_dat_prot"
}  

if {![string equal $f_da_dat_prot ""]
&&  ![string equal $f_a_dat_prot ""]
} {
    set where_dat_prot "and a.data_prot_01 between :f_da_dat_prot and :f_a_dat_prot"
} 

##
set where_dat_prot2 ""
if {![string equal $f_da_dat_prot2 ""]
&&   [string equal $f_a_dat_prot2 ""]
} {
    set where_dat_prot2 "and a.data_prot_02 >= :f_da_dat_prot2"
}  

if { [string equal $f_da_dat_prot2 ""]
&&  ![string equal $f_a_dat_prot2 ""]
} {
    set where_dat_prot2 "and a.data_prot_02 <= :f_a_dat_prot2"
}  

if {![string equal $f_da_dat_prot2 ""]
&&  ![string equal $f_a_dat_prot2 ""]
} {
    set where_dat_prot2 "and a.data_prot_02 between :f_da_dat_prot2 and :f_a_dat_prot2"
}


set where_data_stp ""
if {![string equal $f_da_data_stp ""]
&&   [string equal $f_a_data_stp ""]
} {
    set where_data_stp "and a.data_stampa  >= :f_da_data_stp"
}  

if { [string equal $f_da_data_stp ""]
&&  ![string equal $f_a_data_stp ""]
} {
    set where_data_stp "and a.data_stampa  <= :f_a_data_stp"
}  

if {![string equal $f_da_data_stp ""]
&&  ![string equal $f_a_data_stp ""]
} {
    set where_data_stp "and a.data_stampa between :f_da_data_stp and :f_a_data_stp"
}

set where_num_prot ""
if {![string equal $f_da_num_prot ""]
&&   [string equal $f_a_num_prot ""]
} {
   set where_num_prot "and a.protocollo_01 >= :f_da_num_prot"
}   

if { [string equal $f_da_num_prot ""]
&&  ![string equal $f_a_num_prot ""]
} {
   set where_num_prot "and a.protocollo_01 <= :f_a_num_prot"
}   

if {![string equal $f_da_num_prot ""]
&&  ![string equal $f_a_num_prot  ""]
} {
    set where_num_prot "and a.protocollo_01 between :f_da_num_prot and :f_a_num_prot"
}


set where_num_prot2 ""
if {![string equal $f_da_num_prot2 ""]
&&   [string equal $f_a_num_prot2 ""]
} {
   set where_num_prot2 "and a.protocollo_02 >= :f_da_num_prot2"
}   

if { [string equal $f_da_num_prot2 ""]
&&  ![string equal $f_a_num_prot2 ""]
} {
   set where_num_prot2 "and a.protocollo_02 <= :f_a_num_prot2"
}   

if {![string equal $f_da_num_prot2 ""]
&&  ![string equal $f_a_num_prot2 ""]
} {
    set where_num_prot2 "and a.protocollo_02 between :f_da_num_prot2 and :f_a_num_prot2"
}

if {![string equal $cod_manutentore ""]
&&  [string equal $f_cod_sogg ""]
} {
    set where_cod_sogg "and a.tipo_soggetto = 'M'
                        and a.cod_soggetto = :cod_manutentore"
} else {
    if {![string equal $f_cod_sogg ""]
    &&  [string equal $cod_manutentore ""] 
    } {
        set where_cod_sogg "and a.tipo_soggetto = 'C'
                        and a.cod_soggetto = :f_cod_sogg"
    } else {
	set where_cod_sogg ""
    }
}



if {![string equal $f_tipo_doc ""]} {
    set where_tipo_doc "and a.tipo_documento = :f_tipo_doc"
} else {
    set where_tipo_doc ""
}




set sel_docu [db_map sel_docu_gen]


set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_documento cod_impianto url_aimp url_list_aimp last_cod_documento nome_funz nome_funz_caller extra_par caller} go $sel_docu $table_def]

# preparo url escludendo last_cod_documento che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_documento]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_documento $cod_documento
    append url_vars "&[export_url_vars last_cod_documento]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
