ad_page_contract {
    @author          Paolo Formizzi Adhoc
    @creation-date   21/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimstin-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi:da_data_app, a_data_app.

    
} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {cod_cinc         ""}
    {cod_enve         "VE1"}
    {cod_opve         "VE1000"}
    {cod_comune       ""}
    {flag_cod_tecn    ""}
    {flag_cod_enve    ""}
    {flag_stato_appuntamento ""}
    {da_data_app          ""}
    {a_data_app           ""}
    {da_data_spe          ""}
    {a_data_spe           ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}
#cod_opve, cod_cinc, cod_enve, da_data, a_data
#ns_return 200 text/html "$cod_opve|$cod_cinc|$cod_enve|$da_data_app|$a_data_app"; return

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

set cd_tecn   [iter_check_uten_opve $id_utente]
set cd_enve   [iter_check_uten_enve $id_utente]

if {![string equal $cd_tecn ""]} {
    set cod_opve $cd_tecn
    if {[db_0or1row sel_cod_enve ""] == 1} {
	set cod_enve $cd_enve
    }
    set flag_cod_tecn "t"
} else {
    set flag_cod_tecn "f"
}

if {![string equal $cd_enve ""]} {
    set cod_enve $cd_enve
    set flag_cod_enve "t"
} else {
    set flag_cod_enve "f"
}


iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente   $coimtgen(flag_ente)
set sigla_prov  $coimtgen(sigla_prov)


# Personalizzo la pagina
set titolo       "Parametri per stampa consuntivo ispettori"
set button_label "Seleziona"
set page_title   "Parametri per stampa consuntivo ispettori"

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimveta"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

form create $form_name \
-html    $onsubmit_cmd

element create $form_name cod_cinc \
-label   "Campagna di controllo" \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options [iter_selbox_from_table coimcinc cod_cinc descrizione] 

if {$flag_cod_enve == "f"
|| ($flag_cod_tecn == "f"
  && $flag_cod_enve == "f")
} {    
    element create $form_name cod_enve \
    -label   "Ente verificatore" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimenve cod_enve ragione_01] 
} else {
    element create $form_name cod_enve -widget hidden -datatype text -optional
    element set_properties $form_name cod_enve        -value $cod_enve
}
set nominativo [db_map sel_nominativo]

if {$flag_cod_tecn == "f"} {
    element create $form_name cod_opve \
    -label   "Operatore verificatore" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_2table coimopve cod_opve $nominativo coimenve cod_enve ragione_01 "ragione_01, nominativo" ]
} else {
    element create $form_name cod_opve -widget hidden -datatype text -optional
    element set_properties $form_name cod_opve        -value $cod_opve
}
#but01 Aggiunto la classe ah-jquery-date ai campi:da_data_app, a_data_app.
element create $form_name da_data_app \
-label   "da_data_app" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
-optional 

element create $form_name a_data_app \
-label   "a_data_app" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
-optional

if {$flag_ente == "C"} {
   element create $form_name cod_comune -widget hidden -datatype text -optional
   element set_properties $form_name cod_comune      -value $coimtgen(cod_comu)
} else {
    element create $form_name cod_comune \
    -label   "cod_comune" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_comu] 
} 


element create $form_name flag_cod_enve -widget hidden -datatype text -optional
element create $form_name flag_cod_tecn -widget hidden -datatype text -optional
element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {[db_0or1row sel_cinc_att ""] == 0} {
    set cod_cinc_att ""
}
element set_properties $form_name cod_cinc     -value $cod_cinc_att


if {[form is_request $form_name]} {

    set da_data_app [iter_edit_date $da_data_app]
    set a_data_app  [iter_edit_date $a_data_app]

    element set_properties $form_name cod_cinc         -value $cod_cinc
    element set_properties $form_name cod_enve         -value $cod_enve
    element set_properties $form_name cod_opve         -value $cod_opve
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name da_data_app      -value $da_data_app
    element set_properties $form_name a_data_app       -value $a_data_app
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set cod_cinc                [element::get_value $form_name cod_cinc]
    set cod_enve                [element::get_value $form_name cod_enve]
    set cod_opve                [element::get_value $form_name cod_opve]
    set da_data_app             [element::get_value $form_name da_data_app]
    set a_data_app              [element::get_value $form_name a_data_app]


    set error_num 0
    if {$flag_cod_enve == "t" } {
	set cod_enve [iter_check_uten_enve $id_utente]
    }

    if {[string equal $cod_cinc ""]} {
	element::set_error $form_name cod_cinc "Inserire campagna di controllo"
	incr error_num
    }

    if {![string equal $cod_enve ""]
	&& ![string equal $cod_opve ""]} {
	if {[db_0or1row sel_opve ""] == 0} {
	    element::set_error $form_name cod_opve "Non nell'ente selezionato"
	    incr error_num
	}
    }

    if {![string equal $da_data_app ""]} {
	set da_data_app [iter_check_date $da_data_app]
	if {$da_data_app == 0} {
	    element::set_error $form_name da_data_app "Data non corretta"
	    incr error_num
	}
    }

    if {![string equal $a_data_app ""]} {
	set a_data_app [iter_check_date $a_data_app]
	if {$a_data_app == 0} {
	    element::set_error $form_name a_data_app "Data non corretta"
	    incr error_num
	}
    }

    if {$error_num > 0} {
       ad_return_template
       return
    }

    set link_list [export_url_vars cod_cinc cod_enve cod_opve caller funzione nome_funz nome_funz_caller flag_stato_appuntamento da_data_app a_data_app da_data_spe a_data_spe cod_comune cod_area]

    set return_url "coimveta-layout?$link_list"

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
