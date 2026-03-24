ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   19/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimpaga-filter.tcl
    
    USER  DATA       MODIFICHE
    ===== ========== =================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi: f_data_da, f_data_a.

} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {data_controllo   ""}
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

# Personalizzo la pagina
set titolo       "Parametri per stampa pagamenti non effettuati"
set button_label "Seleziona" 
set page_title   "Parametri per stampa pagamenti non effettuati"

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimpaga"
set onsubmit_cmd ""

form create $form_name \
    -html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date ai campi: f_data_da, f_data_a.
element create $form_name f_data_da \
    -label   "Data inizio" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

element create $form_name f_data_a \
    -label   "Data fine" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional

set l_of_l_caus [db_list_of_lists query "select descrizione, id_caus from coimcaus order by descrizione"]
set l_of_l_caus [linsert $l_of_l_caus 0 [list "" ""]]
element create $form_name f_id_caus \
    -label   "Tipo movimento" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options $l_of_l_caus
#{{Pagamento per dichiarazione} MH} {{Pagamento onere visita di controllo} VC} {{Sanzione tecnica} ST} {{Sanzione amministrativa} SA}

if {$flag_ente == "P"} {
    element create $form_name f_cod_comune \
	-label   "Tipo movimento" \
	-widget   select \
	-datatype text \
	-html    "class form_element" \
	-optional \
	-options [iter_selbox_from_comu]
} else {
    element create $form_name f_cod_comune -widget hidden -datatype text -optional
    element set_properties $form_name f_cod_comune  -value $cod_comune
}

element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name dummy            -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_data_da      [element::get_value $form_name f_data_da]
    set f_data_a       [element::get_value $form_name f_data_a]
    set f_id_caus      [element::get_value $form_name f_id_caus]
    set f_cod_comune   [element::get_value $form_name f_cod_comune]

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

    if {$error_num > 0} {
	ad_return_template
	return
    }

    set link_layout [export_url_vars f_data_da f_data_a f_id_caus f_cod_comune nome_funz nome_funz_caller]
    set return_url "coimpaga-layout?$link_layout"    
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
