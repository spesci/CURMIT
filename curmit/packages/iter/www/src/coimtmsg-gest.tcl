ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimtmsg" (inserimento/modifica/cancellazione messaggi)

    @author          Nicola Mortoni
    @creation-date   26/03/2014 (clonato da coimtpco-gest)

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @param           serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @param           serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimtmsg-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date al campo ts_ins_edit. 

} {
    {cod_tmsg          ""}
    {last_key_order_by ""}
    {funzione          "V"}
    {caller            "index"}
    {nome_funz         ""}
    {extra_par         ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_tmsg last_key_order_by nome_funz extra_par]

# Imposta le class css della barra delle funzion
iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars last_key_order_by caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Messaggio"
switch $funzione {
    M {
	set button_label "Conferma Modifica"
	set page_title   "Modifica $titolo"
    }
    D {
	set button_label "Conferma Cancellazione"
	set page_title   "Cancellazione $titolo"
    }
    I {
	set button_label "Conferma Inserimento"
	set page_title   "Inserimento $titolo"
    }
    V {
	set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"
    }
}

set vieta_azione  "f"

#if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz]
#} else {
#   set context_bar  [iter_context_bar \
#                         [list "javascript:window.close()" "Torna alla Gestione"] \
#                         [list coimtmsg-list?$link_list "Lista Messaggi inviati"] \
#                         "$page_title"]
#}


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimtmsg"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
   "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
       }
   "M" {set readonly_fld \{\}
        set disabled_fld \{\}
       }
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
-html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date al campo ts_ins_edit. 
if {$funzione != "I"} {
    element create $form_name ts_ins_edit \
	-label   "Data/Ora invio" \
	-widget   text \
	-datatype text \
	-html    "size 19 maxlength 19 readonly {} class form_element $jq_date" \
	-optional

    element create $form_name utente_ins \
	-label   "Mittente" \
	-widget   select \
	-datatype text \
	-html    "disabled {} class form_element" \
	-optional \
	-options [iter_selbox_from_table coimuten id_utente "coalesce(cognome)||' '||coalesce(nome)"]
}

element create $form_name oggetto \
    -label   "Oggetto" \
    -widget   text \
    -datatype text \
    -html    "size 100 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name messaggio \
    -label   "Messaggio" \
    -widget   textarea \
    -datatype text \
    -html    "cols 98 rows 7 $readonly_fld {} class form_element" \
    -optional

if {$funzione eq "I" || $funzione eq "M"} {

    set options_unita_dest [db_list_of_lists query "
                            select distinct
                                   coalesce(id_settore,'')||' '||coalesce(id_ruolo,'')
                                 , coalesce(id_settore,'')||' '||coalesce(id_ruolo,'')
                              from coimuten
                          order by coalesce(id_settore,'')||' '||coalesce(id_ruolo,'')
                           "]

    if {$options_unita_dest != ""} {
	set options_unita_dest [linsert $options_unita_dest 0 [list "Tutte" "Tutte"]]
    }

    element create $form_name unita_dest \
	-label   "Unità Organizzativa destinataria del messaggio" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options $options_unita_dest

} else {
    # Visto che l'id_settore e l'id_utente può cambiare, in VIS e CANC preferisco un text
    element create $form_name unita_dest \
	-label   "Unità Organizzativa destinataria del messaggio" \
	-widget   text \
	-datatype text \
	-html    "size 100 maxlength 100 $readonly_fld {} class form_element" \
	-optional
}


element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name extra_par     -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_key_order_by -widget hidden -datatype text -optional
element create $form_name cod_tmsg      -widget hidden -datatype text -optional

set table_result ""

set vieta_del_e_mod_se_letto {
    if {$funzione eq "D"
    ||  $funzione eq "M"
    } {
	if {[db_0or1row query "
            select 1
              from coimdmsg
             where cod_tmsg   = :cod_tmsg
               and flag_letto = 't'
             limit 1
            "]
	} {
	    set vieta_azione "t"
	    if {$funzione eq "D"} {
		set nome_azione "cancellare"
	    } else {
		set nome_azione "modificare"
	    }
	    element::set_error $form_name oggetto "Impossibile $nome_azione: il messaggio è già stato letto da almeno un utente"
	    incr error_num
	}
    }
}

if {[form is_request $form_name]} {
    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name last_key_order_by -value $last_key_order_by
    element set_properties $form_name cod_tmsg      -value $cod_tmsg
 

    if {$funzione == "I"} {
        
    } else {
      # leggo riga
        if {![db_0or1row query "
            select cod_tmsg
                 , ts_ins
                 , to_char(ts_ins,'DD/MM/YYYY HH24:MI:SS') as ts_ins_edit
                 , utente_ins
                 , oggetto
                 , messaggio
                 , unita_dest
              from coimtmsg
             where cod_tmsg = :cod_tmsg
            "]
	} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name ts_ins_edit -value $ts_ins_edit
        element set_properties $form_name utente_ins  -value $utente_ins
        element set_properties $form_name oggetto     -value $oggetto
        element set_properties $form_name messaggio   -value $messaggio
        element set_properties $form_name unita_dest  -value $unita_dest
    }

    if {$funzione eq "V"} {
	set query_per_ad_table "
            select coalesce(b.cognome,'')||' '||coalesce(b.nome,'')        as destinatario
                 , coalesce(b.id_settore,'')||' '||coalesce(b.id_ruolo,'') as unita_dest
                 , case when a.flag_letto = 't' then
                        'S&igrave;'
                   else
                        'No'
                   end as flag_letto
                 , to_char(a.ts_lettura,'DD/MM/YYYY HH24:MI') as ts_lettura_edit
              from coimdmsg a
                 , coimuten b
             where a.cod_tmsg  = :cod_tmsg
               and b.id_utente = a.utente_dest
          order by b.cognome
                 , b.nome
                 , b.id_utente
        "
	set table_def [list \
			   [list destinatario    "Utente Destinatario" no_sort {l}] \
			   [list unita_dest      "Unità Organizzativa" no_sort {l}] \
			   [list flag_letto      "Letto?"              no_sort {c}] \
			   [list ts_lettura_edit "Data/Ora lettura"    no_sort {c}] \
			  ]

	# Espongo anche l'elenco dei destinatari del messaggio col flag letto e quando
	set table_result [ad_table go $query_per_ad_table $table_def]
    }

    eval $vieta_del_e_mod_se_letto
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set oggetto    [string trim [element::get_value $form_name oggetto]]
    set messaggio  [string trim [element::get_value $form_name messaggio]]
    set unita_dest [string trim [element::get_value $form_name unita_dest]]

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {
        if {[string equal $oggetto ""]} {
            element::set_error $form_name oggetto "Inserire Oggetto"
            incr error_num
	}

        if {[string equal $messaggio ""]} {
            element::set_error $form_name messaggio "Inserire Messaggio"
            incr error_num
	} else {
	    set lun_messaggio [string length $messaggio]
	    if {$lun_messaggio > 4000} {
		element::set_error $form_name messaggio "Inserire un messaggio di massimo 4000 caratteri (quello digitato è lungo $lun_messaggio caratteri)"
		incr error_num

	    }
	}

        if {[string equal $unita_dest ""]} {
            element::set_error $form_name unita_dest "Inserire Unità Organizzativa di destinazione"
            incr error_num
	}

    }

    eval $vieta_del_e_mod_se_letto

    if {$error_num > 0} {
        ad_return_template
        return
    }

    db_1row query "select current_timestamp as current_timestamp
                     from dual"

    set inserisci_coimdmsg {
	if {$unita_dest eq "Tutte"} {
	    set where_settore_ruolo ""
	} else {
	    set where_settore_ruolo "where coalesce(id_settore,'')||' '||coalesce(id_ruolo,'') = :unita_dest"
	}
	set lista_utenti [db_list query "select id_utente
                                           from coimuten
                                         $where_settore_ruolo"]

	foreach utente_dest $lista_utenti {
	    db_1row query "select coalesce(max(cod_dmsg),0) + 1 as cod_dmsg
                             from coimdmsg"

	    set flag_letto "f"
	    set ts_lettura ""
	    set utente_ins $id_utente
	    set ts_ins     $current_timestamp
	    
	    db_dml query "
                    insert
                      into coimdmsg
                         ( cod_dmsg
                         , cod_tmsg
                         , utente_dest
                         , flag_letto
                         , ts_lettura
                         , utente_ins
                         , ts_ins
                         )
                  values (:cod_dmsg
                         ,:cod_tmsg
                         ,:utente_dest
                         ,:flag_letto
                         ,:ts_lettura
                         ,:utente_ins
                         ,:ts_ins
                         )"
	}
    }

    with_catch error_msg {
	db_transaction {
	    if {$funzione eq "I"} {
                db_1row query "select coalesce(max(cod_tmsg),0) + 1 as cod_tmsg
                                 from coimtmsg"
                set utente_ins $id_utente
		set ts_ins     $current_timestamp
                set utente_mod ""
                set ts_mod     ""

                db_dml query "
                insert
                  into coimtmsg
                     ( cod_tmsg
                     , utente_ins
                     , ts_ins
                     , oggetto
                     , messaggio
                     , unita_dest
                     , utente_mod
                     , ts_mod
                     )
              values (:cod_tmsg
                     ,:utente_ins
                     ,:ts_ins
                     ,:oggetto
                     ,:messaggio
                     ,:unita_dest
                     ,:utente_mod
                     ,:ts_mod
                     )"

		eval $inserisci_coimdmsg
	    }

            if {$funzione eq "M"} {
                set utente_mod $id_utente
                set ts_mod     $current_timestamp

                db_dml query "
                update coimtmsg
                   set oggetto    = :oggetto
                     , messaggio  = :messaggio
                     , unita_dest = :unita_dest
                     , utente_mod = :utente_mod
                     , ts_mod     = :ts_mod
                 where cod_tmsg   = :cod_tmsg"

		db_dml query "
                delete
                  from coimdmsg
                 where cod_tmsg = :cod_tmsg"

                eval $inserisci_coimdmsg
            }

            if {$funzione eq "D"} {
                db_dml query "
                delete
                  from coimtmsg
                 where cod_tmsg = :cod_tmsg"

                db_dml query "
                delete
                  from coimdmsg
                 where cod_tmsg = :cod_tmsg"

            }

	}

    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

  # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I"} {
        set last_key_order_by [list $ts_ins $cod_tmsg]
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_tmsg last_key_order_by nome_funz extra_par caller]
    switch $funzione {
        M {set return_url   "coimtmsg-gest?funzione=V&$link_gest"}
        D {set return_url   "coimtmsg-list?$link_list"}
        I {set return_url   "coimtmsg-gest?funzione=V&$link_gest"}
        V {set return_url   "coimtmsg-list?$link_list"}
    }


    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
