ad_page_contract {
    Filtro documenti per scarico lista responsabili documenti

    @author          Giulio Laurenzi
    @creation-date   15/09/2004

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar

    @cvs-id          coimscar-docu-filter.tcl
     USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date al campo Data stampa.
} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {f_data_stampa    ""}
    {f_tipo_documento ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars nome_funz nome_funz_caller caller]

set bpos_td896 [parameter::get_from_package_key -package_key iter -parameter bpos_td896 -default 0]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposto variabili usate nel programma:
set sysdate_edit [iter_edit_date [iter_set_sysdate]]

# imposto la directory degli permanenti ed il loro nome.
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]

# Personalizzo la pagina
set button_label "Scarica"
set page_title   "Scarica lista responsabili documenti"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]


set link_scar [export_url_vars nome_funz nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimscar"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set jq_date "";#but01
if {$funzione in "V M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
-html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date al campo Data stampa.
element create $form_name f_data_stampa \
-label   "Data stampa " \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional

element create $form_name f_tipo_documento \
-label   "Tipo documento" \
-widget   select \
-datatype text \
-html    "$readonly_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimtdoc tipo_documento descrizione] \

set l_of_l_f_formato [list [list "Esteso" "Esteso"]]
if {$bpos_td896 == 1} {
    lappend l_of_l_f_formato [list "TD896" "TD896"]
}
element create $form_name f_formato \
-label   "Formato" \
-widget   radio \
-datatype text \
-html    "class form_element" \
-optional \
-options $l_of_l_f_formato

element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
if {[form is_request $form_name]} {
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller

    # Se c'e' solo l'opzione Esteso, la valorizzo per default
    if {$bpos_td896 == 0} {
	set f_formato "Esteso"
	element set_properties $form_name f_formato    -value $f_formato
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_data_stampa     [element::get_value $form_name f_data_stampa]
    set f_tipo_documento  [element::get_value $form_name f_tipo_documento]
    set f_formato         [element::get_value $form_name f_formato]
	
    set error_num 0

    if {[string equal $f_data_stampa ""]} {
	element::set_error $form_name f_data_stampa "Inserire data stampa"
	incr error_num
    } else {
	set f_data_stampa [iter_check_date $f_data_stampa]
	if {$f_data_stampa == 0} {
	    element::set_error $form_name f_data_stampa "Data errata"
	    incr error_num
	}
    }

    if {[string equal $f_tipo_documento ""]} {
	element::set_error $form_name f_tipo_documento "Inserire tipo documento"
	incr error_num
    }

    if {[string is space $f_formato]} {
	element::set_error $form_name f_formato "Scegliere il formato"
	incr error_num
    }

    if {$error_num > 0} {
       ad_return_template
       return
    }

    set link_scar [export_url_vars f_data_stampa f_tipo_documento caller funzione nome_funz nome_funz_caller]
    if {[string equal $f_formato "Esteso"]} {
	set return_url "coimscar-docu-gest-est?$link_scar"
    } else {
	set return_url "coimscar-docu-gest?$link_scar"
    }
    ad_returnredirect $return_url
    
    ad_script_abort
}


ad_return_template
