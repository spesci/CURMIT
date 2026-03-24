ad_page_contract {
    @author          Giulio Laurenzi
    @creation-date   22/08/2005

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, serve per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl
} {
    
   {funzione            "V"}
   {caller          "index"}
   {nome_funz            ""}
   {nome_funz_caller     ""}
   {cod_impianto_old     ""}
   {cod_impianto_est_new ""}

   {f_resp_cogn          ""} 
   {f_resp_nome          ""} 

   {f_comune             ""}
   {f_cod_via            ""}

   {f_desc_via           ""}
   {f_desc_topo          ""}
   {f_manu_cogn          ""}
   {f_manu_nome          ""}
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

if {![string equal $cod_impianto_old ""]} {
    if {[db_0or1row sel_aimp_cod_est ""] == 0} {
	set cod_impianto_est_old ""
    }
    set impianto_old_adp "
       <tr><td colspan=2 align=center>
           <a href=coimaimp-gest?funzione=V&[export_url_vars nome_funz_caller]&cod_impianto=$cod_impianto_old&nome_funz=impianti ><b>Ultimo impianto trattato: $cod_impianto_est_old</b></a>
         </td>
      </tr>"
} else {
    set impianto_old_adp ""
}

# Personalizzo la pagina
set titolo       "Bonifica impianti - Ricerca Impianti"
set button_label "Ricerca" 
set page_title   "Bonifica impianti - ricerca impianti"

iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set flag_viario  $coimtgen(flag_viario)
set cod_comune   $coimtgen(cod_comu)
set sigla_prov   $coimtgen(sigla_prov)

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimbimp"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set readonly_fld \{\}
set disabled_fld \{\}
form create $form_name \
-html    $onsubmit_cmd

# il nuovo codice impianto corrisponde al codice bollino (per la provincia di 
# Livorno) e richiedo l'inserimento solo per la provincia di Livorno
if {$flag_ente == "P"
&&  $sigla_prov == "LI"
} {
    element create $form_name cod_impianto_est_new \
    -label   "Codice impianto esterno" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element tabindex 1" \
    -optional
}

element create $form_name f_resp_cogn \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 2" \
-optional

element create $form_name f_resp_nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 3" \
-optional

if {$flag_ente == "P"} {
    element create $form_name f_comune \
    -label   "Comune" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 4" \
    -optional \
    -options [iter_selbox_from_comu]
} else {
    element create $form_name f_comune -widget hidden -datatype text -optional
}

element create $form_name f_desc_topo \
-label   "topos" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element tabindex 5" \
-optional \
-options [iter_selbox_from_table coimtopo descr_topo descr_topo]

element create $form_name f_desc_via \
-label   "Via" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element tabindex 6" \
-optional

element create $form_name f_manu_cogn \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 7" \
-optional

element create $form_name f_manu_nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element tabindex 8"\
-optional

set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
#ns_log Notice $cerca_manu
if {$flag_viario == "T"} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_desc_via dummy f_desc_topo cod_comune f_comune dummy dummy dummy dummy]]
    regsub {<a href} $cerca_viae {<a tabindex=7 href} cerca_viae
} else {
    set cerca_viae ""
}

element create $form_name f_cod_via   -widget hidden -datatype text -optional
element create $form_name f_cod_manu  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name dummy       -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit tabindex 62"


if {[form is_request $form_name]} {

  # valorizzo i campi di mappa con i parametri ricevuti.
  # serve quando la lista ritorna al filtro.
    if {$flag_ente == "P"
    &&  $sigla_prov == "LI"
    } {
	element set_properties $form_name cod_impianto_est_new -value $cod_impianto_est_new
    }

    element set_properties $form_name f_resp_cogn        -value $f_resp_cogn
    element set_properties $form_name f_resp_nome        -value $f_resp_nome

    if {$flag_ente == "P"} {
	element set_properties $form_name f_comune       -value $f_comune
    } else {
	element set_properties $form_name f_comune       -value $cod_comune
    }

    element set_properties $form_name f_cod_via          -value $f_cod_via
    element set_properties $form_name f_desc_topo        -value $f_desc_topo
    element set_properties $form_name f_desc_via         -value $f_desc_via
    element set_properties $form_name f_manu_cogn        -value $f_manu_cogn
    element set_properties $form_name f_manu_nome        -value $f_manu_nome
    element set_properties $form_name funzione            -value $funzione
    element set_properties $form_name caller              -value $caller
    element set_properties $form_name nome_funz           -value $nome_funz
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    if {$flag_ente == "P"
    &&  $sigla_prov == "LI"
    } {
	set cod_impianto_est_new [string trim [element::get_value $form_name cod_impianto_est_new]]
    }
    set f_resp_cogn        [string trim [element::get_value $form_name f_resp_cogn]]
    set f_resp_nome        [string trim [element::get_value $form_name f_resp_nome]]
    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]
    set f_comune           [string trim [element::get_value $form_name f_comune]]
    set f_cod_via          [string trim [element::get_value $form_name f_cod_via]]
    set f_desc_topo        [string trim [element::get_value $form_name f_desc_topo]]
    set f_desc_via         [string trim [element::get_value $form_name f_desc_via]]  

    set error_num 0

    set sw_filtro_ind "t"
  # per capire se si e' cercato di fare un filtro per indirizzo,
  # per la Provincia e' sufficiente sapere se e' indicato il comune
  # per il Comune    e' necessario sapere se e' indicato il quartiere o la via

    if {$flag_ente == "P"} {
        if {[string equal $f_comune ""]} {
            set sw_filtro_ind "f"
        }
    } else {
        if {[string equal $f_desc_via  ""]
	&&  [string equal $f_desc_topo ""]
        } {
            set sw_filtro_ind "f"
	}
    }

    set mex_err_cod_impianto ""
    if {[string equal $f_resp_cogn        ""]
	&&  [string equal $f_resp_nome        ""]
	&&  [string equal $f_manu_cogn         ""]
	&&  [string equal $f_manu_nome         ""]
    &&  $sw_filtro_ind == "f"
    } {
        if {$flag_ente == "P"} {
            set errore_indirizzo "comune"
	} else {
	    set errore_indirizzo "indirizzo"
	}
	append mex_err_cod_impianto "Indicare almeno responsabile o $errore_indirizzo<br>"
    }

    if {![string equal $mex_err_cod_impianto ""]} {
	element::set_error $form_name f_resp_cogn $mex_err_cod_impianto
	incr error_num
    }

    if {[string equal $f_resp_cogn ""]
    && ![string equal $f_resp_nome ""]
    } {
	element::set_error $form_name f_resp_cogn "Indicare anche il cognome"
	incr error_num
    }

    if {[string equal $f_manu_cogn ""]
	&& ![string equal $f_manu_nome ""]
    } {
	element::set_error $form_name f_manu_cogn "Indicare anche il cognome"
	incr error_num
    }
    # si controlla la via solo se il primo test e' andato bene.
  # in questo modo si e' sicuri che f_comune e' stato valorizzato.
    if {$error_num        ==  0
    &&  $flag_viario      == "T"
    } {
	if {[string equal $f_desc_via  ""]
	&&  [string equal $f_desc_topo ""]
	} {
	    set f_cod_via ""
	} else {
	    # controllo codice via
	    set chk_out_rc      0
	    set chk_out_msg     ""
	    set chk_out_cod_via ""
	    set ctr_viae        0
	    if {[string equal $f_desc_topo ""]} {
		set eq_descr_topo  "is null"
	    } else {
		set eq_descr_topo  "= upper(:f_desc_topo)"
	    }
	    if {[string equal $f_desc_via ""]} {
		set eq_descrizione "is null"
	    } else {
		set eq_descrizione "= upper(:f_desc_via)"
	    }
	    db_foreach sel_viae "" {
		incr ctr_viae
		if {$cod_via == $f_cod_via} {
		    set chk_out_cod_via $cod_via
		    set chk_out_rc       1
		}
	    }
            switch $ctr_viae {
 		0 { set chk_out_msg "Via non trovata"}
	 	1 { set chk_out_cod_via $cod_via
		    set chk_out_rc       1 }
	  default {
                    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovate pi&ugrave; vie: usa il link cerca"
		    }
 		}
	    }
            set f_cod_via $chk_out_cod_via
            if {$chk_out_rc == 0} {
                element::set_error $form_name f_desc_via $chk_out_msg
                incr error_num
	    }
	}
    } else {
	set f_cod_via ""
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

    set link_list [export_url_vars cod_impianto_est_new f_resp_cogn f_resp_nome f_comune f_cod_via f_desc_via f_desc_topo f_manu_cogn f_manu_nome f_cod_manu caller funzione nome_funz_caller nome_funz]

    set return_url "coimbimp-list?$link_list"    
    
    ad_returnredirect $return_url
    ad_script_abort
}
 
ad_return_template
