ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimtodo"
    @author          Adhoc
    @creation-date   16/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimtodo-gest.tcl
     USER  DATA       MODIFICHE
    ===== ========== ========================================================================================
    mat01 15/09/2025 Sandro ha detto che anche in fase di inserimento di una attività sospesa è possibile
    mat01            selezionare tra tutte le tipologie della tabella coimtpdo. Aggiunto lo switch con la
    mat01            tipologia 7

    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi::data_evasione, data_scadenza, data_evento.

} {
    {cod_todo         ""}
    {last_cod_todo    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
    {cod_impianto     ""}
    {flag_impianti    ""}
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
set link_gest [export_url_vars url_aimp url_list_aimp cod_impianto flag_impianti cod_todo last_cod_todo nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {$flag_impianti == "T"} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
    set dett_tab [iter_tab_form $cod_impianto]
} else {
    set link_tab ""
    set dett_tab ""
}

set dettaglio "<td width=25% nowrap class=func-menu>Dettaglio</td>"

# Personalizzo la pagina
set link_list_script {[export_url_vars url_aimp url_list_aimp flag_impianti cod_impianto last_cod_todo caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "sospeso"
switch $funzione {
    M {set button_label "Conferma modifica" 
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma cancellazione"
	set page_title   "Cancella $titolo"}
    I {set button_label "Conferma inserimento"
	set page_title   "Inserisci $titolo"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizza $titolo"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimtodo"
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
#mat01
#if {$funzione != "I"} {
#    set opzioni_tipologia [iter_selbox_from_table coimtpdo cod_tpdo descrizione]
#} else {
#    set opzioni_tipologia {{Generico 4}}
#}

set opzioni_tipologia [iter_selbox_from_table coimtpdo cod_tpdo descrizione];#mat01

element create $form_name tipologia \
    -label   "Tipologia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $opzioni_tipologia

element create $form_name note \
    -label   "Note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 4 $readonly_fld {} class form_element" \
    -optional

if {$funzione != "I"} {
    set opzioni_flag_evasione { {{} {}} {{Non evaso} N} {Evaso E} {Annullato A}}
} else {
    set opzioni_flag_evasione { {{Non evaso} N} }
}

element create $form_name flag_evasione \
    -label   "Evaso" \
    -widget   select \
    -datatype text \
    -options $opzioni_flag_evasione \
    -html    "$disabled_fld {} class form_element" \
    -optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_evasione, data_scadenza, data_evento.
element create $form_name data_evasione \
    -label   "Data evasione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_scadenza \
    -label   "Data scadenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name data_evento \
    -label   "Data evento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
    -optional


element create $form_name url_aimp  -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name flag_impianti -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_todo -widget hidden -datatype text -optional
element create $form_name cod_todo  -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name url_aimp      -value $url_aimp
    element set_properties $form_name url_list_aimp -value $url_list_aimp
    element set_properties $form_name cod_impianto  -value $cod_impianto
    element set_properties $form_name flag_impianti -value $flag_impianti
    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name last_cod_todo -value $last_cod_todo
    
    if {$funzione == "I"} {
        
    } else {
	# leggo riga
        if {[db_0or1row sel_todo {}] == 0} {
            iter_return_complaint "Record non trovato"
	}
	
        element set_properties $form_name cod_todo      -value $cod_todo
        element set_properties $form_name tipologia     -value $tipologia
        element set_properties $form_name note          -value $note
        element set_properties $form_name flag_evasione -value $flag_evasione
        element set_properties $form_name data_evasione -value $data_evasione
	element set_properties $form_name data_scadenza -value $data_scadenza
	element set_properties $form_name data_evento   -value $data_evento

	if {$funzione == "V"} {

	    #mat02 aggiunto switch 7
	    switch $tipologia {
		"1" {set prog "coimdimp-gest"
		    set cod_dimp $cod_cimp_dimp
		    set link_prog "[export_url_vars url_list_aimp url_aimp cod_dimp nome_funz_caller cod_impianto]&nome_funz=[iter_get_nomefunz coimdimp-gest]"
		    set table "coimdimp"
		    set key   "cod_dimp"
		}
		"2" {set prog "coimcimp-gest"
  		    set cod_cimp $cod_cimp_dimp
		    set flag_cimp "S"
		    set link_prog "[export_url_vars url_list_aimp url_aimp cod_cimp cod_impianto flag_cimp nome_funz_caller]&nome_funz=cimp"
		    set table "coimcimp"
		    set key   "cod_cimp"
		}
		"3" {set prog "coimmov2-gest"
		    set cod_dimp $cod_cimp_dimp
		    set link_prog "[export_url_vars url_list_aimp url_aimp cod_movi nome_funz_caller cod_impianto]&nome_funz=[iter_get_nomefunz coimmov2-gest]"
		    set table "coimmovi"
		    set key   "cod_movi"}
		"4" {set prog "coimdocu-gest"
		    set table ""
		    set key   ""}
		"5" {set prog "coimdimp-gest"
		    set cod_dimp $cod_cimp_dimp
		    set link_prog "[export_url_vars url_list_aimp url_aimp cod_dimp nome_funz_caller cod_impianto]&nome_funz=[iter_get_nomefunz coimdimp-gest]"
		    set table "coimdimp"
		    set key   "cod_dimp"}
		"6" {set prog "coimcimp-gest"
  		    set cod_cimp $cod_cimp_dimp
		    set flag_cimp "S"
		    set link_prog "[export_url_vars url_list_aimp url_aimp cod_cimp cod_impianto flag_cimp nome_funz_caller]&nome_funz=cimp"
		    set table "coimcimp"
		    set key   "cod_cimp"}
		"7" {set prog "coimcimp-gest"
		    set cod_cimp $cod_cimp_dimp
		    set flag_cimp "S"
		    set link_prog "[export_url_vars url_list_aimp url_aimp cod_cimp cod_impianto flag_cimp nome_funz_caller]&nome_funz=cimp"
		    set table "coimcimp"
		    set key   "cod_cimp"
		}
	    }
	    if {$tipologia != "4"} {
		db_1row sel_count_dettaglio ""
	    } else {
		set count_dettaglio 0
	    }
	    if {$count_dettaglio != 0} {
		set dettaglio "<td width=25% nowrap class=func-menu>
                 <a href=$prog?funzione=V&$link_prog class=func-menu>Dettaglio</a></td>"
	    } else {
		set dettaglio "<td width=25% nowrap class=func-menu>Dettaglio</td>"
	    }
	} else {
	    set dettaglio "<td width=25% nowrap class=func-menu>Dettaglio</td>"
	}

    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set tipologia     [element::get_value $form_name tipologia]
    set note          [element::get_value $form_name note]
    set flag_evasione [element::get_value $form_name flag_evasione]
    set data_evasione [element::get_value $form_name data_evasione]
    set data_scadenza [element::get_value $form_name data_scadenza]
    set data_evento   [element::get_value $form_name data_evento]  
    
    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
	||  $funzione == "M"
    } {
	
        if {[string equal $tipologia ""]} {
            element::set_error $form_name tipologia "Inserire Tipologia"
            incr error_num
        }
	
	if {[string equal $note ""]} {
            element::set_error $form_name note "Inserire Note"
            incr error_num
        }
	
	if {$flag_evasione == "E"
	    && [string equal $data_evasione ""]
	} {
	    element::set_error $form_name data_evasione "Inserire Data evasione"
	    incr error_num
	}

        if {![string equal $data_evasione ""]} {
            set data_evasione [iter_check_date $data_evasione]
            if {$data_evasione == 0} {
                element::set_error $form_name data_evasione "Data evasione deve essere una data"
                incr error_num
            }
        }

	if {[string equal $data_scadenza ""]} {
	    element::set_error $form_name data_scadenza "Inserire data limite intervento"
	    incr error_num
	} else {
            set data_scadenza [iter_check_date $data_scadenza]
            if {$data_scadenza == 0} {
                element::set_error $form_name data_scadenza "Data limite intervento deve essere una data"
                incr error_num
            }
        }

	if {[string equal $data_evento ""]} {
	    element::set_error $form_name data_evento "Inserire data competenza"
	    incr error_num
	} else {
            set data_evento   [iter_check_date $data_evento]
            if {$data_evento == 0} {
                element::set_error $form_name data_evento "Data competenza deve essere una data"
                incr error_num
            }
        }

    }
    
    
    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {db_1row sel_cod_todo_dual ""
	    set dml_sql [db_map ins_todo]}
        M {set dml_sql [db_map upd_todo]}
        D {set dml_sql [db_map del_todo]}
    }
    
    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimtodo $dml_sql
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }
    
    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I"} {
        set last_cod_todo $cod_todo
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_todo last_cod_todo nome_funz nome_funz_caller extra_par url_aimp url_list_aimp cod_impianto flag_impianti caller]
    switch $funzione {
        M {set return_url   "coimtodo-gest?funzione=V&$link_gest"}
        D {set return_url   "coimtodo-list?$link_list"}
        I {set return_url   "coimtodo-gest?funzione=V&$link_gest"}
        V {set return_url   "coimtodo-list?$link_list"}
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
