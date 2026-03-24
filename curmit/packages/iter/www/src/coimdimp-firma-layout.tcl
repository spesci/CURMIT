ad_page_contract {
    @author          Luca Romitti
    @creation-date   23/11/2022

    @cvs-id          coimdimp-firma-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== ======================================================================================================


} {
    {cod_dimp             ""}
    {last_cod_dimp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {flag_ins             ""}
    {is_only_print_p     "f"}
    {tipo_firma          "M"}
    {flag_tipo_impianto  ""}
}

# Controlla lo user
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

iter_get_coimtgen
db_1row q "select flag_tipo_impianto
             from coimaimp
            where cod_impianto = :cod_impianto"

switch $flag_tipo_impianto {
    "R" {
	set url_redirect_layout "coimdimp-rct-layout"
    }
    "F" {
	set url_redirect_layout "coimdimp-fr-layout"
    }
    "T" {
	set url_redirect_layout "coimdimp-r3-layout"
    }
    "C" {
	set url_redirect_layout "coimdimp-r4-layout"
    }
}

if {$coimtgen(flag_firma_manu_stampa_rcee) eq "f" && $coimtgen(flag_firma_resp_stampa_rcee) eq "t"} {
    set tipo_firma "C"
}
    
if {$coimtgen(flag_firma_manu_stampa_rcee) eq "t" && $tipo_firma eq "M"} {
    set title "Firma del manutetore"
    
    if {$coimtgen(flag_firma_resp_stampa_rcee) eq "t"} {
	set url_redirect "coimdimp-firma-layout?tipo_firma=C&"
    } else {
	set url_redirect "$url_redirect_layout?"
    }
}
    
if {$tipo_firma eq "C" && $coimtgen(flag_firma_resp_stampa_rcee) eq "t"} {
    set title "Firma responsabile"
    
    set url_redirect "$url_redirect_layout?"
}


    
set form_name immagine_firma
form create $form_name \
    -html    ""

element create $form_name imgcode    -widget hidden -datatype text -optional
element create $form_name submit_btn -widget submit -datatype text -label "Salva form" -html "class form_submit style display:none"


element create $form_name cod_dimp            -widget hidden -datatype text -optional
element create $form_name last_cod_dimp       -widget hidden -datatype text -optional
element create $form_name funzione            -widget hidden -datatype text -optional
element create $form_name caller          -widget hidden -datatype text -optional
element create $form_name nome_funz           -widget hidden -datatype text -optional
element create $form_name nome_funz_caller    -widget hidden -datatype text -optional
element create $form_name extra_par           -widget hidden -datatype text -optional
element create $form_name cod_impianto        -widget hidden -datatype text -optional
element create $form_name url_aimp            -widget hidden -datatype text -optional
element create $form_name url_list_aimp       -widget hidden -datatype text -optional
element create $form_name flag_ins            -widget hidden -datatype text -optional
element create $form_name is_only_print_p     -widget hidden -datatype text -optional
element create $form_name tipo_firma          -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name imgcode    -value ""

    element set_properties $form_name cod_dimp             -value $cod_dimp
    element set_properties $form_name last_cod_dimp        -value $last_cod_dimp
    element set_properties $form_name funzione             -value $funzione
    element set_properties $form_name caller               -value $caller
    element set_properties $form_name nome_funz            -value $nome_funz
    element set_properties $form_name nome_funz_caller     -value $nome_funz_caller
    element set_properties $form_name extra_par            -value $extra_par
    element set_properties $form_name cod_impianto         -value $cod_impianto
    element set_properties $form_name url_aimp             -value $url_aimp
    element set_properties $form_name url_list_aimp        -value $url_list_aimp
    element set_properties $form_name flag_ins             -value $flag_ins
    element set_properties $form_name is_only_print_p      -value $is_only_print_p   
    element set_properties $form_name tipo_firma           -value $tipo_firma
    
} else {

    if {[form is_valid $form_name]} {

	set tipo_firma [element::get_value $form_name tipo_firma]

	set img_firma  [element::get_value $form_name imgcode]
	set img_firma  [string range $img_firma [string first "," $img_firma]+1 end]

	set allegato_da_salvare [base64::decode $img_firma]
	set spool_dir     [iter_set_spool_dir]
	set path_nomefile_allegato "$spool_dir/$cod_dimp-$tipo_firma-immagine.png"
	set   allegato_file_id  [open $path_nomefile_allegato w]
	fconfigure $allegato_file_id -translation binary
	puts -nonewline $allegato_file_id $allegato_da_salvare
	close $allegato_file_id

	set link_gest [export_url_vars cod_dimp last_cod_dimp funzione caller nome_funz nome_funz_caller extra_par cod_impianto url_aimp url_list_aimp flag_ins is_only_print_p]

	set return_url "$url_redirect$link_gest"
	ad_returnredirect $return_url
	ad_script_abort
	
    } 
}

ad_return_template




