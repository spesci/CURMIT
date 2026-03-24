ad_page_contract {
    @author          Paolo Formizzi Adhoc
    @creation-date   04/05/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimcimp-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but02 19/06/2023 Aggiunto la classe ah-jquery-date ai campi Da Data controllo e A Data controllo .
    but01 31-03-2023  Sandro mi ha chiesto di modificare i titoli della pagina
} {
    {funzione           "V"}
    {caller         "index"}
    {nome_funz           ""}
    {f_data_controllo_da ""}
    {f_data_controllo_a  ""}
    {f_cod_tecn          ""}
    {f_cod_enve          ""}
    {f_cod_comb          ""}
    {f_anno_inst_da      ""}
    {f_anno_inst_a       ""}
    {f_cod_comune        ""}
    {f_descr_topo        ""}
    {f_descr_via         ""}
    {f_cod_via           ""}
    {f_verb_n            ""}
    {flag_tipo_impianto   ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente $coimtgen(flag_ente)
if {$flag_ente == "C"} {
    set f_cod_comune $coimtgen(cod_comu)
}

set cod_tecn   [iter_check_uten_opve $id_utente]
set cod_enve   [iter_check_uten_enve $id_utente]

if {![string equal $cod_tecn ""]} {
    set f_cod_tecn $cod_tecn
    if {[db_0or1row sel_enve_cod_enve ""] == 1} {
	set f_cod_enve $cod_enve
    }
    set flag_cod_tecn "t"
} else {
    set flag_cod_tecn "f"
}

if {![string equal $cod_enve ""]} {
    set f_cod_enve $cod_enve
    set flag_cod_enve "t"
} else {
    set flag_cod_enve "f"
}

# Personalizzo la pagina
#but01 modifica di titoli di pagina 
set titolo       "Consultazione Rapporti di ispezione"
set button_label "Seleziona" 
set page_title   "Consultazione Rapporti di ispezione"

set context_bar  [iter_context_bar -nome_funz $nome_funz] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coiminco"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
if {$flag_cod_tecn == "t"} {
    set readonly_tecn "readonly"
} else {
    set readonly_tecn  \{\}
}
set jq_date "";#but02
if {$funzione in "V M I S"} {#but02 Aggiunta if e contenuto
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
#but02 Aggiunto la classe ah-jquery-date al campi Da Data controllo e A Data controllo.
element create $form_name f_data_controllo_da \
-label   "Data controllo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional

element create $form_name f_data_controllo_a \
-label   "Data controllo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional


if {$flag_cod_tecn == "f"
&&  $flag_cod_enve == "f"
} {    
    element create $form_name f_cod_enve \
    -label   "Codice ente" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimenve cod_enve ragione_01]
} else {
    element create $form_name f_cod_enve -widget hidden -datatype text -optional
    element set_properties $form_name f_cod_enve   -value $f_cod_enve

    element create $form_name desc_enve \
    -label   "Desc_enve" \
    -widget   text \
    -datatype text \
    -html    "size 30 readonly {} class form_element" \
    -optional 

    if {[db_0or1row sel_ragione_enve ""] == 0} {
        set ragione_01 ""
    }

    element set_properties $form_name desc_enve   -value $ragione_01
}

element create $form_name f_cog_tecn \
-label   "Cognome tecnico" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 40 $readonly_tecn {} class form_element" \
-optional 

element create $form_name f_nom_tecn \
-label   "Nome tecnico" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 40 $readonly_tecn {} class form_element" \
-optional 

if {$flag_cod_tecn == "f"} {
    set cerca_opve [iter_search $form_name coimopve-list [list cod_enve f_cod_enve dummy f_cod_tecn dummy f_nom_tecn dummy f_cog_tecn]]
} else {
    set cerca_opve ""
}

if {$flag_ente == "P"} {
    element create $form_name f_cod_comune \
	-label   "Comune" \
	-widget   select \
	-options  [iter_selbox_from_comu] \
	-datatype text \
	-html    "class form_element" \
	-optional
} else {
    element create $form_name f_cod_comune -widget hidden -datatype text -optional
}

element create $form_name f_descr_via \
-label   "Via" \
-widget   text \
-datatype text \
-html    "size 33 maxlength 40 class form_element" \
-optional

element create $form_name f_descr_topo \
-label   "Descrizione Toponimo" \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options [iter_selbox_from_table coimtopo descr_topo descr_topo]

element create $form_name f_cod_comb \
-label   "combustibile" \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options [iter_selbox_from_table coimcomb cod_combustibile descr_comb]

element create $form_name f_anno_inst_da \
-label   "anno installazione da" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 class form_element" \
-optional

element create $form_name f_anno_inst_a \
-label   "anno installazione a" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 class form_element" \
-optional

element create $form_name f_verb_n \
-label   "N.verbale" \
-widget   text \
-datatype text \
-html    "size 13 maxlength 20 class form_element" \
-optional


if {$flag_viario == "T"} {
    set cerca_viae [iter_search coiminco [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_descr_via dummy f_descr_topo cod_comune f_cod_comune dummy dummy dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

element create $form_name f_cod_via   -widget hidden -datatype text -optional
element create $form_name f_cod_tecn  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name dummy       -widget hidden -datatype text -optional

set f_cod_enve "VE1"

if {[form is_request $form_name]} {

    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz
    element set_properties $form_name f_cod_via      -value $f_cod_via
    if {$flag_ente == "C"} {
	element set_properties $form_name f_cod_comune -value $f_cod_comune
    }
    element set_properties $form_name f_data_controllo_da -value [iter_edit_date $f_data_controllo_da]
    element set_properties $form_name f_data_controllo_a -value [iter_edit_date $f_data_controllo_a]
    element set_properties $form_name f_cod_tecn         -value $f_cod_tecn
    if {[db_0or1row sel_tecn ""] == 0} {
	set f_cog_tecn ""
	set f_nom_tecn ""
    }
    element set_properties $form_name f_cod_enve         -value $f_cod_enve
    #dpr74
    element set_properties $form_name flag_tipo_impianto  -value $flag_tipo_impianto
    #dpr74
    element set_properties $form_name f_cod_comb         -value $f_cod_comb
    element set_properties $form_name f_anno_inst_da     -value $f_anno_inst_da
    element set_properties $form_name f_anno_inst_a      -value $f_anno_inst_a
    element set_properties $form_name f_cog_tecn         -value $f_cog_tecn
    element set_properties $form_name f_nom_tecn         -value $f_nom_tecn
    element set_properties $form_name f_descr_topo       -value $f_descr_topo
    element set_properties $form_name f_descr_via        -value $f_descr_via
    element set_properties $form_name f_cod_comune       -value $f_cod_comune
    element set_properties $form_name f_verb_n           -value $f_verb_n
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_data_controllo_da [element::get_value $form_name f_data_controllo_da]
    set f_data_controllo_a  [element::get_value $form_name f_data_controllo_a]
    set f_anno_inst_da      [element::get_value $form_name f_anno_inst_da]
    set f_anno_inst_a       [element::get_value $form_name f_anno_inst_a]
    set f_cod_comb          [element::get_value $form_name f_cod_comb]
    set f_cod_enve          [element::get_value $form_name f_cod_enve]
    set f_cod_tecn          [element::get_value $form_name f_cod_tecn]
    set f_cog_tecn          [element::get_value $form_name f_cog_tecn]
    set f_nom_tecn          [element::get_value $form_name f_nom_tecn]
    set f_cod_comune        [element::get_value $form_name f_cod_comune]
    set f_descr_topo        [element::get_value $form_name f_descr_topo]
    set f_descr_via         [element::get_value $form_name f_descr_via]
    set f_cod_via           [element::get_value $form_name f_cod_via]
    set f_verb_n            [element::get_value $form_name f_verb_n]
    #dpr74
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]
    #dpr74 

    set error_num 0

    if {$flag_cod_enve == "t"} {
	set f_cod_enve [iter_check_uten_enve $id_utente]
    }
    if {$flag_cod_tecn == "t"} {
	set cod_tecn   [iter_check_uten_opve $id_utente]
	if {[db_0or1row sel_enve_cod_enve ""] == 1} {
	    set f_cod_enve $cod_enve
	}
    }

    #controllo f_data incontro da
    set flag_data_inc_da "t"
    if {![string equal $f_data_controllo_da ""]} {
          set f_data_controllo_da [iter_check_date $f_data_controllo_da]
          if {$f_data_controllo_da == 0} {
              element::set_error $form_name f_data_controllo_da "Data non corretta"
              incr error_num
	      set flag_data_inc_da "f"
          }
    }


    #controllo f_data incontro a
    set flag_data_inc_a "t"
    if {![string equal $f_data_controllo_a ""]} {
          set f_data_controllo_a [iter_check_date $f_data_controllo_a]
          if {$f_data_controllo_a == 0} {
              element::set_error $form_name f_data_controllo_a "Data non corretta"
              incr error_num
	      set flag_data_inc_a "f"
          }
    }

    if {![string equal $f_data_controllo_da ""]
    &&  ![string equal $f_data_controllo_a  ""]
    &&  $flag_data_inc_a  == "t"
    &&  $flag_data_inc_da == "t"
    &&  $f_data_controllo_da > $f_data_controllo_a
    } {
	element::set_error $form_name f_data_controllo_a "La data di fine deve essere maggiore della data di inizio"
	incr error_num
    }

    #controllo f_anno_inst_da
    set flag_anno_inst_da "t"
    if {![string equal $f_anno_inst_da ""]} {
	if {![string is integer $f_anno_inst_da]} {
	    element::set_error $form_name f_anno_inst_da "Anno non valido"
	    incr error_num
	    set flag_anno_insta_da "f"
	}
    }

    #controllo f_anno_inst_a 
    set flag_anno_inst_a "t"
    if {![string equal $f_anno_inst_a ""]} {
	if {![string is integer $f_anno_inst_a]} {
	    element::set_error $form_name f_anno_inst_a "Anno non valido"
	    incr error_num
	    set flag_anno_ins_a "f"
	}
    }
    
    if {![string equal $f_anno_inst_da ""]
    &&  ![string equal $f_anno_inst_a  ""]
    &&  $flag_anno_inst_da  == "t"
    &&  $flag_anno_inst_a   == "t"
    &&  $f_anno_inst_da > $f_anno_inst_a
    } {
	element::set_error $form_name f_anno_inst_a "L'anno di fine deve essere maggiore dell'anno di inizio"
	incr error_num
    }

    #routine generica per controllo codice tecnico
    set check_cod_tecn {
	set chk_out_rc       0
	set chk_out_msg      ""
	set chk_out_cod_tecn ""
	set ctr_tecn         0
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
	db_foreach sel_tecn_nom "" {
	    incr ctr_tecn
	    if {$cod_tecn_db == $chk_inp_cod_tecn} {
		set chk_out_cod_tecn $cod_tecn_db
		set chk_out_rc       1
	    }
	}
	switch $ctr_tecn {
	    0 { set chk_out_msg "Tecnico non trovato"}
	    1 { set chk_out_cod_tecn $cod_tecn_db
		set chk_out_rc       1 }
	    default {
		if {$chk_out_rc == 0} {
		    set chk_out_msg "Trovati pi&ugrave; tecnici: usa il link cerca"
		}
	    }
	}
    }

    if {[string equal $f_cog_tecn ""]
    &&  [string equal $f_nom_tecn    ""]
    } {
	set f_cod_tecn ""
    } else {
	set chk_inp_cod_tecn $f_cod_tecn
	set chk_inp_cognome  $f_cog_tecn
	set chk_inp_nome     $f_nom_tecn
	eval $check_cod_tecn
	set f_cod_tecn  $chk_out_cod_tecn
	if {$chk_out_rc == 0} {
	    element::set_error $form_name f_cog_tecn $chk_out_msg
	    incr error_num
	}
    }


    # si controlla la via solo se il primo test e' andato bene.
    # in questo modo si e' sicuri che f_comune e' stato valorizzato.

    if {[string equal $f_descr_via  ""]
    &&  [string equal $f_descr_topo ""]
    } {
	set f_cod_via ""
    } else {

	if {[string equal $f_cod_comune ""]} {
	    element::set_error $form_name f_cod_comune "Inserire il comune"
	    incr error_num
	} else {

	    # controllo codice via
	    set chk_out_rc      0
	    set chk_out_msg     ""
	    set chk_out_cod_via ""
	    set ctr_viae        0
	    if {[string equal $f_descr_topo ""]} {
		set eq_descr_topo  "is null"
	    } else {
		set eq_descr_topo  "= upper(:f_descr_topo)"
	    }
	    if {[string equal $f_descr_via ""]} {
		set eq_descrizione "is null"
	    } else {
		set eq_descrizione "= upper(:f_descr_via)"
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
                element::set_error $form_name f_descr_via $chk_out_msg
                incr error_num
	    }
	}
    }

    set link_list [export_url_vars f_data_controllo_da f_data_controllo_a f_anno_inst_da f_anno_inst_a f_cod_comb f_cod_enve f_cod_tecn f_cod_comune f_cod_via f_descr_via f_descr_topo f_verb_n flag_tipo_impianto caller funzione nome_funz]
    set return_url "coimcimp-list?$link_list"    
  
    if {$error_num > 0} {
       ad_return_template
       return
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
