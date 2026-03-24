ad_page_contract {
    @author          Gianni Prosperi
    @creation-date   19/04/2007

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimstpm-stat-opve-filter.tcl

     USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi: f_data_da, f_data_a.


} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {f_data_da        ""}
    {f_data_a         ""}
    {f_cod_tecn       ""}
    {f_cod_enve       ""}
    {f_cog_tecn       ""}
    {f_nom_tecn       ""}
    {cod_combustibile ""}
    {f_cod_comune     ""}
    {flag_tipo_impianto ""}
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

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)

set cod_comune $coimtgen(cod_comu)
if {[string equal $flag_ente "C"]} {
    set f_cod_comune $cod_comune
}

# Personalizzo la pagina
set titolo       "Parametri per stampa statistiche amministrativo"
set button_label "Seleziona" 
set page_title   "Parametri per stampa statistiche amministrativo"

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstpm_cimp_tar"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd

# inizio dpr74
element create $form_name flag_tipo_impianto \
    -label   "flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html   "class form_element" \
    -optional \
    -options { {{} {}} {Riscaldamento R} {Raffreddamento F} {Cogenerazione C} {Teleriscaldamento T}}
# fine dpr74
#but01 Aggiunto la classe ah-jquery-date ai campi: f_data_da, f_data_a.
element create $form_name f_data_da \
    -label   "Da data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_a \
    -label   "A data" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_costo_da \
    -label   "A data" \
    -widget   text \
    -datatype text \
    -html    "size 7 maxlength 7 class form_element" \
    -optional

element create $form_name f_costo_a \
    -label   "A data" \
    -widget   text \
    -datatype text \
    -html    "size 7 maxlength 7 class form_element" \
    -optional

element create $form_name f_cod_comune \
    -label   "Comune" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcomu cod_comune denominazione]

element create $form_name f_cod_enve \
    -label   "Codice ente" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimenve cod_enve ragione_01]

element create $form_name f_cog_tecn \
    -label   "Cognome tecnico" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 40 class form_element" \
    -optional

element create $form_name f_nom_tecn \
    -label   "Nome tecnico" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 40 class form_element" \
    -optional

set cerca_opve [iter_search $form_name coimopve-list [list cod_enve f_cod_enve dummy f_cod_tecn dummy f_nom_tecn dummy f_cog_tecn]]


element create $form_name f_cod_tecn  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name dummy       -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name f_cod_tecn       -value $f_cod_tecn
    element set_properties $form_name f_cog_tecn       -value $f_cog_tecn
    element set_properties $form_name f_nom_tecn       -value $f_nom_tecn
#dpr74
    element set_properties $form_name flag_tipo_impianto       -value $flag_tipo_impianto
#dpr74
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_data_da         [element::get_value $form_name f_data_da]
    set f_data_a          [element::get_value $form_name f_data_a]
    set f_cod_enve        [element::get_value $form_name f_cod_enve]
    set f_cod_tecn        [element::get_value $form_name f_cod_tecn]
    set f_costo_da        [element::get_value $form_name f_costo_da]
    set f_costo_a         [element::get_value $form_name f_costo_a]
    set f_cod_comune      [element::get_value $form_name f_cod_comune]
#dpr74    
    set flag_tipo_impianto      [element::get_value $form_name flag_tipo_impianto]
#dpr74

    set error_num 0
    #controllo f_data_da
    if {![string equal $f_data_da ""]} {
	set f_data_da [iter_check_date $f_data_da]
	if {$f_data_da == 0} {
	    element::set_error $form_name f_data_da "Data non corretta"
	    incr error_num
	}
    }

    #controllo f_data_a
    if {![string equal $f_data_a ""]} {
	set f_data_a [iter_check_date $f_data_a]
	if {$f_data_a == 0} {
	    element::set_error $form_name f_data_a "Data non corretta"
	    incr error_num
	}
    }

    #controllo f_costo_da
    if {![string equal $f_costo_da ""]} {
	set f_costo_da [iter_check_num $f_costo_da 2]
	if {[string equal $f_costo_da "Error"]} {
	    element::set_error $form_name f_costo_da "Il campo costo deve essere un numerico con 2 cifre decimali"
	    incr error_num
	}
    }

    #controllo f_costo_a
    if {![string equal $f_costo_a ""]} {
	set f_costo_a [iter_check_num $f_costo_a 2]
	if {[string equal $f_costo_a "Error"]} {
	    element::set_error $form_name f_costo_a "Il campo costo deve essere un numerico con 2 cifre decimali"
	    incr error_num
	}
    }

    if {$error_num > 0} {
	ad_return_template
	return
    }

    set link_layout [export_url_vars f_data_da f_data_a f_cod_tecn f_costo_da f_costo_a f_cod_comune flag_tipo_impianto nome_funz nome_funz_caller]
    set return_url "coimstpm-cimp-tar-layout?$link_layout"
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
