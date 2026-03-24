ad_page_contract {
    @cvs-id          lancia caricamento modelli

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mic01 27/05/2022 Modificato programma per dare la funzione a utenti ente.
    mic01            Introdotta funzione di ricerca manutentori.

} {
    {nome_funz       ""}
    {cod_manutentore ""}
    {tipo_modello    ""}

}  -properties {

    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 3
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

#mic01 modificato nome form e titolo pagina
set form_name "ripristino"
set page_title   "Lancio ripristino caricamenti interrotti"
#set context_bar  [iter_context_bar -nome_funz cari-modelli-f]
set context_bar  [iter_context_bar -nome_funz lancia-ripristino]

form create $form_name 
#mic01 modificate etichette delle opzioni
element create $form_name tipo_modello \
    -label   "Tipo modello" \
    -widget   select \
    -options  {{"RCEE Tipo 1" "modellog"} {"RCEE Tipo 2" "modellof"} } \
    -datatype text \
    -html    "size 1 class form_element" \
    -value   $tipo_modello \
    -optional

#set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore]]
set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
#mic01 introdotta ricerca manutentore

element create $form_name f_manu_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 readonly {} class form_element tabindex 10" \

element create $form_name f_manu_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 readonly {} class form_element tabindex 11"\
    -optional

element create $form_name f_cod_manu        -widget hidden -datatype text -optional

#mic01 nome e cognome del manutentore vengono mantenuti al ritorno in questa pagina
if {$cod_manutentore ne ""} {

    element set_properties $form_name f_cod_manu -value $cod_manutentore

    db_1row q "select nome
                    , cognome
                 from coimmanu
                where cod_manutentore = :cod_manutentore"

    element set_properties $form_name f_manu_cogn -value $cognome
    element set_properties $form_name f_manu_nome -value $nome
}



element create $form_name submit       -widget submit -datatype text -label "Ripristina" -html "class form_submit"
element create $form_name current_date -widget hidden -datatype text -optional
element create $form_name current_time -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    
    set current_date [iter_set_sysdate]
    set current_time [iter_set_systime]
    
    element set_properties $form_name current_date  -value $current_date
    element set_properties $form_name current_time  -value $current_time
    element set_properties $form_name nome_funz         -value $nome_funz

}


if {[form is_valid $form_name]} {

    set current_date       [element::get_value $form_name current_date]
    set current_time       [element::get_value $form_name current_time]
    set tipo_modello       [element::get_value $form_name tipo_modello]
    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]
    
    lappend par        $id_utente
    
    set permanenti_dir [iter_set_permanenti_dir]
    set note           ""
    
    ad_returnredirect iter-ripristino?tipo_modello=$tipo_modello&cod_manutentore=$f_cod_manu&nome_funz=$nome_funz
    ad_script_abort
}

ad_return_template
