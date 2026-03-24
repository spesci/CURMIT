ad_page_contract {

    @creation-date   10/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi Data controllo DA e Data controllo A.

} {  
   {f_data1           ""}
   {f_data2           ""}
   {caller       "index"}
   {funzione         "V"}
   {nome_funz         ""}
   {nome_funz_caller  ""}
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
set titolo       "Parametri per stampa riepilogo controlli"
set button_label "Seleziona"
set page_title   "Parametri per stampa riepilogo controlli"

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimsta4"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"

set onsubmit_cmd ""
set jq_date "";#but01
if {$funzione in "V M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
-html    $onsubmit_cmd

#but01 Aggiunto la classe ah-jquery-date ai campi data inizio e data fine".

element create $form_name f_data1 \
-label   "data inizio" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional \

element create $form_name f_data2 \
-label   "data fine" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional \

element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"


if {[form is_request $form_name]} {
    
    element set_properties $form_name f_data1        -value [iter_edit_date $f_data1]
    element set_properties $form_name f_data2        -value [iter_edit_date $f_data2]

    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set f_data1      [element::get_value $form_name f_data1]
    set f_data2      [element::get_value $form_name f_data2]
   
    set error_num 0

    
    set flag_data1_ok "f"
    if {![string equal $f_data1 ""]} {
	set f_data1 [iter_check_date $f_data1]
	if {$f_data1 == 0} {
	    element::set_error $form_name f_data1 "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data1_ok "t"
	}
    }
    
    set flag_data2_ok "f"
    if {![string equal $f_data2 ""]} {
	set f_data2 [iter_check_date $f_data2]
	if {$f_data2 == 0} {
	    element::set_error $form_name f_data2 "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data2_ok "t"
	}
    }

    if {$flag_data1_ok
    &&  $flag_data2_ok
    &&  $f_data1 > $f_data2
    } {
	element::set_error $form_name f_data2 "La data iniziale dell'intervallo deve essere inferiore a quella finale"
	incr error_num
	
    }
    
    if {$flag_data1_ok
    &&  $flag_data2_ok
    &&  [exists_and_not_null f_campagna]
    &&  ($f_data1 < $data_inizio
    ||  $f_data1 > $data_fine
    ||  $f_data2 < $data_inizio
    ||  $f_data2 > $data_fine)

    } {
	element::set_error $form_name f_data2 "Le date non sono comprese nella campagna selezionata"
	incr error_num
    }
    
    if {$error_num > 0} {
        ad_return_template
        return
    }

    set link [export_url_vars f_data1 f_data2 caller funzione nome_funz nome_funz_caller]

   
    set return_url "coimsta4-layout?$link"    

    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
