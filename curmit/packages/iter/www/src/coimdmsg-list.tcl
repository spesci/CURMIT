ad_page_contract {
    Lista messaggi ricevuti (tabella coimdmsg)

    @author                  Nicola Mortoni (clonato da coimtmsg-list)
    @creation-date           26/03/2014

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  

    @param caller            se diverso da index rappresenta il nome del form da cui è partita
    @                        la ricerca ed in questo caso imposta solo azione "sel"

    @param nome_funz         identifica l'entrata di menu, serve per le autorizzazioni

    @param receiving_element nomi dei campi di form che riceveranno gli argomenti restituiti
    @                        dallo script di zoom, separati da '|' ed impostarli come segue:

    @cvs-id coimdmsg-list.tcl 
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller            "index"}
   {nome_funz         ""}
   {receiving_element ""}
   {last_key_order_by ""}
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

set page_title      "Lista messaggi ricevuti"

set context_bar [iter_context_bar -nome_funz $nome_funz]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimdmsg-gest"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Oggetto"
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element \
			  search_word       $search_word]

set link_aggiungi   ""

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link            "\[export_url_vars cod_dmsg last_key_order_by nome_funz extra_par\]"
set js_function     ""

# imposto la struttura della tabella

# Metto in grassetto i messaggi non letti.
# Per farlo, devo preparare uno script per ogni colonna.

#old set actions "
#old <td nowrap><a href=\"$gest_prog?funzione=V&$link\">Selez.</a></td>"

set actions {
    [if {$flag_letto eq "No"} {
        return "<td nowrap><a href=\"$gest_prog?funzione=V&[subst $link]\" class=\"link-button-2\"><b>Selez.</b></a></td>"
    } else {
        return "<td nowrap><a href=\"$gest_prog?funzione=V&[subst $link]\" class=\"link-button-2\">Selez.</a></td>"
    }]
}


set col_cod_tmsg {
    [if {$flag_letto eq "No"} {
	return "<td nowrap align=right><b>$cod_tmsg</b></td>"
    } else {
	return "<td nowrap align=right>$cod_tmsg</td>"
    }]
}

set col_ts_ins_edit {
    [if {$flag_letto eq "No"} {
	return "<td nowrap align=center><b>$ts_ins_edit</b></td>"
    } else {
	return "<td nowrap align=center>$ts_ins_edit</td>"
    }]
}

set col_mittente {
    [if {$flag_letto eq "No"} {
	return "<td nowrap align=left><b>$mittente</b></td>"
    } else {
	return "<td nowrap align=left>$mittente</td>"
    }]
}

set col_oggetto {
    [if {$flag_letto eq "No"} {
	return "<td nowrap align=left><b>$oggetto</b></td>"
    } else {
	return "<td nowrap align=left>$oggetto</td>"
    }]
}

set col_flag_letto {
    [if {$flag_letto eq "No"} {
	return "<td nowrap align=center><b>$flag_letto</b></td>"
    } else {
	return "<td nowrap align=center>$flag_letto</td>"
    }]
}

set col_ts_lettura_edit {
    [if {$flag_letto eq "No"} {
	return "<td nowrap align=center><b>$ts_lettura_edit</b></td>"
    } else {
	return "<td nowrap align=center>$ts_lettura_edit</td>"
    }]
}

set table_def [list \
		   [list actions         "Azioni"           no_sort $actions] \
		   [list cod_tmsg        "Codice"           no_sort $col_cod_tmsg] \
		   [list ts_ins_edit     "Data/Ora invio"   no_sort $col_ts_ins_edit] \
		   [list mittente        "Mittente"         no_sort $col_mittente] \
		   [list oggetto         "Oggetto"          no_sort $col_oggetto] \
		   [list flag_letto      "Letto?"           no_sort $col_flag_letto] \
		   [list ts_lettura_edit "Data/Ora lettura" no_sort $col_ts_lettura_edit] \
		  ]

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(b.oggetto) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_key_order_by]} {
    set ts_ins   [lindex $last_key_order_by 0]
    set cod_tmsg [lindex $last_key_order_by 1]
    set cod_dmsg [lindex $last_key_order_by 2];#non serve perchè sono solo quelli dell'utente corrente ma non si sa mai

    set where_last " and (    (    b.ts_ins    = :ts_ins
                               and b.cod_tmsg  = :cod_tmsg
                               and a.cod_dmsg <= :cod_dmsg
                              )
                          or  (    b.ts_ins    = :ts_ins
                               and b.cod_tmsg <  :cod_tmsg
                              )
                           or      b.ts_ins   <  :ts_ins
                          )
                   "
} else {
    set where_last ""
}

set sql_query "
   select b.ts_ins
        , b.cod_tmsg
        , a.cod_dmsg
        , to_char(b.ts_ins,'DD/MM/YYYY HH24:MI')           as ts_ins_edit
        , coalesce(c.cognome,'')||' '||coalesce(c.nome,'') as mittente
        , b.oggetto
        , case when a.flag_letto = 't' then
               'S&igrave;'
          else
               'No'
          end                                              as flag_letto
        , to_char(a.ts_lettura,'DD/MM/YYYY HH24:MI')       as ts_lettura_edit
     from coimdmsg a
        , coimtmsg b
left join coimuten c
       on c.id_utente   = b.utente_ins
    where a.utente_dest = :id_utente -- solo i messaggi dallo user corrente
      and b.cod_tmsg    = a.cod_tmsg
   $where_last
   $where_word
 order by b.ts_ins   desc
        , b.cod_tmsg desc
        , a.cod_dmsg desc
"

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {ts_ins cod_tmsg cod_dmsg last_key_order_by nome_funz extra_par gest_prog link} go $sql_query $table_def]

# preparo url escludendo last_key_order_by che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_key_order_by]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_key_order_by [list $ts_ins $cod_tmsg $cod_dmsg]
    append url_vars "&[export_url_vars last_key_order_by]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
