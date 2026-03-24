ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   11/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl
  
    USER  DATA       MODIFICHE
    ===== ========== ===========================================================
    rom01 20/06/2025 Aggiunto campo f_enve che ha preso il posto di f_rgen.

    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi: f_data_evas_a,
    but01            f_data_controllo_da, f_data_controllo_a
    
} {  
    {f_tipologia        ""}
    {f_evaso            ""}
    {f_data_evas_da     ""}
    {f_data_evas_a      ""}
    {f_data_controllo_da ""}
    {f_data_controllo_a  ""}
    {f_potenza_da       ""}
    {f_potenza_a        ""}
    {f_cod_combustibile ""}
    {f_tpimp            ""}
    {f_cod_comune       ""}
    {f_rgen             ""}
    {f_enve             ""}
    {flag_tipo_impianto   ""}
    {caller        "index"}
    {funzione          "V"}
    {nome_funz          ""}
    {nome_funz_caller   ""}
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
set titolo       "Stampa attivit&agrave; sospese"
set button_label "Seleziona"
set page_title   "Stampa attivit&agrave; sospese"

iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimtodo"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set cod_comune  $coimtgen(cod_comu)

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

element create $form_name f_tipologia \
-label   "tipologia" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimtpdo cod_tpdo descrizione]

element create $form_name f_evaso \
-label   "flag evaso" \
-widget   select \
-datatype text \
-html    " $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {{Non evaso} N} {Evaso E} {Annullato A}}

element create $form_name f_data_evas_da \
-label   "Data evaso" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional 
#but01 Aggiunto la classe ah-jquery-date ai campi: f_data_evas_a, f_data_controllo_da, f_data_controllo_a
element create $form_name f_data_evas_a \
-label   "Data evaso" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional 

element create $form_name f_data_controllo_da \
    -label   "Da data controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
    -optional 

element create $form_name f_data_controllo_a \
    -label   "A ata controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
    -optional 

element create $form_name f_potenza_da \
-label   "Da potenza" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional 

element create $form_name f_potenza_a \
-label   "a potenza" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional 

element create $form_name f_cod_combustibile \
-label   "cod combustibile" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimcomb cod_combustibile descr_comb]

element create $form_name f_cod_tpim \
-label   "data fine" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimtpim cod_tpim descr_tpim cod_tpim]

element create $form_name f_rgen \
-label   "ente controllo" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimrgen cod_rgen descrizione]

#rom01
element create $form_name f_enve \
    -label   "ente Verificatore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimenve cod_enve ragione_01]

if {$flag_ente == "P"} {
    element create $form_name comune \
	-label   "Comune" \
	-widget   text \
	-datatype text \
	-html    "size 30 maxlength 35 $readonly_fld {} class form_element" \
	-optional

    set link_comune [iter_search  coimtodo [ad_conn package_url]/tabgen/coimcomu-list [list dummy_1 f_cod_comune search_word comune dummy_2 dummy dummy_3 dummy]]
}


element create $form_name f_cod_comune  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"


if {[form is_request $form_name]} {
    
    if {$flag_ente == "C"} {
	element set_properties $form_name f_cod_comune  -value $cod_comune
    }
    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set f_cod_comune       [element::get_value $form_name f_cod_comune]
    set f_tipologia        [element::get_value $form_name f_tipologia]
    set f_evaso            [element::get_value $form_name f_evaso]
    set f_data_evas_da     [element::get_value $form_name f_data_evas_da]
    set f_data_evas_a      [element::get_value $form_name f_data_evas_a]
    set f_data_controllo_da [element::get_value $form_name f_data_controllo_da]
    set f_data_controllo_a  [element::get_value $form_name f_data_controllo_a]
    set f_potenza_da       [element::get_value $form_name f_potenza_da]
    set f_potenza_a        [element::get_value $form_name f_potenza_a]
    set f_cod_combustibile [element::get_value $form_name f_cod_combustibile]
    set f_cod_tpim         [element::get_value $form_name f_cod_tpim]
    set f_rgen             [element::get_value $form_name f_rgen]
    set f_enve             [element::get_value $form_name f_enve];#rom01
    #dpr74
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]
    #dpr74 
    set error_num 0

    
    # controlli comune
    if {$flag_ente == "P"} {
#	if {[string equal $f_cod_comune "" ]} {
#	    element::set_error $form_name f_cod_comune "Inserire il comune"
#	    incr error_num
#	} 
    }
    
    set flag_data_evas_da_ok "f" 
    if {![string equal $f_data_evas_da ""]} {
	set f_data_evas_da [iter_check_date $f_data_evas_da]
	if {$f_data_evas_da == 0} {
	    element::set_error $form_name f_data_evas_da "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data_evas_da_ok "t" 
	}
    }
    
    set flag_data_evas_a_ok "f" 
    if {![string equal $f_data_evas_a ""]} {
	set f_data_evas_a [iter_check_date $f_data_evas_a]
	if {$f_data_evas_a == 0} {
	    element::set_error $form_name f_data_evas_a "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data_evas_a_ok "t" 
	}
    }

    if {$flag_data_evas_da_ok == "t"
    &&  $flag_data_evas_a_ok  == "t"
    &&  $f_data_evas_da > $f_data_evas_a
    } {
		element::set_error $form_name f_data_evas_da "Data inizio deve essere minore di data fine"
		incr error_num
    }

  # data controllo
    set flag_data_controllo_da_ok "f" 
    if {![string equal $f_data_controllo_da ""]} {
	set f_data_controllo_da [iter_check_date $f_data_controllo_da]
	if {$f_data_controllo_da == 0} {
	    element::set_error $form_name f_data_controllo_da "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data_controllo_da_ok "t" 
	}
    }
    set flag_data_controllo_a_ok "f" 
    if {![string equal $f_data_controllo_a ""]} {
	set f_data_controllo_a [iter_check_date $f_data_controllo_a]
	if {$f_data_controllo_a == 0} {
	    element::set_error $form_name f_data_controllo_a "Inserire correttamente la data"
	    incr error_num
	} else {
	    set flag_data_controllo_a_ok "t" 
	}
    }
    if {$flag_data_controllo_da_ok == "t" &&  $flag_data_controllo_a_ok  == "t" &&  $f_data_controllo_da > $f_data_controllo_a} {
	element::set_error $form_name f_data_controllo_da "Data inizio deve essere minore di data fine"
	incr error_num
    }


    set flag_pot_da_ok "f"
    if {![string equal $f_potenza_da ""]} {
	set f_potenza_da [iter_check_num $f_potenza_da 2]
	if {$f_potenza_da == "Error"} {
	    element::set_error $form_name f_potenza_da "Deve essere numerico"
	    incr error_num
	} else {
	    if {[iter_set_double $f_potenza_da] >=  [expr pow(10,7)]
            ||  [iter_set_double $f_potenza_da] <= -[expr pow(10,7)]} {
		element::set_error $form_name f_potenza_da "deve essere < di 10.000.000"
		incr error_num
	    } else {
		set flag_pot_da_ok "t"
	    }
	}
    }

    set flag_pot_a_ok "f"
    if {![string equal $f_potenza_a ""]} {
	set f_potenza_a [iter_check_num $f_potenza_a 2]
	if {$f_potenza_a == "Error"} {
	    element::set_error $form_name f_potenza_a "Deve essere numerico"
	    incr error_num
	} else {
	    if {[iter_set_double $f_potenza_a] >=  [expr pow(10,7)]
            ||  [iter_set_double $f_potenza_a] <= -[expr pow(10,7)]} {
		element::set_error $form_name f_potenza_da "deve essere < di 10.000.000"
		incr error_num
	    } else {
		set flag_pot_a_ok "t"
	    }
	}
    }

    if {$flag_pot_da_ok == "t"
    &&  $flag_pot_a_ok  == "t"
    &&  $f_potenza_da > $f_potenza_a
    } {
		element::set_error $form_name f_potenza_a "Potenza di inizio deve essere minore di potenza di fine"
		incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }
    #dpr74
    #rom01 Aggiunto f_enve
    set link [export_url_vars set f_cod_comune f_tipologia f_evaso f_data_evas_da f_data_evas_a f_data_controllo_da f_data_controllo_a f_potenza_da f_potenza_a f_cod_combustibile f_cod_tpim f_rgen f_enve flag_tipo_impianto nome_funz nome_funz_caller]

    set return_url "coimtodo-layout?$link"    

    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
