ad_page_contract {

    @author          Luca Romitti
    @creation-date   17/07/2023

    @cvs-id          coimcimp-firma-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== ======================================================================================================
    rom00            Programma copiato da coimdimp-firma-layout e modificato per i rapporto di ispezione.
    
} {
    {cod_cimp             ""}
    {last_cod_cimp        ""}
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
    {tipo_firma          "V"}
    {flag_tracciato  ""}
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
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)
set link         [export_ns_set_vars "url"]

set pack_key [iter_package_key]
set pack_dir [apm_package_url_from_key $pack_key]

switch $flag_ente {
    "P" {set directory "srcpers/$flag_ente$sigla_prov"}
    "C" {
	regsub -all " " $denom_comune "" denom_comune
	set directory "srcpers/$flag_ente$denom_comune"}
    default {set "standard"}
}

db_1row q "select flag_tracciato
             from coimcimp
            where cod_cimp = :cod_cimp"

if {$flag_tracciato == "AC"} {
    set directory "src"
}


switch $flag_tracciato {
    "AA" {set url_redirect_layout $pack_dir/$directory/coimcimp-a-layout}
    "AB" {set url_redirect_layout $pack_dir/$directory/coimcimp-b-layout}
    "RI" {set url_redirect_layout $pack_dir/$directory/coimcimp-ri-layout}
    "RE" {set url_redirect_layout $pack_dir/$directory/coimcimp-re-layout}
    "FR" {set url_redirect_layout $pack_dir/$directory/coimcimp-fr-layout}
    "AC" {set url_redirect_layout $pack_dir/$directory/coimcimp-ac-layout}
 default {set url_redirect_layout $pack_dir/$directory/coimcimp-a-layout}
}

if {$coimtgen(flag_firma_ispe_stampa_cimp) eq "f" && $coimtgen(flag_firma_resp_stampa_cimp) eq "t"} {
    set tipo_firma "R"
}
    
if {$coimtgen(flag_firma_ispe_stampa_cimp) eq "t" && $tipo_firma eq "V"} {
    set title "Firma del verificatore"
    
    if {$coimtgen(flag_firma_resp_stampa_cimp) eq "t"} {
	set url_redirect "coimcimp-firma-layout?tipo_firma=R&"
    } else {
	set url_redirect "$url_redirect_layout?"
    }
}
    
if {$tipo_firma eq "R" && $coimtgen(flag_firma_resp_stampa_cimp) eq "t"} {
    set title "Firma responsabile"
    
    set url_redirect "$url_redirect_layout?"
}


set form_name immagine_firma
form create $form_name \
    -html    ""

element create $form_name imgcode    -widget hidden -datatype text -optional
element create $form_name submit_btn -widget submit -datatype text -label "Salva form" -html "class form_submit style display:none"


element create $form_name cod_cimp            -widget hidden -datatype text -optional
element create $form_name last_cod_cimp       -widget hidden -datatype text -optional
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

    element set_properties $form_name cod_cimp             -value $cod_cimp
    element set_properties $form_name last_cod_cimp        -value $last_cod_cimp
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
	set path_nomefile_allegato "$spool_dir/$cod_cimp-$tipo_firma-immagine.png"
	set   allegato_file_id  [open $path_nomefile_allegato w]
	fconfigure $allegato_file_id -translation binary
	puts -nonewline $allegato_file_id $allegato_da_salvare
	close $allegato_file_id

	set link_gest [export_url_vars cod_cimp last_cod_cimp funzione caller nome_funz nome_funz_caller extra_par cod_impianto url_aimp url_list_aimp flag_ins is_only_print_p]

	set return_url "$url_redirect$link_gest"
	#$return_url
	ad_returnredirect $return_url
	ad_script_abort
	
    } 
}

ad_return_template
