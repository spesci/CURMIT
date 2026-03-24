ad_page_contract {
    @author          Simone Pesci
    @creation-date   07/07/2014

    @param funzione  V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimbpos-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =================================================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date al campi: f_data_controllo_da, f_data_controllo_a,
    but01            f_data_emissione_da, f_data_emissione_a,f_data_scarico_da, f_data_pagamento_da, f_data_pagamento_a.


} {
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}

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
set titolo        "Selezione Bollettini Postali"
set button_label  "Seleziona" 
set page_title    "Selezione Bollettini Postali"

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimbpos"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date al campi: f_data_controllo_da, f_data_controllo_a, f_data_emissione_da, f_data_emissione_a,f_data_scarico_da, f_data_pagamento_da, f_data_pagamento_a.
element create $form_name f_data_controllo_da \
    -label   "Da data appuntamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_controllo_a \
    -label   "A data appuntamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_emissione_da \
    -label   "Da data estrazione file" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_emissione_a \
    -label   "A data estrazione file" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_scarico_da \
    -label   "Da data scarico" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_scarico_a \
    -label   "A data scarico" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_pagamento_da \
    -label   "Da data pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_pagamento_a \
    -label   "A data pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_flag_pagati \
    -label   "Pagati" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options  {{{} {}} {S&igrave; S} {No N}}

element create $form_name f_quinto_campo \
    -label   "5° campo" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 16 class form_element" \
    -optional

element create $form_name f_resp_cogn \
    -label   "Cognome responsabile impianto" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 class form_element" \
    -optional

element create $form_name f_resp_nome \
    -label   "Nome responsabile impianto" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 class form_element" \
    -optional

element create $form_name f_cod_impianto_est \
    -label   "Codice impianto" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 class form_element" \
    -optional

element create $form_name f_stato \
    -label   "Stato" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options  {{{} {}} {Attivo A} {Annullato N}}

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
    element set_properties $form_name f_data_controllo_da -value [iter_edit_date $f_data_controllo_da]
    element set_properties $form_name f_data_controllo_a  -value [iter_edit_date $f_data_controllo_a]
    element set_properties $form_name f_data_emissione_da -value [iter_edit_date $f_data_emissione_da]
    element set_properties $form_name f_data_emissione_a  -value [iter_edit_date $f_data_emissione_a]
    element set_properties $form_name f_data_scarico_da   -value [iter_edit_date $f_data_scarico_da]
    element set_properties $form_name f_data_scarico_a    -value [iter_edit_date $f_data_scarico_a]
    element set_properties $form_name f_data_pagamento_da -value [iter_edit_date $f_data_pagamento_da]
    element set_properties $form_name f_data_pagamento_a  -value [iter_edit_date $f_data_pagamento_a]

    element set_properties $form_name f_flag_pagati       -value $f_flag_pagati
    element set_properties $form_name f_quinto_campo      -value $f_quinto_campo
    element set_properties $form_name f_resp_cogn         -value $f_resp_cogn
    element set_properties $form_name f_resp_nome         -value $f_resp_nome
    element set_properties $form_name f_cod_impianto_est  -value $f_cod_impianto_est
    element set_properties $form_name f_stato             -value $f_stato
}


if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set f_data_controllo_da         [element::get_value $form_name f_data_controllo_da]
    set f_data_controllo_a          [element::get_value $form_name f_data_controllo_a]
    set f_data_emissione_da         [element::get_value $form_name f_data_emissione_da]
    set f_data_emissione_a          [element::get_value $form_name f_data_emissione_a]
    set f_data_scarico_da           [element::get_value $form_name f_data_scarico_da]
    set f_data_scarico_a            [element::get_value $form_name f_data_scarico_a]
    set f_data_pagamento_da         [element::get_value $form_name f_data_pagamento_da]
    set f_data_pagamento_a          [element::get_value $form_name f_data_pagamento_a]
    set f_flag_pagati               [element::get_value $form_name f_flag_pagati]
    set f_quinto_campo              [element::get_value $form_name f_quinto_campo]
    set f_resp_cogn                 [element::get_value $form_name f_resp_cogn]
    set f_resp_nome                 [element::get_value $form_name f_resp_nome]
    set f_cod_impianto_est          [element::get_value $form_name f_cod_impianto_est]
    set f_stato                     [element::get_value $form_name f_stato]

    set error_num 0

    #controllo le date
    set flag_ok_data_controllo_da "f"
    if {![string equal $f_data_controllo_da ""]} {
	set f_data_controllo_da [iter_check_date $f_data_controllo_da]
	if {$f_data_controllo_da == 0} {
	    element::set_error $form_name f_data_controllo_da "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_controllo_da "t"
	}
    }

    set flag_ok_data_controllo_a "f"
    if {![string equal $f_data_controllo_a ""]} {
	set f_data_controllo_a [iter_check_date $f_data_controllo_a]
	if {$f_data_controllo_a == 0} {
	    element::set_error $form_name f_data_controllo_a "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_controllo_a "t"
	}
    } 

    if {![string equal $f_data_controllo_da ""]
        &&  ![string equal $f_data_controllo_a  ""]
        &&  $flag_ok_data_controllo_da == "t"
        &&  $flag_ok_data_controllo_a ==  "t"
        &&  $f_data_controllo_a < $f_data_controllo_da
    } {
        element::set_error $form_name f_data_controllo_a "deve essere maggiore o uguale alla data appuntamento iniziale"
        incr error_num
    }

    set flag_ok_data_emissione_da "f"
    if {![string equal $f_data_emissione_da ""]} {
	set f_data_emissione_da [iter_check_date $f_data_emissione_da]
	if {$f_data_emissione_da == 0} {
	    element::set_error $form_name f_data_emissione_da "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_emissione_da "t"
	}
    }


    set flag_ok_data_emissione_a "f"
    if {![string equal $f_data_emissione_a ""]} {
	set f_data_emissione_a [iter_check_date $f_data_emissione_a]
	if {$f_data_emissione_a == 0} {
	    element::set_error $form_name f_data_emissione_a "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_emissione_a "t"
	}
    }

    if {![string equal $f_data_emissione_da ""]
        &&  ![string equal $f_data_emissione_a  ""]
        &&  $flag_ok_data_emissione_da == "t"
        &&  $flag_ok_data_emissione_a ==  "t"
        &&  $f_data_emissione_a < $f_data_emissione_da
    } {
	ns_log notice "entra nell'if - simone"
        element::set_error $form_name f_data_emissione_a "deve essere maggiore o uguale alla data estrazione iniziale"
        incr error_num
    }


    set flag_ok_data_scarico_da "f"
    if {![string equal $f_data_scarico_da ""]} {
	set f_data_scarico_da [iter_check_date $f_data_scarico_da]
	if {$f_data_scarico_da == 0} {
	    element::set_error $form_name f_data_scarico_da "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_scarico_da "t"
	}
    }
    
    set flag_ok_data_scarico_a "f"
    if {![string equal $f_data_scarico_a ""]} {
	set f_data_scarico_a [iter_check_date $f_data_scarico_a]
	if {$f_data_scarico_a == 0} {
	    element::set_error $form_name f_data_scarico_a "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_scarico_a "t"
	}
    }

    if {![string equal $f_data_scarico_da ""]
        &&  ![string equal $f_data_scarico_a  ""]
        &&  $flag_ok_data_scarico_da == "t"
        &&  $flag_ok_data_scarico_a ==  "t"
        &&  $f_data_scarico_a < $f_data_scarico_da
    } {
        element::set_error $form_name f_data_scarico_a "deve essere maggiore o uguale alla data scarico iniziale"
        incr error_num
    }


    set flag_ok_data_pagamento_da "f"
    if {![string equal $f_data_pagamento_da ""]} {
	set f_data_pagamento_da [iter_check_date $f_data_pagamento_da]
	if {$f_data_pagamento_da == 0} {
	    element::set_error $form_name f_data_pagamento_da "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_pagamento_da "t"
	}
    }

    set flag_ok_data_pagamento_a "f"
    if {![string equal $f_data_pagamento_a ""]} {
	set f_data_pagamento_a [iter_check_date $f_data_pagamento_a]
	if {$f_data_pagamento_a == 0} {
	    element::set_error $form_name f_data_pagamento_a "deve essere una data valida"
	    incr error_num
	} else {
	    set flag_ok_data_pagamento_a "t"
	}
    }

    if {![string equal $f_data_pagamento_da ""]
        &&  ![string equal $f_data_pagamento_a  ""]
        &&  $flag_ok_data_pagamento_da == "t"
        &&  $flag_ok_data_pagamento_a ==  "t"
        &&  $f_data_pagamento_a < $f_data_pagamento_da
    } {
        element::set_error $form_name f_data_pagamento_a "deve essere maggiore o uguale alla data pagamento iniziale"
        incr error_num
    }
    
    set link_list [export_url_vars f_data_controllo_da f_data_controllo_a f_data_emissione_da f_data_emissione_a f_data_scarico_da f_data_scarico_a f_data_pagamento_da f_data_pagamento_a f_flag_pagati f_quinto_campo f_resp_cogn f_resp_nome f_cod_impianto_est f_stato caller funzione nome_funz nome_funz_caller]

    set return_url "coimbpos-list?$link_list"    
    
    if {$error_num > 0} {
	ad_return_template
	return
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
