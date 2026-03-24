ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdimp"
    @author          Giulio Laurenzi
    @creation-date   15/09/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @cvs-id          coimstat-aimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi: f_data_inizio, f_data_fine.

} {
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_batc nome_funz nome_funz_caller caller]

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
set page_title   "Selezione per statistiche rapporti ispezione per applicazioni locali"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]


set link_scar [export_url_vars nome_funz nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstat"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}
form create $form_name \
-html    $onsubmit_cmd
#but01 Aggiunto la classe ah-jquery-date ai campi: f_data_inizio, f_data_fine.
element create $form_name f_data_inizio \
-label   "Data inizio " \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional

element create $form_name f_data_fine \
-label   "Data fine " \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional

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

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_data_inizio     [element::get_value $form_name f_data_inizio]
    set f_data_fine       [element::get_value $form_name f_data_fine]

    set error_num 0

    set flag_data_inizio "f"
    if {![string equal $f_data_inizio ""]} {
	set f_data_inizio [iter_check_date $f_data_inizio]
	if {$f_data_inizio == 0} {
	    element::set_error $form_name f_data_inizio "Data errata"
	    incr error_num
	} else {
	    set flag_data_inizio "t"
	}
    }

    set flag_data_fine "f"
    if {![string equal $f_data_fine ""]} {
	set f_data_fine [iter_check_date $f_data_fine]
	if {$f_data_fine == 0} {
	    element::set_error $form_name f_data_fine "Data errata"
	    incr error_num
	} else {
	    set flag_data_fine "t"
	}
    }

    if {$flag_data_inizio  == "t"
    &&  $flag_data_fine    == "t"
    &&  $f_data_inizio > $f_data_fine
    } {
	element::set_error $form_name f_data_fine "La data finale<br> dell'intervallo deve essere<br> minore di quella iniziale"
	incr error_num
    }

    if {$error_num > 0} {
       ad_return_template
       return
    }

    set link_scar [export_url_vars f_data_inizio f_data_fine  caller funzione nome_funz nome_funz_caller]

    set return_url "coimstat-cimp-gest?$link_scar"
    ad_returnredirect $return_url
    ad_script_abort

}


ad_return_template




