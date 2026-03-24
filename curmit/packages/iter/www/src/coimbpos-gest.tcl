ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimbpos"
    @author          Simone Pesci
    @creation-date   08/07/2014

    @param funzione  M=edit V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la navigation bar

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimbpos-gest.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 10/07/2023  Aggiunto la classe ah-jquery-date al campo data_scad

} {
    {cod_bpos         ""}
    {last_cod_bpos    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    #"I" {set lvl 2}
    "M" {set lvl 3}
    #"D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_bpos last_cod_bpos nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_bpos caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Bollettino Postale"
switch $funzione {
    M {
	set button_label "Conferma Modifica" 
	set page_title   "Modifica $titolo"
    }
#   D {
#      set button_label "Conferma Cancellazione"
#      set page_title   "Cancellazione $titolo"
#   }
#   I {
#      set button_label "Conferma Inserimento"
#      set page_title   "Inserimento $titolo"
#   }
    V {
	set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"
    }
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimbpos"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
if {$funzione eq "M"} {
    set readonly_fld \{\}
    set disabled_fld \{\}
#} elseif {$funzione eq "I"} {
#    set readonly_key \{\}
#    set readonly_fld \{\}
#    set disabled_fld \{\}
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}
# Possono essere modificati solo data pagamento, importo pagato e stato
form create $form_name \
    -html    $onsubmit_cmd

element create $form_name data_emissione \
    -label   "Data estrazione file" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
    -optional

element create $form_name quinto_campo \
    -label   "5° campo" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 16 $readonly_key {} class form_element" \
    -optional

element create $form_name cod_impianto_est \
    -label   "cod_impianto_est" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name responsabile \
    -label   "responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 50 maxlength 201 readonly {} class form_element" \
    -optional

element create $form_name data_verifica \
    -label   "Data appuntamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element $jq_date" \
    -optional

element create $form_name importo_emesso \
    -label   "Importo da pagare" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_key {} class form_element" \
    -optional

element create $form_name importo_pagato \
    -label   "Importo pagato" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_pagamento \
    -label   "Data pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_scarico \
    -label   "Data scarico" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name stato \
    -label   "Stato" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options  {{Attivo A} {Annullato N}}

element create $form_name cod_bpos         -widget hidden -datatype text -optional
element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_bpos    -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name last_cod_bpos    -value $last_cod_bpos

    #if {$funzione == "I"} {
    
    #} else {
    # leggo riga
    if {[db_0or1row sel_bpos ""] == 0} {
	iter_return_complaint "Bollettino postale non trovato"
    }
    
    element set_properties $form_name cod_bpos         -value $cod_bpos
    element set_properties $form_name data_emissione   -value $data_emissione
    element set_properties $form_name quinto_campo     -value $quinto_campo

    # questi 3 campi sono di altre tabelle e sono solo readonly
    element set_properties $form_name cod_impianto_est -value $cod_impianto_est
    element set_properties $form_name responsabile     -value $responsabile
    element set_properties $form_name data_verifica    -value $data_verifica

    element set_properties $form_name importo_emesso   -value $importo_emesso
    element set_properties $form_name importo_pagato   -value $importo_pagato
    element set_properties $form_name data_pagamento   -value $data_pagamento
    element set_properties $form_name data_scarico     -value $data_scarico
    element set_properties $form_name stato            -value $stato

    #}
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set cod_bpos         [element::get_value $form_name cod_bpos]
    set quinto_campo     [element::get_value $form_name quinto_campo]
    set data_emissione   [element::get_value $form_name data_emissione]

    # questi 3 campi sono di altre tabelle e sono solo readonly
    set cod_impianto_est [element::get_value $form_name cod_impianto_est]
    set responsabile     [element::get_value $form_name responsabile]
    set data_verifica    [element::get_value $form_name data_verifica]

    set importo_emesso   [element::get_value $form_name importo_emesso]
    set importo_pagato   [element::get_value $form_name importo_pagato]
    set data_pagamento   [element::get_value $form_name data_pagamento]
    set data_scarico     [element::get_value $form_name data_scarico]
    set stato            [element::get_value $form_name stato]

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I" || $funzione == "M" } {

        if {![string equal $importo_pagato ""]} {
	    set importo_pagato [iter_check_num $importo_pagato 2]
	    if {$importo_pagato == "Error"} {
                element::set_error $form_name importo_pagato "Deve essere numerico, max 2 dec"
                incr error_num
            } else {
		if {[iter_set_double $importo_pagato] >=  [expr pow(10,8)]
		||  [iter_set_double $importo_pagato] <= -[expr pow(10,8)]} {
                    element::set_error $form_name importo_pagato "Deve essere inferiore di 10.000.000"
                    incr error_num
		} 
	    }
	} else {
	    set importo_pagato 0;#altrimenti va in abend l'update per il not null
	}

	if {![string equal $data_pagamento ""]} {
	    set data_pagamento [iter_check_date $data_pagamento]
	    if {$data_pagamento == 0} {
                element::set_error $form_name data_pagamento "Data non corretta"
                incr error_num
            }
	}

	if {![string equal $data_scarico ""]} {
	    set data_scarico [iter_check_date $data_scarico]
	    if {$data_scarico == 0} {
                element::set_error $form_name data_scarico "Data non corretta"
                incr error_num
            }
	}
	
    }

    #  if {$funzione == "I" &&  $error_num == 0 &&  [db_0or1row sel_bpos_check {}] == 1} {
    #	# controllo univocita'/protezione da double_click
    #        element::set_error $form_name cod_movi "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Da#ta Base."
    #        incr error_num
    #    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {$funzione eq "M"} {
        set dml_sql [db_map upd_bpos]
#   } elseif {$funzione eq "I"} {
#	db_1row sel_bpos_next ""
#	set dml_sql [db_map ins_bpos]
#   } elseif {$funzione eq "D"} {
#	set dml_sql [db_map del_bpos]
    }
    # Lancio la query di manipolazione dati contenute in dml_sql
    
    if {[info exists dml_sql]} {
	with_catch error_msg {
            db_transaction {
                db_dml dml_coimbpos $dml_sql
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    # dopo l'inserimento posiziono la lista sul record inserito
    # if {$funzione == "I"} {
    #     set last_cod_movi $cod_movi
    # }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_bpos last_cod_bpos nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimbpos-gest?funzione=V&$link_gest"}
#	D {set return_url   "coimbpos-list?$link_list"}
#	I {set return_url   "coimbpos-gest?funzione=V&$link_gest"}
        V {set return_url   "coimbpos-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
