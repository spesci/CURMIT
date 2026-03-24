ad_page_contract {
    @author          Katia Coazzoli Adhoc
    @creation-date   09/06/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimaces-filter.tcl

     USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi:f_data_ril_da, f_data_ril_a

} {
    
   {funzione          "V"}
   {caller        "index"}
   {nome_funz          ""}
   {nome_funz_caller   ""}
   {f_manu_cogn        ""}
   {f_manu_nome        ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]


# Personalizzo la pagina
set titolo       "Selezione bollini"
set button_label "Seleziona" 
set page_title   "Selezione bollini"

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

iter_get_coimtgen
set flag_ente  $coimtgen(flag_ente)
set sigla_prov $coimtgen(sigla_prov)

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimboll"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
-html    $onsubmit_cmd

element create $form_name f_manu_cogn \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 10" \
-optional

element create $form_name f_manu_nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 11"\
-optional

set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
#but01 Aggiunto la classe ah-jquery-date ai campi:f_data_ril_da, f_data_ril_a 
element create $form_name f_data_ril_da \
-label   "Da data rilascio" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 class ah-jquery-date" \
-optional

element create $form_name f_data_ril_a \
-label   "A data rilascio" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element tabindex 12 class ah-jquery-date" \
-optional

element create $form_name f_cod_manu  -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name nome_funz_caller  -widget hidden -datatype text -optional


if {[form is_request $form_name]} {

    element set_properties $form_name f_manu_cogn        -value $f_manu_cogn
    element set_properties $form_name f_manu_nome        -value $f_manu_nome
    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]
    set f_data_ril_da      [element::get_value $form_name f_data_ril_da]
    set f_data_ril_a       [element::get_value $form_name f_data_ril_a]

    set error_num 0 

    set check_data_da "f"
    if {![string equal $f_data_ril_da ""]} {
        set f_data_ril_da [iter_check_date $f_data_ril_da]
        if {$f_data_ril_da == 0} {
            element::set_error $form_name f_data_ril_da "Data rilascio non corretta"
            incr error_num
        } else {
	    set check_data_da "t"
	}
    }

    set check_data_a "f"
    if {![string equal $f_data_ril_a ""]} {
        set f_data_ril_a [iter_check_date $f_data_ril_a]
        if {$f_data_ril_a == 0} {
            element::set_error $form_name f_data_ril_a "Data rilascio non corretta"
            incr error_num
        } else {
	    set check_data_a "t"
	}
    }
    
    if {![string equal $f_data_ril_da ""]
    &&  ![string equal $f_data_ril_a ""]
    &&  $check_data_da == "t"
    &&  $check_data_a  == "t"
    &&  $f_data_ril_da > $f_data_ril_a 
    } {
	element::set_error $form_name f_data_ril_da "La data iniziale deve essere minore della data finale"
	incr error_num
    }

    if {[string equal $f_manu_cogn ""]
	&& ![string equal $f_manu_nome ""]
    } {
	element::set_error $form_name f_manu_cogn "Indicare anche il cognome"
	incr error_num
    }

    #routine generica per controllo codice manutentore
    set check_cod_manu {
	set chk_out_rc       0
	set chk_out_msg      ""
	set chk_out_cod_manu ""
	set ctr_manu         0
	if {[string equal $chk_inp_cognome ""]} {
	    set eq_cognome "is null"
	} else {
	    set eq_cognome "= upper(:chk_inp_cognome)"
	}
	if {[string equal $chk_inp_nome ""]} {
	    set eq_nome    "is null"
	} else {
	    set eq_nome    "= upper(:chk_inp_nome)"
	}

	db_foreach sel_manu "" {
	    incr ctr_manu
	    if {$cod_manu_db == $chk_inp_cod_manu} {
		set chk_out_cod_manu $cod_manu_db
		set chk_out_rc       1
	    }
	}
	switch $ctr_manu {
	    0 { set chk_out_msg "Soggetto non trovato"}
	    1 { set chk_out_cod_manu $cod_manu_db
		set chk_out_rc       1 }
	    default {
		if {$chk_out_rc == 0} {
		    set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		}
	    }
	}
    }
    
    if {[string equal $f_manu_cogn ""]
	&&  [string equal $f_manu_nome ""]
    } {
	set f_cod_manu ""
    } else {
	set chk_inp_cod_manu $f_cod_manu
	set chk_inp_cognome  $f_manu_cogn
	set chk_inp_nome     $f_manu_nome
	eval $check_cod_manu
	set f_cod_manu  $chk_out_cod_manu
	if {$chk_out_rc == 0} {
	    element::set_error $form_name f_manu_cogn $chk_out_msg
	    incr error_num
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }
    
    set link_list [export_url_vars f_cod_manu f_data_ril_da f_data_ril_a caller funzione nome_funz nome_funz_caller]

    set return_url "coimboll-list?$link_list"    
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
