ad_page_contract {
    Pagina di sfondo.

    @author Abid boutheina
    @date   19/07/2024

    @cvs_id coiminco-help.tcl
} {
    {cod_impianto      ""}
    {last_cod_impianto ""}
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {extra_par         ""}
    {url_list_aimp     ""}
    {url_aimp          ""}
    {f_cod_via         ""}
    {cod_dimp            ""}        
    {receiving_element    ""}
    {data_ins             ""}
    {flag_tipo_impianto   ""}
    {cod_cind_dimp     ""}
    {cod_cind          ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
iter_get_coimtgen
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set page_title      "Bonifica campagna"

if {$caller == "index"} {
   set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller flag_tipo_impianto data_ins]

set flag_ente   $coimtgen(flag_ente)
set flag_viario $coimtgen(flag_viario)
# posso valorizzare eventuali variabili tcl a disposizione del master
set logo_url [iter_set_logo_dir_url]
set css_url  [iter_set_css_dir_url]
set form_name    "coimdimp"
set focus_field  ""
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set disabled_flag_pagato_fld $disabled_fld
set onsubmit_cmd ""
set page_title   "Bonifica campagna"
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
set button_label "Conferma bonifica"

form create $form_name \
    -html    $onsubmit_cmd
set onchange_manu "onChange document.$form_name.__refreshing_p.value='1';document.$form_name.changed_field.value='cod_cind';document.$form_name.submit.click()"

element create $form_name cod_cind \
    -label   "campagna vecchia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcind cod_cind descrizione] \
    -value $cod_cind_dimp

element create $form_name cod_cind_n \
    -label   "campagna vecchia" \
    -widget   select \
    -datatype text \
    -optional \
    -options [iter_selbox_from_table coimcind cod_cind descrizione]

element create $form_name submit   -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name cod_dimp -widget hidden -datatype text -optional -value $cod_dimp       

if {[form is_request $form_name]} {
 #   element set_properties $form_name funzione      -value $funzione
 #   element set_properties $form_name caller        -value $caller
 #   element set_properties $form_name nome_funz     -value $nome_funz
 #   element set_properties $form_name extra_par     -value $extra_par

#    element set_properties $form_name cod_cind     -value $cod_cind
#    element set_properties $form_name cod_cind_n   -value $cod_cind_n

    
}

if {[form is_valid $form_name]} {

    set cod_cind [element::get_value $form_name cod_cind]
    set cod_cind_n [element::get_value $form_name cod_cind_n]
    
	set dml_cind [db_map upd_cind]
    
    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_cind]} {
        with_catch error_msg {
            db_transaction {
		if {[info exists dml_cind]} {
		    db_dml dml_coimdimp $dml_cind
		}
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    } 

  # dopo l'inserimento posiziono la lista sul record inserito
   
   set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller flag_tipo_impianto cod_cind] 
    
    ad_returnredirect "coimdimp-bon-cind-conf?$link_gest"
    #ad_returnredirect "coimdimp-rct-gest?$link_gest&__refreshing_p=1"
  ad_script_abort
}



