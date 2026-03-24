ad_page_contract {
    Lista tabella "coimmanu"

    @author                  Giulio Laurenzi
    @creation-date           27/02/2004

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

    @cvs-id coimmanu-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom03 25/10/2024 Le tipologie Manut/Inst Clim.Estiva e Manut/Inst Biomassa Legnosa
    rom03            nei manutentori devono essere filtrate anche come fossero Installatori I.

    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

    rom02 21/04/2023 Per Regione Friuli modificate le condizioni where_ruolo su manutentore e installatore.

    rom01 19/01/2021 Per la Regione Marche se il caller e' coimdimp devo far refreshare la
    rom01            pagina chiamante dopo che ho selezionato il manutentore per poter
    rom01            leggere attivare il __refreshing_p che va a popolare le combo degli strumenti

    gac01 20/12/2018 Aggiunto nome e cognome dichiarante che verranno passati nel caso in cui
    gac01            il programma venga chiamato dalla coimnoveb (dichiarazione art.284)

    sim02 09/03/2017 Le nuove tipologie Manut/Inst Clim.Estiva e Manut/Inst Biomassa Legnosa
    sim02            nei manutentori devono essere filtrate come se fossero Manutentori M

    gab01 07/03/2016 Aggiunto flag_visualizza_ec   

    sim02 07/03/2016 Aggiunto la gestione del portafoglio

    sim01 07/01/2016 Aggiunto flag_filter agli extra_par da passare alla pagina di dettaglio
    sim01            altrimenti il ritorna non visualizzava i manutentori in stato Cessato.

} {

   {f_cod_manutentore ""}
   {f_cognome         ""}
   {f_nome            ""}
   {f_ruolo           ""}
   {f_convenzionato   ""}
   {f_stato           ""}
   {flag_filter       ""} 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {receiving_element ""}
   {last_cognome      ""}
   {nome_funz_caller  ""}
   {conta_flag        ""}
   {cod_manutentore   ""}
   {cognome           ""}
   {nome              ""}
   {flag_valor_cod    ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

set javascript_sel "";#gac01

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

# reperisco i dati generali
iter_get_coimtgen

db_1row sel_tgen_portafoglio "select flag_portafoglio
                                   , flag_visualizza_ec --gab01 
                                from coimtgen"

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_filter [export_url_vars caller nome_funz receiving_element f_cod_manutentore f_cognome f_nome f_ruolo f_convenzionato f_stato]
set link_scar   [export_url_vars nome_funz nome_funz_caller f_cod_manutentore f_cognome f_nome f_ruolo f_convenzionato f_stato]
set page_title      "Lista Manutentori"


if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimmanu-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Cognome"
#sim01 aggiunto flag_filter
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element \
			  f_cod_manutentore $f_cod_manutentore \
			  f_cognome         $f_cognome \
			  f_nome            $f_nome \
			  f_ruolo           $f_ruolo \
			  f_convenzionato   $f_convenzionato \
		          f_stato           $f_stato \
                          flag_filter       $flag_filter]
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

if {$conta_flag != "t"} {
    set link_conta      "<a href=\"$curr_prog?conta_flag=t&[export_ns_set_vars url]\">Conta</a>"
} else {
    set link_conta ""
}

regsub -all "'" $cognome "!" cognome
#but01 Aggiunta class"link-button-2" nel actions"Selez"
if {$caller == "index"} {
    set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars last_cognome caller nome_funz nome_funz_caller extra_par]\">Aggiungi</a>"
    set link    "\[export_url_vars cod_manutentore last_cognome nome_funz extra_par\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\"link-button-2\">Selez.</a></td>"

    set js_function ""
} else {
    set link_aggiungi ""
    if {$caller == "coimdimp"
		&& $flag_portafoglio == "T"
    } {
	if {$coimtgen(regione) eq "MARCHE"} {#rom01 if e contenuto
	    # Abbiamo dovuto aggiungere questi comandi javascript per fare il refresh
	    # della coimdimp per poter visualizzare correttamente gli strumenti
	    # del manutentore selezionato. Senza, non veniva visto l'onchange
	    # e i dati non venivano aggiornati correttamente.
	    set javascript_sel "
 window.opener.document.coimdimp.__refreshing_p.value = '1';
 window.opener.document.coimdimp.submit.click();"
	}
	
	if {[string equal $flag_valor_cod ""]
	} {
	    set link    "\[export_url_vars cod_manutentore cognome nome nome_funz extra_par\]"
	    set actions "<td nowrap><a href=\"coimmanu-list?flag_valor_cod=t&$link&caller=$caller\"class=\"link-button-2\">Selez.</a></td>"
	    set js_function ""
	} else {
	    set actions ""
	    set js_function ""
	    set ente_portafoglio [db_get_database]
	    set url "lotto/balance?iter_code=$cod_manutentore&ente_portafoglio=$ente_portafoglio"
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    if {$risultato == "OK"} {
		set parte_2 [string range $result(page) [expr [string first " " $result(page)] + 1] end]
		set saldo [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]		
		set conto_manu [string range $parte_2 [expr [string first " " $parte_2] + 1] end]
	    } else {
		set saldo ""
		set conto_manu ""
	    }
	}
    } else {
	set actions [iter_select [list cod_manutentore cognome nome]]
	set receiving_element [split $receiving_element |]
	set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_manutentore [lindex $receiving_element 1]  cognome [lindex $receiving_element 2]  nome]]

	if {$caller eq "coimnoveb"} {#gac01 aggiunta if e suo contenuto
	    #gac01 aggiunto alle actions cod_legale_rapp cognome_dichiarante nome_dichiarante 
	    set actions [iter_select [list cod_manutentore cognome nome cod_legale_rapp cognome_dichiarante nome_dichiarante]]
	    
	    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_manutentore [lindex $receiving_element 1]  cognome [lindex $receiving_element 2] nome [lindex $receiving_element 3] cod_legale_rapp [lindex $receiving_element 4] cognome_dichiarante [lindex $receiving_element 5] nome_dichiarante]]

	    set javascript_sel "
 window.opener.document.coimdimp.cod_legale_rapp.value = '@cod_legale_rapp;noquote@';
 window.opener.document.coimdimp.cognome_dichiarante.value = '@cognome_dichiarante;noquote@';
 window.opener.document.coimdimp.nome_dichiarante.value = '@nome_dichiarante;noquote@';
"

	    
	};#gac01
	
    }
}

if {[string equal $flag_valor_cod ""]
} {
    # imposto la struttura della tabella
    set table_def [list \
		       [list actions         "Azioni"             no_sort $actions] \
		       [list cod_manutentore "Cod."               no_sort {l}] \
		       [list rag_soc         "Ragione sociale"    no_sort {l}] \
		       [list indirizzo       "Indirizzo"          no_sort {l}] \
		       [list comune          "Comune"             no_sort {l}] \
		       [list provincia       "Prov."              no_sort {l}] \
		       [list telefono        "Telefono"           no_sort {l}] \
                       [list flag_attivo     "Attivo S/N"         no_sort {l}] \
                       [list leg_rap         "Leg. Rap."          no_sort {l}] \
		      ]

    # imposto la query SQL 
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
	set where_word  " and upper(a.cognome) like upper(:search_word_1)"
    }
    
    if {[string equal $f_nome ""]} {
	set where_nome ""
    } else {
	set f_nome_1    [iter_search_word $f_nome]
	set where_nome  " and upper(a.nome) like upper(:f_nome_1)"
    }
    
    if {[string equal $f_cod_manutentore ""]} {
	set where_cod_manutentore ""
    } else {
	set where_cod_manutentore " and a.cod_manutentore = :f_cod_manutentore"
    }
    
    if {[string equal $f_ruolo ""]} {
	set where_ruolo ""
    } else {
	if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom02 Aggoimta if e il contenuto
	    if {$f_ruolo == "M"} {
		set where_ruolo " and (a.flag_ruolo != 'I' or a.flag_ruolo is null)";#rom03
	    }
	    if {$f_ruolo == "I"} {
		set where_ruolo " and (a.flag_ruolo != 'M' or a.flag_ruolo is null)";#rom03
	    }
	    if {$f_ruolo == "T"} {
		set where_ruolo " and (a.flag_ruolo = 'T' or a.flag_ruolo is null)"
	    }

	} else {#rom02 Aggiunta else ma non il suo contenuto

	if {$f_ruolo == "M"} {
	    #sim02 set where_ruolo " and (a.flag_ruolo in ('M','T') or a.flag_ruolo is null)"
	    set where_ruolo " and (a.flag_ruolo in ('M','T','E','L') or a.flag_ruolo is null)";#sim02
	}
	if {$f_ruolo == "I"} {
	    #rom03set where_ruolo " and (a.flag_ruolo in ('I','T') or a.flag_ruolo is null)"
	    set where_ruolo " and (a.flag_ruolo in ('I','T','E','L') or a.flag_ruolo is null)";#rom03
	}
	if {$f_ruolo == "T"} {
	    set where_ruolo " and (a.flag_ruolo = 'T' or a.flag_ruolo is null)"
	}
	};#rom02
    }
    
    if {$flag_filter == "S"} {
	set where_att ""
    } else {
	set where_att "and (a.flag_attivo = 'S' or a.flag_attivo is null)"
    }
    
    if {[string equal $f_convenzionato ""]} {
	set where_convenzionato ""
    } else {
	if {$f_convenzionato == "S"} {
	    set where_convenzionato " and a.flag_convenzionato = 'S'"
	}
	if {$f_convenzionato == "N"} {
	    set where_convenzionato " and a.flag_convenzionato = 'N'"
	}
    }

    if {[string equal $f_stato ""]} {
	set where_stato ""
    } else {
	if {$f_stato == "A"} {
	    set where_stato " and a.data_fine is null"
	}
	if {$f_stato == "C"} {
	    set where_stato " and a.data_fine is not null"
	}
    }
    
    # imposto la condizione per la prossima pagina
    if {![string is space $last_cognome]} {
	set cognome         [lindex $last_cognome 0]
	set cod_manu        [lindex $last_cognome 1]
	set where_last "and (  upper(a.cognome) > upper(:cognome)
                       or (upper(a.cognome) = upper(:cognome)
                      and  a.cod_manutentore >= :cod_manu))"
    } else {
	set where_last ""
    }   
    
    set sql_query [db_map sel_manu]
    
    #gab01    if {$flag_portafoglio eq "T"} {#sim02 aggiunto if e suo contenuto  };#gab01
    if {$flag_visualizza_ec eq "T"} {#gab01
	lappend table_def "[list wallet_id  {Codice Portafoglio} no_sort {<td nowrap><a href=\"ec?maintainer_id=$cod_manutentore&[export_url_vars last_cognome caller nome_funz nome_funz_caller extra_par]\">$wallet_id</a></td>}]"
    }
    

    if {$conta_flag == "t"} {
	# estraggo il numero dei record estratti
	db_1row sel_conta_manu ""
	set link_conta "Manutentori selezionati: <b>$conta_num</b>"
    }
    
    #set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_manutentore last_cognome nome_funz nome_funz_caller cognome nome conta_num extra_par} go $sql_query $table_def]
    #gac01 aggiunto cod_legale_rapp, cognome_dichiarante, nome_dichiarante
    set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_manutentore last_cognome nome_funz nome_funz_caller cognome nome conta_num extra_par wallet_id cod_legale_rapp cognome_dichiarante nome_dichiarante} go $sql_query $table_def]

    # preparo url escludendo last_cognome che viene passato esplicitamente
    # per poi preparare il link alla prima ed eventualmente alla prossima pagina
    set url_vars [export_ns_set_vars "url" last_cognome]
    set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"
    
# preparo link a pagina successiva
    set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
    if {$ctr_rec == $rows_per_page} {
	set last_cognome [list  $cognome $cod_manutentore]
	append url_vars "&[export_url_vars last_cognome]"
	append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
    }
    
    # creo testata della lista
    set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
		       "$link_aggiungi<br>$link_conta" $link_altre_pagine $link_righe "Righe per pagina"]

    set link_gest [export_url_vars f_cod_manutentore f_cognome f_nome f_ruolo f_convenzionato f_stato nome_funz nome_funz_caller]
    set return_url "coimfatt-csv?$link_gest"    
}

db_release_unused_handles
ad_return_template 
