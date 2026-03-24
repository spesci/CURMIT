ad_page_contract {
    @author          Nicola Mortoni
    @creation-date   16/10/2014

    @param funzione  V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimfile-pagamenti-postali-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi:f_data_caricamento_da, f_data_caricamento_a.

} {
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}

    {f_data_caricamento_da ""}
    {f_data_caricamento_a  ""}
    {f_nome_file           ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set titolo        "Selezione File ricevuti dalle poste contenenti i pagamenti"
set button_label  "Seleziona" 
set page_title    "Selezione File ricevuti dalle poste contenenti i pagamenti"

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimfile_pagamenti_postali"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date ai campi:f_data_caricamento_da, f_data_caricamento_a.
element create $form_name f_data_caricamento_da \
    -label   "Da data caricamento file" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_caricamento_a \
    -label   "A data caricamento file" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_nome_file \
    -label   "Nome file caricato" \
    -widget   text \
    -datatype text \
    -html    "size 100 maxlength 100 class form_element" \
    -optional

element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"


if {[form is_request $form_name]} {
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller

    # valorizzo i campi di mappa con i parametri ricevuti.
    # serve quando la lista ritorna al filtro.
    element set_properties $form_name f_data_caricamento_da -value [iter_edit_date $f_data_caricamento_da]
    element set_properties $form_name f_data_caricamento_a  -value [iter_edit_date $f_data_caricamento_a]
    element set_properties $form_name f_nome_file         -value $f_nome_file
}


if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set f_data_caricamento_da         [element::get_value $form_name f_data_caricamento_da]
    set f_data_caricamento_a          [element::get_value $form_name f_data_caricamento_a]
    set f_nome_file                 [element::get_value $form_name f_nome_file]

    set error_num 0

    #controllo le date
    set flag_ok_data_caricamento_da "f"
    if {![string equal $f_data_caricamento_da ""]} {
	set f_data_caricamento_da [iter_check_date $f_data_caricamento_da]
	if {$f_data_caricamento_da == 0} {
	    element::set_error $form_name f_data_caricamento_da "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_caricamento_da "t"
	}
    }

    set flag_ok_data_caricamento_a "f"
    if {![string equal $f_data_caricamento_a ""]} {
	set f_data_caricamento_a [iter_check_date $f_data_caricamento_a]
	if {$f_data_caricamento_a == 0} {
	    element::set_error $form_name f_data_caricamento_a "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_caricamento_a "t"
	}
    } 

    if {![string equal $f_data_caricamento_da ""]
        &&  ![string equal $f_data_caricamento_a  ""]
        &&  $flag_ok_data_caricamento_da == "t"
        &&  $flag_ok_data_caricamento_a ==  "t"
        &&  $f_data_caricamento_a < $f_data_caricamento_da
    } {
        element::set_error $form_name f_data_caricamento_a "deve essere maggiore o uguale alla data caricamento file iniziale"
        incr error_num
    }

    set link_list [export_url_vars f_data_caricamento_da f_data_caricamento_a f_nome_file caller funzione nome_funz nome_funz_caller]

    set return_url "coimfile-pagamenti-postali-list?$link_list"    
    
    if {$error_num > 0} {
	ad_return_template
	return
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
