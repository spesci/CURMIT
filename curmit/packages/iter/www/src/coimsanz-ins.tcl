ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimmovi"
    @author          Paolo Formizzi Adhoc
    @creation-date   07/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimmovi-gest.tcl


    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_scad, data_pag, data_compet
    but01            , data_rich_audiz, data_ric_ulter, data_ruolo, data_accertamento. 
    rom01 13/02/2023 Aggiunti i campi data_Accertamento e numero_accertamento su richiesta di Palermo.
    rom01            Sandro ha detto che va bene per tutti.

    san01 23/03/2020 Rimosso controllo su data pagamento che può essere successivo alla data scadenza

    sim01 19/07/2019 Corretto errore nel caso in cui tipo_soggetto fosse stato nullo

} {
    {cod_movi         ""}
    {last_cod_movi    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {cod_impianto     ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
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
set link_gest [export_url_vars cod_movi cod_impianto url_aimp url_list_aimp last_cod_movi nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

db_1row sel_date ""

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_movi caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Pagamento"
switch $funzione {
    M {set button_label "Conferma Modifica" 
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
	set page_title   "Cancellazione $titolo"}
    I {set button_label "Conferma Inserimento"
	set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"}
}

#if {$caller == "index"} {
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar  [iter_context_bar \
    #                     [list "javascript:window.close()" "Torna alla Gestione"] \
    #                     [list coimmovi-list?$link_list "Lista Pagamenti"] \
    #                     "$page_title"]
#}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimmovi"
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_fld_canc "readonly"
set disabled_fld "disabled"
set disabled_mod "disabled"
set onsubmit_cmd ""
switch $funzione {
    "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
	set readonly_fld_canc \{\}
	set disabled_mod \{\}
    }
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
	set readonly_fld_canc \{\}
    }
    "D" {set readonly_fld_canc \{\}
    }
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name cod_movi \
    -label   "Codice" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element" \
    -optional

# lasciare solo la possibilità SANZIONE
set l_of_l_caus [db_list_of_lists query "select descrizione, id_caus from coimcaus where codice = 'SA' order by descrizione"]
#set l_of_l_caus [linsert $l_of_l_caus 0 [list "" ""]]
element create $form_name id_caus \
    -label   "Tipo movimento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $l_of_l_caus
#but01 Aggiunto la classe ah-jquery-date ai campi:data_scad, data_pag, data_compet, data_rich_audiz
element create $form_name data_scad \
    -label   "Data scadenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name importo \
    -label   "Importo" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name importo_pag \
    -label   "Importo pagato" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_pag \
    -label   "Data pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_canc {} class form_element $jq_date" \
    -optional

set l_of_l [db_list_of_lists sel_lol "select descrizione, cod_tipo_pag from coimtp_pag order by ordinamento"]
set options_cod_tp_pag [linsert $l_of_l 0 [list "" ""]]

element create $form_name tipo_pag \
    -label   "Tipo pagamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_cod_tp_pag

element create $form_name nota \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 4 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_compet \
    -label   "Data competenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name tipo_soggetto \
    -label   "tipo sogg." \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 disabled {} class form_element" \
    -optional \
    -options {{{} {}} {Responsabile R} {Manutentore M} {Distributore D}}

element create $form_name cognome \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 readonly {} class form_element" \
    -optional

element create $form_name nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 readonly {} class form_element" \
    -optional

element create $form_name riduzione_importo \
    -label   "Riduzione Importo" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_sanzione_1 \
    -label   "cod. sanzione 1" \
    -widget   select \
    -datatype text \
    -html    "$disabled_mod {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimsanz cod_sanzione "cod_sanzione||' - '||descr_breve"]

element create $form_name cod_sanzione_2 \
    -label   "cod. sanzione 2" \
    -widget   select \
    -datatype text \
    -html    "$disabled_mod {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimsanz cod_sanzione "cod_sanzione||' - '||descr_breve"]

element create $form_name data_rich_audiz \
    -label   "Data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name note_rich_audiz \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 1 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_pres_deduz \
    -label   "Data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name note_pres_deduz \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 1 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_ric_giudice \
    -label   "Data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date " \
    -optional

element create $form_name note_ric_giudice \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 1 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_ric_tar \
    -label   "Data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name note_ric_tar \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 1 $readonly_fld {} class form_element" \
    -optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_ric_ulter, data_ruolo, data_accertamento
element create $form_name data_ric_ulter \
    -label   "Data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name note_ric_ulter \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 1 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_ruolo \
    -label   "Data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name note_ruolo \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 1 $readonly_fld {} class form_element" \
    -optional

#rom01
element create $form_name data_accertamento \
    -label   "Data accertamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
#rom01
element create $form_name numero_accertamento \
    -label   "Numero accertamento" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional


element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par     -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_movi -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp
    element set_properties $form_name last_cod_movi    -value $last_cod_movi

    if {$funzione == "I"} {
        db_1row sel_current_date ""
	element set_properties $form_name data_compet  -value $current_date
    } else {
	# leggo riga
        if {[db_0or1row sel_movi {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

	switch $tipo_soggetto {
	    "R" {db_1row sel_nome_resp ""}
	    "M" {db_1row sel_nome_manu ""}
	    "D" {db_1row sel_nome_dist ""}
	}

	if {$tipo_soggetto eq "" || $cod_soggetto eq ""} {#sim01 if e suo contenuto
	    set cognome ""
	    set nome    ""
	}

        element set_properties $form_name cod_movi          -value $cod_movi
        element set_properties $form_name id_caus           -value $id_caus
        element set_properties $form_name cod_impianto      -value $cod_impianto
        element set_properties $form_name data_scad         -value $data_scad
        element set_properties $form_name importo           -value $importo
        element set_properties $form_name importo_pag       -value $importo_pag
        element set_properties $form_name data_pag          -value $data_pag
        element set_properties $form_name tipo_pag          -value $tipo_pag
        element set_properties $form_name nota              -value $nota
        element set_properties $form_name data_compet       -value $data_compet
        element set_properties $form_name tipo_soggetto     -value $tipo_soggetto
        element set_properties $form_name cognome           -value $cognome
        element set_properties $form_name nome              -value $nome
        element set_properties $form_name riduzione_importo -value $riduzione_importo
        element set_properties $form_name cod_sanzione_1    -value $cod_sanzione_1
        element set_properties $form_name cod_sanzione_2    -value $cod_sanzione_2
        element set_properties $form_name data_rich_audiz   -value $data_rich_audiz
        element set_properties $form_name note_rich_audiz   -value $note_rich_audiz
        element set_properties $form_name data_pres_deduz   -value $data_pres_deduz
        element set_properties $form_name note_pres_deduz   -value $note_pres_deduz
        element set_properties $form_name data_ric_giudice  -value $data_ric_giudice
        element set_properties $form_name note_ric_giudice  -value $note_ric_giudice
        element set_properties $form_name data_ric_tar      -value $data_ric_tar
        element set_properties $form_name note_ric_tar      -value $note_ric_tar
        element set_properties $form_name data_ric_ulter    -value $data_ric_ulter
        element set_properties $form_name note_ric_ulter    -value $note_ric_ulter
        element set_properties $form_name data_ruolo        -value $data_ruolo
        element set_properties $form_name note_ruolo        -value $note_ruolo
        element set_properties $form_name data_accertamento   -value $data_accertamento;#rom01
        element set_properties $form_name numero_accertamento -value $numero_accertamento;#rom01
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set cod_movi          [element::get_value $form_name cod_movi]
    set id_caus           [element::get_value $form_name id_caus]
    set data_scad         [element::get_value $form_name data_scad]
    set importo           [element::get_value $form_name importo]
    set importo_pag       [element::get_value $form_name importo_pag]
    set data_pag          [element::get_value $form_name data_pag]
    set tipo_pag          [element::get_value $form_name tipo_pag]
    set nota              [element::get_value $form_name nota]
    set data_compet       [element::get_value $form_name data_compet]
    set riduzione_importo [element::get_value $form_name riduzione_importo]
    set cod_sanzione_1    [element::get_value $form_name cod_sanzione_1]
    set cod_sanzione_2    [element::get_value $form_name cod_sanzione_2]
    set data_rich_audiz   [element::get_value $form_name data_rich_audiz]
    set note_rich_audiz   [element::get_value $form_name note_rich_audiz]
    set data_pres_deduz   [element::get_value $form_name data_pres_deduz]
    set note_pres_deduz   [element::get_value $form_name note_pres_deduz]
    set data_ric_giudice  [element::get_value $form_name data_ric_giudice]
    set note_ric_giudice  [element::get_value $form_name note_ric_giudice]
    set data_ric_tar      [element::get_value $form_name data_ric_tar]
    set note_ric_tar      [element::get_value $form_name note_ric_tar]
    set data_ric_ulter    [element::get_value $form_name data_ric_ulter]
    set note_ric_ulter    [element::get_value $form_name note_ric_ulter]
    set data_ruolo        [element::get_value $form_name data_ruolo]
    set note_ruolo        [element::get_value $form_name note_ruolo]
    set data_accertamento   [element::get_value $form_name data_accertamento];#rom01
    set numero_accertamento [element::get_value $form_name numero_accertamento];#rom01

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I" || $funzione == "M"} {

        if {[string equal $id_caus ""]} {
            element::set_error $form_name id_caus "Inserire Causale"
            incr error_num
	    set flag_scad "N"
        }

	set flag_scad "S"
        if {[string equal $data_scad ""]} {
            element::set_error $form_name data_scad "Inserire Data scadenza"
            incr error_num
	    set flag_scad "N"
        } else {
            set data_scad [iter_check_date $data_scad]
            if {$data_scad == 0} {
                element::set_error $form_name data_scad "Data non corretta"
                incr error_num
		set flag_scad "N"
            }
        }

	set flag_imp "S"
        if {[string equal $importo ""]} {
	    element::set_error $form_name importo "Inserire importo"
	    incr error_num
	    set flag_imp "N"
	} else {
            set importo [iter_check_num $importo 2]
            if {$importo == "Error"} {
                element::set_error $form_name importo "Deve essere numerico, max 2 dec"
                incr error_num
		set flag_imp "N"
            } else {
                if {[iter_set_double $importo] >=  [expr pow(10,13)]
		    ||  [iter_set_double $importo] <= -[expr pow(10,13)]} {
                    element::set_error $form_name importo "Deve essere inferiore di 10.000.000.000.000"
                    incr error_num
		    set flag_imp "N"
                }
            }
        }

        if {![string equal $importo_pag ""]} {
            set importo_pag [iter_check_num $importo_pag 2]
            if {$importo_pag == "Error"} {
                element::set_error $form_name importo_pag "Deve essere numerico, max 2 dec"
                incr error_num
            } else {
                if {[iter_set_double $importo_pag] >=  [expr pow(10,13)]
		    ||  [iter_set_double $importo_pag] <= -[expr pow(10,13)]} {
                    element::set_error $form_name importo_pag "Deve essere inferiore di 10.000.000.000.000"
                    incr error_num
                } else {
		    if {$flag_imp == "S"
			&& $importo_pag > $importo} {
			element::set_error $form_name importo_pag "Non deve essere maggiore di importo"
			incr error_num
		    }
		}
            }
        }

        if {![string equal $data_pag ""]} {
            set data_pag [iter_check_date $data_pag]
            if {$data_pag == 0} {
                element::set_error $form_name data_pag "Data non corretta"
                incr error_num
            } else {
		if {$flag_scad == "S"
		    && $data_pag > $data_scad} {
                    #san01 element::set_error $form_name data_pag "Non deve essere maggiore di data scad"
		    #san01 incr error_num
		}
	    }
        }
        if {![string equal $data_compet ""]} {
            set data_compet [iter_check_date $data_compet]
            if {$data_compet == 0} {
                element::set_error $form_name data_compet "Data non corretta"
                incr error_num
            } 
        }
    }

    if {$funzione == "I" && $error_num == 0 && [db_0or1row sel_movi_check {}] == 1} {
	# controllo univocita'/protezione da double_click
        element::set_error $form_name cod_movi "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$funzione == "D" && ![string equal $data_pag ""]} {
        element::set_error $form_name data_pag "Il pagamento che stai tentando di cancellare &egrave; gi&agrave; stato effettuato.
                                                Per eliminarlo sbiancare la data pagamento."
        incr error_num
    }

    if {![string equal $cod_sanzione_1 ""] && ![string equal $cod_sanzione_2 ""]} {
	if {$cod_sanzione_1 == $cod_sanzione_2} {
	    element::set_error $form_name cod_sanzione_1 "Le due sanzioni selezionate sono uguali."
	    incr error_num
	} else {
	    db_1row sel_sanz1 ""
	    db_1row sel_sanz2 ""
	    if {$tipo_soggetto1 != $tipo_soggetto2} {
		element::set_error $form_name cod_sanzione_1 "Le due sanzioni selezionate non sono congruenti (differente soggetto)."
		incr error_num
	    }
	}
	db_1row sel_sanz1 ""
	set tipo_soggetto $tipo_soggetto1
	switch $tipo_soggetto {
	    "R" {db_1row sel_cod_resp ""}
	    "M" {db_1row sel_cod_manu ""}
	    "D" {db_1row sel_cod_dist ""}
	}
	if {[string equal $cod_soggetto ""]} {
	    element::set_error $form_name cod_sanzione_1 "Soggetto da sanzionare mancante su impianto."
	    incr error_num
	}
    } else {
	if {![string equal $cod_sanzione_1 ""] && [string equal $cod_sanzione_2 ""]} {
	    db_1row sel_sanz1 ""
	    set tipo_soggetto $tipo_soggetto1
	    switch $tipo_soggetto {
		"R" {db_1row sel_cod_resp ""}
		"M" {db_1row sel_cod_manu ""}
		"D" {db_1row sel_cod_dist ""}
	    }
	    if {[string equal $cod_soggetto ""]} {
		element::set_error $form_name cod_sanzione_1 "Soggetto da sanzionare mancante su impianto."
		incr error_num
	    }
	}
	if {[string equal $cod_sanzione_1 ""] && ![string equal $cod_sanzione_2 ""]} {
	    db_1row sel_sanz2 ""
	    set tipo_soggetto $tipo_soggetto2
	    switch $tipo_soggetto {
		"R" {db_1row sel_cod_resp ""}
		"M" {db_1row sel_cod_manu ""}
		"D" {db_1row sel_cod_dist ""}
	    }
	    if {[string equal $cod_soggetto ""]} {
		element::set_error $form_name cod_sanzione_1 "Soggetto da sanzionare mancante su impianto."
		incr error_num
	    }
	}
    }

    if {![string equal $data_rich_audiz ""]} {
	set data_rich_audiz [iter_check_date $data_rich_audiz]
	if {$data_rich_audiz == 0} {
	    element::set_error $form_name data_rich_audiz "Data non corretta"
	    incr error_num
	} 
    }

    if {![string equal $data_pres_deduz ""]} {
	set data_pres_deduz [iter_check_date $data_pres_deduz]
	if {$data_pres_deduz == 0} {
	    element::set_error $form_name data_pres_deduz "Data non corretta"
	    incr error_num
	} 
    }

    if {![string equal $data_ric_giudice ""]} {
	set data_ric_giudice [iter_check_date $data_ric_giudice]
	if {$data_ric_giudice == 0} {
	    element::set_error $form_name data_ric_giudice "Data non corretta"
	    incr error_num
	} 
    }

    if {![string equal $data_ric_tar ""]} {
	set data_ric_tar [iter_check_date $data_ric_tar]
	if {$data_ric_tar == 0} {
	    element::set_error $form_name data_ric_tar "Data non corretta"
	    incr error_num
	} 
    }

    if {![string equal $data_ric_ulter ""]} {
	set data_ric_ulter [iter_check_date $data_ric_ulter]
	if {$data_ric_ulter == 0} {
	    element::set_error $form_name data_ric_ulter "Data non corretta"
	    incr error_num
	} 
    }

    if {![string equal $data_ruolo ""]} {
	set data_ruolo [iter_check_date $data_ruolo]
	if {$data_ruolo == 0} {
	    element::set_error $form_name data_ruolo "Data non corretta"
	    incr error_num
	} 
    }

    if {![string equal $data_accertamento ""]} {#rom01 Aggiunta if e il suo contenuto
	set data_accertamento [iter_check_date $data_accertamento]
	if {$data_accertamento == 0} {
	    element::set_error $form_name data_accertamento "Data non corretta"
	    incr error_num
	} 
    }

    
    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {![db_0or1row query "select codice as tipo_movi from coimcaus where id_caus = :id_caus"]} {
	set tipo_movi ""
    }

    switch $funzione {
        I {db_1row sel_movi_next ""
	    set dml_sql [db_map ins_movi]}
        M {set dml_sql [db_map upd_movi]}
        D {set dml_sql [db_map del_movi]}
    }

    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimmovi $dml_sql
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
        set last_cod_movi $cod_movi
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_movi cod_impianto url_aimp url_list_aimp last_cod_movi nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimsanz-ins?funzione=V&$link_gest"}
        D {set return_url   "coimmovi-list?$link_list"}
        I {set return_url   "coimsanz-ins?funzione=V&$link_gest"}
        V {set return_url   "coimmovi-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
