ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   26/04/2005

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimaces-filter.tcl
     USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi:da_data_ins, a_data_ins.

} {
    
   {caller        "index"}
   {nome_funz          ""}
   {nome_funz_caller   ""} 
   {da_data_ins        ""}
   {a_data_ins         ""}
   {f_manu_cogn        ""}
   {f_manu_nome        ""}
   {f_comune           ""}
   {flag_tipo_impianto ""}
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

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# controllo se l'utente � un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# Personalizzo la pagina
set titolo       "Stampa dichiarazioni non conformi"
set button_label "Seleziona" 
set page_title   "Stampa dichiarazioni non conformi"


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstco"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set readonly_fld \{\}
set disabled_fld \{\}
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
#but01 Aggiunto la classe ah-jquery-date ai campi:da_data_ins, a_data_ins.
element create $form_name da_data_ins \
-label   "da_data_ins" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional

element create $form_name a_data_ins \
-label   "a_data_ins" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional

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
-html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 7" \
-optional

element create $form_name f_manu_nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 8"\
-optional

element create $form_name f_comune \
-label   "Comune" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element tabindex 4" \
-optional \
-options [iter_selbox_from_comu]

element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name f_cod_manu  -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"


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
    
    element set_properties $form_name f_manu_cogn      -value $f_manu_cogn
    element set_properties $form_name f_manu_nome      -value $f_manu_nome
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set da_data_ins        [element::get_value $form_name da_data_ins]
    set a_data_ins         [element::get_value $form_name a_data_ins]
    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]
    set f_comune           [string trim [element::get_value $form_name f_comune]]
#dpr74
    set flag_tipo_impianto  [string trim [element::get_value $form_name flag_tipo_impianto]]
#dpr74
    set error_num 0 

    if {[string equal $f_comune ""]} {
	element::set_error $form_name f_comune "Inserire"
	incr error_num
    }

    if {[string equal $da_data_ins ""]} {
	element::set_error $form_name da_data_ins "Inserire"
	incr error_num
    } else {
	set da_data_ins [iter_check_date $da_data_ins]
	if {$da_data_ins == 0} {
	    element::set_error $form_name da_data_ins "Data non corretta"
	    incr error_num
	}
    }    

    if {[string equal $a_data_ins ""]} {
	element::set_error $form_name a_data_ins "Inserire"
	incr error_num
    } else {
	set a_data_ins [iter_check_date $a_data_ins]
	if {$a_data_ins == 0} {
	    element::set_error $form_name a_data_ins "Data non corretta"
	    incr error_num
	}
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

	db_foreach sel_manu "select cod_manutentore as cod_manu_db
               from coimmanu
              where upper(cognome)   $eq_cognome
                and upper(nome)      $eq_nome" {
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
	set cod_manutentore ""
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
   #dpr74 
    set link_gest [export_url_vars da_data_ins a_data_ins f_manu_cogn f_manu_nome f_cod_manu f_comune flag_tipo_impianto nome_funz nome_funz_caller]

    set return_url "coimst_dimp_nc-layout?$link_gest"
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
