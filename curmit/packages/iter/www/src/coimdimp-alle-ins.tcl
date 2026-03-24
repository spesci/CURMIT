ad_page_contract {
    inserimento allegato all'autodichiarazione (tabella allegati "coimallv")

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    sim01 06/12/2019 Corretto controllo sull'inserimento e anche il redirect dopo l'inserimento
    
} {
    {tabella            ""}
    {cod_dimp           ""}
    {funzione          "V"}
    {caller        "index"}
    {nome_funz          ""}
    {nome_funz_caller   ""}
    {extra_par          ""}
    {cod_impianto       ""}
    {url_aimp           ""}
    {url_list_aimp      ""}
    contenuto:trim,optional
    contenuto.tmpfile:tmpfile,optional
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 2
set form_name "coimallv"
#set pack_key  [iter_package_key]
#set pack_dir  [apm_package_url_from_key $pack_key]

set link_prnt [export_url_vars cod_dimp data_ins cod_impianto nome_funz nome_funz_caller caller]
set link_prn2 [export_url_vars cod_dimp nome_funz nome_funz_caller caller]

set link         [export_ns_set_vars "url"];#sim01

set link [export_url_vars cod_dimp last_cod_dimp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp url_gage flag_no_link cod_opma data_ins]

#ns_log notice "prova dob1 $pack_dir"

#append pack_dir "spool/allegati"

#ns_log notice "prova dob2 $pack_dir"

#if {[db_0or1row query "select cod_impianto,
#                      data_controllo,
#                      to_char(data_controllo,'yy') as anno,
#                      to_char(data_controllo,'mmdd') as gior
#                 from coimdimp
#                where cod_dimp = :cod_dimp"] == 0} {
#    ns_return 200 text/html "Prima di allegare si deve inserire il rapporto di ispezione o la mancata verifica."
#}
set dir "[iter_set_spool_dir]/allegati"

#if {![file exists $dir]} {
#    file mkdir $dir
#    exec chmod 777 $dir
#}

set file_name $dir/$tabella$cod_dimp

ns_log notice "prova dob3 $file_name"

#ns_return 200 text/html "prova dob allv1 file_name = $file_name"

#set id_utente [lindex [iter_check_login $lvl docu] 1]
set id_utente "sandro"
#set link_gest [export_url_vars cod_cimp cod_impianto url_aimp url_list_aimp nome_funz nome_funz_caller extra_par caller]
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

set button_label "Conferma inserimento"
set page_title   "Inserimento allegato"
set onsubmit_cmd "enctype {multipart/form-data}"

set context_bar [iter_context_bar "Ins. allegato"]

form create $form_name \
-html    $onsubmit_cmd

element create $form_name contenuto \
-label   "Contenuto" \
-widget   file \
-datatype text \
-html    "class form_element" \
-optional

element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name tabella       -widget hidden -datatype text -optional
element create $form_name cod_dimp      -widget hidden -datatype text -optional
element create $form_name submit       -widget submit -datatype text -label "$button_label" -html "class form_submit"

#sim01 spostato controllo dal is_request per evitare inserimenti doppi
if {[db_0or1row sel_allv "select * from coimallegati where codice = :cod_dimp and tabella = :tabella limit 1"] == 1} {
    iter_return_complaint "Il documento scansionato risulta allegato e visualizzabile."
}


if {[form is_request $form_name]} {


    element set_properties $form_name tabella   -value $tabella
    element set_properties $form_name cod_dimp   -value $cod_dimp
    element set_properties $form_name funzione  -value $funzione
    element set_properties $form_name caller    -value $caller
    element set_properties $form_name nome_funz -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp

#    ns_return 200 text/html "prova dob allv1 file_name = $file_name"

}
if {[form is_valid $form_name]} {

#    ns_return 200 text/html "prova dob allv1 $contenuto"

    set contenuto            [element::get_value $form_name contenuto]
    set error_num 0

    if {![info exists contenuto]
        || [string is space $contenuto]
    } {
        element::set_error $form_name contenuto "Selezionare file"
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    set nome_tmpfile  ${contenuto.tmpfile}


#    ns_return 200 text/html "prova dob allv1 $contenuto $nome_tmpfile "

    set alle_id [db_string query "select coalesce(max(alle_id) + 1,1) from coimallegati "] 

    db_dml query "insert into coimallegati
                                     (alle_id,
                                      tabella,
                                      codice,
                                      allegato)
                                values
                                     (:alle_id,
                                      :tabella,
                                      :cod_dimp,
                                      :file_name)"

#    file rename $nome_tmpfile $file_name
    ns_rename $nome_tmpfile $file_name

#sim01    ns_return 200 text/html "Inserito allegato con nome file: $tabella$cod_dimp nella cartella $dir"

    set return_url "coimdimp-list?$link";#sim01
    ad_returnredirect -message "Allegato inserito correttamente" $return_url;#sim01
    ad_script_abort
}

ad_return_template


