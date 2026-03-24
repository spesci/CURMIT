ad_page_contract {

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi da_data_app, a_data_app.
    
} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {cod_manutentore  ""}
    {cod_comune       ""}
    {da_data_app      ""}
    {a_data_app       ""}
    {flag_tipo_impianto  ""}
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#set id_utente "sandro"
# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente   $coimtgen(flag_ente)
set sigla_prov  $coimtgen(sigla_prov)


# Personalizzo la pagina
#rom01set page_title   "Parametri di selezione modelli"
set page_title "Stampa Dichiarazioni con orario non congruo";#rom01

set context_bar  [iter_context_bar -nome_funz $nome_funz] 
set button_label "stampa"
set button_label1 "esporta"
# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstin"
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

# inizio dpr74
element create $form_name flag_tipo_impianto \
    -label   "flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html   "class form_element" \
    -optional \
    -options { {{} {}} {Riscaldamento R} {Raffreddamento F} {Cogenerazione C} {Teleriscaldamento T}}
# fine dpr74

element create $form_name cod_manutentore \
    -label   "Manutentore" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimmanu cod_manutentore "cognome || ' ' || coalesce(nome,'') as manutentore" cod_manutentore ]
#but01 Aggiunto la classe ah-jquery-date ai campi da_data_app, a_data_app.
element create $form_name da_data_app \
    -label   "da_data_app" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element $jq_date" \
    -optional 

element create $form_name a_data_app \
    -label   "a_data_app" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element $jq_date" \
    -optional


element create $form_name cod_comune \
    -label   "cod_comune" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_comu] 



element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name submit1     -widget submit -datatype text -label "$button_label1" -html "class form_submit"

if {[form is_request $form_name]} {

    set da_data_app [iter_edit_date $da_data_app]
    set a_data_app  [iter_edit_date $a_data_app]


    element set_properties $form_name cod_manutentore  -value $cod_manutentore
    element set_properties $form_name cod_comune       -value $cod_comune
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name da_data_app      -value $da_data_app
    element set_properties $form_name a_data_app       -value $a_data_app
#dpr74
     element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
#dpr74
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set cod_manutentore         [element::get_value $form_name cod_manutentore]
    set da_data_app             [element::get_value $form_name da_data_app]
    set a_data_app              [element::get_value $form_name a_data_app]
    set cod_comune              [element::get_value $form_name cod_comune]
#dpr74
    set flag_tipo_impianto      [element::get_value $form_name flag_tipo_impianto]
#dpr74
    set submit                  [element::get_value $form_name submit]
    set submit1                 [element::get_value $form_name submit1]

    set error_num 0


 if {[string equal $da_data_app ""]} {
	element::set_error $form_name da_data_app "Inserire data"
   	incr error_num
   } 


  if {[string equal $a_data_app ""]} {
	element::set_error $form_name a_data_app "Inserire data"
   	incr error_num
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
#dpr74
    set link_list [export_url_vars caller funzione nome_funz nome_funz_caller da_data_app a_data_app cod_comune cod_manutentore flag_tipo_impianto]



    if {$submit1 == "esporta"} {
	set return_url "coimstin1-export?$link_list"
    } else {
	set return_url "coimstin1-layout?$link_list"
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
