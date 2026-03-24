ad_page_contract {

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date ai campi da_data_app, a_data_app, da_data_ins, a_data_ins.
    rom01 21/10/2020 Su segnalazione di Salerno modificato page_title per renderlo
    rom01            uguale al nome del menu', Sandro ha detto che va bene per tutti.
    
    san01 21/07/2016 Aggiunto filtro obbligatorio da_data_ins e a_data_ins e rimossa
    san01            obbligatorieta' dal filtro da_data_app e a_data_app come concordato
    san01            con l'Agenzia Fiorentina per l'Energia.

} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {cod_manutentore  ""}
    {cod_comune       ""}
    {da_data_app      ""}
    {a_data_app       ""}
    {osserv           ""}
    {prescr           ""}
    {raccom           ""}
    {funzionare       ""}
    {da_data_ins      ""}
    {a_data_ins       ""}
    {flag_tipo_impianto ""}
    {f_manu_cogn          ""}
    {f_manu_nome          ""}
    {f_cod_manu        ""}

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
#rom01set page_title   "Selezione allegati per stampa delle note"
set page_title "Stampa osservazioni/raccomandazioni/prescrizioni";#rom01

set context_bar  [iter_context_bar -nome_funz $nome_funz] 
set button_label "stampa"
set button_label1 "esporta"
# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstin"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# controllo se l'utente � un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]



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

#element create $form_name cod_manutentore \
#   -label   "Manutentore" \
#    -widget   select \
#    -datatype text \
#    -html    "class form_element" \
#    -optional \
#    -options [iter_selbox_from_table coimmanu cod_manutentore "cognome || ' ' || coalesce(nome,'') as manutentore" cod_manutentore ]

set sw_manu "f"

if {[string equal $cod_manutentore ""]} {
    set sw_manu "f"
    set readonly_fld2 \{\}
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
} else {
    set sw_manu "t"
    set readonly_fld2 "readonly"
    set cerca_manu ""
}

element create $form_name f_manu_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 10" \
    -optional

element create $form_name f_manu_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 11"\
    -optional



element create $form_name cod_comune \
    -label   "cod_comune" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_comu] 

element create $form_name osserv \
    -label   "Presenti Osservazioni" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}

element create $form_name prescr \
    -label   "Presenti Prescrizioni" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}

element create $form_name raccom \
    -label   "Presenti Raccomandazioni" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}

element create $form_name funzionare \
    -label   "Funzionare sn" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}

#but01 Aggiunto la classe ah-jquery-date ai campi da_data_app, a_data_app, da_data_ins, a_data_ins.
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

element create $form_name da_data_ins \
    -label   "da_data_ins" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional;#san01

element create $form_name a_data_ins \
    -label   "a_data_ins" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element class ah-jquery-date" \
    -optional;#san01

element create $form_name f_cod_manu       -widget hidden -datatype text -optional
element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name submit1     -widget submit -datatype text -label "$button_label1" -html "class form_submit"

if {[form is_request $form_name]} {

if {![string equal $cod_manutentore ""]} {
	element set_properties $form_name f_cod_manu    -value $cod_manutentore
	if {[db_0or1row get_nome_manu "select cognome as f_manu_cogn
            , nome    as f_manu_nome
         from coimmanu
        where cod_manutentore = :cod_manutentore"] == 0} {
	    set f_manu_cogn ""
	    set f_manu_nome ""
	}
    }


    set da_data_app [iter_edit_date $da_data_app]
    set a_data_app  [iter_edit_date $a_data_app]

    set da_data_ins [iter_edit_date $da_data_ins];#san01 (serve quando si ritorna dalla stampa)
    set a_data_ins  [iter_edit_date $a_data_ins];#san01 (serve quando si ritorna dalla stampa)

    element set_properties $form_name f_manu_cogn      -value $f_manu_cogn
    element set_properties $form_name f_manu_nome      -value $f_manu_nome
    element set_properties $form_name f_cod_manu       -value $f_cod_manu
    element set_properties $form_name cod_comune       -value $cod_comune
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name da_data_app      -value $da_data_app
    element set_properties $form_name a_data_app       -value $a_data_app
    element set_properties $form_name da_data_ins      -value $da_data_ins;#san01
    element set_properties $form_name a_data_ins       -value $a_data_ins;#san01
#dpr74
    element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
#dpr74

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set da_data_app             [element::get_value $form_name da_data_app]
    set a_data_app              [element::get_value $form_name a_data_app]
    set da_data_ins             [element::get_value $form_name da_data_ins];#san01
    set a_data_ins              [element::get_value $form_name a_data_ins];#san01
    set cod_comune              [element::get_value $form_name cod_comune]
    set prescr                  [element::get_value $form_name prescr]
    set osserv                  [element::get_value $form_name osserv]
    set raccom                  [element::get_value $form_name raccom]
    set funzionare              [element::get_value $form_name funzionare]
#dpr74
    set flag_tipo_impianto      [element::get_value $form_name flag_tipo_impianto]
#dpr74
    set submit                  [element::get_value $form_name submit]
    set submit1                 [element::get_value $form_name submit1]

    set error_num 0

    #san01 if {[string equal $da_data_app ""]} {
    #san01    element::set_error $form_name da_data_app "Inserire data"
    #san01    incr error_num
    #san01 }

    #san01 if {[string equal $a_data_app ""]} {
    #san01     element::set_error $form_name a_data_app "Inserire data"
    #san01     incr error_num
    #san01 }

    if {[string is space $da_data_ins]} {#san01: aggiunta if e suo contenuto
	element::set_error $form_name da_data_ins "Inserire data"
   	incr error_num
    } else {
	set da_data_ins [iter_check_date $da_data_ins]
	if {$da_data_ins eq 0} {
	    element::set_error $form_name da_data_ins "Data non corretta"
	    incr error_num
	}
    }
    
    if {[string is space $a_data_ins]} {#san01: aggiunta if e suo contenuto
	element::set_error $form_name a_data_ins "Inserire data"
   	incr error_num
    } else {
	set a_data_ins [iter_check_date $a_data_ins]
	if {$a_data_ins eq 0} {
	    element::set_error $form_name a_data_ins "Data non corretta"
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

    set cod_manutentore $f_cod_manu

    #dpr74
    #san01: aggiunti da_data_ins e a_data_ins
    set link_list [export_url_vars caller funzione nome_funz nome_funz_caller da_data_app a_data_app cod_comune cod_manutentore prescr osserv raccom funzionare flag_tipo_impianto da_data_ins a_data_ins]

    if {$submit1 == "esporta"} {
	set return_url "coimstin2-export?$link_list"
    } else {
	set return_url "coimstin2-layout?$link_list"
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
